" Clean autocmds
autocmd!

let s:use_treesitter = 0

if !has('nvim')
    let s:use_treesitter = 0
endif

" -------------------------------------- General settings start {{{
syntax enable
set number
set noruler
set noshowcmd

" tab size = 4, spaces instead of tabs, and auto indent
set shiftwidth=4
set tabstop=4
set expandtab
set smarttab
set autoindent
set cinoptions+=j1

" enable folding
set foldmethod=syntax
" set nofoldenable
" set foldlevel=1
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

" set breakindentopt=shift:2
" set showbreak=↳\ |
" set showbreak=⇥\ |
" set showbreak=⭲\ |
set cpoptions+=n " remove background from line number column on wrapped lines

" Change buffers without writing changes to a file
set hidden

" Case insensitive file completion
set wildignorecase

" allow incrementing/decrementing letters with c-a / c-x
set nrformats+=alpha

" don't echo the mode
set noshowmode

" Disable visual and audio bell
set visualbell t_vb=
set novisualbell

set viewoptions=cursor,folds,slash,unix

" fold functions, if, for, and while in shell scripts
let g:sh_fold_enabled=7

set previewheight=3

" Disable preview window
" set completeopt-=preview

" Gvim settings
" set guioptions=aic
set guicursor=

set laststatus=2

set pyxversion=3
set fileencoding=utf-8
set encoding=utf-8

set linebreak
set breakindent
" set breakindentopt=shift:4

set display+=lastline

" set smartcase
" set ignorecase

set colorcolumn=80

set mouse=a

" Enable doxygen tag highlighting
let g:load_doxygen_syntax = 1

" Prevent lag when inserting new lines in python files due to indent scripts
let g:pyindent_searchpair_timeout = 10
let g:python_pep8_indent_searchpair_timeout = 10


" ALE configs that need to be set before ALE is loaded
let g:ale_lint_on_enter = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_delay = 2000
" -------------------------------------- General settings end }}}


" -------------------------------------- Aliases {{{
" Treat E as e command
cnoreabbrev E e
cnoreabbrev git Git

" -------------------------------------- Aliases end }}}


" -------------------------------------- Functions and Commands {{{

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


function RunClangTidy()
    let l:checks = join(ale#Var(bufnr('%'), 'cpp_clangtidy_checks'), ',')
    exec '!clang-tidy ' . shellescape(expand('%:p')) . ' --fix --fix-errors --checks=' . shellescape(l:checks)
    normal <esc>
    e
    ALELint
endfun

command! ClangTidy call RunClangTidy()

function! ProfileStart()
    profile start profile.log
    profile func *
    profile file *
endfunction

function! ProfileStop()
    profile pause
    echo 'Quit vim now'
    " noautocmd qall!
endfunction

" change directory to current file
command! Cdhere cd %:h

" -------------------------------------- Functions end }}}


" -------------------------------------- vim-plug {{{
call plug#begin('~/.vim/plugged')

" color schemes
Plug 'icymind/NeoSolarized'
Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'
Plug 'romainl/flattened'
Plug 'qualiabyte/vim-colorstepper'
Plug 'mhartington/oceanic-next'

Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'Lokaltog/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-markdown'
Plug 'tomtom/tcomment_vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'OmniSharp/omnisharp-vim'
Plug 'Shougo/echodoc.vim'

Plug 'Raimondi/delimitMate'
Plug 'airblade/vim-gitgutter'
Plug 'jeetsukumaran/vim-buffergator'

Plug 'majutsushi/tagbar'
Plug 'SirVer/ultisnips'
Plug 'reconquest/vim-pythonx'
Plug 'honza/vim-snippets'
Plug 'kien/ctrlp.vim'
Plug 'kshenoy/vim-signature'
Plug 'dense-analysis/ale'
Plug 'vimperator/vimperator.vim'
Plug 'Shougo/vimproc.vim'
Plug 'dhruvasagar/vim-table-mode'
" Plug '~/dev/python/grayout.vim'
" Plug 'mphe/grayout.vim'
" Plug 'LaTeX-Box-Team/LaTeX-Box'
Plug 'lervag/vimtex'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-user'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'derekwyatt/vim-fswitch'
Plug 'derekwyatt/vim-protodef'
Plug 'tmhedberg/SimpylFold'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'vim-python/python-syntax'
Plug 'withgod/vim-sourcepawn'
Plug 'junegunn/vim-easy-align'
Plug 'osyo-manga/vim-over'
Plug 'Rubonnek/vim-gdscript3'
Plug 'gaving/vim-textobj-argument'
Plug 'farmergreg/vim-lastplace'
Plug 'romainl/vim-cool'
Plug 'neoclide/jsonc.vim'
Plug 'dominikduda/vim_current_word'
" Plug 'bfrg/vim-cpp-modern'
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'lambdalisue/suda.vim'
Plug 'tpope/vim-liquid'
Plug 'embear/vim-localvimrc'
Plug 'amadeus/vim-convert-color-to'
Plug 'mingchaoyan/vim-shaderlab'
Plug 'wsdjeg/FlyGrep.vim'
Plug 'tikhomirov/vim-glsl'
" Plug 'beyondmarc/glsl.vim'
" Plug 'petrbroz/vim-glsl'
Plug 'captbaritone/better-indent-support-for-php-with-html'
Plug 'mattn/emmet-vim'
Plug 'kosayoda/nvim-lightbulb'

Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-EnhancedJumps'
Plug 'MattesGroeger/vim-bookmarks'
" Plug 'Jorengarenar/vim-syntaxMarkerFold'

" Auto detect indent
Plug 'tpope/vim-sleuth'

" IntelliJ <-> Neovim bridge
Plug 'beeender/Comrade'

if !has('nvim')
    Plug 'Konfekt/FastFold'
endif

if s:use_treesitter
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
endif

call plug#end()

" -------------------------------------- vim-plug end }}}


" -------------------------------------- Style config {{{
source /home/marvin/.vim/themes/solarized.vim
" source /home/marvin/.vim/themes/dark.vim

" set the split char tmux uses
set fillchars+=vert:│

" Highlight trailing whitespace
call matchadd('Error', '\s\+$')

" -------------------------------------- Style config end }}}


" -------------------------------------- Plugin configuration {{{

" lightline
source ~/.vim/lightline_cfg.vim

" easymotion
let g:EasyMotion_smartcase = 1
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)
nnoremap <leader>n n
nnoremap <leader>N N

