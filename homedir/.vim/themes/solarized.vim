" ------------------ General
set t_Co=256
set background=dark
set guifont="Terminus"


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

let s:base03  = '#002b36'
let s:base02  = '#073642'
let s:base01  = '#586e75'
let s:base00  = '#657b83'
let s:base0   = '#839496'
let s:base1   = '#93a1a1'
let s:base2   = '#eee8d5'
let s:base3   = '#fdf6e3'
let s:yellow  = '#b58900'
let s:orange  = '#cb4b16'
let s:red     = '#dc322f'
let s:magenta = '#d33682'
let s:violet  = '#6c71c4'
let s:blue    = '#268bd2'
let s:cyan    = '#2aa198'
let s:green   = '#859900'
let s:blue3   = '#094655'

let s:pum_fg  = '#C6C6C6'
let s:pum_bg = s:blue3

let s:normal_fg = s:base0
let s:normal_bg = s:base02

function s:hl(group, colordict)
    exec 'highlight ' . a:group . ' ' . join(values(map(copy(a:colordict), 'v:key . "=" .. v:val')), ' ')
endfunction

" ------------------ Solarized
" let g:solarized_termtrans = 1
" let g:solarized_hitrail = 1

if &term ==? 'xterm-termite'
    let g:solarized_termcolors=256
endif

augroup SyntaxFix
autocmd FileType c,cpp call s:CSyntaxFixes()
autocmd FileType scala call s:ScalaSyntaxFixes()
autocmd VimEnter * call s:StyleOverrides()
autocmd ColorScheme * call s:StyleOverrides()
augroup END

" https://vi.stackexchange.com/questions/16813/avoid-highlighting-defined-by-matchadd-in-comments
function! s:CSyntaxFixes()
    " let l:commentassert = '\(\/\/.*\|\/\*.*\)\@<!'
    " call matchadd('cString', l:commentassert . '".\{-}"')
    hi doxygenBrief ctermfg=10 guifg=#586e75 gui=italic cterm=italic
    hi link doxygenStart doxygenBrief
    hi link doxygenComment doxygenBrief
    hi link doxygenContinueComment doxygenBrief
endfun

function! s:ScalaSyntaxFixes()
    highlight! link scalaSquareBracketsBrackets Normal
    highlight! link scalaInstanceDeclaration Type
    highlight! link scalaCapitalWord Type
    highlight! link scalaCapitalWord Function
    highlight! link scalaKeywordModifier Keyword
    highlight! CocErrorLine ctermbg=NONE guibg=NONE
    highlight! ALEWarning cterm=NONE gui=NONE

    " Add this line at the start of the python syntax file
    syn match scalaFunctionCall "\zs\(\k\w*\)*\s*\ze("
    highlight link scalaFunctionCall Function
endfun

function! s:StyleOverrides()
    call s:ApplyBarBar()
endfun

function s:ApplyBarBar()
    " darker background for active buffers
    " let current_bg = s:normal_bg
    " let current_fg = s:pum_fg
    " let visible_bg = current_bg
    " let visible_fg = s:normal_fg
    " let inactive_bg = s:blue3
    " let inactive_fg = visible_fg
    " let bufferline_bg = s:base03

    " brighter background for active buffers
    let current_bg = s:blue3
    let current_fg = s:pum_fg
    let inactive_bg = s:normal_bg
    let inactive_fg = s:normal_fg
    let visible_bg = inactive_bg
    let visible_fg = current_fg
    let bufferline_bg = s:base03
    let modif_fg = s:red

    exec 'highlight BufferCurrent           guibg=' . current_bg  . ' guifg=' . current_fg
    exec 'highlight BufferCurrentMod        guibg=' . current_bg  . ' guifg=' . modif_fg
    exec 'highlight BufferCurrentSign       guibg=' . current_bg  . ' guifg=' . bufferline_bg
    exec 'highlight BufferInactive          guibg=' . inactive_bg . ' guifg=' . inactive_fg
    exec 'highlight BufferInactiveSign      guibg=' . inactive_bg . ' guifg=' . bufferline_bg
    exec 'highlight BufferInactiveMod       guibg=' . inactive_bg . ' guifg=' . modif_fg
    exec 'highlight BufferVisible           guibg=' . visible_bg  . ' guifg=' . visible_fg
    exec 'highlight BufferVisibleSign       guibg=' . visible_bg  . ' guifg=' . bufferline_bg
    exec 'highlight BufferVisibleMod        guibg=' . visible_bg  . ' guifg=' . modif_fg
    exec 'highlight BufferTabpageFill       guibg=' . bufferline_bg . ' guifg=' . bufferline_bg

    " powerline
    exec 'highlight BufferCurrentSignRight  guibg=' . bufferline_bg . ' guifg=' . current_bg
    exec 'highlight BufferInactiveSignRight guibg=' . bufferline_bg . ' guifg=' . inactive_bg
    exec 'highlight BufferVisibleSignRight  guibg=' . bufferline_bg . ' guifg=' . visible_bg

    " slanted
    " exec 'highlight BufferCurrentSignRight  guibg=' . current_bg  . ' guifg=' . bufferline_bg
    " exec 'highlight BufferInactiveSignRight guibg=' . inactive_bg . ' guifg=' . bufferline_bg
