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
Plug 'dense-analysis/ale'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'chuling/ci_dark'
Plug 'luochen1990/rainbow'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'



call plug#end()
filetype plugin indent on    " required
filetype on



" CoC stuff
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <silent><expr> <C-space> coc#refresh()

"GoTo code navigation
nmap <leader>g <C-o>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>rn <Plug>(coc-rename)

"show all diagnostics.
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
"manage extensions.
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>


" fzv stuff 

" this is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }



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



" THEME STUFF
colorscheme ci_dark

set fillchars+=vert:│

let g:airline_theme = 'ci_dark'
let g:lightline = { 'colorscheme': 'ci_dark' }



if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif


let mapleader=' '



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
nnoremap <Leader><Leader> <C-^>

"fzf basic action
nnoremap <silent> <LEADER>fp :FZF -m<cr>

nnoremap <silent> <LEADER>ff :FZF ~<cr> 


"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
