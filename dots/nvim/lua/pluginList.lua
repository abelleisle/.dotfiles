-- Use this to change pack location for architecture
-- local packloc, packloc_count = vim.opt.packpath._value:gsub("/site", "/site_arm")
-- print(packloc)

----------------------
--  LAZY BOOTSTRAP  --
----------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- If we can't install plugins, don't bother
vim.g.plugins_installed = vim.fn.has("nvim-0.8.0") ~= 0
if not vim.g.plugins_installed then
    return
end

---------------------
--  Plugin Config  --
---------------------
-- BufEnter is kinda not lazy
local lazy_events = {"BufRead", "BufWinEnter", "BufNewFile"}

local Events = {
    OpenFile = {"BufReadPost", "BufNewFile"},
    InsertMode = {"InsertEnter"},
    EnterWindow = {"BufEnter"},
    CursorMove = {"CursorMoved"},
    Modified = {"TextChanged", "TextChangedI"}
}

return require('lazy').setup({ spec = {
    ------------------
    --  NAVIGATION  --
    ------------------

    { -- Ctrl-<hjkl> navigation with TMUX
        "numToStr/Navigator.nvim",
        opts = {
            auto_save = nil,
            disable_on_zoom = true
        },
    },

    { -- Statusline
        "NTBBloodbath/galaxyline.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },

    { -- Statusline
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },

    { -- File manager/browser
        "kyazdani42/nvim-tree.lua",
        cmd = "NvimTreeToggle",
        config = function()
            require("plugins.nvimtree").config()
        end
    },

    { -- Fuzzy search
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {"nvim-lua/popup.nvim"},
            {"nvim-lua/plenary.nvim"},
        },
        event = Events.EnterWindow,
        config = function()
            require("plugins.telescope").config()
        end
    },

    { -- Telescope plugins
        {"abelleisle/telescope-fzf-native.nvim", build = "make"}, -- Prod
        -- {dir = "~/Development/telescope-fzf-native.nvim", build = "make"}, -- Dev
        {"nvim-telescope/telescope-media-files.nvim"},
        lazy = true,
    },

    { -- Leap
        "ggandor/leap.nvim",
        enabled = true,
        keys = require("mappings").leap,
        opts = {
            labels = 'tnseriaoplfuvmwyqjc,x.z' --home row & least effort keys for Colemak layout
        },
        config = function(_, opts)
            local leap = require("leap")
            for k, v in pairs(opts) do
                leap.opts[k] = v
            end
            leap.add_default_mappings(true)
            vim.keymap.del({ "x", "o" }, "x")
            vim.keymap.del({ "x", "o" }, "X")
        end,
    },

    { -- Harpoon
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        -- config = true -- Force harpoon setup without opts set
        -- lazy = true, -- This is faster but may not work properly
        config = function()
            require("harpoon").setup()
            require("mappings").harpoon_extend()
        end
    },

    --------------
    --  COLORS  --
    --------------

    { -- Gruvbox theme
        "ellisonleao/gruvbox.nvim",
        -- TODO update this to new version
        -- This is being held because new version renamed variables
        dependencies = {"rktjmp/lush.nvim"},
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

    { -- Wal theme
        "dylanaraps/wal.vim",
        lazy = true,
    },

    { -- Highlight hex colors
        "norcalli/nvim-colorizer.lua",
        event = Events.OpenFile,
        config = function()
            require("colorizer").setup({
                ['*'] = {
                    rgb_fn = true;
                },
            })
            vim.cmd("ColorizerReloadAllBuffers")
        end
    },

    { -- Highlight todo comments
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "telescope.nvim"
        },
        event = Events.OpenFile,
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
        }
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
                    name = "tcl"
                }
            }
        }
    },
    -----------------------
    --  LANGUAGE SERVER  --
    -----------------------

    { -- Treesitter front end
        "nvim-treesitter/nvim-treesitter",
        build = ':TSUpdate',
        event = Events.OpenFile,
        config = function()
            require("plugins.treesitter").config()
        end
    },

    { -- Neovim Language Server
        "neovim/nvim-lspconfig",
        event = Events.OpenFile,
        config = function()
            require("plugins.lspconfig").config()
        end,
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim"
        }
    },

    { -- Images inside neovim LSP completion menu
        "onsails/lspkind-nvim",
        event = Events.InsertMode,
        config = function()
            require("lspkind").init(require("plugins.lspkind_icons"))
        end
    },

    {
        "ray-x/lsp_signature.nvim",
        event = Events.OpenFile,
        opts = {
            bind = true,
            handler_opts = {
                border = "rounded"
            },
            hint_enable = false
        }
    },

    { -- Debug adapter protocol
        "mfussenegger/nvim-dap"
    },

    ---------------------------
    --  SNIPPETS/COMPLETION  --
    ---------------------------

    { -- Snippet sources
        "honza/vim-snippets",
        "rafamadriz/friendly-snippets",
        event = Events.InsertMode,
    },

    { -- Snippet engine
        "L3MON4D3/LuaSnip",
        event = Events.InsertMode,
        build = "make install_jsregexp",
        config = function()
            require("plugins.cmp").luasnip()
        end
    },

    { -- Completion engine
        "hrsh7th/nvim-cmp",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "LuaSnip",
        },
        module = "cmp",
        event = Events.InsertMode,
        config = function()
            require("plugins.cmp").config()
        end
    },

    ---------------
    --  VCS/Git  --
    ---------------

    { -- Git modification signs
        "lewis6991/gitsigns.nvim",
        event = Events.OpenFile,
        config = function()
            require("plugins.gitsigns").config()
        end
    },

    { -- Git commands within Neovim
        "tpope/vim-fugitive",
        "tpope/vim-rhubarb",
        event = Events.EnterWindow
    },

    { -- Github PRs in Neovim
        'pwntester/octo.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        cmd = "Octo",
        config = function ()
            vim.notify("Loading octo")
            require("plugins.octo").config()
        end
    },

    {
        'ruifm/gitlinker.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        event = Events.EnterWindow,
        opts = {
            opts = {
                print_url = false,
            },
            mappings = nil,
        },
    },

    ------------------
    --  FORMATTING  --
    ------------------

    { -- Automatically format files
        "sbdchd/neoformat",
        cmd = "Neoformat",
        config = function ()
            vim.g.neoformat_run_all_formatters = 1
        end
    },

    { -- Automatically close HTML/XML tags
        "windwp/nvim-ts-autotag",
        dependencies = "nvim-treesitter",
        event = Events.InsertMode,
    },

    { -- Easy navigation between pairs
        "andymass/vim-matchup",
        dependencies = "nvim-treesitter",
        event = Events.OpenFile,
        config = function()
            vim.g.matchup_matchparen_deferred = 1
            vim.g.matchup_matchparen_offscreen = {} -- { method = 'popup' }
        end
    },

    { -- Easily toggle comments
        "numToStr/Comment.nvim",
        event = Events.Modified,
        config = function()
            require("Comment").setup()

            local ft = require("Comment.ft")
            ft.set("vhdl", {"--%s", "/*%s*/"})
        end
    },

    { -- Toggle True/False, Yes/No, etc..
        "rmagatti/alternate-toggler",
        cmd = "ToggleAlternate",
        opts = {
            alternates = {
                ["=="] = "!=",
                ["yes"] = "no",
            }
        }
    },

    -- { -- Automatically set buffer settings based on text
    --     "tpope/vim-sleuth",
    --     event = Events.OpenFile
    -- },

    -----------------
    --  UTILITIES  --
    -----------------

    { -- Benchmark Neovim startup
        "tweekmonster/startuptime.vim",
        cmd = "StartupTime"
    },

    { -- Auto buffer resizing
        "anuvyklack/windows.nvim",
        dependencies = {
            "anuvyklack/middleclass",
            "anuvyklack/animation.nvim"
        },
        event = Events.EnterWindow,
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
                filetype = { "NvimTree", "neo-tree", "undotree", "gundo",
                             "fzf", "TelescopePrompt", "TelescopeResults",
                             "Avante", "AvanteInput", "AvanteSelectedFiles",
                             "codecompanion" }
            },
            animation = {
                enable = true,
                duration = 300,
                fps = 30,
                easing = "in_out_sine"
            }
        },
    },

    { -- Show current function/class context
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = "nvim-treesitter",
        event = Events.OpenFile,
        opts = {
            enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        }
    },

    { -- Add indent lines
        "lukas-reineke/indent-blankline.nvim",
        dependencies = "nvim-treesitter",
        event = Events.OpenFile,
        main = "ibl",
        opts = {},
        config = require("plugins.indentlines").config
    },

    { -- Various small utilies
        "echasnovski/mini.nvim",
        branch = 'main',
        event = Events.OpenFile,
        config = function()
            require("plugins.mini").config()
        end
    },

    { -- Devcontainer support
        "https://codeberg.org/esensar/nvim-dev-container",
        config = function()
            require("devcontainer").setup({})
        end
    },

    --------------------
    --  LANG HELPERS  --
    --------------------

    { -- Automatically compile (la)tex
        "lervag/vimtex",
        ft = {'tex'},
    },

    { -- Preview markdown
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = {'markdown'},
        build = function() vim.fn['mkdp#util#install']() end,
    },

    { -- Edit hex
        "RaafatTurki/hex.nvim",
        enabled = (vim.fn.executable('xxd') == 1),
        config = function()
            require("hex").setup()
        end
    },

    ----------------
    --  AI STUFF  --
    ----------------
    -- I really don't want this stuff in here,
    -- but I guess this is the future :(

    { -- Copilot chat
        "olimorris/codecompanion.nvim",
        config = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = require("plugins.codecompanion").opts,
    },
    { -- AI Coding Companion
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = true,
        version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
        opts = require("plugins.avante").opts,
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
            -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            -- "zbirenbaum/copilot.lua", -- for providers='copilot'
            -- {
            --     -- support for image pasting
            --     "HakonHarnes/img-clip.nvim",
            --     event = "VeryLazy",
            --     opts = {
            --         -- recommended settings
            --         default = {
            --             embed_image_as_base64 = false,
            --             prompt_for_file_name = false,
            --             drag_and_drop = {
            --                 insert_mode = true,
            --             },
            --             -- required for Windows users
            --             use_absolute_path = true,
            --         },
            --     },
            -- },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },

},
    -- defaults = {
    --     lazy = false,
    -- }
    git = {
        timeout = 600, -- kill processes that take more than 2 minutes
    }
})
