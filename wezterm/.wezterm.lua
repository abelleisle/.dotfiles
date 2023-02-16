-----------------------------------------------------
--                    LIBRARIES                    --
-----------------------------------------------------
local wezterm   = require('wezterm')
local wezaction = wezterm.action

-----------------
--  VARIABLES  --
-----------------
-- Colorscheme file
local theme_file = wezterm.home_dir.."/.cache/wal/colors-wez.toml"

-- Colorscheme Colors
local scheme_colors, _ = wezterm.color.load_scheme(theme_file)


local bar_colors = {
    bg       = scheme_colors.background,
    fg       = "#C0C0C0",
    red      = '#EC5F67',
    orange   = '#FF8800',
    yellow   = '#FABD2F',
    green    = '#AFD700',
    blue     = '#0087D7',
    cyan     = '#008080',
    purple   = '#3C3836',
    darkblue = '#504945',
    magenta  = '#D16D9E',
    grey     = '#C0C0C0',
}

-- Tab bar colors
local tab_colors = {
    tab_bar = {
        background = scheme_colors.background,
        active_tab = {
            bg_color = bar_colors.darkblue,
            fg_color = bar_colors.yellow,
        },
        inactive_tab = {
            bg_color = bar_colors.purple,
            fg_color = bar_colors.grey,
        },
        new_tab = {
            bg_color = bar_colors.bg,
            fg_color = bar_colors.red,
        }
    }
}

-- Output colors
local final_colors = {}

-- Merge color tables
local color_tables = {scheme_colors, tab_colors}
for _,t in pairs(color_tables) do
    for k,v in pairs(t) do final_colors[k] = v end
end

----------------------------------------------------
--                    SETTINGS                    --
----------------------------------------------------
-- Reload wez if colorscheme is changed (wal support)
wezterm.add_to_config_reload_watch_list(theme_file)

-- Actual settings table
return {
    ------------------
    --  APPEARANCE  --
    ------------------
    hide_tab_bar_if_only_one_tab = true,
    use_fancy_tab_bar            = false,
    tab_bar_at_bottom            = true,

    --------------
    --  COLORS  --
    --------------
    colors = final_colors,

    ------------
    --  FONT  --
    ------------
    font = wezterm.font {
        family = "FiraCode Nerd Font Mono",
        weight = "Regular",
        stretch = "Normal",
        style = "Normal",
        harfbuzz_features = {
            -- Font Feature Notes/Testing:
            "zero = 0",     -- 0
            "ss02 = 1",     -- <= >=
            "ss03 = 0",     -- &
            "ss04 = 1",     -- $
            "ss05 = 0",     -- @
            "ss06 = 1",     -- \\
            "ss07 = 1",     -- ~=
            "ss08 = 0",     -- == === != !==
            "ss09 = 0",     -- >>= <<= ||= |=
            "cv14 = 1",     -- 3
            "cv29 = 0",     -- {}
            "cv30 = 1",     -- |
            "cv31 = 1",     -- ()
            "onum = 0",     -- 0123456789
        },
    },
    font_size = 14,

    -------------------
    --  KEYBINDINGS  --
    -------------------
    keys = {
        --
        -- Fix some mac bindings
        --
        { -- Move one tab to the left
            key    = "LeftArrow",
            mods   = "CMD|ALT",
            action = wezaction.ActivateTabRelative(-1)
        },
        { -- Move one tab to the right
            key    = "RightArrow",
            mods   = "CMD|ALT",
            action = wezaction.ActivateTabRelative(1)
        }
    },
}
