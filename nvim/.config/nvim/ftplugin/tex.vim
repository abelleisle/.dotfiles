set modeline
set colorcolumn=

map <Leader>m :VimtexCompile<CR>
map <Leader>t :VimtexTocOpen<CR>

Goyo 85%

setlocal spell 

noremap <silent> k gk
noremap <silent> j gj
noremap <silent> 0 g0
noremap <silent> $ g$
onoremap <silent> j gj
onoremap <silent> k gk

syntax match texSpecialChar '\\\\' contained conceal cchar=↩
syntax match texSpecialChar '\\%' contained conceal cchar=%

let g:indentLine_enabled = 0
set conceallevel=2
set concealcursor=c
