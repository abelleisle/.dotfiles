local M = {}

M.config = function()
    local ts_config = require("nvim-treesitter.configs")

    ts_config.setup {
        ensure_installed = {
            "cpp",
            "c",
            "verilog",
            "latex",
            "bash",
            "json",
            "jsonc",
            "python",
            "lua",
            "html",
            "php",
            "css",
            "cuda",
            "rust",
            "zig",
            "glsl",
            "nix",
            "markdown",
            "markdown_inline",
            "yaml"
        },
        sync_install = true, -- Wait while parsers install
        highlight = {
            enable = true,
            use_languagetree = true,
            --additional_vim_regex_highlighting = true,
        },
        autopairs = { -- windwp/nvim-autopairs
            enable = true,
        },

        autotag = { -- windwp/nvim-ts-autotag
            enable = true,
            filetypes = { "html" , "xml", "php" },
        },

        indent = {
            enable = true,
            disable = {
                'cpp'
            }
        }
    }
end

return M