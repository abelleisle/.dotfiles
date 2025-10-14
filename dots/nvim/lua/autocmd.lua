local opt = vim.opt

--------------------
--  AUTOCOMMANDS  --
--------------------

-- Create autocommand group to prevent duplicating autocommands
vim.api.nvim_create_augroup("bufcheck", { clear = true })

-- Highlight Yanks
vim.api.nvim_create_autocmd("TextYankPost", {
    group = "bufcheck",
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            timeout = 500,
        })
    end,
})

-- Autoreload file on external change
opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = "bufcheck",
    pattern = "*",
    callback = function()
        if vim.fn.mode() ~= "c" then
            vim.cmd("checktime")
        end
    end,
}) -- vim.cmd('autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != \'c\' | checktime | endif')

-- Report when file was changed outside of neovim
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = "bufcheck",
    pattern = "*",
    callback = function()
        vim.cmd('echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None')
    end,
}) -- vim.cmd('autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None')

-- When re-opening a file restore cursor to previous position
vim.api.nvim_create_autocmd("BufReadPost", {
    group = "bufcheck",
    pattern = "*",
    callback = function()
        local fn = vim.fn.expand("%t")
        if fn:find(".git") then
            return
        end -- Don't restore cursor on git files
        if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
            vim.fn.setpos(".", vim.fn.getpos("'\""))
            vim.api.nvim_feedkeys("zz", "n", true)
        end
    end,
})

-- Autosave file when leaving buffer or neovim.
-- Can be disabled in ft or local config by setting vim.g.auto_save = false
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
    group = "bufcheck",
    pattern = "*",
    callback = function()
        local buf = vim.fn.bufnr()
        local bvr = vim.fn.getbufvar(buf, "&")
        local fname = vim.fn.expand("%:t")
        if
            vim.g.auto_save == true
            and bvr.buftype == ""
            and bvr.modifiable == 1
            and bvr.modified == 1
            and fname ~= ""
        then
            vim.cmd("silent update")
            vim.cmd(
                'echohl InfoMsg | echo "Auto-saved " .. expand("%:t") .. " at " .. strftime("%H:%M:%S") | echohl None'
            )
            vim.fn.timer_start(1500, function()
                vim.cmd('echon ""')
            end)
        end
    end,
})

-- Disable mini.trailspace on xxd filetypes
vim.api.nvim_create_autocmd("Filetype", {
    pattern = "xxd",
    callback = function(args)
        vim.b[args.buf].minitrailspace_disable = true
    end,
})

-- Disable wrapping and colorcolumn on Avante
vim.api.nvim_create_autocmd("Filetype", {
    pattern = { "Avante", "AvanteInput", "AvanteSelectedFiles" },
    callback = function()
        vim.opt_local.colorcolumn = ""
        vim.opt_local.textwidth = 0
    end,
})

-- Create group for noice notifications
vim.api.nvim_create_augroup("NoiceMacroNotfication", { clear = true })

-- Notify user if macro recording starts
vim.api.nvim_create_autocmd("RecordingEnter", {
    callback = function()
        local msg = string.format("Register: %s", vim.fn.reg_recording())
        _MACRO_RECORDING_STATUS = true
        vim.notify(msg, vim.log.levels.INFO, {
            title = "Macro Recording",
            keep = function()
                return _MACRO_RECORDING_STATUS
            end,
        })
    end,
    group = "NoiceMacroNotfication",
})

-- Notify user if macro recording ends
vim.api.nvim_create_autocmd("RecordingLeave", {
    callback = function()
        _MACRO_RECORDING_STATUS = false
        vim.notify("Success!", vim.log.levels.INFO, {
            title = "Macro Recording End",
            timeout = 2000,
        })
    end,
    group = "NoiceMacroNotfication",
})

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*", -- We can use this to filter for certain
    -- colorschemes, e.g. `pattern = "gruvbox"`.
    callback = function()
        require("highlights").config()
        -- vim.notify("Colorscheme changed!", vim.log.levels.INFO)
    end,
})
