local opt = vim.opt
local g = vim.g
local M = {} -- For any helper functions

---------------
--  OPTIONS  --
---------------

-- Global Stuff
g.mapleader = " "
g.maplocalleader = " "
g.auto_save = true

-- Misc options
opt.ruler = true
opt.hidden = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.cul = true
opt.mouse = "a"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.updatetime = 750 -- update interval (ms) for gitsigns
opt.timeoutlen = 500 -- keybind timeout length (ms)
opt.clipboard = "unnamedplus"
-- opt.clipboard     = opt.clipboard + "unnamed"
opt.shortmess:append("cI")
opt.autowrite = true
opt.autowriteall = true

-- Searching
opt.smartcase = true
opt.ignorecase = true
opt.hlsearch = true
opt.incsearch = true

-- Text
opt.cursorline = false
opt.textwidth = 80
opt.colorcolumn = "81,101"
opt.scrolloff = 15
opt.sidescrolloff = 8
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.iskeyword:append("-") -- Letters separated by "-" are still words

-- Numbers
opt.number = true
opt.numberwidth = 3
opt.relativenumber = true

-- Indenting
opt.expandtab = true
opt.smartindent = false
opt.shiftround = true
opt.autoindent = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

-- Completion Stuff
opt.completeopt = "menuone,noinsert,noselect"

-- Caching
opt.backupdir = { "/tmp/nvim/backup" }
opt.undodir = { "/tmp/nvim/undo" }
opt.directory = { "/tmp/nvim/swap" }

opt.undofile = true
opt.confirm = true
opt.undolevels = 1000

-- Disable builtin vim plugins
g.loaded_gzip = 0
g.loaded_tar = 0
g.loaded_tarPlugin = 0
g.loaded_zipPlugin = 0
g.loaded_2html_plugin = 0
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_matchit = 0
g.loaded_matchparen = 0
g.loaded_spec = 0

-- Configure vim diagnostics
vim.diagnostic.config({
    virtual_lines = true,
    virtual_text = false,
    underline = true,
    update_in_insert = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
        -- linehl = {
        --     [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
        -- },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticDefaultError",
            [vim.diagnostic.severity.WARN] = "DiagnosticDefaultWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticDefaultInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        },
    },
})

-- Highlight configuration
g.search_highlight_timeout_ms = 1000

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
        if g.auto_save == true and bvr.buftype == "" and bvr.modifiable == 1 and bvr.modified == 1 and fname ~= "" then
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
        vim.notify("Colorscheme changed!", vim.log.levels.INFO)
    end,
})

-----------------
--  FUNCTIONS  --
-----------------

local retab_buf = function(old)
    local bet = opt.expandtab
    local bsw = opt.shiftwidth
    local bts = opt.tabstop
    local bst = opt.softtabstop

    opt.expandtab = false
    opt.shiftwidth = old
    opt.tabstop = old
    opt.softtabstop = old
    vim.cmd([[retab!]])

    opt.expandtab = bet
    opt.shiftwidth = bsw
    opt.tabstop = bts
    opt.softtabstop = bst
    vim.cmd([[retab]])
end

vim.api.nvim_create_user_command("FixTabs", function(args)
    local retab_width = tonumber(args.args)
    if retab_width >= 1 then
        retab_buf(retab_width)
    else
        vim.notify(args.args .. " is not a number >= 1. Please use :FixTabs <number>", vim.log.levels.ERROR)
    end
end, { nargs = 1, desc = "Retab files to 4 spaces" })

vim.api.nvim_create_user_command("DebugVar", function()
    local buf = vim.fn.bufnr()
    local bvr = vim.fn.getbufvar(buf, "&")
    require("utils").print_variable(bvr)
end, {})

vim.api.nvim_create_user_command("Fmt", function()
    vim.cmd("Neoformat")
end, {})

vim.api.nvim_create_user_command("TrimWhitespace", function()
    require("mini.trailspace").trim()
end, { desc = "Trim all trailing whitespace" })

vim.api.nvim_create_user_command("GodotServer", function()
    local dap = require("dap")
    dap.adapters.godot = {
        type = "server",
        host = "localhost",
        port = 6005,
    }

    dap.configurations.gdscript = {
        {
            launch_game_instance = false,
            launch_scene = false,
            name = "Launch scene",
            project = "${workspaceFolder}",
            request = "launch",
            type = "godot",
        },
    }
end, { desc = "Start Godot debug adapter server" })

------------------------
--  HELPER FUNCTIONS  --
------------------------

function M.is_buffer_empty()
    -- Check whether the current buffer is empty
    return vim.fn.empty(vim.fn.expand("%:t")) == 1
end

function M.has_width_gt(cols)
    -- Check if the windows width is greater than a given number of columns
    return vim.fn.winwidth(0) / 2 > cols
end

--------------------
--  MISC OPTIONS  --
--------------------

-----------
--  END  --
-----------

return M
