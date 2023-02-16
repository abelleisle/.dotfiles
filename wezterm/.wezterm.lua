-----------------------------------------------------
--                    LIBRARIES                    --
-----------------------------------------------------
local wezterm   = require('wezterm')
local wezaction = wezterm.action

-----------------
--  VARIABLES  --
-----------------
local wez_colors, _ = wezterm.color.load_scheme(wezterm.home_dir.."/.cache/wal/colors-wez.toml")

----------------------------------------------------
--                    SETTINGS                    --
----------------------------------------------------
return {
    ------------------
    --  APPEARANCE  --
    ------------------
    hide_tab_bar_if_only_one_tab = true,

    --------------
    --  COLORS  --
    --------------
    colors = wez_colors,

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
