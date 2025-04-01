local M = {}

M.config = function()
    local status, lualine = pcall(require, 'lualine')
    if not status then return end

    local colors = vim.g.colors
    if colors == nil then
        print("Error: StatusLine vim.g.colors are not set")
        return
    end

    ---------------
    --  HELPERS  --
    ---------------

    local buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end

    local buffer_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) == 1
    end

    local filename_and_parent = function()
        if buffer_not_empty() then
            local file = vim.fn.expand("%:")
            local t = {}
            local entries = 0
            local sep = "/"
            for str in string.gmatch(file, "([^"..sep.."]+)") do
                table.insert(t, str)
                entries = entries + 1
            end

            local pr = ""
            for k,v in pairs(t) do
                if k > entries - 2 then
                    pr = pr .. "/" .. v
                else
                    pr = pr .. "/" .. v:sub(0,1)
                end
            end
            return pr:sub(2) .. " "
        end
        return " [BLANK] "
    end

    local checkwidth = function()
        local current_win = vim.fn.winnr()
        if current_win == -1 then
            current_win = 0
        end
        local squeeze_width  = vim.fn.winwidth(current_win) / 2
        return squeeze_width > 60
    end

    local buffer_wide = function()
        return buffer_not_empty() and checkwidth()
    end

    local buffer_narrow_or_empty = function()
        return buffer_empty() or not checkwidth()
    end

    local csep = function(cond, char, fg, bg)
        return {function() return char end, color = {fg = fg, bg = bg}, padding = 0, cond = cond}
    end

    local sep = function(char, fg, bg)
        return csep(nil, char, fg, bg)
    end

    ---------------------
    --  CONFIGURATION  --
    ---------------------

    lualine.setup({
        options = {
            theme = {
                normal = {
                    a = { bg = colors.grey1 },
                    b = { bg = colors.grey0 },
                    c = { bg = colors.bg},
                    x = { fg = colors.grey2, bg = colors.grey0},
                    y = { fg = colors.grey2, bg = colors.grey1},
                    z = { fg = colors.blue, bg = colors.grey0}
                },
                inactive = {
                    a = { bg = colors.grey1 },
                    b = { bg = colors.bg },
                    c = { bg = colors.bg},
                    z = { fg = colors.red, bg = colors.grey0}
                },
            },
            section_separators = '',
            component_separators = '',
            always_divide_middle = true,
        },
        sections = {
            lualine_a = {
                sep('▋', colors.blue, colors.grey0),
                {'mode', color = {fg = colors.yellow, bg = colors.grey0, gui = 'bold'}, padding = 0},
                sep('', colors.grey0),
                {'filetype', icon_only = true, padding = 0},
                {filename_and_parent, color = {fg = colors.magenta}, padding = 0},
                {'filesize', padding = {left = 0, right = 1}},
            },
            lualine_b = {
                csep(buffer_wide, '', colors.grey1),
                csep(buffer_narrow_or_empty, '', colors.grey1, colors.bg),
                {'branch', icon = {'', color = {fg = colors.orange}}, color = {fg = colors.grey2}, cond = buffer_wide},
                {'diff', symbols = {added = ' ', modified = ' ', removed = ' '}, cond = buffer_wide},
            },
            lualine_c = {
                csep(buffer_wide, '', colors.grey0),
                {'diagnostics', sources = {"nvim_lsp"}, symbols = {error = '  ', warn = '  '}, cond = buffer_wide},
            },
            lualine_x = {
                sep('', colors.grey0, colors.bg),
                {'fileformat', symbols = {unix = "UNIX", dos = "WIN", mac = "MAC"}},
                sep('|', colors.grey1, colors.grey0),
                {'location'},
                sep('', colors.grey1, colors.grey0),
            },
            lualine_y = {
                {'progress'},
            },
            lualine_z = {
                sep('', colors.grey0, colors.grey1),
                {'filetype', icons_enabled = false, fmt=string.upper}
            }
        },
        inactive_sections = {
            lualine_a = {
                sep('▋ ', colors.red, colors.grey0),
                sep('', colors.grey0),
                {'filetype', icon_only = true, padding = 0},
                {filename_and_parent, cond = buffer_not_empty, color = {fg = colors.magenta}, padding = 0},
            },
            lualine_b = {
                sep('', colors.grey1),
            },
            lualine_c = {},
            lualine_x = {},
            lualine_y = {
                sep('', colors.grey0)
            },
            lualine_z = {
                {'filetype', icons_enabled = false, fmt=string.upper}
            }
        },
    }) -- lualine.setup

    --------------
    --  COLORS  --
    --------------

    -- vim.api.nvim_command(string.format("highlight StatusLine guifg=%s", colors.grey0))
    -- vim.api.nvim_command(string.format("highlight StatusLineNC guifg=%s", colors.grey0))

    --------------------
    --  AUTOCOMMANDS  --
    --------------------

    -- vim.api.nvim_create_augroup('lualine_custom', {clear = true})
    --
    -- vim.api.nvim_create_autocmd({'BufEnter'}, {
    --     group    = 'lualine_custom',
    --     pattern  = '*',
    --     callback = function()
    --         lualine.refresh()
    --     end
    -- })

end

return M
