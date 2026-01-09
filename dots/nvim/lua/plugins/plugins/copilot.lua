local enable_nes = false -- set to true to enable next edit suggestion functionality
local enable_copilot = (vim.g.copilot_enabled == true) -- Copilot is only enabled on some systems (work computer)
local opts = {
    suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        trigger_on_accept = true,
        keymap = {
            accept = false,
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<M-q>",
        },
    },
    nes = {
        enabled = enable_nes,
        auto_trigger = false,
        keymap = {
            accept_and_goto = false,
            accept = false,
            dismiss = false,
        },
    },
    server = {
        -- To prevent needing to use nodejs we can just download the server
        type = "binary",
    },
}

return {
    { -- Enable inline code suggestions from GitHub Copilot
        "zbirenbaum/copilot.lua",
        cond = enable_copilot,
        requires = enable_nes
                and {
                    "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
                }
            or {},
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup(opts)
        end,
    },
    { -- Dependency for optional next edit suggestion functionality
        "copilotlsp-nvim/copilot-lsp",
        cond = enable_nes,
    },
}
