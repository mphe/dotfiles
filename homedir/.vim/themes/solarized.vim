" ------------------ General
set t_Co=256
set background=dark

let s:transparent_background = 0

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

let s:base4   = '#a3b1b1'
let s:pum_fg  = '#C6C6C6'
let s:pum_bg = s:blue3

" Actually not normal fg and bg but the slightly brighter variant.
" TODO: rename
let s:normal_fg = s:base0
let s:normal_bg = s:base02

function ApplySolarizedStylePre()
    augroup BarBarStyles
        autocmd!
        autocmd VimEnter * call s:EarlyStyleOverrides()
        autocmd ColorScheme * call s:EarlyStyleOverrides()
    augroup END

    call s:EarlyStyleOverrides()
endfun

function ApplySolarizedStyle()
    if has('nvim')
        set termguicolors
    endif

    colorscheme solarized

    exec 'highlight NormalBgFg gui=NONE guibg=' . s:base03 . ' guifg=' . s:base1
    exec 'highlight BrighterBgFg gui=NONE guibg=' . s:base02 . ' guifg=' . s:base4
    exec 'highlight BrightBgFg guibg=' . s:pum_bg . ' guifg=' . s:pum_fg
    exec 'highlight BlueFg guifg=' s:blue
    exec 'highlight VioletFg guifg=' s:violet
    exec 'highlight MagentaFg guifg=' s:magenta

    augroup SyntaxFix
        autocmd!
        autocmd FileType c,cpp call s:CSyntaxFixes()
        autocmd FileType scala call s:ScalaSyntaxFixes()
        autocmd FileType markdown call s:MarkdownStyles()
        " autocmd VimEnter * call s:EarlyStyleOverrides()
        " autocmd ColorScheme * call s:EarlyStyleOverrides()
    augroup END

    " make comments non-italic
    highlight Comment cterm=NONE gui=NONE

    " treesitter (also used by coc implicitly) {{{
    hi link @module VioletFg
    hi link @keyword.storage @keyword
    hi link @comment Comment

    " gdscript
    hi link @attribute.gdscript Keyword
    hi link @string.special.url.gdscript Macro  " $ or % node paths

    " }}}

    " Search highlight color
    highlight Search cterm=NONE ctermbg=240 ctermfg=black gui=NONE guibg=#586e75 guifg=#073642
    highlight! link CurSearch Search
    highlight link EasyMotionMoveHL Search
    " highlight link Search EasyMotionMoveHL
    " highlight Search cterm=bold,reverse ctermfg=40 gui=bold,reverse guifg=#7fbf00

    " Cursorline
    set cursorline
    highlight CursorLine ctermbg=Black cterm=NONE gui=NONE
    highlight CursorLineNr cterm=bold ctermfg=3 ctermbg=black gui=bold guifg=#b58900 guibg=#073642

    " No underline in folds
    highlight Folded cterm=bold gui=bold

    highlight SignColumn cterm=bold ctermbg=black gui=bold guibg=#073642
    highlight! link StatusLineNC SignColumn
    highlight link WinSeparator LineNr

    highlight clear Error
    exec 'highlight Error cterm=undercurl ctermfg=1 gui=undercurl guisp=' . s:red
    highlight link SpellBad Error
    highlight DiagnosticUnderlineInfo gui=undercurl
    highlight DiagnosticUnderlineWarn gui=undercurl
    highlight DiagnosticUnderlineError gui=undercurl

    if s:transparent_background
        highlight Normal     ctermbg=NONE guibg=NONE
    endif

    highlight PmenuSbar  ctermfg=12 ctermbg=0
    hi! link Pmenu BrightBgFg
    highlight VertSplit  ctermbg=0 guibg=#073642
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
    " hi link CocMenuSel PmenuSel
    " hi link CocFloating Pmenu
    hi link CocMenuSel BrightBgFg
    hi link CocFloating NormalBgFg
    " hi link CocFloating BrighterBgFg
    exec 'highlight CocFloatingBorder guifg=' . s:blue

    highlight CocUnderline cterm=underline gui=underline
    " highlight CocErrorLine ctermbg=52 guibg=#4F2938
    " highlight link CocErrorHighlight Error
    highlight CocCodeLens guibg=#073642 guifg=#6C71C4
    highlight! link CocInlayHint CocCodeLens

    highlight link CocInlayHintType Comment
    " exec 'highlight CocInlayHintType guifg=' . s:yellow . ' guibg=#333333'
    " exec 'highlight CocInlayHintType guifg=' . s:base01 . ' guibg=' . s:normal_bg
    " exec 'highlight CocInlayHintType guifg=' . s:yellow . ' guibg=' . s:pum_bg
    " exec 'highlight CocInlayHintType guibg=' . s:normal_bg

    highlight link DiagnosticVirtualTextError CocErrorSign
    highlight link DiagnosticVirtualTextWarn CocWarningSign
    highlight link DiagnosticVirtualTextInfo CocInfoSign
    highlight link DiagnosticVirtualTextHint CocHintSign

    hi link CocSemType CocSemTypeType
    hi link CocSemTypeStruct CocSemTypeType
    hi link CocSemTypeEnumMember @constant
    hi link CocSemTypeModVariableReadonly @constant
    hi link CocSemTypeEvent @property

    " ale
    highlight! link ALEError CocErrorHighlight
    highlight! link ALEErrorLine CocErrorLine
    highlight! link ALEErrorSign CocErrorSign
    highlight! link ALEWarning CocWarningHighlight
    highlight! link ALEWarningLine CocWarningLine
    highlight! link ALEWarningSign CocWarningSign
    highlight! link ALEInfo CocInfoHighlight
    highlight! link ALEInfoLine CocInfoLine
    highlight! link ALEInfoSign CocInfoSign

    highlight! link ALEVirtualTextError ALEErrorSign
    highlight! link ALEVirtualTextWarning ALEWarningSign
    highlight! link ALEVirtualTextInfo ALEInfoSign

    " ycm
    highlight link YcmWarningSign CocWarningSign
    highlight link YcmErrorSign CocErrorSign
    highlight link YcmErrorSection CocErrorHighlight
    highlight link YcmErrorLine CocErrorLine

    " Add this line at the start of the python syntax file
    " syn match pythonFunctionCall "\zs\(\k\w*\)*\s*\ze("
    highlight link pythonFunctionCall Function

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

    hi texStatement ctermbg=NONE guibg=NONE
    exec 'highlight VirtColumn guifg=' . s:normal_bg . ' guibg=NONE'

    " tagbar
    hi link TagbarAccessProtected BlueFg
endfun


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

function! s:MarkdownStyles()
    " These styles also affect the hover popup, hence only apply it when actually editing a markdown file
    " hi! link markdownCode CocCodeLens
    " hi! link markdownCode CurrentWord
    " exec 'highlight markdownCode guibg=' . s:blue3  . ' guifg=' . s:pum_fg
    " exec 'highlight markdownCode guibg=' . s:base02  . ' guifg=' . s:pum_fg
    " exec 'highlight markdownCode guibg=' . s:base02
    highlight markdownCode guibg=#223344
    " hi! link markdownCodeBlock markdownCode
endfun

function! s:EarlyStyleOverrides()
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
    exec 'highlight BufferCurrentIcon       guibg=' . current_bg  . ' guifg=' . current_fg
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

    " highlight BufferCurrent
    " highlight BufferCurrentADDED
    " highlight BufferCurrentBtn
    " highlight BufferCurrentCHANGED
    " highlight BufferCurrentDELETED
    " highlight BufferCurrentERROR
    " highlight BufferCurrentHINT
    " highlight BufferCurrentINFO
    " highlight BufferCurrentIcon
    " highlight BufferCurrentIndex
    " highlight BufferCurrentMod
    " highlight BufferCurrentModBtn
    " highlight BufferCurrentNumber
    " highlight BufferCurrentPin
    " highlight BufferCurrentPinBtn
    " highlight BufferCurrentSign
    " highlight BufferCurrentSignRight
    " highlight BufferCurrentTarget
    " highlight BufferCurrentWARN
endfun



