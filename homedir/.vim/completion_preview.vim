set completeopt+=preview

let s:compl_buffer = []
let s:compl_index = -1
let s:compl_buffer_size = 5

function! EchoComplBuffer()
    echo s:compl_buffer
endfun

function! NextCompletionString()
    call s:IncCompletionString(1)
    return ''
endfun

function! PrevCompletionString()
    call s:IncCompletionString(len(s:compl_buffer) - 1)
    return ''
endfun

function! s:IncCompletionString(n)
    let s:compl_index = (s:compl_index + a:n) % len(s:compl_buffer)
    call s:SetPreviewString(s:GetCompletionString())
endfun

function! s:PushCompletion(text)
    if a:text ==# s:GetCompletionString()
        return
    endif

    let s:compl_index = (s:compl_index + 1) % s:compl_buffer_size
    if s:compl_index >= len(s:compl_buffer)
        call add(s:compl_buffer, a:text)
    else
        let s:compl_buffer[s:compl_index] = a:text
    endif
endfun

function! s:GetCompletionString()
    if len(s:compl_buffer) > 0
        return s:compl_buffer[s:compl_index]
    else
        return ''
    endif
endfun

function! s:SetPreviewString(text)
    let current = winnr()
    for nr in range(1, winnr('$'))
        if getwinvar(nr, "&pvw") == 1
            " found a preview
            silent execute nr.'wincmd w'
            setlocal modifiable
            silent normal! gg"_dG
            silent $put=a:text
            silent normal! 1G"_dd
            setlocal nomodifiable
            setlocal nomodified
            silent execute current.'wincmd w'
        endif
    endfor
endfun

function! s:OnCompleteDone()
    let item = v:completed_item
    if get(item, 'kind', '') ==# 'f' && len(item.info) > 0
        call s:PushCompletion(item.info)
    else
        call s:SetPreviewString(s:GetCompletionString())
    endif
    " echo v:completed_item
endfun

autocmd CompleteDone * call s:OnCompleteDone()


" we need <c-r>= syntax because <expr> doesn't allow buffer modification
inoremap <c-h> <c-r>=PrevCompletionString()<CR>
inoremap <c-l> <c-r>=NextCompletionString()<CR>
nnoremap <leader>pp :call PrevCompletionString()<CR>
nnoremap <leader>pn :call NextCompletionString()<CR>
