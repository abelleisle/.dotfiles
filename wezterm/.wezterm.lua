-----------------------------------------------------
--                    LIBRARIES                    --
-----------------------------------------------------
local wezterm   = require('wezterm')
local wezaction = wezterm.action

------------------
--  APPEARANCE  --
------------------
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

local font_rule_set = function(weight, style)
    local config = wezterm.font {
        family = "FiraCode Nerd Font Mono",
        weight = weight,
        stretch = "Normal",
        style = style,
        harfbuzz_features = {
            -- Font Feature Notes/Testing:
            "zero = 1",     -- 0
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
        scale = 1.0
    }

    return config
end

---------------------------------------------------
--                    ACTIONS                    --
---------------------------------------------------
local function isViProcess(pane)
    -- get_foreground_process_name On Linux, macOS and Windows,
    -- the process can be queried to determine this path. Other operating systems
    -- (notably, FreeBSD and other unix systems) are not currently supported
    return pane:get_foreground_process_name():find('n?vim') ~= nil
    -- return pane:get_title():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
    if isViProcess(pane) then
        window:perform_action(
            -- This should match the keybinds you set in Neovim.
            wezaction.SendKey({ key = vim_direction, mods = 'CTRL' }),
            pane
        )
    else
        window:perform_action(wezaction.ActivatePaneDirection(pane_direction), pane)
    end
end

wezterm.on('ActivatePaneDirection-right', function(window, pane)
    conditionalActivatePane(window, pane, 'Right', 'l')
end)
wezterm.on('ActivatePaneDirection-left', function(window, pane)
    conditionalActivatePane(window, pane, 'Left', 'h')
end)
wezterm.on('ActivatePaneDirection-up', function(window, pane)
    conditionalActivatePane(window, pane, 'Up', 'k')
end)
wezterm.on('ActivatePaneDirection-down', function(window, pane)
    conditionalActivatePane(window, pane, 'Down', 'j')
end)

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
    font = font_rule_set("Regular", "Normal"),
    font_rules = {
        { -- Bold but not italic
            intensity = 'Bold',
            italic = false,
            font = font_rule_set("DemiBold", "Normal"),
        },
        { -- Bold and italic
            intensity = 'Bold',
            italic = true,
            font = font_rule_set("DemiBold", "Italic"),
        },
        { -- Normal and italic
            intensity = 'Normal',
            italic = true,
            font = font_rule_set("Regular", "Italic"),
        },
        { -- Normal and Normal
            intensity = 'Normal',
            italic = false,
            font = font_rule_set("Regular", "Normal"),
        },
        { -- Half and italic
            intensity = 'Half',
            italic = true,
            font = font_rule_set("Light", "Italic"),
        },
        { -- Half and not italic
            intensity = 'Half',
            italic = false,
            -- font = font_rule_set("Light", "Normal"),
            font = font_rule_set("Light", "Normal"),
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
        },

        --
        -- Fix some Linux bindings
        --
        --[[ { -- Create new tab
            key    = "T",
            mods   = "CTRL",
            action = wezaction.SpawnTab('CurrentPaneDomain')
        } ]]

        --
        -- nvim Navigator bindings
        --
        { key = 'h', mods = 'CTRL', action = wezaction.EmitEvent('ActivatePaneDirection-left') },
        { key = 'j', mods = 'CTRL', action = wezaction.EmitEvent('ActivatePaneDirection-down') },
        { key = 'k', mods = 'CTRL', action = wezaction.EmitEvent('ActivatePaneDirection-up')   },
        { key = 'l', mods = 'CTRL', action = wezaction.EmitEvent('ActivatePaneDirection-right')},
    },
}
