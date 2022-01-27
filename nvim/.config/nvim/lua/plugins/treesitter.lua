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
            "python",
            "lua",
            "html",
            "css",
            "cuda"
        },
        highlight = {
            enable = true,
            use_languagetree = true,
            additional_vim_regex_highlighting = true,
        },
        -- windwp/nvim-autopairs
        autopairs = {
            enable = true,
        },

        indent = {
            enable = true
        }
    }
end

return M
