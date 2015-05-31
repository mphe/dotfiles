syntax enable
set number
set ruler
set showcmd

" tab size = 4, spaces instead of tabs, and auto indent
set shiftwidth=4
set expandtab
set smarttab
set autoindent

" global clipboard
set clipboard+=unnamed

" disable swap files
set noswapfile


let mapleader = ","

" insert a new line without switching to insert mode
nnoremap <leader>o o<ESC>
nnoremap <leader>O O<ESC>

" Shortcuts for :w 
inoremap <c-s> <c-o>:w<CR>
noremap <c-s> :w<CR>
vnoremap <c-s> <ESC>:w<CR>gv

" Shortcuts for :x
inoremap <c-x> <ESC>:x<CR>
noremap <c-x> :x<CR>
vnoremap <c-x> <ESC>:x<CR>

" Keep selections
vnoremap > >gv
vnoremap < <gv

" Comment shortcut for insert mode
imap <F2> <c-_><c-_>

" Buffer shortcuts
nnoremap <leader>tn :bn<CR>
nnoremap <leader>tp :bp<CR>
nnoremap <leader>tq :bd<CR>

" vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'gmarik/vundle'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'tpope/vim-fugitive'
Plugin 'tomtom/tcomment_vim'
" Plugin 'davidhalter/jedi-vim'
Plugin 'Valloric/YouCompleteMe'

" Turn filetype functionality back on
filetype plugin indent on


" vim-airline
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
" set timeoutlen=50

" disable separators since it doesn't work right in terminal
let g:airline_symbols = {}
let g:airline_left_sep = ''
let g:airline_right_sep = ''


" solarized
set t_Co=256
set background=dark
let g:solarized_termtrans=1
colorscheme solarized

" easymotion
let g:EasyMotion_smartcase = 1
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)

" NERDTree keybindings
command NT NERDTreeToggle

" jedi-vim
" let g:jedi#use_tabs_not_buffers = 0
" autocmd FileType python setlocal completeopt-=preview

" YCM
nmap <F5> :YcmForceCompileAndDiagnostics<CR>
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
