" lightline related configs

let s:diagnostic_symbols = { 'error': "\uf05e  ", 'warning': "\uf071  ", 'info': "\uf05a  " }

let s:error_symbol = "\uf05e  "
let s:warning_symbol = "\uf071  "
let s:info_symbol = "\uf05a  "

" lightline-bufferline
set showtabline=2
let g:lightline#bufferline#unnamed = '[No Name]'
let g:lightline#bufferline#modified = '[+]'
let g:lightline#bufferline#read_only = ' ⭤'
let g:lightline#bufferline#filename_modifier = ':t'

" lightline ale
" let g:lightline#ale#indicator_infos = 'i '
" let g:lightline#ale#indicator_infos = ''
" let g:lightline#ale#indicator_warnings = ''
" let g:lightline#ale#indicator_errors = ''

" let g:lightline#ale#indicator_checking = "\uf110  "
" let g:lightline#ale#indicator_infos = "\uf129 "
let g:lightline#ale#indicator_infos = s:info_symbol
let g:lightline#ale#indicator_warnings = s:warning_symbol
let g:lightline#ale#indicator_errors = s:error_symbol
" let g:lightline#ale#indicator_ok = "\uf00c  "


" lightline {{{

" \       [ 'lineinfo' ],
" \       [ 'fileformat', 'fileencoding', 'filetype' ],
" \       [ 'percent' ],
" \       [ 'maxlines' ],
" \   'syntastic': 'SyntasticStatuslineFlag',
" \   'syntastic': 'error',

let g:lightline = {}
let g:lightline.colorscheme = 'custom_solarized'

" let g:lightline.separator = { 'left': "\u258c", 'right': "\u2590" }
" let g:lightline.separator = { 'left': "\u2599", 'right': "\u259f" }
" let g:lightline.separator = { 'left': ' ', 'right': '█' }
" let g:lightline.separator = { 'left': '', 'right': '' }
" let g:lightline.subseparator = { 'left': '', 'right': '' }
let g:lightline.tabline_subseparator = { 'left': '', 'right': '' }
let g:lightline.tabline_separator =  { 'left': '', 'right': '' }
" let g:lightline.tabline_separator =  { 'left': '', 'right': '' }

" \ 'separator': { 'left': '█', 'right': '█' },
" \ 'subseparator': { 'left': '|', 'right': '|' },
" \ 'tabline_subseparator': { 'left': '', 'right': '' },
" \ 'tabline_separator':  { 'left': '█', 'right': '█' },
" \ 'separator': { 'left': '', 'right': '' },
" \ 'subseparator': { 'left': '', 'right': '' },
" \ 'tabline_subseparator': { 'left': '', 'right': '' },
" \ 'tabline_separator':  { 'left': '', 'right': '' },
" \ 'separator': { 'left': '▓░', 'right': '░▓' },
" \ 'subseparator': { 'left': '|', 'right': '|' },
" \ 'tabline_subseparator': { 'left': '', 'right': '' },
" \ 'tabline_separator':  { 'left': '▓░', 'right': '░▓' },

let g:lightline.active = {
    \ 'left': [ [ 'mode', 'paste' ], [ 'filename' ] ],
    \ 'right': [
    \     [ 'lineinfo' ],
    \     [  ],
    \     [ 'filetype' ],
    \     [ 'linter_infos', 'linter_warnings', 'linter_errors', ],
    \ ]
    \ }

    " \ 'right': [ [ 'lineinfo' ] ]
let g:lightline.inactive = {
    \ 'left': [ [ 'filename' ] ],
    \ 'right': []
    \ }

let g:lightline.tab = {
    \ 'active': ['tabnum'],
    \ 'inactive': ['tabnum']
    \ }

let g:lightline.tabline = {
    \ 'left': [ ['buffers'] ],
    \ 'right': [ ['tabs'] ]
    \ }

let g:lightline.component = {
    \ 'lineinfo': '%3l:%-2v / %L',
    \ 'maxlines': '%L',
    \ }

