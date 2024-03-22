-- load all plugins

require("pluginList")
require("options")

require("mappings").setup()

--require("utils").hideStuff()

-- Call local nvim configs
local path = vim.fn.expand("$HOME/.shelf/nvim.lua")
local local_exists, local_configs = pcall(dofile, path)
if local_exists then
    local_configs.setup()
else
    print("No local configs... Using global")
end

-- Call this after local config sets colors
require("highlights")

-- require "plugins.lspconfig".config()
require("session")
