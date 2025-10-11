------------------
--  FORMATTING  --
------------------
local events = require("plugins").events
return {
    { -- Automatically format files
        "sbdchd/neoformat",
        cmd = "Neoformat",
        config = function()
            vim.g.neoformat_run_all_formatters = 1
        end,
    },

    { -- Automatically close HTML/XML tags
        "windwp/nvim-ts-autotag",
        dependencies = "nvim-treesitter",
        event = events.InsertMode,
    },

    { -- Easy navigation between pairs
        "andymass/vim-matchup",
        dependencies = "nvim-treesitter",
        event = events.OpenFile,
        config = function()
            vim.g.matchup_matchparen_deferred = 1
            vim.g.matchup_matchparen_offscreen = {} -- { method = 'popup' }
        end,
    },

    { -- Easily toggle comments
        "numToStr/Comment.nvim",
        event = events.Modified,
        config = function()
            require("Comment").setup()

            local ft = require("Comment.ft")
            ft.set("vhdl", { "--%s", "/*%s*/" })
        end,
    },

    { -- Toggle True/False, Yes/No, etc..
        "rmagatti/alternate-toggler",
        cmd = "ToggleAlternate",
        opts = {
            alternates = {
                ["=="] = "!=",
                ["yes"] = "no",
            },
        },
    },

    -- { -- Automatically set buffer settings based on text
    --     "tpope/vim-sleuth",
    --     event = Events.OpenFile
    -- },
}
