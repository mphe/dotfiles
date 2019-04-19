" Clean autocmds
autocmd!

" -------------------------------------- General settings start {{{
syntax enable
set number
set ruler
set showcmd

" tab size = 4, spaces instead of tabs, and auto indent
set shiftwidth=4
set tabstop=4
set expandtab
set smarttab
set autoindent
set cino+=j1

" enable folding
set foldmethod=syntax
set nofoldenable
" Don't fold anything when opening a new buffer
set foldlevelstart=99
" Skip over closed folds with { }
set foldopen-=block

" global clipboard
set clipboard+=unnamed

" disable swap files
set noswapfile

" open splits on the right/bottom
set splitright
set splitbelow

let mapleader = ','

" Don't wrap lines
set nowrap

" Change buffers without writing changes to a file
set hidden

" Case insensitive file completion
set wildignorecase

" allow incrementing/decrementing letters with c-a / c-x
set nrformats+=alpha

" don't echo the mode
set noshowmode

" Disable visual and audio bell
set vb t_vb=
set novisualbell

set viewoptions=cursor,folds,slash,unix

" fold functions, if, for, and while in shell scripts
let g:sh_fold_enabled=7

set previewheight=3

" Disable preview window
" set completeopt-=preview

" Gvim settings
set guioptions=aic

set laststatus=2

" -------------------------------------- General settings end }}}


" -------------------------------------- Aliases {{{
" Treat E as e command
cnoreabbrev E e
cnoreabbrev git Git

" -------------------------------------- Aliases end }}}


" -------------------------------------- Functions {{{

" Function for time measurement
function! HowLong(command)
    " We don't want to be prompted by a message if the command being tried is
    " an echo as that would slow things down while waiting for user input.
    let more = &more
    set nomore
    let startTime = localtime()
    execute a:command
    let &more = more
    echo localtime() - startTime 
endfunction

command! -nargs=1 HowLong call HowLong(<q-args>)

function! ToggleLatexMath()
    if ! exists('s:latex_math_mode')
        let s:latex_math_mode = 1
    else
        let s:latex_math_mode = !s:latex_math_mode
    endif

    if s:latex_math_mode
        inoremap * \cdot
        inoremap ( \left(
        inoremap ) \right)
        let g:delimitMate_matchpairs = "[:],{:},<:>"
        DelimitMateReload
        let g:surround_{char2nr(')')} = "\\left(\r\\right)"
        let g:surround_{char2nr('(')} = "\\left( \r \\right)"
        let g:surround_{char2nr(']')} = "\\left[\r\\right]"
        let g:surround_{char2nr('[')} = "\\left[ \r \\right]"
        let g:surround_{char2nr('}')} = "\\left{\r\\right}"
        let g:surround_{char2nr('{')} = "\\left{ \r \\right}"
    else
        iunmap *
        iunmap (
        iunmap )
        let g:delimitMate_matchpairs = "(:),[:],{:},<:>"
        DelimitMateReload
        let g:surround_{char2nr(')')} = "(\r)"
        let g:surround_{char2nr('(')} = "( \r )"
        let g:surround_{char2nr(']')} = "[\r]"
        let g:surround_{char2nr('[')} = "[ \r ]"
        let g:surround_{char2nr('}')} = "{\r}"
        let g:surround_{char2nr('{')} = "{ \r }"
    endif
    return ''
endfunction

function! ShowPreview()
    call feedkeys("i\<c-space>\<c-n>\<esc>")
endfunction

function! TogglePreview(on)
    if a:on
        setlocal completeopt+=preview
    else
        setlocal completeopt-=preview
    endif
    return ""
endfunction

command! ToggleLatexMath call ToggleLatexMath()

" -------------------------------------- Functions end }}}


" -------------------------------------- vundle {{{
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'gmarik/vundle'

" color schemes
Plugin 'altercation/vim-colors-solarized'
Plugin 'qualiabyte/vim-colorstepper'

Plugin 'scrooloose/nerdtree'
Plugin 'itchyny/lightline.vim'
Plugin 'mengelbrecht/lightline-bufferline'
" Plugin 'vim-airline/vim-airline'
" Plugin 'vim-airline/vim-airline-themes'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tomtom/tcomment_vim'

