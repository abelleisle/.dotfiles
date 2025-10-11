local M = {}

M.config = function()
    local mini = {
        ai = require("mini.ai"),
        align = require("mini.align"),
        clue = require("mini.clue"),
        jump2d = require("mini.jump2d"),
        pairs = require("mini.pairs"),
        surround = require("mini.surround"),
        trailspace = require("mini.trailspace"),
    }

    ---------------------------------
    -- A,I
    mini.ai.setup({
        -- Use `''` (empty string) to disable one.
        mappings = {
            -- Main textobject prefixes
            around = "a",
            inside = "i",

            -- Next/last variants
            around_next = "an",
            inside_next = "in",
            around_last = "al",
            inside_last = "il",

            -- Move cursor to corresponding edge of `a` textobject
            goto_left = "g[",
            goto_right = "g]",
        },
    })

    ---------------------------------
    -- Align
    mini.align.setup({
        mappings = {
            start = "ga",
            start_with_preview = "gA",
        },
    })

    ---------------------------------
    -- Clue
    mini.clue.setup({
        window = {
            delay = 0,
            config = {
                width = "auto",
            },
        },
        triggers = require("mappings").clue.triggers,

        clues = {
            -- Enhance this by adding descriptions for <Leader> mapping groups
            mini.clue.gen_clues.builtin_completion(),
            mini.clue.gen_clues.g(),
            mini.clue.gen_clues.marks(),
            mini.clue.gen_clues.registers(),
            mini.clue.gen_clues.windows(),
            mini.clue.gen_clues.z(),

            require("mappings").clue.clues,
        },
    })

    ---------------------------------
    -- Pairs
    mini.pairs.setup({
        modes = {
            insert = true,
            command = true,
            terminal = false,
        },
        mappings = {
            ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
            ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
            ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

            [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
            ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
            ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

            ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
            ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
            ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
        },
    })

    ---------------------------------
    -- Surround
    mini.surround.setup({
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
            add = "<Leader>sa", -- Add surrounding in Normal and Visual modes
            --  Works by using visual selection. e.g.
            --  <L>saiW), add surrounding to inner word: '(...)'
            delete = "<Leader>sd", -- Delete surrounding
            find = "<Leader>sf", -- Find surrounding (to the right)
            find_left = "<Leader>sF", -- Find surrounding (to the left)
            highlight = "<Leader>sh", -- Highlight surrounding
            replace = "<Leader>sr", -- Replace surrounding.
            --  Use by running sr"' for example to replace
            --  surrounding "quotes" with single 'ticks'
            update_n_lines = "<Leader>sn", -- Update `n_lines`

            suffix_last = "l", -- Suffix to search with "prev" method
            suffix_next = "n", -- Suffix to search with "next" method
        },
    })

    ---------------------------------
    -- Trailspace
    mini.trailspace.setup({
        only_in_normal_buffers = true,
    })
end

-----------------
--  MINI.NVIM  --
-----------------
return {
    { -- Various small utilies
        "nvim-mini/mini.nvim",
        branch = "main",
        -- TODO: check to see if we need to lazy load this
        -- event = events.OpenFile,
        config = M.config,
    },
}
