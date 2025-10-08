local opt = vim.opt

-----------------
--  FUNCTIONS  --
-----------------

local retab_buf = function(old)
    local bet = opt.expandtab
    local bsw = opt.shiftwidth
    local bts = opt.tabstop
    local bst = opt.softtabstop

    opt.expandtab = false
    opt.shiftwidth = old
    opt.tabstop = old
    opt.softtabstop = old
    vim.cmd([[retab!]])

    opt.expandtab = bet
    opt.shiftwidth = bsw
    opt.tabstop = bts
    opt.softtabstop = bst
    vim.cmd([[retab]])
end

vim.api.nvim_create_user_command("FixTabs", function(args)
    local retab_width = tonumber(args.args)
    if retab_width >= 1 then
        retab_buf(retab_width)
    else
        vim.notify(args.args .. " is not a number >= 1. Please use :FixTabs <number>", vim.log.levels.ERROR)
    end
end, { nargs = 1, desc = "Retab files to 4 spaces" })

vim.api.nvim_create_user_command("DebugVar", function()
    local buf = vim.fn.bufnr()
    local bvr = vim.fn.getbufvar(buf, "&")
    require("utils").print_variable(bvr)
end, {})

vim.api.nvim_create_user_command("Fmt", function()
    vim.cmd("Neoformat")
end, {})

vim.api.nvim_create_user_command("TrimWhitespace", function()
    require("mini.trailspace").trim()
end, { desc = "Trim all trailing whitespace" })

vim.api.nvim_create_user_command("GodotServer", function()
    local dap = require("dap")
    dap.adapters.godot = {
        type = "server",
        host = "localhost",
        port = 6005,
    }

    dap.configurations.gdscript = {
        {
            launch_game_instance = false,
            launch_scene = false,
            name = "Launch scene",
            project = "${workspaceFolder}",
            request = "launch",
            type = "godot",
        },
    }
end, { desc = "Start Godot debug adapter server" })

