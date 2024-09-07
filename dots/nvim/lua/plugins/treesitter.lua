local M = {}

M.config = function()
    local ts_config = require("nvim-treesitter.configs")

    ts_config.setup {
        ensure_installed = {
            -- Compiled
            "c",
            "cpp",
            "cuda",
            "glsl",
            "rust",
            "verilog",
            "bash",
            "lua",
            "python",
            "zig",

            -- Markup/Web
            "css",
            "html",
            -- "latex",
            "php",

            -- Config
            "cmake",
            "json",
            "jsonc",
            "markdown",
            "markdown_inline",
            "yaml"
        },
        sync_install = true, -- Wait while parsers install
        highlight = {
            enable = true,
            use_languagetree = true,
            --additional_vim_regex_highlighting = true,
            -- Disable treesitter highlight on files larger than 1 MB in size
            disable = function(lang, buf)
                local max_filesize = 1 * 1024 * 1024 -- 1 MB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
        },
        autopairs = { -- windwp/nvim-autopairs
            enable = true,
        },

        autotag = { -- windwp/nvim-ts-autotag
            enable = true,
            filetypes = { "html" , "xml", "php" },
        },

        matchup = { -- andymass/vim-matchup
            enable = true,
        },

        -- This is experimental, so it's disabled for now.
        -- With this enabled, continuing comments on new lines didn't align
        -- to the last set of comments on the previous line.
        -- indent = {
        --     enable = true,
        --     disable = {
        --         'cpp'
        --     }
        -- }
    }
end

return M
