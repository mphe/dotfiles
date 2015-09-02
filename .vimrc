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

" Don't fold anything when opening a new buffer
set foldlevelstart=99

" open splits on the right
set splitright

let mapleader = ","

" Don't wrap lines
set nowrap

" Horizontal scrolling
nnoremap <C-l> 2zl
nnoremap <C-h> 2zh

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
xnoremap j gj
xnoremap k gk

" Easy split navigation
" nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" Make Y behave like other capitals
nnoremap Y y$

" map <leader>p to substitute the selection with yanked text in visual mode
xnoremap <leader>p "_dP

" faster substitution with yanked text
nmap S viw<leader>p

" ensure newline at eof
" autocmd BufWritePre *
"     \ if match(getline('$'), '\S') != -1 |
"     \     call append(line('$'), '') |
"     \ endif

" Don't screw up folds when inserting text that might affect them,
" until leaving insert mode.
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif


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
Plugin 'tpope/vim-surround'
Plugin 'tomtom/tcomment_vim'
" Plugin 'davidhalter/jedi-vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'tmhedberg/SimpylFold'
Plugin 'kevinw/pyflakes-vim'
Plugin 'rdnetto/YCM-Generator'
Plugin 'Raimondi/delimitMate'
Plugin 'xuqix/h2cppx'
Plugin 'airblade/vim-gitgutter'
Plugin 'jeetsukumaran/vim-buffergator'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
" Plugin 'vim-scripts/taglist.vim'
Plugin 'xolox/vim-lua-ftplugin.git'

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

" Solid background color
highlight SignColumn ctermbg=black


" easymotion
let g:EasyMotion_smartcase = 1
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)

" NERDTree shortcut
command NT NERDTreeToggle
let NERDTreeWinPos = "right"

" YCM
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR><CR>
inoremap <F5> <c-o>:YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>jd :YcmCompleter GoTo<CR>
nnoremap <leader>gt :YcmCompleter GetType<CR>
nnoremap <leader>gp :YcmCompleter GetParent<CR>
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_always_populate_location_list = 1

" Solid background color
highlight YcmErrorSign ctermbg=black ctermfg=red
highlight YcmWarningSign ctermbg=black ctermfg=red


" SimpylFold
let g:SimpylFold_fold_docstring = 0
autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<

" pyflakes
highlight SpellBad term=underline ctermfg=160 gui=undercurl guisp=Orange 

" delimitMate
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

" h2cppx
command TOCPP H2cppx

" easytags
let g:easytags_async = 1
let g:easytags_auto_highlight = 0
let g:easytags_resolve_links = 1

" tagbar
command TB TagbarToggle