" ./install.py --clang-completer
" Plugin 'Valloric/YouCompleteMe'
Plugin 'oblitum/YouCompleteMe'
" Plugin 'neoclide/coc.nvim'

Plugin 'rdnetto/YCM-Generator'
Plugin 'tmhedberg/SimpylFold'
Plugin 'Raimondi/delimitMate'
Plugin 'airblade/vim-gitgutter'
Plugin 'jeetsukumaran/vim-buffergator'

Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-lua-inspect'
" Plugin 'xolox/vim-lua-ftplugin.git'

" Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-scripts/cscope.vim'
Plugin 'kshenoy/vim-signature'
Plugin 'scrooloose/syntastic'
Plugin 'richq/vim-cmake-completion'
Plugin 'BohrShaw/vim-vimperator-syntax'
Plugin 'Shougo/vimproc.vim'
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'mphe/grayout.vim'
Plugin 'LaTeX-Box-Team/LaTeX-Box'
Plugin 'kana/vim-textobj-indent'
Plugin 'kana/vim-textobj-user'
Plugin 'davinche/godown-vim'
Plugin 'vim-scripts/ReplaceWithRegister'
Plugin 'derekwyatt/vim-protodef'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'withgod/vim-sourcepawn'
Plugin 'Konfekt/FastFold'
" Plugin 'zhimsel/vim-stay'
Plugin 'junegunn/vim-easy-align'
Plugin 'osyo-manga/vim-over'

" Turn filetype functionality back on
filetype on
filetype plugin on
filetype plugin indent on

" -------------------------------------- vundle end }}}


" -------------------------------------- Style config {{{
source /home/marvin/.vim/themes/solarized.vim
" source /home/marvin/.vim/themes/dark.vim

" -------------------------------------- Style config end }}}


" -------------------------------------- Plugin configuration {{{
" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = '▓░'
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = '░▓'
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#tabline#fnamemod = ':.'
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#show_tab_count = 1
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#buf_label_first = 0
let g:airline#extensions#tabline#current_first = 0
let g:airline_highlighting_cache = 1
let g:airline_theme='solarized'
let g:airline_left_sep='▓░'
let g:airline_right_sep='░▓'
let g:airline_detect_spell=0
let g:airline_powerline_fonts = 1
let g:airline#extensions#tagbar#enabled = 0
let g:airline_skip_empty_sections = 1
let g:airline_solarized_dark_text = 1

" lightline {{{
let g:lightline = {
    \ 'colorscheme': 'custom_solarized',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ],
    \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
    \ },
    \ 'tab': {
    \   'active': ['tabnum'],
    \   'inactive': ['tabnum']
    \ },
    \ 'tabline': {
    \   'left': [ ['buffers'] ],
    \   'right': [ ['tabs'] ]
    \ },
    \ 'component': {
    \ },
    \ 'component_expand': {
    \   'syntastic': 'SyntasticStatuslineFlag',
    \   'buffers': 'lightline#bufferline#buffers',
    \ },
    \ 'component_function': {
    \   'fugitive': 'LightLineFugitive',
    \   'filename': 'LightLineFilename',
    \   'fileformat': 'LightLineFileFormat',
    \   'fileencoding': 'LightLineFileEnc',
    \   'filetype': 'LightLineFileType'
    \ },
    \ 'component_visible_condition': {
    \ },
    \ 'component_type': {
    \   'syntastic': 'error',
    \   'buffers': 'tabsel',
    \ },
    \ 'separator': { 'left': '▓░', 'right': '░▓' },
    \ 'subseparator': { 'left': '|', 'right': '|' },
    \ 'tabline_subseparator': { 'left': '', 'right': '' },
    \ 'tabline_separator':  { 'left': '▓░', 'right': '░▓' },
    \ }
    " \ 'separator': { 'left': '█▓░', 'right': '░▓█' },

function! LightLineFileFormat()
    return winwidth(0) > 85 ? &fileformat : ''