" NERDTree shortcut
command! NT NERDTreeToggle
" let NERDTreeWinPos = "right"

" YCM
" let g:ycm_use_clangd = 0
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_server_keep_logfiles = 0
" let g:ycm_server_log_level = 'debug'
" let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_always_populate_location_list = 1
let g:ycm_filetype_blacklist = {}
let g:ycm_warning_symbol = '!!'
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_comments = 1

" autocmd FileType tex let g:ycm_min_num_of_chars_for_completion = 5

" Enable tab for completion
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']

" SimpylFold
let g:SimpylFold_fold_docstring = 1
" autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
" autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<

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

augroup au_tagbar
    au!
    " kinda fix tagbar cursor lag
    autocmd FileType tagbar setlocal nocursorline nocursorcolumn
augroup END

let g:tagbar_type_gdscript3 = {
			\ 'ctagstype' :'gdscript3',
			\ 'kinds': [
                            \ 'c:constants',
                            \ 'p:preloads',
                            \ 'e:exports',
                            \ 'o:onready',
                            \ 'v:variables',
                            \ 's:signals',
                            \ 'f:functions',
                            \ 't:static functions',
                        \ ]
                        \ }
let g:tagbar_type_gdscript3.deffile = expand('~/.vim/ctags/gdscript3.ctags')


" ColorStepper Keys
" nmap <S-F6> <Plug>ColorstepPrev
" nmap <S-F7> <Plug>ColorstepNext
" nmap <S-F7> <Plug>ColorstepReload

" FSwitch
nnoremap <leader>gf :FSHere<CR>
nnoremap <leader>gF :vsp<CR>:FSHere<CR>

" UltiSnip
let g:UltiSnipsExpandTrigger='<c-j>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
let g:ultisnips_java_brace_style='nl'

command! UltiSnipReload call UltiSnips#RefreshSnippets()

" ale
let g:ale_disable_lsp = 1

let g:ale_linters = {
    \ 'cpp': [ 'clangtidy' ],
    \ 'c': [ 'clangtidy' ],
    \ 'java': [],
    \ 'gdscript3': [],
    \ 'tex': [],
    \ 'css': [],
    \ 'cs': [ 'OmniSharp' ],
    \ }
let g:ale_fixers = {
    \ 'cpp': [ 'clangtidy' ],
    \ 'c': [ 'clangtidy' ],
    \ 'java': [],
    \ }

let g:ale_pattern_options = {'\.tex$': {'ale_enabled': 0}}

let g:ale_linters_ignore = [ 'lacheck', 'pyright' ]

let g:ale_cs_csc_options = ' /warn:4 /langversion:7.2'

let g:ale_cpp_clangtidy_checks = [ 'modernize-use-override' ]
let g:ale_c_clangtidy_checks = [ 'modernize-use-override' ]
" let g:ale_exclude_highlights = [ '.*clang-diagnostic-.*' ]

