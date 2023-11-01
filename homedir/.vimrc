" Clean autocmds
autocmd!

let s:use_treesitter = 0
let s:use_vim_omnisharp = 0

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

set colorcolumn=100

" Make gq break lines at 100 but don't automatically break lines while typing
set textwidth=100
set formatoptions-=tc

set mouse=a

" Ensure there is always a sign column to prevent flickering when signs get
" removed and added within a fraction of a second, when the linter updates,
" causing the sign column to appear and disappear constantly while typing.
set signcolumn=yes

" Enable doxygen tag highlighting
let g:load_doxygen_syntax = 1

" Prevent lag when inserting new lines in python files due to indent scripts
let g:pyindent_searchpair_timeout = 10
let g:python_pep8_indent_searchpair_timeout = 10

" -------------------------------------- General settings end }}}

" -------------------------------------- Plugin settings before loading {{{
" ALE configs that need to be set before ALE is loaded
let g:ale_use_neovim_diagnostics_api = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_delay = 2000

" Workaround ALE diagnostics disappearing upon saving when getting diagnostics from coc.nvim
" https://github.com/dense-analysis/ale/discussions/3721
" augroup ale_autocmd
"     au!
"     autocmd FileType typescript,gdscript3 let g:ale_lint_on_save = 0 |
"                 \ let g:ale_lint_on_insert_leave = 0 |
"                 \ let g:ale_lint_on_text_changed = 0 |
"                 \ let g:ale_lint_on_enter = 0 |
"                 \ let g:ale_lint_on_filetype_changed = 0
" augroup END

" -------------------------------------- Plugin settings before loading }}}


" -------------------------------------- Aliases {{{
" Treat E as e command
cnoreabbrev E e

" -------------------------------------- Aliases end }}}


" -------------------------------------- Functions and Commands {{{

command! OpenExplorer silent exec '!xdg-open .'

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


" Better GQ operator that uses colorcolumn as text width {{{
" See also
" - https://learnvimscriptthehardway.stevelosh.com/chapters/33.html
" - https://vi.stackexchange.com/questions/19770/how-to-create-new-operator-by-using-existing-operator-with-current-motion

function! BetterGQ(type)
    let old_textwidth = &textwidth
    exec 'set textwidth=' . &colorcolumn

    call s:ExecuteOperator(a:type, a:0 > 0, 'gq')

    exec 'set textwidth=' . old_textwidth
endfun

function! s:ExecuteOperator(type, visual, operator)
  " Use normal! to make sure no user mappings are used
    if a:visual
        exec 'normal! gv' . a:operator
    else
        if a:type ==# 'line'
            exec 'normal! ''[V'']' . a:operator
        else
            exec 'normal! ''[v'']' . a:operator
        endif
    endif
endfunction

" nnoremap gq :set operatorfunc=BetterGQ<CR>g@
" vnoremap gq :<c-u>call BetterGQ(visualmode())<CR>

" }}}

" -------------------------------------- Functions end }}}


" -------------------------------------- vim-plug {{{
call plug#begin('~/.vim/plugged')

" color schemes
Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'
Plug 'romainl/flattened'
Plug 'qualiabyte/vim-colorstepper'

Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'Lokaltog/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-markdown'
Plug 'tomtom/tcomment_vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Shougo/echodoc.vim'

Plug 'Raimondi/delimitMate'
Plug 'airblade/vim-gitgutter'
Plug 'jeetsukumaran/vim-buffergator'

Plug 'majutsushi/tagbar'
Plug 'SirVer/ultisnips'
" Plug 'reconquest/vim-pythonx'
Plug 'honza/vim-snippets'
Plug 'kien/ctrlp.vim'
Plug 'kshenoy/vim-signature'
Plug 'dense-analysis/ale'
Plug 'vimperator/vimperator.vim'
Plug 'Shougo/vimproc.vim'
Plug 'dhruvasagar/vim-table-mode'
" Plug '~/extdata/vim/grayout.vim'
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

" IntelliJ a-> Neovim bridge
" Plug 'beeender/Comrade'

" Scrollbar with diagnostics and search markers
Plug 'petertriho/nvim-scrollbar'

" Move function arguments (and other delimited-by-something items) left and right.
Plug 'AndrewRadev/sideways.vim'

" Easy text exchange operator
Plug 'tommcdo/vim-exchange'

" Interact with jupyter from neovim
Plug 'tzachar/magma-nvim', { 'do': ':UpdateRemotePlugins' }

" Open a scratch buffer to quickly evaluate code
Plug 'shift-d/scratch.nvim'

" Plug 'github/copilot.vim'
" Plug 'samodostal/copilot-client.lua'
Plug 'zbirenbaum/copilot.lua'
Plug 'nvim-lua/plenary.nvim'

