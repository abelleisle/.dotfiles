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

    use { -- Easy sneaking motion
        "justinmk/vim-sneak"
    }

    use { -- Motion across file
        "easymotion/vim-easymotion"
    }

    use { -- Statusline
        "NTBBloodbath/galaxyline.nvim",
        requires = {"kyazdani42/nvim-web-devicons"},
        config = function()
            require("plugins.statusline").config()
        end
    }

    --------------
    --  COLORS  --
    --------------

    use { -- Gruvbox theme
        "ellisonleao/gruvbox.nvim",
        commit = 'cb7a8a867cfaa7f0e8ded57eb931da88635e7007',
        requires = {"rktjmp/lush.nvim"},
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

    use {
        "folke/todo-comments.nvim",
        branch = "neovim-pre-0.8.0",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {
                signs = false,
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
        "honza/vim-snippets", rtp = '.',
        event = "BufRead"
    }

    use {
        "rafamadriz/friendly-snippets",
        event = "BufRead"
    }

    use {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        config = function()
            require("plugins.cmp").luasnip()
            require("snippets").config()
        end
    }

    use {
        "saadparwaiz1/cmp_luasnip",
        after = "LuaSnip",
    }

    use {
        "hrsh7th/nvim-cmp",
        module = "cmp",
        after = "LuaSnip",
        config = function()
            require("plugins.cmp").config()
        end
    }

    use {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        after = "nvim-cmp"
    }

    use { -- Automatically format files
        "sbdchd/neoformat", cmd = "Neoformat",
        event = "BufRead",
    }

    use { -- Easily align text
        "junegunn/vim-easy-align",
        config = function()
            vim.g.easy_align_delimiters = {
                ['/'] = {
                    pattern = '//\\+',
                    delimiter_align = 'l',
                    ignore_groups = {'!Comment'}
                }
            }
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
        --cmd = "Telescope",
        config = function()
            require("plugins.telescope").config()
        end
    }

    use { -- Git modification signs
        "lewis6991/gitsigns.nvim",
        event = "BufRead",
        config = function()
            require("plugins.gitsigns").config()
        end
    }

    use {
        "tpope/vim-fugitive",
        "tpope/vim-rhubarb"
    }

    use {
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

    use { -- Automatically add ending pairs
        "windwp/nvim-autopairs",
        --after = "coq_nvim",
        config = function()
            local npairs = require("nvim-autopairs")
            local ts_conds = require("nvim-autopairs.ts-conds")
            local rule = require("nvim-autopairs.rule")
            npairs.setup({
                check_ts = true,
                ts_config = {

                },
                map_cr = true,
                enable_check_bracket_line = false
            })
            -- npairs.add_rules({
            --     rule("%", "%", "lua")
            --         :with_pair(ts_conds.is_ts_node({'string','comment'})),
            --     rule("$", "$", "lua")
            --         :with_pair(ts_conds.is_not_ts_node({'function'}))
            -- })
            --
            -- require("nvim-autopairs.completion.compe").setup(
            --     {
            --         map_cr = true,
            --         map_complete = true -- insert () func completion
            --     }
            -- )
            -- you need setup cmp first put this after cmp.setup()
            --require("nvim-autopairs.completion.cmp").setup({
            require("cmp").setup({
                map_cr = true, --  map <CR> on insert mode
                map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
                auto_select = true, -- automatically select the first item
                insert = false, -- use insert confirm behavior instead of replace
                map_char = { -- modifies the function or method delimiter by filetypes
                }
            })
        end
    }

    --[[
    use {
        "steelsojka/pears.nvim",
        config = function ()
            require('pears').setup()
        end
    }
    --]]

    use { -- Automatically close HTML/XML tags
        "windwp/nvim-ts-autotag",
        after = "nvim-treesitter",
        --event = "BufRead",
        config = function()
            require('nvim-ts-autotag').setup({
                filetypes = { "html" , "xml", "php" },
            })
        end
    }

    use {
        "lewis6991/spellsitter.nvim",
        after = "nvim-treesitter",
        config = function()
            require('spellsitter').setup({
                --hl = 'SpellBad',
                enable = true,
                captures = {}
            })
        end
    }

    use {
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        config = function()
            require'treesitter-context'.setup{
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            }
        end
    }

    use { -- Easy navigation between pairs
        "andymass/vim-matchup",
        event = "CursorMoved",
        config = function()
            require('nvim-treesitter.configs').setup {
                matchup = {
                    enable = true,
                }
            }
            --vim.g.matchup_matchparen_deferred = 1
            --vim.g.matchup_matchparen_offscreen = { method = 'popup' }
            --vim.g.matchup_honor_rnu = 1
        end
    }

    -- use { -- Comment lines easily
    --     "terrortylor/nvim-comment",
    --     cmd = "CommentToggle",
    --     config = function()
    --         require("nvim_comment").setup()
    --     end
    -- }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup({
                toggler = {
                    ---Line-comment toggle keymap
                    line = '<Leader>/',
                },
            })
        end
    }

    use { -- VIM Startup dashboard
        "glepnir/dashboard-nvim",
        cmd = {
            "Dashboard",
            "DashboardNewFile",
            "DashboardJumpMarks",
            "SessionLoad",
            "SessionSave"
        },
        setup = function()
            require("plugins.dashboard").config()
        end
    }

    use { -- Benchmark Neovim startup
        "tweekmonster/startuptime.vim",
        cmd = "StartupTime"
    }

    use { -- Auto-save
        "Pocco81/auto-save.nvim",
        config = function()
            require("plugins.autosave").config()
        end,
        cond = function() -- Only enable if auto save is enabled
            return vim.g.auto_save == true
        end
    }

    -- smooth scroll
    -- use {
    --     "karb94/neoscroll.nvim",
    --     event = "WinScrolled",
    --     config = function()
    --         require("neoscroll").setup()
    --     end
    -- }

    use { -- Add indent lines
        "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        setup = function()
            require("utils").blankline()
            vim.g.indent_blankline_show_first_indent_level = true
            vim.g.indent_blankline_show_current_context = true
            vim.g.indent_blankline_show_trailing_blankline_indent = false
            vim.cmd [[highlight IndentBlanklineContextChar guifg=gray]]
            -- IndentBlanklineContextChar
        end
    }

    use {
        'jdhao/whitespace.nvim',
        event = 'VimEnter',
    }

    use {
        "lervag/vimtex",
        ft = {'tex'},
    }

    use {
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn['mkdp#util#install']() end,
        ft = {'markdown'}
    }

    use {
        "lambdalisue/suda.vim"
    }

    if packer_bootstrap then
        require('packer').sync()
    end
end)