endfunction

function! LightLineFileEnc()
    return !strlen(SyntasticStatuslineFlag()) && winwidth(0) > 80 ? strlen(&fenc) ? &fenc : &enc : ''
endfunction

function! LightLineFileType()
    return !strlen(SyntasticStatuslineFlag()) && winwidth(0) > 80 ? strlen(&filetype) ? &filetype : 'unknown' : ''
endfunction

function! LightLineFilename()
    " return (expand('%:t') != '' ? expand('%:t') : '[No Name]') .
    return (expand('%') != '' ? expand('%') : '[No Name]') .
        \ (&modified != '' ? '[+]' : '') .
        \ (&readonly != '' ? ' ⭤' : '')
endfunction

function! LightLineFugitive()
    if exists('*fugitive#head') && strlen(fugitive#head())
        return '⎇  '.fugitive#head()
    endif
    return ''
endfunction
" lightline end }}}

" lightline-bufferline
set showtabline=2
let g:lightline#bufferline#unnamed = '[No Name]'
let g:lightline#bufferline#modified = '[+]'
let g:lightline#bufferline#read_only = ' ⭤'
let g:lightline#bufferline#filename_modifier = ':t'

" easymotion
let g:EasyMotion_smartcase = 1
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)

" NERDTree shortcut
command! NT NERDTreeToggle
" let NERDTreeWinPos = "right"

" YCM
" The preview window is disabled to prevent heavy laggs when cycling through
" completion candidates.
" Instead there are custom mappings for <c-y> and <c-l> to show the preview
" for the current entry. They do both the same except that <c-y> also closes
" the popup menu.

autocmd FileType c,cpp
    \ nnoremap <F5> :YcmForceCompileAndDiagnostics<CR><CR>|
    \ inoremap <F5> <c-o>:YcmForceCompileAndDiagnostics<CR><CR>|
    \ nnoremap <leader>gd :YcmCompleter GetDoc<CR>|
    \ nnoremap <leader>fx :YcmCompleter FixIt<CR>
autocmd FileType c,cpp,python
    \ nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>|
    \ nnoremap <leader>jD :YcmCompleter GoToDeclaration<CR>|
    \ nnoremap <leader>gt :YcmCompleter GetType<CR>|
    \ nnoremap <leader>gp :YcmCompleter GetParent<CR>|
    \ nnoremap <leader>gi :call ShowPreview()<CR>

let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_server_keep_logfiles = 0
" let g:ycm_server_log_level = 'debug'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_always_populate_location_list = 1
let g:ycm_filetype_blacklist = {}
let g:ycm_warning_symbol = '!!'
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_comments = 1

" autocmd FileType tex let g:ycm_min_num_of_chars_for_completion = 5

" Enable tab for completion (removed in oblitum's fork)
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']

" SimpylFold
let g:SimpylFold_fold_docstring = 1
autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<

" delimitMate
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
let delimitMate_jump_expansion = 1

" easytags
let g:easytags_async = 1
let g:easytags_auto_highlight = 0
let g:easytags_resolve_links = 1
let g:easytags_include_members = 1

" tagbar
command! TB TagbarToggle
nnoremap <F8> :TagbarOpen fjc<CR>
nnoremap tt :TagbarOpen fjc<CR>

" ColorStepper Keys
nmap <F6> <Plug>ColorstepPrev
nmap <F7> <Plug>ColorstepNext
nmap <S-F7> <Plug>ColorstepReload

" FSwitch
nnoremap <leader>gf :FSHere<CR>
nnoremap <leader>gF :vsp<CR>:FSHere<CR>

" UltiSnip
let g:UltiSnipsExpandTrigger='<c-j>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
let g:ultisnips_java_brace_style='nl'
let g:UltiSnipsUsePythonVersion = 2

" vim-cscope
let g:cscope_auto_update = 0
autocmd BufWritePost *.c,*.h,*.cpp,*.hpp call cscope#updateDB()

