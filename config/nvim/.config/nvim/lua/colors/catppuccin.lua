local M = {}

M.config = function ()
    local flavour = "macchiato" -- latte, frappe, macchiato, mocha
    require("catppuccin").setup({
        flavour = flavour,
        background = { -- :h background
            light = "latte",
            dark = "mocha",
        },
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
            enabled = false, -- dims the background color of inactive window
            shade = "dark",
            percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
            comments = { "italic" }, -- Change the style of comments
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            telescope = true,
            notify = false,
            mini = false,
            -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
    })

    local palette = require("catppuccin.palettes").get_palette(flavour);

    vim.g.colors = {
      bg      = palette.base,
      fg      = palette.text,
      magenta = palette.muave,
      red     = palette.red,
      orange  = palette.peach,
      yellow  = palette.yellow,
      green   = palette.green,
      cyan    = palette.sky,
      blue    = palette.blue,
      grey0   = palette.surface0,
      grey1   = palette.overlay1,
      grey2   = palette.subtext1,
    }

    -- setup must be called before loading
    vim.cmd.colorscheme "catppuccin"
end

return M
