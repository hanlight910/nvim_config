local fineline = require('fine-cmdline');
local fn = fineline.fn;
vim.keymap.set("n", ":", "<cmd>FineCmdline<CR>")

fineline.setup({
    cmdline = {
        enable_keymaps = false,
        smart_history = true,
        prompt = "Cmd: "
    },
    popup = {
        position = {
            row = '10%',
            col = '50%',
        },
        size = {
            width = '60%',
        },
        border = {
            style = 'rounded',
        },
        win_options = {
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
        },
    },
    hooks = {
        before_mount = function(input)
            -- code
        end,
        after_mount = function(input)
            vim.keymap.set('i', '<Esc>', '<cmd>stopinsert<cr>', {buffer = input.bufnr})
        end,
        set_keymaps = function(imap, feedkeys)
            imap('<A-s>', '%s///gc<Left><Left><Left><Left>')
            imap('<C-s>', 's///gc<Left><Left><Left><Left>')
            imap('qq', fn.close);

            imap('<C-p>', fn.up_search_history)
            imap('<C-n>', fn.down_search_history)
            imap('<C-n>', fn.complete_or_next_item);
        end
    }
})
