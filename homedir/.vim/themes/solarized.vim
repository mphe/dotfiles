" ------------------ General
set t_Co=256
set background=dark
set guifont="xos4 Terminus"

" ------------------ Solarized
" let g:solarized_termtrans = 1
" let g:solarized_hitrail = 1

if &term == 'xterm-termite'
    let g:solarized_termcolors=256
endif

if has('nvim')
"     let g:neosolarized_contrast = 'normal'
"     let g:neosolarized_visibility = 'normal'
"     let g:neosolarized_bold = 1
"     let g:neosolarized_underline = 1
"     let g:neosolarized_italic = 1

    set termguicolors
    " colorscheme NeoSolarized
    colorscheme flattened_dark
else
    " colorscheme solarized8_flat
    colorscheme solarized
    " colorscheme flattened_dark
endif

" Search highlight color
highlight Search cterm=NONE ctermbg=240 ctermfg=black gui=NONE guibg=#586e75 guifg=#073642
highlight link EasyMotionMoveHL Search
" highlight link Search EasyMotionMoveHL
" highlight Search cterm=bold,reverse ctermfg=40 gui=bold,reverse guifg=#7fbf00

" Cursorline
set cursorline
highlight CursorLine ctermbg=Black cterm=NONE gui=NONE
highlight CursorLineNr cterm=bold ctermfg=3 ctermbg=black gui=bold guifg=#b58900 guibg=#073642

" No underline in folds
highlight Folded cterm=bold

highlight SignColumn cterm=bold ctermbg=black gui=bold guibg=#073642
highlight Error   cterm=underline ctermfg=1 ctermbg=NONE gui=underline guifg=#dc322f guibg=NONE
highlight link SpellBad Error
highlight Normal     ctermbg=NONE guibg=NONE
highlight PmenuSbar  ctermfg=12 ctermbg=0
highlight Pmenu      cterm=NONE ctermbg=17 ctermfg=251 gui=NONE guibg=#094655 guifg=#C6C6C6
highlight VertSplit  ctermbg=0 guibg=#073642
highlight Comment cterm=NONE gui=NONE

" coc
highlight CocErrorSign   cterm=bold ctermbg=black ctermfg=9   gui=bold guibg=#073642 guifg=#cb4b16
highlight CocWarningSign cterm=bold ctermbg=black ctermfg=130 gui=bold guibg=#073642 guifg=#b58900
highlight CocInfoSign    cterm=bold ctermbg=black ctermfg=11  gui=bold guibg=#073642
highlight link CocHintSign CocInfoSign
highlight CocErrorFloat   cterm=NONE ctermbg=black ctermfg=9   gui=NONE guibg=#094655 guifg=#cb4b16
highlight CocWarningFloat cterm=NONE ctermbg=black ctermfg=130 gui=NONE guibg=#094655 guifg=#b58900
highlight CocInfoFloat    cterm=NONE ctermbg=black ctermfg=11  gui=NONE guibg=#094655
highlight link CocHintFloat CocInfoFloat

highlight CocUnderline cterm=underline gui=underline
highlight CocErrorLine ctermbg=52 guibg=#5F0000
highlight link CocErrorHighlight Error

" ale
highlight link ALEError CocErrorHighlight
highlight link ALEErrorLine CocErrorLine
highlight link ALEErrorSign CocErrorSign
highlight link ALEWarningSign CocWarningSign
highlight link ALEInfoSign CocInfoSign

" ycm
highlight link YcmWarningSign CocWarningSign
highlight link YcmErrorSign CocErrorSign
highlight link YcmErrorSection CocErrorHighlight
highlight link YcmErrorLine CocErrorLine


highlight link SyntasticErrorLine ALEErrorLine

" Add this line at the start of the python syntax file
" syn match pythonFunctionCall "\zs\(\k\w*\)*\s*\ze("
highlight link pythonFunctionCall cUserFunction

highlight CurrentWordTwins ctermbg=black guibg=#094655
highlight link CurrentWord CurrentWordTwins


highlight fugitiveUnstagedSection ctermfg=red guifg=#dc322f
highlight link fugitiveUntrackedSection fugitiveUnstagedSection
highlight fugitiveStagedSection ctermfg=green guifg=#859900

highlight link cStorageClass cStatement
highlight link cppModifier cStatement
highlight link cppStructure cStatement
highlight link cModifier cStatement
highlight link cStructure cStatement

" vim-cpp-modern
" highlight cUserFunction ctermfg=13 guifg=#6C71C4
highlight link cUserFunction Function

" vim-lsp-cxx colors
hi link LspCxxHlGroupEnumConstant Normal
hi LspCxxHlGroupNamespace  ctermfg=13 guifg=#6C71C4
hi link LspCxxHlGroupMemberVariable Normal
hi link LspCxxHlSymTypeParameter Normal

" hi link LspCxxHlSymFunction cUserFunction
hi link LspCxxHlSymFunction Function
hi link LspCxxHlSymMethod LspCxxHlSymFunction
hi link LspCxxHlSymClassFunction LspCxxHlSymFunction
hi link LspCxxHlSymClassMethod LspCxxHlSymFunction
hi link LspCxxHlSymStructMethod LspCxxHlSymFunction
hi link LspCxxHlSymStaticMethod LspCxxHlSymFunction
hi link LspCxxHlSymConstructor LspCxxHlSymFunction

" hi link LspCxxHlSymClass Function
hi link LspCxxHlSymClass Type
hi link LspCxxHlSymStruct LspCxxHlSymClass
hi link LspCxxHlSymEnum LspCxxHlSymClass
hi link LspCxxHlSymTypeAlias LspCxxHlSymClass

hi link LspCxxHlSymConstant Constant
hi link LspCxxHlSymParameterConstant Constant
hi link LspCxxHlSymParameterString Constant
" hi link LspCxxHlGroupConstant Constant
" hi link LspCxxHlGroupEnumConstant Constant

" hi link AutoType Type
" hi link Namespace cUserFunction

" https://vi.stackexchange.com/questions/16813/avoid-highlighting-defined-by-matchadd-in-comments
function! s:CSyntaxFixes()
    let l:commentassert = '\(\/\/.*\|\/\*.*\)\@<!'
    " let l:commentassertahead = '\(.*\*\/\)\@=!'
    call matchadd('cString', l:commentassert . '".\{-}"')
    " . l:commentassertahead)
    " call matchadd('Function', l:commentassert . '~.\{-}(\@=')
    " . l:commentassertahead)
endfun

augroup SyntaxFix
autocmd FileType c,cpp call s:CSyntaxFixes()
augroup END

" base03  = #002b36
" base02  = #073642
" base01  = #586e75
" base00  = #657b83
" base0   = #839496
" base1   = #93a1a1
" base2   = #eee8d5
" base3   = #fdf6e3
" yellow  = #b58900
" orange  = #cb4b16
" red     = #dc322f
" magenta = #d33682
" violet  = #6c71c4
" blue    = #268bd2
" cyan    = #2aa198
" green   = #859900
" blue3   = #094655
" pum fg  = #C6C6C6
