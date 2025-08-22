local M = {}

M.config = function()
    local ibl = require("ibl")
    local hooks = require("ibl.hooks")
    local indent_chars = {
        "▏",
        "▎",
        "▍",
        "▌",
        "▋",
        "▊",
        "▉",
        "█",
        "│",
        "┃",
        "┆",
        "┇",
        "┊",
        "┋",
    }

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        -- Indent line colors
        -- Indent scope colors
        local colorutils = require("utils.colors")
        local sc_hl = vim.api.nvim_get_hl(0, { name = "Normal"} )
        local sc_hl_bg = colorutils.hl_to_hex(sc_hl.bg or vim.g.terminal_color_0, "#000000")
        local sc_hl_fg = colorutils.hl_to_hex(sc_hl.fg or vim.g.terminal_color_15, "#FFFFFF")

        local gray = colorutils.blend(sc_hl_fg, sc_hl_bg, 0.50)
        local spaces = colorutils.blend(sc_hl_fg, sc_hl_bg, 0.10)

        vim.api.nvim_set_hl(0, "IblScope",      { fg=gray })
        vim.api.nvim_set_hl(0, "IblWhitespace", { fg=spaces })
    end)
    local blank_line_opts = {
        indent = {
            char = indent_chars[9],
            smart_indent_cap = true,
            highlight = "IblIndent",
        },
        whitespace = {
            highlight = "IblWhitespace",
        },
        exclude = {
            filetypes = {
                "help", "terminal", "NvimTree",
                "TelescopePrompt", "TelescopeResults"
            },
            buftypes = {
                "terminal"
            },
        },
        scope = {
            enabled = true,
            char = indent_chars[10],
            show_start = false,
            show_end = false,
            highlight = "IblScope",
        },
    }

    -- Enabled these for endline
    vim.opt.list = true
    vim.opt.listchars = {
        -- eol = "" -- Option 1
        -- eol = "↴" -- Option 2
        tab = "   ",
        lead= "∙",
        -- leadmultispace = "⋅˙",
    }

    ibl.setup(blank_line_opts)
end

return M
