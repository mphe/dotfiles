syntax enable
set number
set ruler
set showcmd

" tab size = 4, spaces instead of tabs, and auto indent
set shiftwidth=4
set expandtab
set smarttab
set autoindent

" enable folding
set foldmethod=syntax

" save foldings
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview 

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

" Shortcut for <Esc>
inoremap jk <Esc>

" Keep selections
vnoremap > >gv
vnoremap < <gv

" Comment shortcut for insert mode
imap <F2> <c-_><c-_>

" better j and k
nnoremap j gj
nnoremap k gk

" Easy split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" map <leader>p to substitute the selection with yanked text in visual mode
xnoremap <leader>p "_dP

" faster substitution with yanked text
nmap S viw<leader>p

" ensure newline at eof
autocmd BufWritePre *
    \ if match(getline('$'), '\S') != -1 |
    \     call append(line('$'), '') |
    \ endif



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
Plugin 'tmhedberg/SimpylFold'
Plugin 'kevinw/pyflakes-vim'
Plugin 'rdnetto/YCM-Generator'
Plugin 'Raimondi/delimitMate'

" Turn filetype functionality back on
filetype on
filetype plugin on
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

" NERDTree shortcut
command NT NERDTreeToggle

" YCM
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR><CR>
inoremap <F5> <c-o>:YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>jd :YcmCompleter GoTo<CR>
nnoremap <leader>gt :YcmCompleter GetType<CR>
nnoremap <leader>gp :YcmCompleter GetParent<CR>
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 0

" SimpylFold
let g:SimpylFold_fold_docstring = 0
autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<

" pyflakes
highlight SpellBad term=underline ctermfg=160 gui=undercurl guisp=Orange 

" delimitMate
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

