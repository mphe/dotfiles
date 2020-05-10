set completeopt-=preview
" set noshowmode

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

function! s:FindPreviewWindow()
    for nr in range(1, winnr('$'))
        if getwinvar(nr, '&pvw') == 1
            return nr
        endif
    endfor
    return -1
endfun

function! s:SetPreviewString(text)
    let current = winnr()
    let nr = s:FindPreviewWindow()
    if nr != -1
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
endfun

function! s:OnCompleteDone()
    let item = v:completed_item
    " echo get(item, 'kind', '')
    " let kind = get(item, 'kind', '')
    " if (kind ==# 'f' || kind ==# 'c') && len(item.info) > 0
    if has_key(item, 'info') && len(item.info) > 0
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
" inoremap <expr> <return> pumvisible() ? echo GetCompletionString() : '\<return>'



" simplify preview window
function! SetPreviewVariables()
    setlocal wrap 
    setlocal breakindentopt=shift:4
    setlocal laststatus=0 
    setlocal nobuflisted 
    setlocal nocursorline 
    setlocal nonumber 
    " setlocal statusline=''
    " normal ggjjzt
    " exec 'setlocal winheight='.&previewheight
endfun

function! ResetStatusLine()
    let buf = expand('<abuf>')
    if winbufnr(s:FindPreviewWindow()) == buf
        set laststatus=2
    endif
endfun

autocmd BufEnter * if &previewwindow | call SetPreviewVariables() | endif
autocmd BufWipeout * call ResetStatusLine()


" function OpenPreview()
"     " if pumvisible()
"         call feedkeys("\<c-p>")
"         set completeopt+=preview
"         call feedkeys("\<c-n>")
"         set completeopt-=preview
"     " endif
" endfunction

function! TogglePreview(on)
    if a:on
        setlocal completeopt+=preview
    else
        setlocal completeopt-=preview
    endif
    return ''
endfunction

" Open the preview window only when accepting a completion candidate
" Reduces lag when cycling through completions
autocmd FileType c,cpp,python,java
    \ imap     <expr>  <CR> pumvisible() ? "\<c-p>\<c-r>=TogglePreview(1)\<CR>\<c-n>\<c-r>=TogglePreview(0)\<CR>" : "<Plug>delimitMateCR"

    " \ imap     <expr>  <CR> pumvisible() ? "\<c-r>=OpenPreview()\<CR>" : "<Plug>delimitMateCR"
    " \ imap     <expr>  <CR> pumvisible() ? "\<c-p>\<c-r>=TogglePreview(1)\<CR>\<c-n>\<c-y>\<c-r>=TogglePreview(0)\<CR>" : "<Plug>delimitMateCR"
    " \ inoremap <expr> <c-y> pumvisible() ? "\<c-p>\<c-r>=TogglePreview(1)\<CR>\<c-n>\<c-y>\<c-r>=TogglePreview(0)\<CR>" : "\<c-y>"|
    " \ inoremap <expr> <c-l> pumvisible() ? "\<c-p>\<c-r>=TogglePreview(1)\<CR>\<c-n>\<c-r>=TogglePreview(0)\<CR>" : "\<c-l>"

autocmd InsertLeave * set completeopt-=preview
