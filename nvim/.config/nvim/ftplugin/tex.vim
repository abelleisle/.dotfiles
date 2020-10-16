set modeline
set colorcolumn=

map <Leader>m :VimtexCompile<CR>

Goyo 85%

setlocal spell 

noremap <silent> k gk
noremap <silent> j gj
noremap <silent> 0 g0
noremap <silent> $ g$
onoremap <silent> j gj
onoremap <silent> k gk

let g:indentLine_enabled = 0
set conceallevel=2
set concealcursor=c

syntax match texSpecialChar '\\\\' contained conceal cchar=↩
syntax match texSpecialChar '\\%' contained conceal cchar=%