autocmd FileType c,cpp
    \ nnoremap <leader>fa :call cscope#findInteractive(expand('<cword>'))<CR>|
    " s: Find this C symbol
    \ nnoremap  <leader>fs :call cscope#find('s', expand('<cword>'))<CR>|
    " g: Find this definition
    \ nnoremap  <leader>fg :call cscope#find('g', expand('<cword>'))<CR>|
    " d: Find functions called by this function
    \ nnoremap  <leader>fd :call cscope#find('d', expand('<cword>'))<CR>|
    " c: Find functions calling this function
    \ nnoremap  <leader>fc :call cscope#find('c', expand('<cword>'))<CR>|
    " t: Find this text string
    \ nnoremap  <leader>ft :call cscope#find('t', expand('<cword>'))<CR>|
    " e: Find this egrep pattern
    \ nnoremap  <leader>fe :call cscope#find('e', expand('<cword>'))<CR>|
    " f: Find this file
    \ nnoremap  <leader>ff :call cscope#find('f', expand('<cword>'))<CR>|
    " i: Find files #including this file
    \ nnoremap  <leader>fi :call cscope#find('i', expand('<cword>'))<CR>

" lua inspect
let g:lua_inspect_events = ''
let g:lua_inspect_mappings = 0

" vim-javacomplete2
" autocmd FileType java set omnifunc=javacomplete#Complete
"
" if filereadable("AndroidManifest.xml")
"     let g:JavaComplete_SourcesPath = "target/generated-sources/r"
" endif

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_quiet_messages = { 'type': 'style' }
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args = '--ignore=F403,F401'
let g:syntastic_vim_checkers = ['vint']
let g:syntastic_warning_symbol = '!!'
" let g:syntastic_aggregate_errors = 1
" let g:syntastic_java_javac_config_file_enabled = 1
" let g:syntastic_java_javac_delete_output = 0
let g:syntastic_mode_map = {
    \ 'mode': 'passive',
    \ 'active_filetypes': ['lua'],
    \ 'passive_filetypes': [] }

function! s:SynCheck()
    SyntasticCheck
    call lightline#update()
endfunction

function! s:SynReset()
    SyntasticReset
    call lightline#update()
endfunction

command! SynCheck call s:SynCheck()
command! SynReset call s:SynReset()

autocmd FileType python,lua,vim,sh
    \ nnoremap <F5> :SynCheck<CR> |
    \ inoremap <F5> <c-o>:SynCheck<CR> |
    \ nnoremap <leader>gd :Errors<CR>

" eclim
let g:EclimCompletionMethod = 'omnifunc'
autocmd FileType java
    \ nnoremap <F5> :Validate<CR> |
    \ inoremap <F5> <c-o>:Validate<CR> |
    \ nnoremap <leader>fx :JavaCorrect<CR>|
    \ nnoremap <leader>fi :JavaImport<CR>

" vim-template
let g:username = 'Marvin Ewald'
let g:email = 'marvin.e@protonmail.ch'
let g:templates_no_autocmd = 1
let g:templates_directory = [ $HOME.'/.vim/templates', $HOME.'/.vim/bundle/vim-template/templates' ]
" autocmd BufNewFile *.h,*.hpp Template *.h
" autocmd BufNewFile *.c,*.cpp Template *.c

" CtrlP
let g:ctrlp_show_hidden=1
" let g:ctrlp_custom_ignore = '\.pyc'
let g:ctrlp_open_multiple_files = 'ijr'
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git|hg|svn)$',
            \ 'file': '\v\.(exe|so|dll|pyc|o|a)$'
            \ }
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -c -o --exclude-standard && git submodule --quiet foreach --recursive "git ls-files . -c -o --exclude-standard"', 'find %s -type f']

" grayout.vim
let g:grayout_confirm = 0
let g:grayout_cmd_line = 'clang -x c++ -w -P -nostdinc -nostdinc++ -E -'

" latex box
let g:LatexBox_viewer = 'zathura'
let g:LatexBox_complete_inlineMath = 1
let g:LatexBox_custom_indent = 0
let g:LatexBox_Folding = 1
let g:LatexBox_fold_automatic = 0
let g:LatexBox_quickfix = 2
" let g:LatexBox_fold_sections=[ "part", "chapter", "section", "subsection", "subsubsection", "paragraph", "subparagraph" ]
autocmd FileType tex nnoremap <F5> :Latexmk<CR>
" let g:LatexBox_completion_close_braces = 0
" let g:LatexBox_complete_inlineMath = 0