" \ 'linter_checking': 'lightline#ale#checking',
" \ 'linter_ok': 'lightline#ale#ok',
" \ 'linter_infos': 'lightline#ale#infos',
" \ 'linter_warnings': 'lightline#ale#warnings',
" \ 'linter_errors': 'lightline#ale#errors',
let g:lightline.component_expand = {
    \ 'linter_infos': 'LightlineDiagnosticsInfo',
    \ 'linter_warnings': 'LightlineDiagnosticsWarning',
    \ 'linter_errors': 'LightlineDiagnosticsError',
    \ 'buffers': 'lightline#bufferline#buffers',
    \ }

let g:lightline.component_function = {
    \ 'fugitive': 'LightLineFugitive',
    \ 'filename': 'LightLineFilename',
    \ 'fileformat': 'LightLineFileFormat',
    \ 'fileencoding': 'LightLineFileEnc',
    \ 'filetype': 'LightLineFileType',
    \ 'customlineinfo': 'LightLineLineInfo'
    \ }

let g:lightline.component_visible_condition = {
    \ }

let g:lightline.component_type = {
    \ 'linter_infos': 'info',
    \ 'linter_warnings': 'warning',
    \ 'linter_errors': 'error',
    \ 'buffers': 'tabsel',
    \ }

" \ 'linter_checking': 'info',
" \ 'linter_ok': 'info',
" lightline }}}


" lightline functions {{{
function! LightLineLineInfo()
    return col('.') . ':' . line('.') . '/' . line('$')
endfunction

function! LightLineFileFormat()
    return winwidth(0) > 85 ? &fileformat : ''
endfunction

function! LightLineFileEnc()
    " return !strlen(SyntasticStatuslineFlag()) && winwidth(0) > 80 ? strlen(&fenc) ? &fenc : &enc : ''
    return winwidth(0) > 80 ? strlen(&fenc) ? &fenc : &enc : ''
endfunction

function! LightLineFileType()
    " return !strlen(SyntasticStatuslineFlag()) && winwidth(0) > 80 ? strlen(&filetype) ? &filetype : 'unknown' : ''
    return winwidth(0) > 80 ? strlen(&filetype) ? &filetype : 'unknown' : ''
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


function! LightlineUpdateDiagnostics()
    let l:info = { 'error': 0, 'warning': 0, 'info': 0 }

    " coc
    let l:cocinfo = get(b:, 'coc_diagnostic_info', {})
    if !empty(cocinfo)
        let l:info.error   += get(cocinfo, 'error', 0)
        let l:info.warning += get(cocinfo, 'warning', 0)
        let l:info.info    += get(cocinfo, 'information', 0) + get(cocinfo, 'hint', 0)
    endif

    " ale
    if get(g:, 'ale_enabled', 0) == 1
        let l:aleinfo = ale#statusline#Count(bufnr(''))
        let l:info.error   += get(aleinfo, 'error', 0)   + get(aleinfo, 'style_error', 0)
        let l:info.warning += get(aleinfo, 'warning', 0) + get(aleinfo, 'style_warning', 0)
        let l:info.info    += get(aleinfo, 'info', 0)
    endif

    " ycm
    if exists('*youcompleteme#GetWarningCount')
        let l:info.error += youcompleteme#GetErrorCount()
        let l:info.warning += youcompleteme#GetWarningCount()
    endif

    " store in buffer variable
    let b:_lightline_diagnostic_info = l:info
    call lightline#update()
endfun

augroup lightline_diagnostics
    autocmd!
    " autocmd User ALEJobStarted call LightlineUpdateDiagnostics()
    autocmd User ALELintPost call LightlineUpdateDiagnostics()
    autocmd User ALEFixPost call LightlineUpdateDiagnostics()
    autocmd User CocDiagnosticChange call LightlineUpdateDiagnostics()
    autocmd InsertLeave * call LightlineUpdateDiagnostics()
augroup END

function! LightlineGetDiagnostics(name)
    if !exists('b:_lightline_diagnostic_info')
        return ''
    endif
    let l:count = get(b:_lightline_diagnostic_info, a:name, 0)
    return l:count == 0 ? '' : get(s:diagnostic_symbols, a:name, '') .  string(l:count)
endfun

function! LightlineDiagnosticsError()
    return LightlineGetDiagnostics('error')
endfun

function! LightlineDiagnosticsWarning()
    return LightlineGetDiagnostics('warning')
endfun

function! LightlineDiagnosticsInfo()
    return LightlineGetDiagnostics('info')
endfun

" lightline functions }}}
