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
    bg      = scheme_colors.background,
    fg      = scheme_colors.foreground,
    magenta = scheme_colors.ansi[6],
    red     = scheme_colors.ansi[2],
    orange  = scheme_colors.brights[4],
    yellow  = scheme_colors.ansi[4],
    green   = scheme_colors.ansi[3],
    blue    = scheme_colors.ansi[5],
    cyan    = scheme_colors.ansi[7],
    grey0   = scheme_colors.brights[1],
    grey1   = scheme_colors.ansi[1],
    grey2   = scheme_colors.foreground,
}

-- Tab bar colors
local tab_colors = {
    tab_bar = {
        background = scheme_colors.background,
        active_tab = {
            bg_color = bar_colors.grey1,
            fg_color = bar_colors.yellow,
        },
        inactive_tab = {
            bg_color = bar_colors.grey0,
            fg_color = bar_colors.grey2,
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

local function isTmuxProcess(pane)
    -- see: isViProcess
    return pane:get_foreground_process_name():find('tmux') ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
    if isViProcess(pane) or isTmuxProcess(pane) then
        window:perform_action(
            -- This should match the keybinds set in Neovim and tmux.
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
    font_size = 13,

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
        -- nvim/tmux Navigator bindings
        --
        -- Note: These MUST match the bindings in nvim/tmux for it to work properly
        --
        { key = 'h', mods = 'CTRL', action = wezaction.EmitEvent('ActivatePaneDirection-left') },
        { key = 'j', mods = 'CTRL', action = wezaction.EmitEvent('ActivatePaneDirection-down') },
        { key = 'k', mods = 'CTRL', action = wezaction.EmitEvent('ActivatePaneDirection-up')   },
        { key = 'l', mods = 'CTRL', action = wezaction.EmitEvent('ActivatePaneDirection-right')},
    },
}
