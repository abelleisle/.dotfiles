local events = require("plugins").events

---------------------
--  Plugin Config  --
---------------------
return {
    -----------------
    --  UTILITIES  --
    -----------------
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

    --------------------
    --  LANG HELPERS  --
    --------------------

    { -- Automatically compile (la)tex
        "lervag/vimtex",
        ft = { "tex" },
    },

    { -- Preview markdown
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },

    { -- Edit hex
        "RaafatTurki/hex.nvim",
        enabled = (vim.fn.executable("xxd") == 1),
        config = function()
            require("hex").setup()
        end,
    },

}
