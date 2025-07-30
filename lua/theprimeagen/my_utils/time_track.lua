local current_time_tracking = require('theprimeagen.variables')

local date_to_second = function(date)
	if not date or type(date) ~= "table" then
		return 0
	end

	local days = date.days or 0
	local hours = date.hours or 0
	local minutes = date.minutes or 0
	local seconds = date.seconds or 0

	return days * 86400 + hours * 3600 + minutes * 60 + seconds
end
local read_time_tracking_data_from_file = function()
	local file_path = vim.g.time_track_path

	if not file_path or file_path == "" then
		print("Time tracking file path is not set.")
		print(filepath)
		return
	end

	local file = io.open(file_path, "r")
	if not file then
		print("Failed to open time tracking file: " .. file_path)
		return
	end

	local data = {}

	for line in file:lines() do
		local subject, time_str = line:match('^%s*"([^"]+)"%s*,%s*(%d+:%d+:%d+:%d+)%s*$')
		if subject and time_str then
			local d, h, m, s = time_str:match("^(%d+):(%d+):(%d+):(%d+)$")
			data[subject] = {
				days = tonumber(d),
				hours = tonumber(h),
				minutes = tonumber(m),
				seconds = tonumber(s)
			}
		end
	end

	file:close()
	return data
end

local find_time_tracking_data = function(subject)

	subject = subject:match("^%s*(.-)%s*$")
	local data = read_time_tracking_data_from_file()
	if not data then
		print("No time tracking data available.")
		return nil
	end
	--deub print data
	local entry = data[subject]
	if not entry then
		return nil
	end

	return entry
end

local custom_picker = function(data, on_select)
	local picker = require('telescope.pickers')
	local finders = require('telescope.finders')
	local conf = require('telescope.config').values
	local actions = require('telescope.actions')
	local action_state = require('telescope.actions.state')

	picker.new({}, {
		prompt_title = "Subjects",
		finder = finders.new_table {
			results = data
		},
		sorter = conf.generic_sorter({}),
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()[1]
				actions.close(prompt_bufnr)
				if on_select and selection then
					on_select(selection)
				end
			end)
			return true
		end
	}):find()
end

local stop_callback = function(selected_subject) 
	if not selected_subject or selected_subject == "" then
		print("No subject selected.")
		return
	end

	local tracking = current_time_tracking[selected_subject]
	if not tracking then
		print("No active tracking found for subject: " .. selected_subject)
		return
	end

	local elapsed_time = os.time() - tracking.start_time +  date_to_second(find_time_tracking_data(selected_subject))
	local days = math.floor(elapsed_time / 86400)
	local hours = math.floor((elapsed_time % 86400) / 3600)
	local minutes = math.floor((elapsed_time % 3600) / 60)
	local seconds = elapsed_time % 60

	tracking.elapsed = { days = days, hours = hours, minutes = minutes, seconds = seconds }

	-- Update file with new time
	local file_path = vim.g.time_track_path
	if not file_path or file_path == "" then
		print("Time tracking file path is not set.")
		return
	end

	local file = io.open(file_path, "r+")
	if not file then
		print("Failed to open time tracking file for updating.")
		return
	end

	local content = {}
	for line in file:lines() do
		if line:match('^%s*"' .. selected_subject .. '"') then
			line = string.format('\"%s\",%02d:%02d:%02d:%02d', selected_subject, days, hours, minutes, seconds)
		end
		table.insert(content, line)
	end

	file:close()

	file = io.open(file_path, "w")
	if not file then
		print("Failed to open time tracking file for writing.")
		return
	end

	for _, line in ipairs(content) do
		file:write(line .. "\n")
	end

	file:close()

	print(string.format("Stopped tracking for subject: %s. Total time: %02d:%02d:%02d:%02d", selected_subject, days, hours, minutes, seconds))
	current_time_tracking[selected_subject] = nil -- Remove from current tracking after stopping
end