" Preview colours in source code while editing
Plug 'ap/vim-css-color'

" typescript/javascript indent
" Plug 'jason0x43/vim-js-indent'

Plug 'Konfekt/FastFold'

Plug 'weirongxu/plantuml-previewer.vim'
Plug 'tyru/open-browser.vim'

" Custom symbol as color column
" Plug 'lukas-reineke/virt-column.nvim'

" Generate TOC in markdown files
Plug 'mzlogin/vim-markdown-toc'

if has('nvim')
    Plug 'rcarriga/nvim-notify'
    if s:use_treesitter
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
    endif

    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }

    " Fix CursorHold performance
    Plug 'antoinemadec/FixCursorHold.nvim'

    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'romgrk/barbar.nvim'

    " Easy custom highlight patterns
    Plug 'folke/paint.nvim'
else
endif

if s:use_vim_omnisharp
    Plug 'OmniSharp/omnisharp-vim'
endif

call plug#end()

" -------------------------------------- vim-plug end }}}


" -------------------------------------- Style config {{{
source /home/marvin/.vim/themes/solarized.vim
" source /home/marvin/.vim/themes/dark.vim

" set the split char tmux uses
set fillchars+=vert:│

" Highlight trailing whitespace
" highlight! link TrailingWhitespace Error
" augroup trailing_spaces_hl
"   au!
"   autocmd Syntax * syn match TrailingWhitespace /\s\+$\| \+\ze\t/
" augroup END

" -------------------------------------- Style config end }}}


" -------------------------------------- Plugin configuration {{{

" localvimrc
let g:localvimrc_reverse = 1
let g:localvimrc_blacklist = [ expand('~/.vimrc'), resolve(expand('~/.vimrc')) ]
let g:localvimrc_name = [ '.lvimrc', '.vimrc' ]

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
let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_prefix = ' ◾'

let g:ale_linters = {
    \ 'cpp': [ 'clangtidy' ],
    \ 'c': [ 'clangtidy' ],
    \ 'java': [],
    \ 'gdscript3': [],
    \ 'tex': [],
    \ 'css': [],
    \ 'go': [],
    \ 'cs': [ 'OmniSharp' ],
    \ 'glsl': [ 'glslang' ],
    \ }
let g:ale_fixers = {
    \ 'cpp': [ 'clangtidy' ],
    \ 'c': [ 'clangtidy' ],
    \ 'java': [],
    \ }

let g:ale_pattern_options = {'\.tex$': {'ale_enabled': 0}}

let g:ale_linters_ignore = [ 'lacheck', 'pyright', 'shell']

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

" let g:ale_python_auto_pipenv = 1
let g:ale_python_flake8_options = '--ignore=F403,F401,E201,E202,F841,E501,E221,E241,E722,F405'
let g:ale_python_pylint_options = '-j 4 --ignored-modules=pyglet,scapy,numpy,matplotlib,pyplot --disable=C,syntax-error,too-few-public-methods,global-statement,useless-object-inheritance,try-except-raise,broad-except,too-many-branches,too-many-arguments,protected-access,chained-comparison,too-many-instance-attributes,unspecified-encoding'
let g:ale_python_mypy_options = '--install-types --non-interactive --namespace-packages --show-error-codes --show-error-context --show-column-numbers --no-strict-optional --ignore-missing-imports --check-untyped-defs --allow-untyped-globals'
let g:ale_python_mypy_ignore_invalid_syntax = 1
let g:ale_python_mypy_show_notes = 0
let g:ale_python_pylint_auto_pipenv = 1
let g:ale_python_auto_pipenv = 1

let b:ale_python_pyright_config = {
\ 'pyright': {
\   'disableLanguageServices': v:true,
\ },
\}

let g:ale_nasm_nasm_options = '-f elf64'

let g:ale_lua_luacheck_options = ''

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
            \ 'dir':  '\v[\/](\.(git|hg|svn|clangd|ccls-cache|tmp|mypy_cache|cache)|node_modules)$',
            \ 'file': '\v\.(exe|so|dll|pyc|o|a)$'
            \ }
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -c -o --exclude-standard && git submodule --quiet foreach --recursive "git ls-files . -c -o --exclude-standard"', 'find %s -type f']

" vimtex
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_enabled = 0
let g:vimtex_complete_enabled = 0
let g:vimtex_delim_timeout = 10
let g:vimtex_delim_insert_timeout = 10
let g:vimtex_fold_enabled = 1
let g:vimtex_imaps_enabled = 0
let g:vimtex_mappings_enabled = 0

