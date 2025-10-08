--------------
--  COLORS  --
--------------
local events = require("plugins").events
return {
    { -- Gruvbox theme
        "ellisonleao/gruvbox.nvim",
        -- TODO update this to new version
        -- This is being held because new version renamed variables
        dependencies = { "rktjmp/lush.nvim" },
        lazy = true,
    },

    { -- Catppuccin
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
    },

    { -- OneDark
        "navarasu/onedark.nvim",
        name = "onedark",
        lazy = true,
    },

    { -- Adwaita
        "Mofiqul/adwaita.nvim",
        lazy = false,
        priority = 1000,

        -- configure and set on startup
        config = function()
            vim.g.adwaita_darker = false -- for darker version
            vim.g.adwaita_disable_cursorline = false -- to disable cursorline
            vim.g.adwaita_transparent = true -- makes the background transparent
        end,
    },

    { -- Tokyo Night
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    { -- Wal theme
        "dylanaraps/wal.vim",
        lazy = true,
    },

    { -- Highlight hex colors
        "norcalli/nvim-colorizer.lua",
        event = events.OpenFile,
        config = function()
            require("colorizer").setup({
                ["*"] = {
                    rgb_fn = true,
                },
            })
            vim.cmd("ColorizerReloadAllBuffers")
        end,
    },

    { -- Highlight todo comments
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "telescope.nvim",
        },
        event = events.OpenFile,
        opts = {
            signs = false,
            highlight = {
                pattern = [[.*<(KEYWORDS)\s*:?]], -- vim regex
            },
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                -- Don't replace the (KEYWORDS) placeholder
                pattern = [[\b(KEYWORDS):?]], -- ripgrep regex
            },
        },
    },
}
