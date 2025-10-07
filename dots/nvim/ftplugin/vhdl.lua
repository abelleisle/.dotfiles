local opt = vim.opt

opt.textwidth = 0
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

vim.api.nvim_command("set commentstring=--%s")
