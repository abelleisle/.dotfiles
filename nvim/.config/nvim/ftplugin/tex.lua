local opt = vim.opt

opt.wrap = true
opt.linebreak = true
opt.list = false
opt.textwidth = 0
opt.colorcolumn = ""
opt.spell = true

vim.api.nvim_set_keymap('n', 'j', 'gj', {noremap = true})
vim.api.nvim_set_keymap('n', 'k', 'gk', {noremap = true})

vim.api.nvim_set_keymap('v', 'j', 'gj', {noremap = true})
vim.api.nvim_set_keymap('v', 'k', 'gk', {noremap = true})

vim.g.tex_flavor='latex'
vim.g.vimtex_view_method='zathura'
vim.g.vimtex_quickfix_mode=0
vim.g.tex_superscripts= "[0-9a-zA-Z.,:;+-<>/()=]"
vim.g.tex_subscripts= "[0-9a-zA-Z,+-/().]"
vim.g.tex_conceal_frac=1
vim.g.tex_conceal='abdgm'