" tcomment
let g:tcommentLineC = {
            \ 'commentstring': '// %s',
            \ 'replacements': g:tcomment#replacements_c
            \ }
call tcomment#DefineType('c', g:tcommentLineC)

" Godown
autocmd FileType markdown,md nnoremap <F5> :GodownPreview<CR>

" protodef
let g:disable_protodef_sorting = 1

function! s:Implement(...)
    if a:0 > 0
        " DelimitMate handles the closing }
        execute 'normal inamespace '.a:1."\<cr>{\<cr>"
    endif
    execute 'normal i'.protodef#ReturnSkeletonsFromPrototypesForCurrentBuffer({ 'includeNS' : 0 })
endfunction

command! -nargs=? Implement call s:Implement(<f-args>)

" fugitive
command! Gst Gtabedit :

" vim-sourcepawn
au FileType sourcepawn setlocal makeprg=/home/marvin/servers/steamcmd/tf2/tf/addons/sourcemod/scripting/spcomp\ %

" tablemode
au FileType markdown,md let table_mode_corner = '|'

" easy align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
let g:easy_align_delimiters = { '>': { 'pattern': '->' } }


" -------------------------------------- Plugin configuration end }}}


" -------------------------------------- Autocmds {{{

" Don't screw up folds when inserting text that might affect them,
" until leaving insert mode.
" autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
" autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

" Save/Restore folds
" autocmd BufWinLeave * if !&diff && strlen(expand('%')) && &ft != 'gitcommit' | mkview | endif
" autocmd BufRead * if !&diff && strlen(expand('%')) && &ft != 'gitcommit' | silent! loadview | endif

" automatically :retab on save
" autocmd BufWritePre * :retab

" filetype specific foldmethods
autocmd FileType cmake setlocal foldmethod=marker
autocmd FileType vim setlocal foldmethod=marker
autocmd FileType lua setlocal foldmethod=marker
autocmd FileType sourcepawn setlocal commentstring=//\ %s
autocmd FileType markdown setlocal tabstop=2 | setlocal shiftwidth=2 | setlocal wrap

" Markdown preview (requires 'Markdown Viewer' addon)
" autocmd FileType markdown,md nnoremap <F5> :!firefox % &<CR><CR>

" simplify preview window
autocmd BufEnter * if &previewwindow | exec 'setlocal laststatus=0 | setlocal nobuflisted | setlocal nocursorline | setlocal nonumber | setlocal winheight='.&previewheight | endif
autocmd BufDelete * if &previewwindow | exec 'setlocal laststatus=2' | endif

" Open the preview window only when accepting a completion candidate
" Reduces lag when cycling through completions
" ! Might not be necessary anymore !
" autocmd FileType c,cpp,python,java
"     \ inoremap <expr> <c-y> pumvisible() ? "\<c-p>\<c-r>=TogglePreview(1)\<CR>\<c-n>\<c-y>\<c-r>=TogglePreview(0)\<CR>" : "\<c-y>"|
"     \ imap     <expr>  <CR> pumvisible() ? "\<c-p>\<c-r>=TogglePreview(1)\<CR>\<c-n>\<c-y>\<c-r>=TogglePreview(0)\<CR>" : "<Plug>delimitMateCR"|
"     \ inoremap <expr> <c-l> pumvisible() ? "\<c-p>\<c-r>=TogglePreview(1)\<CR>\<c-n>\<c-r>=TogglePreview(0)\<CR>" : "\<c-l>"

" -------------------------------------- Autocmds end }}}


" -------------------------------------- Key mappings {{{
" Disable Ex mode
map Q <Nop>

" Horizontal scrolling
nnoremap <C-l> 3zl
nnoremap <C-h> 3zh

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
nnoremap <s-tab> <c-w><c-w>
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" Make Y behave like other capitals
nnoremap Y y$

