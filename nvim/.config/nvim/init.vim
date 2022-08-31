set nocompatible              " be iMproved, required
filetype on


set termguicolors
set tabstop=4           " 4 space tab
set expandtab           " use spaces for tabs
set softtabstop=4       " 4 space tab


set hidden
set statusline=%(%F%m%r%h%w\ [%Y]\ %{&encoding}\ %)%=%(%l,%v\ %LL\ %p%%%)
set laststatus=2
set autoindent

set listchars=tab:▸\ ,trail:▫

syntax enable           " enable syntax processing
set nocompatible
set shell=/bin/bash

set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.o,*.~,*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep


let maplocalleader=","

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright


nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l
nmap <c-h> <c-w>h

nmap <LEADER>w- :split<CR>
nmap <LEADER>w<bar> :vsplit<CR>



"add relative numbering"
set number relativenumber


set mouse=a



" Switch between the last two files
nnoremap <Leader><Tab> <C-^>

nnoremap <F4> :!make clean main run<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>


"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>


if exists('g:vscode')
    "simular spacemacs aqui"
    nnoremap <LEADER><LEADER> <Cmd>call VSCodeNotify('workbench.action.showCommands')<CR>
    nnoremap <LEADER>ff <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>

    nnoremap <c-t> <Cmd>call VSCodeNotify('workbench.action.terminal.focus')<CR>
endif

lua << EOF
require('init')
require('lsp')
EOF

colorscheme molokai
