-- load all plugins

require "pluginList"
require "options"

--require "highlights"
require "mappings"

--require("utils").hideStuff()

-- Call local nvim configs
pcall(require, "local")
