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

set viewoptions=cursor,folds

" fold functions, if, for, and while in shell scripts
let g:sh_fold_enabled=7

set previewheight=5

" -------------------------------------- General settings end }}}


" -------------------------------------- Aliases {{{
" Treat E as e command
cnoreabbrev E e

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
Plugin 'whatyouhide/vim-gotham'
Plugin 'twerth/ir_black'
Plugin 'qualiabyte/vim-colorstepper'

Plugin 'scrooloose/nerdtree'
Plugin 'itchyny/lightline.vim'
Plugin 'bling/vim-bufferline'
Plugin 'pearofducks/vim-quack-lightline'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tomtom/tcomment_vim'

" ./install.py --clang-completer
" Plugin 'Valloric/YouCompleteMe'
Plugin 'oblitum/YouCompleteMe'

Plugin 'rdnetto/YCM-Generator'
Plugin 'tmhedberg/SimpylFold'
Plugin 'Raimondi/delimitMate'
Plugin 'airblade/vim-gitgutter'
Plugin 'jeetsukumaran/vim-buffergator'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
" Plugin 'xolox/vim-lua-ftplugin.git'
Plugin 'xolox/vim-lua-inspect'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-scripts/cscope.vim'
Plugin 'kshenoy/vim-signature'
" Plugin 'artur-shaik/vim-javacomplete2'
Plugin 'scrooloose/syntastic'
Plugin 'richq/vim-cmake-completion'
Plugin 'aperezdc/vim-template'
Plugin 'BohrShaw/vim-vimperator-syntax'
Plugin 'idanarye/vim-vebugger'
Plugin 'Shougo/vimproc.vim'
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'mall0c/grayout.vim'
Plugin 'LaTeX-Box-Team/LaTeX-Box'
Plugin 'kana/vim-textobj-indent'
Plugin 'kana/vim-textobj-user'
Plugin 'davinche/godown-vim'
Plugin 'vim-scripts/ReplaceWithRegister'

" Turn filetype functionality back on
filetype on
filetype plugin on
filetype plugin indent on

" -------------------------------------- vundle end }}}


" -------------------------------------- Style config {{{
" ------------------ General
set t_Co=256
set background=dark
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline
set laststatus=2

" ------------------ Solarized
let g:solarized_termtrans=1
let g:solarized_hitrail=1
let g:solarized_termcolors=256
colorscheme solarized

highlight SignColumn ctermbg=black
highlight CursorLineNr ctermbg=black cterm=bold

" Solid background color for YCM indicators
highlight YcmWarningSign cterm=bold ctermbg=black ctermfg=red
highlight YcmErrorSign cterm=bold ctermbg=black ctermfg=red
highlight YcmErrorSection cterm=underline ctermfg=darkred

" Search highlight color
highlight EasyMotionMoveHL ctermbg=240 ctermfg=black

" ------------------ Cursorline
set cursorline
highlight CursorLine ctermbg=Black cterm=NONE

" No underline in folds
highlight Folded cterm=bold

" Syntastic Errors
highlight SpellBad term=underline ctermfg=160 gui=undercurl guisp=Orange 

" -------------------------------------- Style config end }}}


