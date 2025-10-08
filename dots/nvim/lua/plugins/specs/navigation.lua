------------------
--  NAVIGATION  --
------------------
return {

    { -- Ctrl-<hjkl> navigation with TMUX
        "dynamotn/Navigator.nvim",
        opts = {
            auto_save = nil,
            disable_on_zoom = true,
        },
    },

    { -- Leap
        "ggandor/leap.nvim",
        enabled = true,
        opts = {

            safe_labels = "rtklb/RTKIHMLGBZ?",
            labels = "tnseriaoplfuvmwyqjc,x.zTNSERIAOPLFUVMWYQJCXZ", --home row & least effort keys for Colemak layout
        },
        config = function(_, opts)
            local leap = require("leap")
            leap.add_default_mappings(true)
            for k, v in pairs(opts) do
                leap.opts[k] = v
            end
        end,
    },

    { -- Harpoon
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        -- config = true -- Force harpoon setup without opts set
        -- lazy = true, -- This is faster but may not work properly
        config = function()
            require("harpoon").setup()
            require("mappings").harpoon_extend()
        end,
    },

    { -- Hardtime, ban repetitive movements
        "m4xshen/hardtime.nvim",
        lazy = false,
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            disabled_filetypes = {
                lazy = false, -- Disable Hardtime in lazy filetype
            },
            disabled_keys = {},
        },
    },

}
