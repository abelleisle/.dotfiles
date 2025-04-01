local M = {}

M.config = function()
end

M.opts = {
    strategies = {
        chat = {
            adapter = "qwen",
            roles = {
                user = "andy"
            },
        },
        inline = {
            adapter = "qwen"
        },
        cmd = {
            adapter = "qwen"
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
            }
        },
        diff = {
          provider = "mini_diff", -- default|mini_diff
        },
    },
    adapters = {
        qwen = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "qwen",
                schema = {
                    model = {
                        default = "qwen2.5-coder:32b",
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
    }
}

return M
