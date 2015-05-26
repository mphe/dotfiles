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

" disable swap files
set noswapfile

" insert a new line without switching to insert mode
nmap ,o o<ESC>

" vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'gmarik/vundle'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'
Plugin 'Lokaltog/vim-easymotion'

" Turn filetype functionality back on
filetype plugin indent on


" vim-airline
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline
set laststatus=2
let g:airline_powerline_fonts=1

" disable separators since it doesn't work right in terminal
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
  let g:airline_left_sep = ''
  let g:airline_right_sep = ''
endif


" solarized
set t_Co=256
set background=dark
let g:solarized_termtrans=1
colorscheme solarized
