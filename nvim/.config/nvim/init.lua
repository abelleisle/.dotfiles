-- load all plugins

require "pluginList"
require "options"

--require "highlights"
require "mappings"

--require("utils").hideStuff()

-- Call local nvim configs
local local_exists, local_configs = pcall(require, "local")
if local_exists then
    local_configs.config()
else
    print("No local configs... Using global")
end
