function ApplyCommonStylePre()
    set guifont="Terminus"

    augroup AutocmdCommonStylesPre
        autocmd!
        autocmd VimEnter * call s:EarlyStyleOverrides()
        autocmd ColorScheme * call s:EarlyStyleOverrides()
    augroup END

    call s:EarlyStyleOverrides()
endfun

function! s:EarlyStyleOverrides()
    highlight link cppStorageClass Keyword
    " highlight link cTypedef Keyword
endfun

function ApplyCommonStyle()
endfun
