local opt = vim.opt

vim.g.mapleader = " "
vim.g.auto_save = false
opt.autowrite = true
opt.autowriteall = true

opt.ruler = true
opt.hidden = true
opt.ignorecase = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.cul = true
opt.mouse = "a"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.updatetime = 750 -- update interval for gitsigns
opt.timeoutlen = 500
opt.clipboard = opt.clipboard + "unnamedplus"
opt.shortmess:append("cI")

opt.smartcase = true
opt.ignorecase = true
opt.autoindent = true

-- Text
opt.cursorline = false
opt.textwidth = 80
opt.colorcolumn = "81,101"
opt.scrolloff=15
opt.sidescrolloff=8
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
vim.cmd('au TextYankPost * lua vim.highlight.on_yank {on_visual = false}')  -- disabled in visual mode
opt.autoread = true
vim.cmd('autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != \'c\' | checktime | endif')
vim.cmd('autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None')

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true

-- for indenline
opt.expandtab = true
opt.smartindent = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftround = true

opt.completeopt = "menuone,noinsert,noselect"

-- Caching
opt.backupdir = {"/tmp/nvim/backup"}
opt.undodir = {"/tmp/nvim/undo"}
opt.directory = {"/tmp/nvim/swap"}

opt.undofile = true
opt.confirm = true
opt.undolevels = 1000

-- disable builtin vim plugins
vim.g.loaded_gzip = 0
vim.g.loaded_tar = 0
vim.g.loaded_tarPlugin = 0
vim.g.loaded_zipPlugin = 0
vim.g.loaded_2html_plugin = 0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchit = 0
vim.g.loaded_matchparen = 0
vim.g.loaded_spec = 0

local M = {}

function M.is_buffer_empty()
    -- Check whether the current buffer is empty
    return vim.fn.empty(vim.fn.expand("%:t")) == 1
end

function M.has_width_gt(cols)
    -- Check if the windows width is greater than a given number of columns
    return vim.fn.winwidth(0) / 2 > cols
end

-- file extension specific tabbing
-- vim.cmd([[autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4]])

require("nvim-web-devicons").setup({
    -- your personnal icons can go here (to override)
    -- you can specify color or cterm_color instead of specifying both of them
    -- DevIcon will be appended to `name`
    override = {
        tcl = {
            icon = "",
            name = "tcl"
        }
    }
})

return M
