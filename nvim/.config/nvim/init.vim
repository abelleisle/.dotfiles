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

    Plug 'https://github.com/tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'LaTeX-Box-Team/LaTeX-Box'
    Plug 'scrooloose/nerdtree'
    Plug 'jistr/vim-nerdtree-tabs'

    if has('nvim')
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
        Plug 'Shougo/deoppet.nvim', { 'do': ':UpdateRemotePlugins' }
    else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
    Plug 'Shougo/neosnippet'
    Plug 'Shougo/neosnippet-snippets'
    Plug 'honza/vim-snippets'

    Plug 'https://github.com/jiangmiao/auto-pairs'

    Plug 'artur-shaik/vim-javacomplete2'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'vim-scripts/cSyntaxAfter'
    Plug 'dylanaraps/wal.vim'
    Plug 'sukima/xmledit'
    Plug 'junegunn/goyo.vim'

    Plug 'JPR75/vip'
    Plug 'vim-syntastic/syntastic'
    Plug 'suoto/vim-hdl'

    Plug 'christoomey/vim-tmux-navigator'

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
let hostname = substitute(system('hostname'), '\n', '', '')
if hostname == "adesktop"
    colorscheme agila
elseif hostname == "aarch"
    colorscheme dawn
endif

syntax on
set number relativenumber
set ruler
"!set showmode
set showcmd

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


" Status
"---------------------------------
set laststatus=2
let g:currentmode={
    \ 'n'  : 'normal ',
    \ 'no' : 'n·operator pending ',
    \ 'v'  : 'visual ',
    \ 'V'  : 'v·line ',
    \ '' : 'v·block ',
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

hi def Dim cterm=none ctermbg=none ctermfg=8

function! s:DimInactiveWindow()
    syntax region Dim start='' end='$$$end$$$'
endfunction

function! s:UndimActiveWindow()
    ownsyntax
endfunction

autocmd WinEnter * call s:UndimActiveWindow()
autocmd BufEnter * call s:UndimActiveWindow()
autocmd WinLeave * call s:DimInactiveWindow()

" Syntax highlighting
"---------------------------------
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl setf glsl
"hi Comment ctermfg=red
"hi CursorLineNr ctermfg=7
noremap <Leader>c :set cursorcolumn! <CR>

set colorcolumn=81
hi colorcolumn ctermfg=14

set fillchars+=vert:│

set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

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

"nnoremap <C-h> :bprevious<CR>
"nnoremap <C-l> :bnext<CR>
"
"inoremap <C-h> <C-o>:bprevious<CR>
"inoremap <C-l> <C-o>:bnext<CR>

nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

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


" deoplete & neosnippet
"---------------------------------
let g:deoplete#enable_at_startup = 1 
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
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" javacomplete
"---------------------------------
autocmd FileType java setlocal omnifunc=javacomplete#Complete

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


" Syntastic
"---------------------------------
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