local parse_dict_to_time = function(dict)
	if not dict or type(dict) ~= "table" then
		return "00:00:00:00"
	end

	local days = dict.days or 0
	local hours = dict.hours or 0
	local minutes = dict.minutes or 0
	local seconds = dict.seconds or 0

	return string.format("%02d:%02d:%02d:%02d", days, hours, minutes, seconds)
end

local time_tracker_start = function()
	vim.g.time_tracker = os.time()
	require("noice").notify("Time tracker started at: " .. os.date("%H:%M:%S", vim.g.time_tracker), {
		title = "Time Tracker",
		level = "info",
		timeout = 5000,
	})
end

local time_tracker_stop = function()
	if not vim.g.time_tracker then
		print("Time tracker is not running.")
		return
	end

	local elapsed = os.time() - vim.g.time_tracker
	local hours = math.floor(elapsed / 3600)
	local minutes = math.floor((elapsed % 3600) / 60)
	local seconds = elapsed % 60

	local output = string.format("%02d:%02d:%02d", hours, minutes, seconds)

	require("noice").notify("Time tracker stopped. Elapsed time: " .. output, {
		title = "Time Tracker",
		level = "info",
		timeout = 5000,
	})
	vim.fn.setreg('"', output)
	vim.fn.setreg('+', output)
	print(output)
	vim.g.time_tracker = nil

	vim.g.time_tracker = nil

end

local add_time_tracker_to_topic = function()
	-- Input subject
	local subject = vim.fn.input("Enter subject: ")
	if subject == "" then
		print("Subject cannot be empty.")
		return
	end

	if find_time_tracking_data(subject) then
		return nil
	end

	-- Initialize current_tracking if nil
	if not current_time_tracking then
		current_time_tracking = {}
	end

	-- Wrap subject in quotes
	local quoted_subject = '"' .. subject .. '"'

	-- Start tracking for this subject only if not already tracked
	if current_time_tracking[subject] then
		print("Already tracking subject: " .. subject)
		return
	end

	print("subject: " .. subject)
	current_time_tracking[subject] = {
		start_time = os.time(),
		elapsed = { days = 0, hours = 0, minutes = 0, seconds = 0 },
		quoted_subject = quoted_subject,
	}

	-- Append to file with zero time initially
	local file_path = vim.g.time_track_path
	if not file_path or file_path == "" then
		print("Time tracking file path is not set.")
		return
	end

	local file = io.open(file_path, "a")
	if not file then
		print("Failed to open time tracking file for appending.")
		return
	end

	file:write(string.format('%s,00:00:00:00\n', quoted_subject))
	file:close()
end

local stop_current_time_tracker = function()
	local tracking = current_time_tracking
	if not tracking or vim.tbl_isempty(tracking) then
		return
	end

	-- Build list of subjects for selection UI
	local subjects = {}
	for subject, _ in pairs(tracking) do
		table.insert(subjects, subject)
	end
	local data = { "Apple", "Banana", "Cherry", "Date" }
	custom_picker(subjects, stop_callback)
end

local start_time_tracker = function()
	local data = read_time_tracking_data_from_file()
	-- filter non current_tracking from data
	local non_current_tracking = {}
	for subject, entry in pairs(data) do
		if not current_time_tracking[subject] then
			table.insert(non_current_tracking, subject)
		end
	end

	custom_picker(non_current_tracking, function(selected_subject)
		if selected_subject and selected_subject ~= "" then
			local entry = find_time_tracking_data(selected_subject)
			current_time_tracking[selected_subject] = {
				start_time = os.time(),
				elapsed = entry or { days = 0, hours = 0, minutes = 0, seconds = 0 },
				quoted_subject = '"' .. selected_subject .. '"',
			}
		end
	end)
end

vim.keymap.set("n", "<leader>tk", add_time_tracker_to_topic, {desc="Add time tracker to topic"})
vim.keymap.set("n", "<leader>to", stop_current_time_tracker, {desc="Stop current time tracker"})
vim.keymap.set("n", "<leader>ty", start_time_tracker, {desc="Start time tracker from file"})
-- add_time_tracker_to_topic()
-- stop_current_time_tracker()

-- add_time_tracker_to_topic()
