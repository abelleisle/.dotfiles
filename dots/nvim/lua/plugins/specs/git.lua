---------------
--  VCS/Git  --
---------------

local events = require("plugins").events
return {
    { -- Git commands within Neovim
        "tpope/vim-fugitive",
        "tpope/vim-rhubarb",
        event = events.EnterWindow,
    },

    { -- Get github permalink for selected lines
        "ruifm/gitlinker.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        event = events.EnterWindow,
        opts = {
            opts = {
                print_url = false,
            },
            mappings = nil,
        },
    },

    { -- View git diffs for any revision
        "sindrets/diffview.nvim",
    },

}
