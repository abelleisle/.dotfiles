-- load all plugins

require "pluginList"
require "options"

local g = vim.g
local o = vim.o

g.mapleader = " "
g.auto_save = false

-- colorscheme related stuff

g.theme = "gruvbox"
--g.theme = "agila"
o.background = "dark"
g.gruvbox_italic = 1
g.gruvbox_bold = 1
g.gruvbox_underline = 1
g.gruvbox_undercurl = 1
g.gruvbox_contrast_dark = "hard"
--vim.cmd([[colorscheme gruvbox]])
vim.cmd([[colorscheme agila]])

--require "highlights"
require "mappings"

require("utils").hideStuff()
