-- Use this to change pack location for architecture
-- local packloc, packloc_count = vim.opt.packpath._value:gsub("/site", "/site_arm")
-- print(packloc)

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

---------------------
--  Packer Config  --
---------------------

if not packer_bootstrap then
    require("packer").init {
        snapshot = 'dotfiles',
        snapshot_path = vim.fn.stdpath('config')..'/packer.nvim/',
        --compile_path = vim.fn.stdpath('cache')..'/plugin/packer.nvim',
        display = {
            open_fn = function()
                return require("packer.util").float {border = "single"}
            end
        },
        git = {
            clone_timeout = 600, -- Timeout, in seconds, for git clones

            subcommands = {
                -- Use this one normally
                update = 'pull --ff-only --progress --rebase=true --allow-unrelated-histories',
                -- Use this one if plugin fails to fast foward
                --update = 'pull --rebase=true',
            }

        }
    }
end

return require('packer').startup(function(use)
    use "wbthomason/packer.nvim"

    ------------------
    --  NAVIGATION  --
    ------------------

    use { -- Ctrl-<hjkl> navigation with TMUX
        "numToStr/Navigator.nvim",
        config = function()
            require("Navigator").setup()
        end
    }

    use { -- Statusline
        "NTBBloodbath/galaxyline.nvim",
        requires = {"kyazdani42/nvim-web-devicons"},
        -- config = function()
            -- require("plugins.statusline").config()
        -- end
    }

    use { -- Keybind Help
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup{}
        end
    }

    use { -- File manager/browser
        "kyazdani42/nvim-tree.lua",
        --cmd = "NvimTreeToggle",
        config = function()
            require("plugins.nvimtree").config()
        end
    }

    use { -- Fuzzy search
        "nvim-telescope/telescope.nvim",
        requires = {
            {"nvim-lua/popup.nvim"},
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope-fzf-native.nvim", run = "make"},
            {"nvim-telescope/telescope-media-files.nvim"}
        },
        config = function()
            require("plugins.telescope").config()
        end
    }

    --------------
    --  COLORS  --
    --------------

    use { -- Gruvbox theme
        "ellisonleao/gruvbox.nvim",
        commit = 'fc66cfbadaf926bc7c2a5e0616d7b8e64f8bd00c',
        requires = {"rktjmp/lush.nvim"},
    }

    use { -- Catppuccin
        "catppuccin/nvim",
        as = "catppuccin"
    }

    use { -- OneDark
        "navarasu/onedark.nvim",
        as = "onedark"
    }

    use { -- Wal theme
        "dylanaraps/wal.vim"
    }

    use { -- Highlight hex colors
        "norcalli/nvim-colorizer.lua",
        event = "BufRead",
        config = function()
            require("colorizer").setup()
            vim.cmd("ColorizerReloadAllBuffers")
        end
    }

    use { -- Highlight todo comments
        "folke/todo-comments.nvim",
        branch = "neovim-pre-0.8.0",
        requires = "nvim-lua/plenary.nvim",
        after = "telescope.nvim",
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
    }
    -----------------------
    --  LANGUAGE SERVER  --
    -----------------------

    use { -- Treesitter front end
        "nvim-treesitter/nvim-treesitter",
        run = ':TSUpdate',
        event = "BufRead",
        config = function()
            require("plugins.treesitter").config()
        end
    }

    use { -- Neovim Language Server
        "neovim/nvim-lspconfig",
        event = "BufRead",
        config = function()
            require("plugins.lspconfig").config()
        end,
        requires = "williamboman/nvim-lsp-installer"
    }

    use { -- Images inside neovim LSP completion menu
        "onsails/lspkind-nvim",
        event = "BufRead",
        config = function()
            require("lspkind").init(require("plugins.lspkind_icons"))
        end
    }

    use {
        "ray-x/lsp_signature.nvim",
        event = "BufRead",
        config = function()
            require("lsp_signature").setup({
                bind = true,
                handler_opts = {
                    border = "rounded"
                },
                hint_enable = false
            })
        end
    }

    ---------------------------
    --  SNIPPETS/COMPLETION  --
    ---------------------------

    use { -- Snippet sources
        "honza/vim-snippets",
        "rafamadriz/friendly-snippets",
    }

    use { -- Snippet engine
        "L3MON4D3/LuaSnip",
        config = function()
            require("plugins.cmp").luasnip()
        end
    }

    use { -- Completion engine
        "hrsh7th/nvim-cmp",
        after = "LuaSnip",
        module = "cmp",
        config = function()
            require("plugins.cmp").config()
        end
    }

    use { -- Completion engine plugins
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        after = "nvim-cmp"
    }

    ---------------
    --  VCS/Git  --
    ---------------

    use { -- Git modification signs
        "lewis6991/gitsigns.nvim",
        event = "BufRead",
        config = function()
            require("plugins.gitsigns").config()
        end
    }

    use { -- Git commands within Neovim
        "tpope/vim-fugitive",
        "tpope/vim-rhubarb"
    }

    use { -- Github PRs in Neovim
        'pwntester/octo.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'kyazdani42/nvim-web-devicons',
        },
        config = function ()
            require("plugins.octo").config()
        end
    }

    ------------------
    --  FORMATTING  --
    ------------------

    use { -- Automatically format files
        "sbdchd/neoformat", cmd = "Neoformat",
        event = "BufRead",
    }

    use { -- Automatically close HTML/XML tags
        "windwp/nvim-ts-autotag",
        after = "nvim-treesitter",
    }

    use { -- Easy navigation between pairs
        "andymass/vim-matchup",
        after = "nvim-treesitter",
        config = function()
            require('nvim-treesitter.configs').setup {
                matchup = {
                    enable = true,
                }
            }

            vim.g.matchup_matchparen_deferred = 0
            vim.g.matchup_matchparen_offscreen = {}--{ method = 'popup' }
        end
    }

    use { -- Easily toggle comments
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()

            local ft = require("Comment.ft")
            ft.set("vhdl", {"--%s", "/*%s*/"})
        end
    }

    use { -- Toggle True/False, Yes/No, etc..
        "lukelbd/vim-toggle",
        config = function()
            -- vim.g.toggle_map            = '<Leader>b'
            vim.g.toggle_chars_on       = true
            vim.g.toggle_words_on       = true
            vim.g.toggle_consecutive_on = true
        end
    }

    use {
        "tpope/vim-sleuth",
        config = function()
        end
    }

    -----------------
    --  UTILITIES  --
    -----------------

    use { -- Benchmark Neovim startup
        "tweekmonster/startuptime.vim",
        cmd = "StartupTime"
    }

    use { -- Auto-save
        "Pocco81/auto-save.nvim",
        event = "BufRead",
        config = function()
            require("plugins.autosave").config()
        end,
        cond = function() -- Only enable if auto save is enabled
            return vim.g.auto_save == true
        end
    }

    use { -- Show current function/class context
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        config = function()
            require'treesitter-context'.setup{
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            }
        end
    }

    use { -- Add indent lines
        "lukas-reineke/indent-blankline.nvim",
        after = "nvim-treesitter",
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

                space_char_blankline = " ",
                show_current_context = true,
                show_current_context_start = false,
            })

            vim.cmd [[highlight IndentBlanklineContextChar guifg=gray]]
        end
    }

    use {
        "echasnovski/mini.nvim",
        branch = 'main',
        config = function()
            require("plugins.mini").config()
        end
    }

    --------------------
    --  LANG HELPERS  --
    --------------------

    use { -- Automatically compile (la)tex
        "lervag/vimtex",
        ft = {'tex'},
    }

    use { -- Preview markdown
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn['mkdp#util#install']() end,
        ft = {'markdown'},
    }

    --------------
    --  PACKER  --
    --------------

    if packer_bootstrap then
        require('packer').sync()
    end
end)
