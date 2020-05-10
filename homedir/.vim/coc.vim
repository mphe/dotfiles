" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
" set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
" set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> <leader>jr <Plug>(coc-references)

nmap <silent> <leader>jd <Plug>(coc-definition)
nmap <silent> <leader>jD <Plug>(coc-implementation)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>fa  <Plug>(coc-format-selected)
nmap <leader>fa  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>fx  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" <tab> == <c-i>
" nmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
" nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>c  :<C-u>CocList commands<cr>
" Find symbol of current document
" nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
" nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
    execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

nmap <leader>gd <Plug>(coc-diagnostic-info)
nmap <leader>L <Plug>(coc-openlink)

nnoremap <leader>gi :call CocActionAsync('showSignatureHelp')<esc>

inoremap <silent> <expr> <c-e> coc#util#has_float() ? ToggleExpandFloat(0) : "\<c-e>"
nnoremap <silent> <expr> <c-e> coc#util#has_float() ? ToggleExpandFloat(1) : "\<c-e>"

inoremap <silent> <expr> <c-f> coc#util#has_float() ? FloatScrollMultiple(1) : "\<c-f>"
inoremap <silent> <expr> <c-b> coc#util#has_float() ? FloatScrollMultiple(0) :  "\<c-b>"
nnoremap <expr> <C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
nnoremap <expr> <C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"


" TODO: include word wrap
function! ToggleExpandFloat(normal) abort
    let retval = a:normal ? "\<esc>" : ''
    let float = coc#util#get_float()
    if !float | return '' | endif
    let buf = nvim_win_get_buf(float)

    let buf_height = nvim_buf_line_count(buf)
    let win_height = nvim_win_get_height(float)
    let b:last_expand_height = get(b:, 'last_expand_height', win_height)

    if buf_height == win_height && b:last_expand_height < win_height
        call nvim_win_set_height(float, b:last_expand_height)
        return retval
    endif

    if buf_height <= win_height | return '' | endif
    let b:last_expand_height = win_height
    call nvim_win_set_height(float, buf_height)
    return retval
endfun

" https://gitter.im/neoclide/coc.nvim?at=5e013bebc0c8ef301b01ff69
function! FloatScroll(forward) abort
    let float = coc#util#get_float()
    if !float | return '' | endif
    let buf = nvim_win_get_buf(float)
    let buf_height = nvim_buf_line_count(buf)
    let win_height = nvim_win_get_height(float)
    if buf_height < win_height | return '' | endif
    let pos = nvim_win_get_cursor(float)
    if a:forward
        if pos[0] == 1
            let pos[0] += 3 * win_height / 4
        elseif pos[0] + win_height / 2 + 1 < buf_height
            let pos[0] += win_height / 2 + 1
        else
            let pos[0] = buf_height
        endif
    else
        if pos[0] == buf_height
            let pos[0] -= 3 * win_height / 4
        elseif pos[0] - win_height / 2 + 1  > 1
            let pos[0] -= win_height / 2 + 1
        else
            let pos[0] = 1
        endif
    endif
    call nvim_win_set_cursor(float, pos)
    return ''
endfunction

function FloatScrollMultiple(down)
    call FloatScroll(a:down)
    return FloatScroll(a:down)
endfun
