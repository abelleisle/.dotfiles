-----------------
--  UTILITIES  --
-----------------
local events = require("plugins").events
return {
    { -- Benchmark Neovim startup
        "tweekmonster/startuptime.vim",
        cmd = "StartupTime",
    },

    { -- Show current function/class context
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = "nvim-treesitter",
        event = events.OpenFile,
        opts = {
            enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        },
    },

    -- { -- Devcontainer support
    --     "https://codeberg.org/esensar/nvim-dev-container",
    --     config = function()
    --         require("devcontainer").setup({})
    --     end
    -- },

    { -- Nicer CSV rendering
        "mechatroner/rainbow_csv",
    },
}