endfun


if has('nvim')
    set termguicolors
    colorscheme flattened_dark
else
    colorscheme solarized
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
highlight! link StatusLineNC SignColumn
highlight Error   cterm=underline ctermfg=1 ctermbg=NONE gui=underline guifg=#dc322f guibg=NONE
highlight link SpellBad Error
highlight Normal     ctermbg=NONE guibg=NONE
highlight PmenuSbar  ctermfg=12 ctermbg=0
highlight Pmenu      cterm=NONE ctermbg=17 ctermfg=251 gui=NONE guibg=#094655 guifg=#C6C6C6
highlight VertSplit  ctermbg=0 guibg=#073642
highlight Comment cterm=NONE gui=NONE
highlight! link QuickFixLine CursorLine

" coc
highlight CocErrorSign   cterm=bold ctermbg=black ctermfg=9   gui=bold guibg=#073642 guifg=#cb4b16
highlight CocWarningSign cterm=bold ctermbg=black ctermfg=130 gui=bold guibg=#073642 guifg=#b58900
highlight CocInfoSign    cterm=bold ctermbg=black ctermfg=11  gui=bold guibg=#073642
highlight link CocHintSign CocInfoSign
highlight CocErrorFloat   cterm=NONE ctermbg=black ctermfg=9   gui=NONE guibg=#094655 guifg=#cb4b16
highlight CocWarningFloat cterm=NONE ctermbg=black ctermfg=130 gui=NONE guibg=#094655 guifg=#b58900
highlight CocInfoFloat    cterm=NONE ctermbg=black ctermfg=11  gui=NONE guibg=#094655
highlight link CocHintFloat CocInfoFloat
" highlight link NormalFloat CursorLine
highlight link CocFadeOut Comment

" fix completion menu colors
hi link CocMenuSel PmenuSel
hi link CocFloating Pmenu

highlight CocUnderline cterm=underline gui=underline
" highlight CocErrorLine ctermbg=52 guibg=#5F0000
highlight CocErrorLine ctermbg=52 guibg=#4F2938
highlight link CocErrorHighlight Error
highlight CocCodeLens guibg=#073642 guifg=#6C71C4
highlight! link CocInlayHint CocCodeLens

highlight link DiagnosticVirtualTextError CocErrorSign
highlight link DiagnosticVirtualTextWarn CocWarningSign
highlight link DiagnosticVirtualTextInfo CocInfoSign
highlight link DiagnosticVirtualTextHint CocHintSign

" ale
highlight link ALEError CocErrorHighlight
highlight link ALEErrorLine CocErrorLine
highlight link ALEErrorSign CocErrorSign
highlight link ALEWarningSign CocWarningSign
highlight link ALEInfoSign CocInfoSign

highlight link ALEVirtualTextError ALEErrorSign
highlight link ALEVirtualTextWarning ALEWarningSign
highlight link ALEVirtualTextInfo ALEInfoSign

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

hi link CocSemNamespace LspCxxHlGroupNamespace
hi link CocSemType Type
hi link CocSemClass LspCxxHlSymClass
hi link CocSemEnum LspCxxHlSymEnum
hi link CocSemInterface Type
hi link CocSemStruct LspCxxHlSymStruct
hi link CocSemTypeParameter LspCxxHlSymTypeParameter
hi link CocSemParameter Normal
hi link CocSemVariable LspCxxHlGroupMemberVariable
hi link CocSemProperty LspCxxHlGroupMemberVariable
hi link CocSemEnumMember LspCxxHlGroupEnumConstant
hi link CocSemEvent Identifier
hi link CocSemFunction LspCxxHlSymFunction
hi link CocSemMethod LspCxxHlSymClassMethod
hi link CocSemMacro Macro
hi link CocSemKeyword Keyword
hi link CocSemModifier Statement
hi link CocSemComment Comment
hi link CocSemString String
hi link CocSemNumber Number
hi link CocSemRegexp Normal
hi link CocSemOperator Operator

hi texStatement ctermbg=NONE guibg=NONE
exec 'highlight VirtColumn guifg=' . s:normal_bg . ' guibg=NONE'
