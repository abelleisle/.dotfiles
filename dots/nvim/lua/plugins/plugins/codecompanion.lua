local M = {}

M.opts = {
    strategies = {
        chat = {
            adapter = "qwen",
            roles = {
                user = "andy",
            },
        },
        inline = {
            adapter = "qwen",
        },
        cmd = {
            adapter = "qwen",
        },
    },
    display = {
        action_palette = {
            width = 95,
            height = 10,
            prompt = "Prompt ",
            provider = "telescope",
            opts = {
                show_default_actions = true,
                show_default_prompt_library = true,
            },
        },
        diff = {
            -- provider = "mini_diff", -- default|mini_diff
            provider = "default", -- default|mini_diff
        },
        chat = {
            window = {
                layout = "vertical", -- "vertical" will open this to the side
                width = 0.3, -- Ignored if using "buffer"
            },
        },
    },
    adapters = {
        qwen = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "qwen",
                schema = {
                    model = {
                        default = "qwen2.5-coder:14b-instruct-q4_K_M",
                    },
                    num_ctx = {
                        default = 32768,
                    },
                },
            })
        end,
    },
    opts = {
        log_level = "ERROR",
    },
}

----------------
--  AI STUFF  --
----------------
-- I really don't want this stuff in here,
-- but I guess this is the future :(
return {
    { -- Copilot chat
        "olimorris/codecompanion.nvim",
        config = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = M.opts,
    },
}
