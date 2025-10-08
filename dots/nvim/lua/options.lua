local o = vim.opt
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
o.ruler = true
o.hidden = true
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.cul = true
o.mouse = "a"
o.signcolumn = "yes"
o.cmdheight = 1
o.updatetime = 750 -- update interval (ms) for gitsigns
o.timeoutlen = 500 -- keybind timeout length (ms)
o.clipboard = "unnamedplus"
-- opt.clipboard     = opt.clipboard + "unnamed"
o.shortmess:append("cI")
o.autowrite = true
o.autowriteall = true

-- Searching
o.smartcase = true
o.ignorecase = true
o.hlsearch = true
o.incsearch = true

-- Text
o.cursorline = false
o.textwidth = 80
o.colorcolumn = "81,101"
o.scrolloff = 15
o.sidescrolloff = 8
o.wrap = true
o.linebreak = true
o.breakindent = true
o.iskeyword:append("-") -- Letters separated by "-" are still words

-- Numbers
o.number = true
o.numberwidth = 3
o.relativenumber = true

-- Indenting
o.expandtab = true
o.smartindent = false
o.shiftround = true
o.autoindent = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

-- Completion Stuff
o.completeopt = "menuone,noinsert,noselect"

-- Caching
o.backupdir = { "/tmp/nvim/backup" }
o.undodir = { "/tmp/nvim/undo" }
o.directory = { "/tmp/nvim/swap" }

o.undofile = true
o.confirm = true
o.undolevels = 1000

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

return M
