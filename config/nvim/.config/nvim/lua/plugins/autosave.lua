local M = {}

-- autosave.nvim plugin disabled by default
M.config = function()
    local autosave = require("auto-save")

    autosave.setup ({
        enabled = vim.g.auto_save, -- takes boolean value from init.lua
        execution_message = {
            message = function()
                return "Auto-saved at : " .. vim.fn.strftime("%H:%M:%S")

            end,
            dim = 0.18,
            cleaning_interval = 1250
        },
        events = {"FocusLost", "BufLeave", "BufUnload", "UILeave", "TabLeave", "VimSuspend", "WinLeave"},
        -- conditions = {
        --     exists = true,
        --     filetype_is_not = {"tex"},
        --     modifiable = true
        -- },
        write_all_buffers = false,
        debounce_delay = 1000,
    })
end

return M
