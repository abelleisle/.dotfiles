-----------------------
--  LANGUAGE SERVER  --
-----------------------
local events = require("plugins").events
return {

    { -- Images inside neovim LSP completion menu
        "onsails/lspkind-nvim",
        event = events.InsertMode,
        config = function()
            require("lspkind").init({
                mode = "text_symbol",

                icons = {
                    Text = "󰉿",
                    Method = "󰆧",
                    Function = "󰊕",
                    Constructor = "",
                    Field = "󰜢",
                    Variable = "󰀫",
                    Class = "󰠱",
                    Interface = "",
                    Module = "",
                    Property = "󰜢",
                    Unit = "󰑭",
                    Value = "󰎠",
                    Enum = "",
                    Keyword = "󰌋",
                    Snippet = "",
                    Color = "󰏘",
                    File = "󰈙",
                    Reference = "󰈇",
                    Folder = "󰉋",
                    EnumMember = "",
                    Constant = "󰏿",
                    Struct = "󰙅",
                    Event = "",
                    Operator = "󰆕",
                    TypeParameter = "",
                }
            })
        end,
    },

    -- {
    --     "ray-x/lsp_signature.nvim",
    --     event = Events.OpenFile,
    --     opts = {
    --         bind = true,
    --         handler_opts = {
    --             border = "rounded"
    --         },
    --         hint_enable = false
    --     }
    -- },

    { -- Debug adapter protocol
        "mfussenegger/nvim-dap",
    },
}
