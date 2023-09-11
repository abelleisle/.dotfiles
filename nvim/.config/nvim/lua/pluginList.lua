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


---------------------
--  Plugin Config  --
---------------------
-- BufEnter is kinda not lazy
local lazy_events = {"BufRead", "BufWinEnter", "BufNewFile"}

return require('lazy').setup({
    ------------------
    --  NAVIGATION  --
    ------------------

    { -- Ctrl-<hjkl> navigation with TMUX
        "numToStr/Navigator.nvim",
        config = function()
            require("Navigator").setup()
        end
    },

    { -- Statusline
        "NTBBloodbath/galaxyline.nvim",
        dependencies = {"kyazdani42/nvim-web-devicons"},
        -- config = function()
            -- require("plugins.statusline").config()
        -- end
    },

    { -- Keybind Help
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup{}
        end
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
            {"nvim-telescope/telescope-fzf-native.nvim", build = "make"},
            {"nvim-telescope/telescope-media-files.nvim"}
        },
        config = function()
            require("plugins.telescope").config()
        end
    },

    --------------
    --  COLORS  --
    --------------

    { -- Gruvbox theme
        "ellisonleao/gruvbox.nvim",
        commit = 'fc66cfbadaf926bc7c2a5e0616d7b8e64f8bd00c',
        dependencies = {"rktjmp/lush.nvim"},
    },

    { -- Catppuccin
        "catppuccin/nvim",
        name = "catppuccin"
    },

    { -- OneDark
        "navarasu/onedark.nvim",
        name = "onedark"
    },

    { -- Wal theme
        "dylanaraps/wal.vim"
    },

    { -- Highlight hex colors
        "norcalli/nvim-colorizer.lua",
        event = lazy_events,
        config = function()
            require("colorizer").setup()
            vim.cmd("ColorizerReloadAllBuffers")
        end
    },

    { -- Highlight todo comments
        "folke/todo-comments.nvim",
        branch = "neovim-pre-0.8.0",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "telescope.nvim"
        },
        config = function()
            require("todo-comments").setup {
                signs = false,
                highlight = {
                    pattern = [[(.*\@*<(KEYWORDS)(\s*|:))]],
                },
                search = {
                    pattern = [[@*\b(KEYWORDS)(\s|:)]],
                },
            }
        end
    },
    -----------------------
    --  LANGUAGE SERVER  --
    -----------------------

    { -- Treesitter front end
        "nvim-treesitter/nvim-treesitter",
        build = ':TSUpdate',
        event = lazy_events,
        config = function()
            require("plugins.treesitter").config()
        end
    },

    { -- Neovim Language Server
        "neovim/nvim-lspconfig",
        event = lazy_events,
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
        event = lazy_events,
        config = function()
            require("lspkind").init(require("plugins.lspkind_icons"))
        end
    },

    {
        "ray-x/lsp_signature.nvim",
        event = lazy_events,
        config = function()
            require("lsp_signature").setup({
                bind = true,
                handler_opts = {
                    border = "rounded"
                },
                hint_enable = false
            })
        end
    },

    ---------------------------
    --  SNIPPETS/COMPLETION  --
    ---------------------------

    { -- Snippet sources
        "honza/vim-snippets",
        "rafamadriz/friendly-snippets",
    },

    { -- Snippet engine
        "L3MON4D3/LuaSnip",
        config = function()
            require("plugins.cmp").luasnip()
        end
    },

    { -- Completion engine
        "hrsh7th/nvim-cmp",
        dependencies = "LuaSnip",
        module = "cmp",
        config = function()
            require("plugins.cmp").config()
        end
    },

    { -- Completion engine plugins
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        dependencies = "nvim-cmp"
    },

    ---------------
    --  VCS/Git  --
    ---------------

    { -- Git modification signs
        "lewis6991/gitsigns.nvim",
        event = lazy_events,
        config = function()
            require("plugins.gitsigns").config()
        end
    },

    { -- Git commands within Neovim
        "tpope/vim-fugitive",
        "tpope/vim-rhubarb"
    },

    { -- Github PRs in Neovim
        'pwntester/octo.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'kyazdani42/nvim-web-devicons',
        },
        config = function ()
            require("plugins.octo").config()
        end
    },

    ------------------
    --  FORMATTING  --
    ------------------

    { -- Automatically format files
        "sbdchd/neoformat", cmd = "Neoformat",
        event = lazy_events,
    },

    { -- Automatically close HTML/XML tags
        "windwp/nvim-ts-autotag",
        dependencies = "nvim-treesitter",
    },

    { -- Easy navigation between pairs
        "andymass/vim-matchup",
        dependencies = "nvim-treesitter",
        config = function()
            require('nvim-treesitter.configs').setup {
                matchup = {
                    enable = true,
                }
            }

            vim.g.matchup_matchparen_deferred = 0
            vim.g.matchup_matchparen_offscreen = {}--{ method = 'popup' }
        end
    },

    { -- Easily toggle comments
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()

            local ft = require("Comment.ft")
            ft.set("vhdl", {"--%s", "/*%s*/"})
        end
    },

    { -- Toggle True/False, Yes/No, etc..
        "lukelbd/vim-toggle",
        config = function()
            -- vim.g.toggle_map            = '<Leader>b'
            vim.g.toggle_chars_on       = true
            vim.g.toggle_words_on       = true
            vim.g.toggle_consecutive_on = true
        end
    },

    {
        "tpope/vim-sleuth",
        config = function()
        end
    },

    -----------------
    --  UTILITIES  --
    -----------------

    { -- Benchmark Neovim startup
        "tweekmonster/startuptime.vim",
        cmd = "StartupTime"
    },

    {
        "anuvyklack/windows.nvim",
        dependencies = {
            "anuvyklack/middleclass",
            "anuvyklack/animation.nvim"
        },
        config = function()
            -- vim.o.winwidth = 10
            -- vim.o.winminwidth = 10
            -- vim.o.equalalways = false
            require("windows").setup({
                autowidth = {
                    enable = true,
                    winwidth = 10,
                    filetype = {
                        help = 2,
                    },
                },
                ignore = {
                    buftype = { "quickfix" },
                    filetype = { "NvimTree", "neo-tree", "undotree", "gundo", "fzf", "TelescopePrompt", "TelescopeResults" }
                },
                animation = {
                    enable = true,
                    duration = 300,
                    fps = 30,
                    easing = "in_out_sine"
                }
            })
        end
    },

    -- { -- Auto-save
    --     "Pocco81/auto-save.nvim",
    --     event = lazy_events,
    --     config = function()
    --         require("plugins.autosave").config()
    --     end,
    --     cond = function() -- Only enable if auto save is enabled
    --         return false
    --     end
    -- },

    { -- Show current function/class context
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = "nvim-treesitter",
        config = function()
            require'treesitter-context'.setup{
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            }
        end
    },

    { -- Add indent lines
        "lukas-reineke/indent-blankline.nvim",
        dependencies = "nvim-treesitter",
        event = lazy_events,
        config = function()
            require("indent_blankline").setup({
                char = "▏",
                filetype_exclude = {
                    "help", "terminal", "NvimTree",
                    "TelescopePrompt", "TelescopeResults"
                },
                buftype_exclude = {"terminal"},

                show_first_indent_level = true,
                show_trailing_blankline_indent = false,
                show_end_of_line = true,

                space_char_blankline = " ",
                show_current_context = true,
                show_current_context_start = false,
            })

            vim.opt.list = true
            vim.opt.listchars:append "eol:"
            vim.cmd [[highlight IndentBlanklineContextChar guifg=gray]]
        end
    },

    {
        "echasnovski/mini.nvim",
        branch = 'main',
        -- event = lazy_events,
        config = function()
            require("plugins.mini").config()
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
        build = function() vim.fn['mkdp#util#install']() end,
        ft = {'markdown'},
    }
},
{
    defaults = {
        lazy = true,
    }
})
