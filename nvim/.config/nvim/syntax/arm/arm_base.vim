setlocal iskeyword +=.,_,\$

syn keyword armTodo     contained todo fixme danger note notice bug author date

syn match armNumbericOp "[+-/*%<>=&|^!]"

" Assembler identifiers/labels
syn match armIdentifer  "\<[.\$_A-Za-z0-9]\+\>"
syn match armLabel      "\<[.\$_A-Za-z0-9]\+:"

" dec
syn match armNumber     "[#\$]\?\d\+\>"
" hex
syn match armNumber     "[#\$]\?0x\x\+\>"
" bin
syn match armNumber     "[#\$]\?0b[01]\+\>"
" floats
syn match armNumber "\%(\d\+\.\d*\|\d*\.\d\+\)\%([eE]\?[-+]\?\d\+\)\?\>"

" Comments
syn match armComment   ";.*" contains=armTodo
"syn region armComment   start="//\|@" end="$" contains=armTodo
" syn region armComment   start="^#\|//\|@" end="$" contains=armTodo
"syn region armComment   start="/\*"   end="\*/" contains=armTodo
"syn region armComment   start="/\*"   end="\*/" contains=armTodo

" String literal
syn region armString    start=/"/ skip=/\\"/ end=/"/
" Ascii character literal
syn match armString     "'\\\?[\d32-~]'\?"

"so <sfile>:p:h/gas_directives.vim
"so <sfile>:p:h/arm_directives.vim

syn match armCPreProc   "^\s*#\s*\(include\|define\|undef\|if\|ifdef\|ifndef\|elif\|else\|endif\|error\|pragma\)\>"

" Registers
syn match armRegister "\<R\%(1[0-5]\|[0-9]\)\>"
syn match armRegister "\<C\%(1[0-5]\|[0-9]\)\>"
syn match armRegister "\<P\%(1[0-5]\|[0-9]\)\>"
syn keyword armRegister FP SP LR PC SPSR CPSR CPSR_c CPSR_cxsf BP
syn match armRegister "\<A[1-3]\>"
syn match armRegister "\<V[1-8]\>"
