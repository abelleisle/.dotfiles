"   
" ~/.vimrc
"

" Vundle
"---------------------------------
set nocompatible              " be iMproved, required
set encoding=utf-8
filetype off                  " required

" set the runtime path to include Vundle and initialize
call plug#begin('~/.config/nvim/plugged')
    Plug 'VundleVim/Vundle.vim'
    Plug 'https://github.com/tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'LaTeX-Box-Team/LaTeX-Box'
    Plug 'scrooloose/nerdtree'
    Plug 'jistr/vim-nerdtree-tabs'
    Plug 'Shougo/neocomplcache'
    Plug 'Shougo/neocomplete'
    Plug 'Shougo/neosnippet'
    Plug 'Shougo/neosnippet-snippets'
    Plug 'artur-shaik/vim-javacomplete2'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'vim-scripts/cSyntaxAfter'
    Plug 'bling/vim-bufferline'
    Plug 'dylanaraps/wal.vim'
    Plug 'sukima/xmledit'
    Plug 'junegunn/goyo.vim'
    "TODO fix this one
    "Plugin 'terryma/vim-multiple-cursors'
    "
    "Plugin 'jeaye/color_coded'
    "Plugin 'Valloric/YouCompleteMe'
    "Plugin 'SirVer/ultisnips'
    "Plugin 'honza/vim-snippets'
    "Plugin 'vim-airline/vim-airline'
    "Plugin 'vim-airline/vim-airline-themes'
    "Plugin 'itchyny/lightline.vim'
    "Plugin 'nathanaelkane/vim-indent-guides'
    "Plugin 'xuhdev/vim-latex-live-preview'

call plug#end()
filetype plugin indent on

" General Options
"---------------------------------
syntax on
set number relativenumber
set ruler
set showmode
set showcmd
colorscheme agila

" cut long messages
set shm=atI

" set textwidth=80
set textwidth=0 wrapmargin=0

" don't wrap long lines
"set nowrap

set splitbelow
set splitright

" ignore case when searching
set smartcase
set ignorecase

" persistant undo
if has('persistant_undo') && !isdirectory(expand('~').'/.config/nvim/backups')
    silent !mkdir ~/.config/nvim/backups > /dev/null 2>&1
    set undodir=~/.config/nvim/backups
    set undofile
end

" set persistant undo
set undofile

" set undo dir
set undodir=$HOME/.config/nvim/undo

" save 1000 undos
set undolevels=1000

set directory=~/.config/nvim/swap,~/tmp,.      " keep swp files under ~/.vim/swap

" Indenting
"---------------------------------
"set tabstop=4
"set shiftwidth=4
"set softtabstop=4
"set smarttab
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

set laststatus=2
let g:currentmode={
    \ 'n'  : 'normal ',
    \ 'no' : 'n·operator pending ',
    \ 'v'  : 'visual ',
    \ 'V'  : 'v·line ',
    \ '' : 'v·block ',
    \ 's'  : 'select ',
    \ 'S'  : 's·line ',
    \ '' : 's·block ',
    \ 'i'  : 'insert ',
    \ 'R'  : 'replace ',
    \ 'Rv' : 'v·replace ',
    \ 'c'  : 'command ',
    \ 'cv' : 'vim ex ',
    \ 'ce' : 'ex ',
    \ 'r'  : 'prompt ',
    \ 'rm' : 'more ',
    \ 'r?' : 'confirm ',
    \ '!'  : 'shell ',
    \ 't'  : 'terminal '}


set statusline=
set statusline+=%#PrimaryBlock#
set statusline+=\ %{g:currentmode[mode()]}
set statusline+=%#SecondaryBlock#
set statusline+=%{StatuslineGit()}
set statusline+=%#TeritaryBlock#
set statusline+=\ %f\ 
set statusline+=%M\ 
set statusline+=%#TeritaryBlock#
set statusline+=%=
set statusline+=%#SecondaryBlock#
set statusline+=\ %Y\ 
set statusline+=%#PrimaryBlock#
set statusline+=\ %P\ 

function! GitBranch()
	return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
	let l:branchname = GitBranch()
	return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

" Syntax highlighting
"---------------------------------
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl setf glsl
hi Comment ctermfg=red

" Keybinds
"---------------------------------
let mapleader = ","
nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>

map <Up> <Nop>
map <Down> <Nop>
map <Left> <Nop>
map <Right> <Nop>
map <PageUp> <Nop>
map <PageDown> <Nop>

imap <Up> <Nop>
imap <Down> <Nop>
imap <Left> <Nop>
imap <Right> <Nop>
imap <PageUp> <Nop>
imap <PageDown> <Nop>
imap jk <Esc>

nnoremap <C-h> :bprevious<CR>
nnoremap <C-l> :bnext<CR>

inoremap <C-h> <C-o>:bprevious<CR>
inoremap <C-l> <C-o>:bnext<CR>

hi CursorLineNr ctermfg=7
noremap <Leader>c :set cursorcolumn! <CR>
set colorcolumn=81
hi colorcolumn ctermbg=235

" Code Folding
"---------------------------------
if has ('folding')
    set nofoldenable
    set foldmethod=syntax
    set foldmarker={{{,}}}
    set foldcolumn=0
endif

function RangerExplorer()
    exec "silent !ranger --choosefile=/tmp/vim_ranger_current_file " . expand("%:p:h")
    if filereadable('/tmp/vim_ranger_current_file')
        exec 'edit ' . system('cat /tmp/vim_ranger_current_file')
        call system('rm /tmp/vim_ranger_current_file')
    endif
    redraw!
endfun
map <Leader>x :call RangerExplorer()<CR>

" YouCompleteMe
"---------------------------------
"let g:ycm_server_python_interpreter = '/usr/bin/python2.7'
"let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

" neocomplete
"---------------------------------
let g:neocomplete#enable_at_startup = 1

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.config/nvim/bundle/vim-snippets/snippets'

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" javacomplete
"---------------------------------
autocmd FileType java setlocal omnifunc=javacomplete#Complete

" delimitMate
"---------------------------------
let delimitMate_expand_cr = 1

" UltiSnips
"---------------------------------
" Trigger configuration. Do not use <tab> if you use 
" https://github.com/Valloric/YouCompleteMe.

"let g:UltiSnipsExpandTrigger="<F2>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" ctrlp
"---------------------------------
" Use <leader>t to open ctrlp
"let g:ctrlp_map = '<leader>t'
" Ignore these directories
set wildignore+=*/build/**
" disable caching
let g:ctrlp_use_caching=0

" cSyntaxAfter
"---------------------------------
autocmd! FileType c,cpp,java,php call CSyntaxAfter()


" NERDTree
"--------------------------------


" LaTeX - Box
"---------------------------------
let g:tex_flavor = "latex"
let g:tex_fast = "cmMprs"
let g:tex_conceal = ""
let g:tex_fold_enabled = 0
let g:tex_comment_nospell = 1
let g:LatexBox_quickfix = 2
let g:LatexBox_latexmk_preview_continuously = 1
let g:LatexBox_viewer = "mupdf"

function! TexEdit()
    set spelllang=en_gb spell
    set modeline
    set colorcolumn=
    :Goyo 80%
    map <Leader>m :Latexmk<CR>
endfunction

autocmd! FileType tex call TexEdit()

" Multiple Cursors
"---------------------------------
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'
let g:multi_cursor_start_word_key='g<C-n>'
