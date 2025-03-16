augroup omnisharp_commands
    autocmd!

    " Show type information automatically when the cursor stops moving.
    " Note that the type is echoed to the Vim command line, and will overwrite
    " any other messages in this space including e.g. ALE linting messages.
    " autocmd CursorHold *.cs OmniSharpTypeLookup

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nmap <silent> <buffer> <leader>jd <Plug>(omnisharp_go_to_definition)
    autocmd FileType cs nmap <silent> <buffer> <Leader>jr <Plug>(omnisharp_find_usages)
    autocmd FileType cs nmap <silent> <buffer> <Leader>jD <Plug>(omnisharp_find_implementations)
    " autocmd FileType cs nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
    " autocmd FileType cs nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
    autocmd FileType cs nmap <silent> <buffer> <Leader>gt <Plug>(omnisharp_type_lookup)
    autocmd FileType cs nmap <silent> <buffer> K <Plug>(omnisharp_documentation)
    " autocmd FileType cs nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
    autocmd FileType cs nmap <silent> <buffer> <Leader>fx <Plug>(omnisharp_fix_usings)
    autocmd FileType cs nmap <silent> <buffer> <Leader>gi <Plug>(omnisharp_signature_help)
    autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

    " Navigate up and down by method/property/field
    " autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
    " autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
    " Find all code errors/warnings for the current solution and populate the quickfix window
    " autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
    " Contextual code actions (uses fzf, CtrlP or unite.vim selector when available)
    autocmd FileType cs nmap <silent> <buffer> <Leader>ac <Plug>(omnisharp_code_actions)
    autocmd FileType cs xmap <silent> <buffer> <Leader>ac <Plug>(omnisharp_code_actions)
    " Repeat the last code action performed (does not use a selector)
    " autocmd FileType cs nmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)
    " autocmd FileType cs xmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)

    autocmd FileType cs nmap <silent> <buffer> <Leader>fa <Plug>(omnisharp_code_format)

    autocmd FileType cs nmap <silent> <buffer> <Leader>rn <Plug>(omnisharp_rename)

    " autocmd FileType cs nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
    " autocmd FileType cs nmap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)
    " autocmd FileType cs nmap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)
augroup END
