local events = require("plugins").events
return {
    { -- Statusline
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    { -- Filetype icons
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        opts = {
            -- your personnal icons can go here (to override)
            -- you can specify color or cterm_color instead of specifying both of them
            -- DevIcon will be appended to `name`
            override = {
                tcl = {
                    icon = "",
                    name = "tcl",
                },
            },
        },
    },

    { -- Replace all UI with new look
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = false, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false, -- add a border to hover docs and signature help
            },
            popupmenu = {
                backend = "cmp",
            },
            views = {
                hover = {
                    border = {
                        style = "rounded",
                    },
                    position = { row = 2, col = 0 },
                },
            },
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            {
                "rcarriga/nvim-notify",
                opts = {
                    top_down = false,
                },
            },
        },
    },

    { -- Auto buffer resizing
        "anuvyklack/windows.nvim",
        dependencies = {
            "anuvyklack/middleclass",
            "anuvyklack/animation.nvim",
        },
        event = events.EnterWindow,
        opts = {
            autowidth = {
                enable = true,
                winwidth = 10,
                filetype = {
                    help = 2,
                },
            },
            ignore = {
                buftype = { "quickfix" },
                filetype = {
                    "NvimTree",
                    "neo-tree",
                    "undotree",
                    "gundo",
                    "fzf",
                    "TelescopePrompt",
                    "TelescopeResults",
                    "Avante",
                    "AvanteInput",
                    "AvanteSelectedFiles",
                    "codecompanion",
                },
            },
            animation = {
                enable = true,
                duration = 300,
                fps = 30,
                easing = "in_out_sine",
            },
        },
    },
}
