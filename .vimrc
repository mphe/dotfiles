syntax enable
set number
set ruler
set showcmd

" tab size = 4, spaces instead of tabs, and auto indent
set shiftwidth=4
set expandtab
set smarttab
set autoindent

set nocompatible
filetype off

" global clipboard
set clipboard+=unnamed


" insert a new line without switching to insert mode
nmap ,o o<ESC>
nmap ,O O<ESC>

" vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'gmarik/vundle'

" Turn filetype functionality back on
filetype plugin indent on
