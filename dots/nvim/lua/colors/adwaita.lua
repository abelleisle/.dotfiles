local M = {}

-- M.flavours = {"latte", "frappe", "macchiato", "mocha"}
--
-- local function valid_palette(str)
--     for _, element in ipairs(M.flavours) do
--         if (element == str) then
--             return true
--         end
--     end
--     return false
-- end
--
-- local function get_dark_background(flavour)
--     if not valid_palette(flavour) or flavour == "latte" then
--         return "mocha"
--     end
--
--     return flavour
-- end

M.config = function()
    -- if not valid_palette(flavour) then
    --     vim.notify("Unknown catppuccin palette: "..flavour, vim.log.levels.ERROR)
    -- end
    -- require("catppuccin").setup({
    --     flavour = flavour,
    --     background = { -- :h background
    --         light = "latte",
    --         dark = get_dark_background(flavour),
    --     },
    --     transparent_background = false, -- disables setting the background color.
    --     show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    --     term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    --     dim_inactive = {
    --         enabled = false, -- dims the background color of inactive window
    --         shade = "dark",
    --         percentage = 0.15, -- percentage of the shade to apply to the inactive window
    --     },
    --     no_italic = false, -- Force no italic
    --     no_bold = false, -- Force no bold
    --     no_underline = false, -- Force no underline
    --     styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    --         comments = { "italic" }, -- Change the style of comments
    --         conditionals = { "italic" },
    --         loops = {},
    --         functions = {},
    --         keywords = {},
    --         strings = {},
    --         variables = {},
    --         numbers = {},
    --         booleans = {},
    --         properties = {},
    --         types = {},
    --         operators = {},
    --     },
    --     color_overrides = {},
    --     custom_highlights = {},
    --     integrations = {
    --         cmp = true,
    --         gitsigns = true,
    --         nvimtree = true,
    --         telescope = true,
    --         notify = false,
    --         mini = false,
    --         -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    --     },
    -- })

    -- local palette = require('adwaita.utils').gen_colors()
    --
    -- vim.g.colors = {
    --   bg      = palette.libadwaita_dark,
    --   fg      = palette.dark_4,
    --   magenta = palette.purple_1,
    --   red     = palette.red_1,
    --   orange  = palette.orange_1,
    --   yellow  = palette.yellow_1,
    --   green   = palette.green_1,
    --   cyan    = palette.chameleon_3,
    --   blue    = palette.blue_1,
    --   grey0   = palette.dark_4,
    --   grey1   = palette.dark_5,
    --   grey2   = palette.dark_6,
    -- }
    --
    -- if vim.o.background == 'light' then
    --     vim.g.colors.bg = palette.light_1
    --     vim.g.colors.fg = palette.dark_4
    --     vim.g.colors.grey0 = palette.light_4
    --     vim.g.colors.grey1 = palette.light_5
    --     vim.g.colors.grey2 = palette.light_6
    -- end

    -- setup must be called before loading
    vim.cmd.colorscheme("adwaita")

    vim.api.nvim_set_hl(0, "TelescopeSelection", { link = "CursorLine" })
end

return M
