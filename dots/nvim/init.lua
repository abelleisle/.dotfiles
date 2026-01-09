-----------------------------------------------------------
-- Configuration
require("options")

-- Call local nvim configs/overrides
local path = vim.fn.expand("$HOME/.shelf/nvim.lua")
local local_exists, local_configs = pcall(dofile, path)
if local_exists then
    local_configs.setup()
else
    print("No local configs... Using global")
end

-----------------------------------------------------------
-- Load plugins

-- Remote Plugins
require("plugins").setup()

-- "Local" Plugins
require("utils.search").setup()

-----------------------------------------------------------
-- Keybinds
require("mappings").setup()

-----------------------------------------------------------
-- LSP
require("lsp").setup()

-----------------------------------------------------------
-- Configuration
require("autocmd")
require("functions")
require("filetype")

if local_exists then
    local_configs.colorscheme()
else
    print("No local colorscheme... Using default")
end

-----------------------------------------------------------
-- Highlights
-- Call this after local config sets colors
-- require("highlights")

-----------------------------------------------------------
-- Session loading
require("session")