augroup vimtex_build_on_save
    autocmd!
    autocmd BufReadPost,BufWritePost * if &ft == 'tex' | exec 'CocCommand latex.Build' | endif
augroup END

" latex box
" let g:LatexBox_viewer = 'zathura'
" let g:LatexBox_complete_inlineMath = 1
" let g:LatexBox_custom_indent = 0
" let g:LatexBox_Folding = 1
" let g:LatexBox_fold_automatic = 0
" let g:LatexBox_quickfix = 4
" let g:LatexBox_fold_sections=[ 'part', 'chapter', 'section', 'subsection', 'subsubsection', 'paragraph', 'subparagraph' ]
" let g:LatexBox_completion_close_braces = 0
" let g:LatexBox_complete_inlineMath = 0

command! LatexPreview VimtexView
command! LatexJump VimtexView

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

" Adds 'c' as vim-surround command to wrap selection in a latex command like \emph{}
let g:surround_{char2nr('c')} = "\\\1command\1{\r}"


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
cnoreabbrev git Git
cnoreabbrev Gcommit Git commit

" vim-sourcepawn
au FileType sourcepawn setlocal makeprg=/home/marvin/servers/steamcmd/tf2/tf/addons/sourcemod/scripting/spcomp\ %

" tablemode
au FileType markdown,md let table_mode_corner = '|'

" easy align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
let g:easy_align_delimiters = {
      \ '>': { 'pattern': '->' },
      \ '/': { 'pattern': '/' },
      \ }

" vim-cpp-modern
" let g:cpp_no_function_highlight = 0
" let g:cpp_simple_highlight = 0
" let g:cpp_named_requirements_highlight = 1

" echodoc
" autocmd FileType gdscript3 let g:echodoc#enable_at_startup = 1
let g:echodoc#enable_at_startup = 0
set noshowmode

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
nmap g<c-o> <Plug>EnhancedJumpsOlder
nmap g<c-i> <Plug>EnhancedJumpsNewer
nmap <BS> <Plug>EnhancedJumpsRemoteOlder
nmap <C-Left> <Plug>EnhancedJumpsRemoteOlder
nmap <C-Right> <Plug>EnhancedJumpsRemoteNewer

" grayout.vim
let g:grayout_debug_logfile = 1
" autocmd BufReadPost,BufWritePost * if &ft == 'c' || &ft == 'cpp' || &ft == 'objc' | exec 'GrayoutUpdate' | endif
" autocmd CursorHold,CursorHoldI * if &ft == 'c' || &ft == 'cpp' || &ft == 'objc' | exec 'GrayoutUpdate' | endif

" omnisharp-vim
if s:use_vim_omnisharp
    let g:OmniSharp_server_stdio = 1
    " let g:OmniSharp_server_use_mono = 0
    let g:OmniSharp_server_use_mono = 1
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
    source ~/.vim/omnisharp.vim

    augroup au_omnisharp_hints
        autocmd FileType cs EchoDocEnable
        autocmd BufWritePost *.cs OmniSharpHighlight
    augroup end

endif

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


" treesitter
" https://github.com/nvim-treesitter/nvim-treesitter
if s:use_treesitter
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()

    lua << EOF
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



fun! Qf_test()
    lua ll_handler(vim.fn.bufnr())
    lua require('scrollbar.handlers').show();require('scrollbar').render()
endfun

" augroup scrollbar_loclist
"     autocmd!
"     autocmd User ALELintPost,ALEFixPost,CocDiagnosticChange call Qf_test()
"
"     " quickfix
"     autocmd QuickFixCmdPost [^l]* call Qf_test()
"     " location
"     autocmd QuickFixCmdPost l* call Qf_test()
"     autocmd Filetype qf call Qf_test()
" augroup END


" magma-nvim
nnoremap <silent><expr> <leader>r  :MagmaEvaluateOperator<CR>
nnoremap <silent>       <leader>rr :MagmaEvaluateLine<CR>
xnoremap <silent>       <leader>r  :<C-u>MagmaEvaluateVisual<CR>
nnoremap <silent>       <leader>rc :MagmaReevaluateCell<CR>
nnoremap <silent>       <leader>rd :MagmaDelete<CR>
nnoremap <silent>       <leader>ro :MagmaShowOutput<CR>
nnoremap <silent>       <leader>rq :noautocmd MagmaEnterOutput<CR>

let g:magma_automatically_open_output = v:false
let g:magma_wrap_output = v:false


" sideways.vim
nnoremap <leader>< :SidewaysLeft<cr>
nnoremap <leader>> :SidewaysRight<cr>

" FixCursorHold
" in millisecond, used for both CursorHold and CursorHoldI, uses updatetime instead if not defined
let g:cursorhold_updatetime = 100

