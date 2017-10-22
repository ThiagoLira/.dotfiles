set nocompatible              " be iMproved, required
filetype off                  " required


"-----PLUGINS-----

" check whether vim-plug is installed and install it if necessary
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
    if executable('curl')
        let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
        if v:shell_error
            echom "Error downloading vim-plug. Please install it manually.\n"
            exit
        endif
    else
        echom "vim-plug not installed. Please install it manually or install curl.\n"
        exit
    endif
endif

call plug#begin('~/.config/nvim/plugged')



Plug 'flazz/vim-colorschemes'
Plug 'nvie/vim-flake8'
Plug 'kien/ctrlp.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-surround'


" Initialize plugin system

call plug#end()
filetype plugin indent on    " required

filetype on


set termguicolors
set tabstop=4           " 4 space tab
set expandtab           " use spaces for tabs
set softtabstop=4       " 4 space tab


set hidden
set statusline=%(%F%m%r%h%w\ [%Y]\ %{&encoding}\ %)%=%(%l,%v\ %LL\ %p%%%)
set laststatus=2
set autoindent
set number              " show line numbers

set listchars=tab:▸\ ,trail:▫

syntax enable           " enable syntax processing
set nocompatible
colorscheme badwolf
set shell=/bin/bash

set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.o,*.~,*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep







map <C-n> :NERDTreeToggle<CR>

"flake8 python check every time writes on a python file
autocmd BufWritePost *.py call Flake8()




let mapleader=','

nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l
nmap <c-h> <c-w>h

nmap <LEADER>v :vsplit<CR>
nmap <LEADER>s :split<CR>

"+ and - to resize splited windows"
map - <C-W>-
map = <C-W>+


autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif


colorscheme Monokai