let g:ale_type_map = {
            \ 'flake8': {'ES': 'I', 'WS': 'I'},
            \ 'mypy':   {'ES': 'I', 'WS': 'I'},
            \ 'pylint': {'ES': 'I', 'WS': 'I'},
            \ 'vint':   {'ES': 'I', 'WS': 'I'},
            \ 'luacheck': {'ES': 'I', 'WS': 'I'},
            \ }

let g:ale_python_flake8_options = '--ignore=F403,F401,E201,E202,F841,E501,E221,E241,E722,F405'
let g:ale_python_pylint_options = '-j 4 --ignored-modules=scapy,numpy,matplotlib,pyplot --disable=C,syntax-error,too-few-public-methods,global-statement,useless-object-inheritance,try-except-raise,broad-except,too-many-branches,too-many-arguments,protected-access,chained-comparison'
let g:ale_python_mypy_options = '--install-types --non-interactive --namespace-packages --show-error-codes --show-error-context --show-column-numbers --no-strict-optional --ignore-missing-imports --check-untyped-defs --allow-untyped-globals'
let g:ale_python_mypy_ignore_invalid_syntax = 1
let g:ale_python_mypy_show_notes = 0

let b:ale_python_pyright_config = {
\ 'pyright': {
\   'disableLanguageServices': v:true,
\ },
\}

let g:ale_nasm_nasm_options = '-f elf64'

let g:ale_lua_luacheck_options = ''

" let g:ale_lint_on_enter = 1
" let g:ale_lint_on_filetype_changed = 1
" let g:ale_lint_on_text_changed = 1
" let g:ale_lint_on_insert_leave = 1
" let g:ale_lint_on_save = 1

let g:ale_echo_msg_format = '[ale][%linter%] %code: %%s'
let g:ale_sign_warning = ' '
let g:ale_sign_info = ' '
let g:ale_sign_error = ' '
" let g:ale_sign_warning = '!!'
" let g:ale_sign_info = '?'
" let g:ale_sign_error = "\uf05e  "
" let g:ale_sign_warning = "\uf071  "
" let g:ale_sign_info = "\uf05a  "


" eclim
let g:EclimCompletionMethod = 'omnifunc'
autocmd FileType java
    \ nnoremap <leader>fx :JavaCorrect<CR>|
    \ nnoremap <leader>fi :JavaImport<CR>

" CtrlP
let g:ctrlp_show_hidden=1
" let g:ctrlp_custom_ignore = '\.pyc'
let g:ctrlp_open_multiple_files = 'ijr'
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git|hg|svn|clangd|ccls-cache|tmp)$',
            \ 'file': '\v\.(exe|so|dll|pyc|o|a)$'
            \ }
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -c -o --exclude-standard && git submodule --quiet foreach --recursive "git ls-files . -c -o --exclude-standard"', 'find %s -type f']

" vimtex
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_enabled = 0
let g:vimtex_complete_enabled = 0
let g:vimtex_delim_timeout = 10
let g:vimtex_delim_insert_timeout = 10
let g:vimtex_fold_enabled = 0
let g:vimtex_imaps_enabled = 0
let g:vimtex_mappings_enabled = 0

" latex box
let g:LatexBox_viewer = 'zathura'
let g:LatexBox_complete_inlineMath = 1
let g:LatexBox_custom_indent = 0
let g:LatexBox_Folding = 1
let g:LatexBox_fold_automatic = 0
let g:LatexBox_quickfix = 4
let g:LatexBox_fold_sections=[ 'part', 'chapter', 'section', 'subsection', 'subsubsection', 'paragraph', 'subparagraph' ]
let g:LatexBox_completion_close_braces = 0
let g:LatexBox_complete_inlineMath = 0

command! LatexPreview silent exec '!zathura ' . expand('%:p:r') . '.pdf' . '&'
command! LatexJump CocCommand latex.ForwardSearch

let g:tex_flavor = 'latex'

" Remaps some keys for easier latex math input, e.g. * -> \cdot.
inoremap <expr> <F4> ToggleLatexMath()

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
        let g:delimitMate_matchpairs = '[:],{:},<:>'
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
        let g:delimitMate_matchpairs = '(:),[:],{:},<:>'
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


" tcomment
let g:tcommentLineC = {
            \ 'commentstring': '// %s',
            \ 'replacements': g:tcomment#replacements_c
            \ }
call tcomment#type#Define('c', g:tcommentLineC)
call tcomment#type#Define('glsl', g:tcommentLineC)

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

