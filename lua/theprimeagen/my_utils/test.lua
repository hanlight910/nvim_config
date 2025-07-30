local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local function my_custom_picker(callback)
  local data = { "Apple", "Banana", "Cherry", "Date" }

  pickers.new({}, {
    prompt_title = "Fruits",
    finder = finders.new_table { results = data },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if callback then
          callback(selection[1])
        end
      end)
      return true
    end
  }):find()
end

-- Use it like this:
my_custom_picker(function(selected)
  print("Selected from callback: " .. selected)
end)

