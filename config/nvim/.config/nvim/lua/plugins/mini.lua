local M = {}

local mini = {
    ai         = require('mini.ai'),
    align      = require('mini.align'),
    jump2d     = require('mini.jump2d'),
    pairs      = require('mini.pairs'),
    trailspace = require('mini.trailspace')
}

M.config = function ()
    ---------------------------------
    -- A,I
    mini.ai.setup({
        -- Use `''` (empty string) to disable one.
        mappings = {
            -- Main textobject prefixes
            around = 'a',
            inside = 'i',

            -- Next/last variants
            around_next = 'an',
            inside_next = 'in',
            around_last = 'al',
            inside_last = 'il',

            -- Move cursor to corresponding edge of `a` textobject
            goto_left = 'g[',
            goto_right = 'g]',
        },
    })

    ---------------------------------
    -- Align
    mini.align.setup({
        mappings = {
            start = 'ga',
            start_with_preview = 'gA'
        }
    })

    ---------------------------------
    -- Jump 2D
    mini.jump2d.setup({
        mappings = {
            start_jumping = '', -- This is mapped in mappings.lua
        },
        hooks = {}
    })

    ---------------------------------
    -- Pairs
    mini.pairs.setup({
        modes = {
            insert = true,
            command = true,
            terminal = false
        },
        mappings = {
            ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
            ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
            ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

            [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
            [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
            ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

            ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
            ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
            ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
        },
    })

    ---------------------------------
    -- Trailspace
    mini.trailspace.setup({
        only_in_normal_buffers = true
    })
    vim.api.nvim_create_user_command(
        'TrimWhitespace',
        function()
            mini.trailspace.trim()
        end,
        {desc = "Trim all trailing whitespace"}
    )
end

return M