" vim-cpp-modern
" let g:cpp_no_function_highlight = 0
" let g:cpp_simple_highlight = 0
" let g:cpp_named_requirements_highlight = 1

" echodoc
" autocmd FileType gdscript3 let g:echodoc#enable_at_startup = 1
let g:echodoc#enable_at_startup = 0
set noshowmode

augroup au_omnisharp_hints
    autocmd FileType cs EchoDocEnable
augroup end

" python-syntax
let g:python_highlight_all = 1

" vim-cool
let g:CoolTotalMatches = 0

" current word
let g:vim_current_word#highlight_delay = 1500

" markdown preview
let g:mkdp_auto_close = 0

" vim-lsp-cxx
" let g:lsp_cxx_hl_log_file = 'lspcxxlog.txt'
" let g:lsp_cxx_hl_verbose_log = 1

" chromatica
let g:chromatica#enable_at_startup = 1
let g:chromatica#responsive_mode = 1


" suda.vim
command! SudoWrite w suda://%

" enhanced jumps
let g:EnhancedJumps_no_mappings = 1
let g:EnhancedJumps_CaptureJumpMessages = 0
map <c-o> <Plug>EnhancedJumpsLocalOlder
map <c-i> <Plug>EnhancedJumpsLocalNewer

" grayout.vim
let g:grayout_debug_logfile = 1
" autocmd BufReadPost,BufWritePost * if &ft == 'c' || &ft == 'cpp' || &ft == 'objc' | exec 'GrayoutUpdate' | endif
" autocmd CursorHold,CursorHoldI * if &ft == 'c' || &ft == 'cpp' || &ft == 'objc' | exec 'GrayoutUpdate' | endif

" omnisharp-vim
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_server_use_mono = 0
let g:OmniSharp_highlight_groups = {
    \ 'ClassName': 'Type',
    \ 'StructName': 'Type',
    \ 'EnumName': 'Type',
    \ 'FieldName': 'Normal',
    \ 'PropertyName': 'Normal',
    \ 'ParameterName': 'Normal',
    \ 'LocalName': 'Normal',
    \ 'ConstantName': 'Constant',
    \ 'NamespaceName': 'LspCxxHlGroupNamespace',
    \ }

" echodoc
let g:echodoc#enable_at_startup = 0
let g:echodoc#type = 'floating'


" Comrade
let g:comrade_key_fix = '<leader>fx'

" vim-bookmarks
let g:bookmark_no_default_key_mappings = 1
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1
nmap mm <Plug>BookmarkToggle

" lightline-bufferline
" Additional config in .vim/lightline_cfg.vim
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

" treesitter
" https://github.com/nvim-treesitter/nvim-treesitter
if s:use_treesitter
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()

    lua <<EOF
    require'nvim-treesitter.configs'.setup {
        ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        ignore_install = {}, -- List of parsers to ignore installing
        highlight = {
            enable = true,
            disable = { "json" },  -- list of language that will be disabled
            custom_captures = {
                -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
                -- ["foo.bar"] = "Identifier",
            },
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true
        }
    }
EOF
endif

" -------------------------------------- Plugin configuration end }}}


" -------------------------------------- Autocmds {{{
augroup vimrc_autocmds
au!
" Don't screw up folds when inserting text that might affect them,
" until leaving insert mode.
" autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
" autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

" Save/Restore folds
" autocmd BufWinLeave * if !&diff && strlen(expand('%')) && &ft != 'gitcommit' | mkview | endif
" autocmd BufRead * if !&diff && strlen(expand('%')) && &ft != 'gitcommit' | silent! loadview | endif

" filetype specific settings
" autocmd FileType cmake,vim,lua setlocal foldmethod=marker
autocmd FileType sourcepawn,json,jsonc setlocal commentstring=//\ %s
autocmd FileType text,markdown,tex,unknown setlocal wrap
autocmd FileType markdown setlocal shiftwidth=2 | setlocal tabstop=2
autocmd FileType scala setlocal previewheight=5

" cursorline in php or html files often severe massive lags
autocmd FileType * setlocal cursorline
autocmd FileType php,html,tex setlocal nocursorline

" autoclose location list after jump
autocmd FileType qf nmap <buffer> <cr> <cr>:lcl<cr>

autocmd FileType * setlocal formatoptions+=croj

" Set filetype by extension
autocmd BufRead,BufNewFile *.fsh set filetype=glsl
autocmd BufRead,BufNewFile *.vsh set filetype=glsl

autocmd FileType *
    \ nmap <silent> <F8> <Plug>(ale_previous_wrap_error)|
    \ nmap <silent> <F9> <Plug>(ale_next_wrap_error)