" table-mode
let g:table_mode_syntax = 0
nnoremap <leader>ta :TableModeRealign<CR>


" virt-column
" lua require("virt-column").setup()

" vim-markdown-toc
let g:vmt_list_item_char = '-'

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
autocmd FileType cmake,vim,lua setlocal foldmethod=marker
autocmd FileType sourcepawn,json,jsonc setlocal commentstring=//\ %s
autocmd FileType text,markdown,tex,unknown setlocal wrap
autocmd FileType markdown setlocal shiftwidth=2 | setlocal tabstop=2 | setlocal formatoptions-=tc
" autocmd FileType markdown call coc#config('diagnostic.displayByAle', v:false)
autocmd FileType scala setlocal previewheight=5

" cursorline in php or html files often severe massive lags
autocmd FileType * setlocal cursorline
autocmd FileType php,html,tex setlocal nocursorline

" autoclose location list after jump
autocmd FileType qf nmap <buffer> <cr> <cr>:lcl<cr>

" autocmd FileType * setlocal formatoptions+=croj
autocmd FileType * setlocal formatoptions+=roj

" Set filetype by extension
autocmd BufRead,BufNewFile *.fsh set filetype=glsl
autocmd BufRead,BufNewFile *.vsh set filetype=glsl

autocmd FileType *
    \ nmap <silent> <F8> <Plug>(ale_previous_wrap_error)|
    \ nmap <silent> <F9> <Plug>(ale_next_wrap_error)

" autocmd FileType *
"     \ nnoremap <F8> :labove<CR>|
"     \ nnoremap <F9> :lbelow<CR>

augroup END
" -------------------------------------- Autocmds end }}}


" -------------------------------------- Key mappings {{{

" Make commands for {} groups better accessible
nnoremap dib di}
nnoremap cib ci}
nnoremap vib vi}
nnoremap dab da}
nnoremap cab ca}
nnoremap vab va}

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
" nnoremap <leader>bn :bn<CR>
" nnoremap <leader>bp :bp<CR>
nnoremap <leader>bl :b#<CR>
nnoremap <leader>l :ls<CR>:b 

" buffergator
let g:buffergator_suppress_keymaps = 1
nnoremap <leader>bb :BuffergatorOpen<CR>

" Delete current buffer and open the next or an empty buffer
" instead of closing the window
" nnoremap <leader>bD :bp<bar>sp<bar>bn<bar>bd<CR>
" nnoremap <leader>bd :bn<bar>sp<bar>bp<bar>bd<CR>

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
    elseif &filetype ==# 'c' || &filetype ==# 'cpp'
        if exists(':GrayoutUpdate')
            GrayoutUpdate
        endif
        LspCxxHighlight
        ALELint
    elseif &filetype ==# 'cs'
        if s:use_vim_omnisharp
            OmniSharpHighlight
        endif
    else
        ALELint
    endif
endfun

nnoremap <silent> <F5> :call F5Refresh()<CR>
inoremap <silent> <F5> <c-o>:call F5Refresh()<CR>

function! ShowDiagnostics()
  ALEDetail
  call CocAction('diagnosticInfo')
endfun

" nnoremap <leader>d :ALEDetail<CR>
nnoremap <leader>d :call ShowDiagnostics()<CR>


nnoremap <F8> :labove<CR>
nnoremap <F9> :lbelow<CR>

" Make ctrl-c copy the selected text
vmap <c-c> "+y

" -------------------------------------- Key mappings end }}}


" better fold text {{{
" indent folds
" https://old.reddit.com/r/vim/comments/fwjpi4/here_is_how_to_retain_indent_level_on_folds/

" Modified from http://dhruvasagar.com/2013/03/28/vim-better-foldtext
function! NeatFoldText()
    let indent_level = indent(v:foldstart)
    let indent = repeat(' ', indent_level)
    let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = printf('%10s', lines_count . ' lines') . ' '
    let foldchar = matchstr(&fillchars, 'fold:\zs.')
    " let foldtextstart = strpart('+ ' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
    let foldtextstart = strpart('+' . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return indent . foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength - indent_level) . foldtextend
endfunction

" set fillchars+=fold:─
set fillchars+=fold:\ ,
set foldtext=NeatFoldText()
highlight! Folded guibg=NONE gui=bold

" better fold text }}}

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


" copilot
" let g:copilot_no_tab_map = v:true
" imap <silent><script><expr> <C-J> copilot#Accept("\<C-J>")
" let g:copilot_assume_mapped = v:true

" lua vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })



" source ~/.vim/completion_preview.vim
source ~/.vim/coc.vim

if has('nvim')
  lua require("config")
endif
