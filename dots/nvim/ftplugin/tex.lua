require("spell").init()

vim.api.nvim_set_keymap('n', 'j', 'gj', {noremap = true})
vim.api.nvim_set_keymap('n', 'k', 'gk', {noremap = true})

vim.api.nvim_set_keymap('v', 'j', 'gj', {noremap = true})
vim.api.nvim_set_keymap('v', 'k', 'gk', {noremap = true})

vim.g.auto_save = false

vim.g.tex_flavor='latex'
vim.g.vimtex_view_method='zathura'
vim.g.vimtex_quickfix_mode=0
vim.g.tex_superscripts= "[0-9a-zA-Z.,:;+-<>/()=]"
vim.g.tex_subscripts= "[0-9a-zA-Z,+-/().]"
vim.g.tex_conceal_frac=1
vim.g.tex_conceal='abdgm'
vim.g.vimtex_compiler_latexmk = {
    options = {
        '--shell-escape',
        '-verbose',
        '-file-line-error',
        '-interaction=nonstopmode'
    }
}