" -------------------------------------- Plugin configuration {{{
" bufferline
set showtabline=2
let g:bufferline_echo = 0
let g:bufferline_active_buffer_left = ''
let g:bufferline_active_buffer_right = ''
let g:bufferline_modified = '[+]'
let g:bufferline_show_bufnr = 0
let g:bufferline_pathshorten = 1
let g:bufferline_fname_mod = ''

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
    \   'left': [ ['bufferline'] ],
    \   'right': [ ['tabs'] ]
    \ },
    \ 'component': {
    \ },
    \ 'component_expand': {
    \   'syntastic': 'SyntasticStatuslineFlag',
    \   'bufferline': 'LightLineBufferline',
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
    \   'bufferline': 'tabsel',
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
    return (expand('%:t') != '' ? expand('%:t') : '[No Name]') .
        \ (&modified != '' ? '[+]' : '') .
        \ (&readonly != '' ? ' ⭤' : '')
endfunction

function! LightLineFugitive()
    if exists('*fugitive#head') && strlen(fugitive#head())
        return '⎇  '.fugitive#head()
    endif
    return ''
endfunction

function! LightLineBufferline()
    call bufferline#refresh_status()
    call Trim_status_info(&columns - 8 - 5 * tabpagenr('$'))
    return [ g:bufferline_status_info.before, g:bufferline_status_info.current, g:bufferline_status_info.after ]
endfunction

let s:scroll_start = 0

" Copied from here:
" https://github.com/critiqjo/vim-bufferline/blob/master/autoload/bufferline.vim#L97
function! Trim_status_info(width)
    let line = bufferline#get_echo_string()
    if g:bufferline_status_info.current == ' ' || g:bufferline_status_info.current == ''
        let g:bufferline_status_info.current = '[No Name]'
    elseif g:bufferline_status_info.current == '[+]'
        let g:bufferline_status_info.current = '[No Name][+]'
    endif
    if len(line) < a:width
        return
    endif
    let before = g:bufferline_status_info.before
    let current = g:bufferline_status_info.current
    let after = g:bufferline_status_info.after
    let beg_i = len(before)
    let end_i = beg_i + len(current)
    let scr_i = s:scroll_start
    if beg_i < scr_i
        let scr_i = beg_i
    endif
    if end_i > (scr_i + a:width)
        let scr_i = end_i - a:width + 1
    endif
    if len(line[scr_i :]) < a:width
        let scr_i = len(line) - a:width + 1
    endif
    let g:bufferline_status_info.before = before[scr_i :]
    let beg_i__scr_i = beg_i - scr_i
    if beg_i__scr_i < 0
        let g:bufferline_status_info.current = current[-beg_i__scr_i :]
    endif
    let width__end_i = a:width - len(g:bufferline_status_info.before) - len(g:bufferline_status_info.current) - 1
    if width__end_i == -1
        let g:bufferline_status_info.after = '' " VimL sucks!
    else
        let g:bufferline_status_info.after = after[: width__end_i]
    endif
    let s:scroll_start = scr_i
endfunction

" lightline end }}}

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

function! ShowPreview()
    call feedkeys("i\<c-space>\<c-n>\<esc>")
endfunction

let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_always_populate_location_list = 1
let g:ycm_filetype_blacklist = {}

autocmd FileType tex let g:ycm_min_num_of_chars_for_completion = 5

" Enable tab for completion (removed in oblitum's fork)
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']

" SimpylFold
let g:SimpylFold_fold_docstring = 0
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

nnoremap <leader>fa :call cscope#findInteractive(expand('<cword>'))<CR>
" s: Find this C symbol
nnoremap  <leader>fs :call cscope#find('s', expand('<cword>'))<CR>
" g: Find this definition
nnoremap  <leader>fg :call cscope#find('g', expand('<cword>'))<CR>
" d: Find functions called by this function
nnoremap  <leader>fd :call cscope#find('d', expand('<cword>'))<CR>
" c: Find functions calling this function
nnoremap  <leader>fc :call cscope#find('c', expand('<cword>'))<CR>
" t: Find this text string
nnoremap  <leader>ft :call cscope#find('t', expand('<cword>'))<CR>
" e: Find this egrep pattern
nnoremap  <leader>fe :call cscope#find('e', expand('<cword>'))<CR>
" f: Find this file
nnoremap  <leader>ff :call cscope#find('f', expand('<cword>'))<CR>
" i: Find files #including this file
nnoremap  <leader>fi :call cscope#find('i', expand('<cword>'))<CR>

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
let g:syntastic_vim_checkers = ['vint']
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
    \ inoremap <F5> <c-o>:Validate<CR>

" vim-template
let g:username = 'Marvin Ewald'
let g:email = 'marvin.e@protonmail.ch'
let g:templates_no_autocmd = 1
let g:templates_directory = [ $HOME.'/.vim/templates', $HOME.'/.vim/bundle/vim-template/templates' ]
" autocmd BufNewFile *.h,*.hpp Template *.h
" autocmd BufNewFile *.c,*.cpp Template *.c

" CtrlP
let g:ctrlp_show_hidden=1

" grayout.vim
let g:grayout_confirm = 0
let g:grayout_cmd_line = 'clang -x c++ -w -P -nostdinc -nostdinc++ -E -'

" latex box
let g:LatexBox_viewer = 'zathura'
let g:LatexBox_complete_inlineMath = 1
let g:LatexBox_custom_indent = 0
let g:LatexBox_Folding = 1
let g:LatexBox_fold_automatic = 0
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

" -------------------------------------- Plugin configuration end }}}


" -------------------------------------- Autocmds {{{

" Don't screw up folds when inserting text that might affect them,
" until leaving insert mode.
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

" automatically :retab on save
" autocmd BufWritePre * :retab

" filetype specific foldmethods
autocmd FileType cmake setlocal foldmethod=marker
autocmd FileType vim setlocal foldmethod=marker
autocmd FileType lua setlocal foldmethod=marker

" Markdown preview (requires 'Markdown Viewer' addon)
" autocmd FileType markdown,md nnoremap <F5> :!firefox % &<CR><CR>

" Save/Restore folds
autocmd BufWinLeave * if !&diff && strlen(expand('%')) && &ft != 'gitcommit' | mkview | endif
autocmd BufRead * if !&diff && strlen(expand('%')) && &ft != 'gitcommit' | silent! loadview | endif

autocmd BufEnter ?* if &previewwindow | exec 'setlocal winheight='.&previewheight | endif

" -------------------------------------- Autocmds end }}}


" -------------------------------------- Key mappings {{{
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
nnoremap <s-tab> <c-w><c-w>
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" Make Y behave like other capitals
nnoremap Y y$

" faster substitution with yanked text
nmap S griw

" visually select the text just pasted
nnoremap gz `[v`]

" write file with root permissions
command! SudoWrite w !sudo tee %

command! PabsFormat %s/:/\r    {\r\r    } \/\/

command! FollowSymlink exec 'file '.resolve(expand('%:p')) | e

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

" -------------------------------------- Key mappings end }}}