autocmd FileType c,cpp
    \ nnoremap <F8> :labove<CR>|
    \ nnoremap <F9> :lbelow<CR>

augroup END
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
nmap j gj
nmap k gk
" nmap $ g$
xmap j gj
xmap k gk
" xmap $ g$

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

" write file with root permissions (does not work in neovim, use suda.vim instead)
" command! SudoWrite w !sudo tee %

command! PabsFormat %s/:/\r    {\r\r    } \/\/

command! FollowSymlink exec 'file '.resolve(expand('%:p')) | e

command! -range=% StripTrailingSpaces <line1>,<line2>s/\s\+$//e

command! -range=% StripExtraSpaces <line1>,<line2>s/\(\S\)\s\+/\1 /ge | StripTrailingSpaces

command! -range=% ToSource silent <line1>,<line2>s/\s*=.*\(,\|)\)/\1/ge |
            \ exec '<line1>,<line2>normal ==' |
            \ silent exec '<line1>,<line2>StripExtraSpaces' |
            \ silent <line1>,<line2>s/\(virtual \|static \|constexpr \|explicit \)//ge |
            \ silent <line1>,<line2>s/\( override\| final\)//ge |
            \ silent <line1>,<line2>s/;/\r    {\r        \/\/ TODO\r    }\r/ge |

command! -nargs=? -range=% ToSourceAuto silent exec '<line1>,<line2>ToSourceAutoName ' . expand('%:t:r')

command! -nargs=? -range=% ToSourceAutoName exec '<line1>,<line2>normal ==' |
            \ silent exec '<line1>,<line2>StripExtraSpaces' |
            \ silent <line1>,<line2>s/\(virtual \|static \|constexpr \|explicit \)//ge |
            \ silent <line1>,<line2>s/\( override\| final\)//ge |
            \ silent <line1>,<line2>s/\s*=.*\(,\|)\)/\1/ge |
            \ silent <line1>,<line2>s/auto \(.\{-}\)\s*->\s*\(.\{-}\)\s*;/auto <args>::\1 -> \2\r    {\r        \/\/ TODO\r    }\r/ |
            \ normal =``

" Surrounds operators by one space.
" It does not fix multiple spaces around operators.
command! -range=% OpSpacing <line1>,<line2>s/\>\v(\=|\+|\-|\=\=|\>|\<|\*|\/|\&\&|\|\||\%)\m\</ \1 /g

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
" inoremap <C-L> <C-O>A

" Repeat last ex command
nnoremap ; @:

" Find next character when using f/F or t/T
nnoremap <space> ;
vnoremap <space> ;

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" F5
function! F5Refresh()
    if &filetype ==# 'java'
        Validate
    elseif &filetype ==# 'tex'
        if exists(':Latexmk')
            Latexmk
        elseif exists(':CocCommand')
            CocCommand latex.Build
            LatexJump
        endif
    elseif &filetype ==# 'markdown' || &filetype ==# 'md'
        MarkdownPreview
        " GodownPreview
    elseif &filetype ==# 'c' || &filetype ==# 'cpp' || &filetype ==# 'cs'
        if exists(':GrayoutUpdate')
            GrayoutUpdate
        endif
        LspCxxHighlight
        ALELint
    else
        ALELint
    endif
endfun

nnoremap <silent> <F5> :call F5Refresh()<CR>
inoremap <silent> <F5> <c-o>:call F5Refresh()<CR>

nnoremap <leader>d :ALEDetail<CR>


" -------------------------------------- Key mappings end }}}


" better fold text {{{
" indent folds
" https://old.reddit.com/r/vim/comments/fwjpi4/here_is_how_to_retain_indent_level_on_folds/
let indent_level = indent(v:foldstart)
let indent = repeat(' ',indent_level)

" Modified from http://dhruvasagar.com/2013/03/28/vim-better-foldtext
function! NeatFoldText()
    let indent_level = indent(v:foldstart)
    let indent = repeat(' ',indent_level)
    let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '-' . printf('%10s', lines_count . ' lines') . ' '
    let foldchar = matchstr(&fillchars, 'fold:\zs.')
    let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return indent . foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()
" better fold text }}}

" source ~/.vim/completion_preview.vim
source ~/.vim/coc.vim
source ~/.vim/omnisharp.vim

function! CheckSize()
    let size = getfsize(@%)
    if size > 10000000 " 10 MB
        echo 'Warning: The file is larger than 10MB -> Disabling ALE and Syntax'
        let b:ale_enabled = 0
        " syntax clear
        setlocal syntax=off
    endif
endfun

au BufEnter * :call CheckSize()
