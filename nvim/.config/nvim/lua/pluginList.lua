local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require("packer").init {
    display = {
        open_fn = function()
            return require("packer.util").float {border = "single"}
        end
    },
    git = {
        clone_timeout = 600, -- Timeout, in seconds, for git clones

        subcommands = {
            update = 'pull --ff-only --progress --rebase=false --allow-unrelated-histories',
        }

    }
}

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
        requires = {"rktjmp/lush.nvim"}
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
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {
                signs = false,
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            }
        end
    }
    -----------------------
    --  LANGUAGE SERVER  --
    -----------------------

    use { -- Treesitter front end
        "nvim-treesitter/nvim-treesitter",
        run = ':TSUpdate',
        --event = "BufRead",
        config = function()
            require("plugins.treesitter").config()
        end
    }

    -- use {
    --     "williamboman/nvim-lsp-installer"
    -- }

    use { -- Neovim Language Server
        "neovim/nvim-lspconfig",
        event = "BufRead",
        --setup = function()
        --    --require("plugins.lspconfig").config()
        --    vim.defer_fn(function()
        --        vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
        --    end, 0)
        --end,
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

    -- load compe in insert mode only
    -- use {
    --     "hrsh7th/nvim-compe",
    --     event = "InsertEnter",
    --     config = function()
    --         require("plugins.compe").config()
    --     end,
    --     -- wants = {"LuaSnip"},
    --     requires = {
    --         -- {
    --         --     "L3MON4D3/LuaSnip",
    --         --     wants = "friendly-snippets",
    --         --     event = "InsertCharPre",
    --         --     config = function()
    --         --         require("plugins.compe").snippets()
    --         --     end
    --         -- },
    --         -- "rafamadriz/friendly-snippets",
    --         "ray-x/lsp_signature.nvim",
    --         "SirVer/ultisnips",
    --         "honza/vim-snippets"
    --     }
    -- }

    -- use { -- Completion Plugin
    --     "nvim-lua/completion-nvim",
    --     after = "nvim-lspconfig",
    --     event = "BufRead",
    --     config = function()
    --         vim.g.completion_enable_auto_popup = 1
    --         vim.g.completion_enable_snippet = 'UltiSnips'
    --         -- vim.cmd("autocmd BufEnter * lua require'completion'.on_attach()")
    --     end,
    --     requires = {
    --         {
    --             "SirVer/ultisnips",
    --             config = function()
    --                 vim.g.UltiSnipsExpandTrigger="<Nop>"
    --                 vim.g.UltiSnipsJumpForwardTrigger="<Nop>"
    --                 vim.g.UltiSnipsJumpBackwardTrigger="<Nop>"
    --                 vim.g.UltiSnipsSnippetDirectories={"UltiSnips"}
    --             end
    --         },
    --         "honza/vim-snippets"
    --     }
    -- }
    
--         Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
--         " 9000+ Snippets
--         Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
-- 
--         " lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
--         " Need to **configure separately**
-- 
--         Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

    --[[
    use {
        "ms-jpq/coq_nvim",
        branch = 'coq',

        requires = {
            {
                'ms-jpq/coq.artifacts',
                branch = 'artifacts'
            },
            {
                'ms-jpq/coq.thirdparty',
                branch = '3p'
            }
        },

        config = function()
            vim.g.coq_settings = {
                auto_start = 'shut-up',
                keymap = {
                    jump_to_mark = '<C-q>',
                    bigger_preview = nil
                }
            }
        end
    }
    --]]

    use {
        "rafamadriz/friendly-snippets",
        event = "InsertEnter",
    }

    use {
        "hrsh7th/nvim-cmp",
        module = "cmp",
        after = "friendly-snippets",
        config = function()
            require("plugins.cmp").config()
        end
    }

    use {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        after = "nvim-cmp",
        config = function()
            require("plugins.cmp").luasnip()
        end
    }

    use {
        "saadparwaiz1/cmp_luasnip",
        after = "LuaSnip",
    }

    use {
        "hrsh7th/cmp-nvim-lua",
        --after = "cmp_luasnip",
    }

    use {
        "hrsh7th/cmp-nvim-lsp",
        --module = "cmp_nvim_lsp",
        --after = "nvim-lspconfig",
    }

    use {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    }

    -- UltiSnips
    use {
        "honza/vim-snippets", rtp = '.',
    }
    use {
        "SirVer/ultisnips",
        config = function()
            vim.g.UltiSnipsExpandTrigger="<Nop>"
            vim.g.UltiSnipsJumpForwardTrigger="<Nop>"
            vim.g.UltiSnipsJumpBackwardTrigger="<Nop>"
            vim.g.UltiSnipsSnippetDirectories={"UltiSnips"}
            vim.g.UltiSnipsRemoveSelectModeMappings = 0
        end,
        requires = {
            "quangnguyen30192/cmp-nvim-ultisnips",
            config = function()
                -- optional call to setup (see customization section)
                require("cmp_nvim_ultisnips").setup{
                    -- filetype_source = "treesitter",
                    -- show_snippets = "all",
                    -- documentation = function(snippet)
                    --     return snippet.description
                    -- end
                }
            end,
        }
    }

    use { -- Automatically format files
        "sbdchd/neoformat", cmd = "Neoformat"
    }

    use { -- Easily align text
        "junegunn/vim-easy-align"
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
                hl = 'SpellBad',
                captures = {}
            })
        end
    }

    use {
        "romgrk/nvim-treesitter-context",
        after = "nvim-treesitter",
        config = function()
            require'treesitter-context.config'.setup{
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

    use { -- Comment lines easily
        "terrortylor/nvim-comment",
        cmd = "CommentToggle",
        config = function()
            require("nvim_comment").setup()
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
        "Pocco81/AutoSave.nvim",
        config = function()
            require("plugins.zenmode").autoSave()
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

    use { -- Distraction-free editing
        "Pocco81/TrueZen.nvim",
        cmd = {"TZAtaraxis", "TZMinimalist", "TZFocus"},
        config = function()
            require("plugins.zenmode").config()
        end
    }

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