" faster substitution with yanked text
nmap S griw

" substitute word under the cursor
nnoremap <leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

" visually select the text just pasted
nnoremap gz `[v`]

" write file with root permissions
command! SudoWrite w !sudo tee %

command! PabsFormat %s/:/\r    {\r\r    } \/\/

command! FollowSymlink exec 'file '.resolve(expand('%:p')) | e

command! -range=% StripTrailingSpaces <line1>,<line2>s/\s\+$//e

command! -range=% StripExtraSpaces <line1>,<line2>s/\(\S\)\s\+/\1 /ge | StripTrailingSpaces

command! -range=% ToSource silent <line1>,<line2>s/\s*=.*\(,\|)\)/\1/ge |
            \ exec '<line1>,<line2>normal ==' |
            \ silent exec '<line1>,<line2>StripExtraSpaces' |
            \ silent <line1>,<line2>s/\(virtual \|static \|constexpr \)//ge |
            \ silent <line1>,<line2>s/\( override\| final\)//ge |
            \ silent <line1>,<line2>s/;/\r    {\r        \/\/ TODO\r    }\r/ge |

command! -nargs=? -range=% ToSourceAuto exec '<line1>,<line2>normal ==' |
            \ silent exec '<line1>,<line2>StripExtraSpaces' |
            \ silent <line1>,<line2>s/\(virtual \|static \|constexpr \)//ge |
            \ silent <line1>,<line2>s/\( override\| final\)//ge |
            \ silent <line1>,<line2>s/\s*=.*\(,\|)\)/\1/ge |
            \ silent <line1>,<line2>s/auto \(.\{-}\)\s*->\s*\(.\{-}\)\s*;/auto <args>::\1 -> \2\r    {\r        \/\/ TODO\r    }\r/

" command! -nargs=? -range=% ToSourceAuto exec '<line1>,<line2>normal ==' |
"             \ silent exec '<line1>,<line2>StripExtraSpaces' |
"             \ silent <line1>,<line2>s/\(virtual \|static \|constexpr \)//ge |
"             \ silent <line1>,<line2>s/\( override\| final\)//ge |
"             \ silent <line1>,<line2>s/\s*=.*\(,\|)\)/\1/ge |
"             \ silent <line1>,<line2>s/auto \(.\{-}\)\s*->\s*\(.\{-}\)\s*;/\2 <args>::\1\r    {\r        \/\/ TODO\r    }\r/

" Puts exactly one space between operator and operands.
" Does not pick up all occurrences in some corner cases, but good enough.
" If this breaks some day, try something like this:
" s/\[(\w\+\)]\{-}\s*\(||\|&&\|%\|+\|-\|\*\|\/\)\s*\(\w\+\)/\1 \2 \3/g
command! -range=% OpSpacing <line1>,<line2>s/\(\w\+\)\{-}\s*\(||\|&&\|%\|+\|-\|\*\|\/\)\s*\(\w\+\)/\1 \2 \3/g

command! ID exe "normal a0x". system("uuidgen | sed 's/-.*//'")
command! Fname echo expand('%:p')

" buffer shortcuts
nnoremap <F3> :bn<CR>
nnoremap <F2> :bp<CR>
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>
nnoremap <leader>bl :b#<CR>
nnoremap <leader>bb :BuffergatorOpen<CR>
nnoremap <leader>l :ls<CR>:b 

" Delete current buffer and open the next or an empty buffer
" instead of closing the window
nnoremap <leader>bD :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <leader>bd :bn<bar>sp<bar>bp<bar>bd<CR>

" Remap { } and [ ] to ö and ä
set langmap=ö{,ä},Ö[,Ä]

" Jump to line end in insert mode
inoremap <C-L> <C-O>A

" Repeat last ex command
nnoremap ; @:

" Remaps some keys for easier latex math input, e.g. * -> \cdot.
inoremap <expr> <F4> ToggleLatexMath()

" Find next character when using f/F or t/T
nnoremap <space> ;
vnoremap <space> ;

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" -------------------------------------- Key mappings end }}}
