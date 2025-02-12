local ts = require("telescope")
local tb = require('telescope.builtin')

local function find_files_with_cwd(cwd, title)
    tb.find_files({
        prompt_title = title,
        cwd = cwd,
        hidden = true,
    })
end
local keymaps = {
    {'n', '<leader>pf', tb.find_files},
    {'n', '<leader>pb', tb.buffers},
    {'n', '<C-p>', tb.git_files},
    {'n', '<leader>ps', function()
        tb.grep_string({ search = vim.fn.input("Grep > ") })
    end},
    {'n', '<leader>pa', function() find_files_with_cwd(vim.g.archive, "< ARCHIVE >") end},
    {'n', '<leader>paa', function() find_files_with_cwd(vim.g.areas, "< 02-AREAS >") end},
    {'n', '<leader>pap', function() find_files_with_cwd(vim.g.projects, "< 03-PROJECTS >") end},
    {'n', '<A-s>', function() find_files_with_cwd(vim.g.config, "< 03-PROJECTS >") end}
}

for _, map in ipairs(keymaps) do
    vim.keymap.set(map[1], map[2], map[3])
end

