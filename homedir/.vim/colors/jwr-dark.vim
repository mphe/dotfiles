" pare Vim colorscheme
" Author: mohabaks
" Github: https://github.com/mohabaks/dotfiles/
" SpecialThanks: https://github.com/ggalindezb/Vim-Colorscheme-Template

" --------------------------------
set background=dark
" - or ---------------------------
"set background=light
" --------------------------------

highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="custom"

"----------------------------------------------------------------
" General settings                                              |
"----------------------------------------------------------------
"----------------------------------------------------------------
" Syntax group   | Foreground    | Background    | Style        |
"----------------------------------------------------------------

" --------------------------------
" Editor settings
" --------------------------------
hi Normal          ctermfg=none    ctermbg=none    cterm=none
hi Cursor          ctermfg=15      ctermbg=none    cterm=none
hi CursorLine      ctermfg=none    ctermbg=00      cterm=none
hi LineNr          ctermfg=08      ctermbg=00      cterm=none
hi CursorLineNR    ctermfg=02      ctermbg=00      cterm=none

" -----------------
" - Number column -
" -----------------
hi CursorColumn    ctermfg=01      ctermbg=00      cterm=none
hi FoldColumn      ctermfg=05      ctermbg=none    cterm=none
hi SignColumn      ctermfg=06      ctermbg=none    cterm=none
hi Folded          ctermfg=02      ctermbg=none    cterm=none

" -------------------------
" - Window/Tab delimiters - 
" -------------------------
hi VertSplit       ctermfg=08      ctermbg=00      cterm=none
hi ColorColumn     ctermfg=none    ctermbg=00      cterm=none
hi TabLine         ctermfg=none    ctermbg=00      cterm=none
hi TabLineFill     ctermfg=04      ctermbg=none    cterm=none
hi TabLineSel      ctermfg=05      ctermbg=none    cterm=none

" -------------------------------
" - File Navigation / Searching -
" -------------------------------
hi Directory       ctermfg=01      ctermbg=none    cterm=none
hi Search          ctermfg=03      ctermbg=00      cterm=none
hi IncSearch       ctermfg=15      ctermbg=10      cterm=none

" -----------------
" - Prompt/Status -
" -----------------
hi StatusLine      ctermfg=07      ctermbg=00      cterm=none
hi StatusLineNC    ctermfg=07      ctermbg=00      cterm=none
hi WildMenu        ctermfg=00      ctermbg=03      cterm=none
hi Question        ctermfg=02      ctermbg=00      cterm=none
hi Title           ctermfg=04      ctermbg=00      cterm=none
hi ModeMsg         ctermfg=09      ctermbg=00      cterm=none
hi MoreMsg         ctermfg=06      ctermbg=00      cterm=none

" --------------
" - Visual aid -
" --------------
hi MatchParen      ctermfg=10      ctermbg=00      cterm=none
hi Visual          ctermfg=08     ctermbg=00      cterm=none
hi VisualNOS       ctermfg=06      ctermbg=00      cterm=none
hi NonText         ctermfg=02      ctermbg=none    cterm=none

hi Todo            ctermfg=00      ctermbg=03      cterm=none
hi Underlined      ctermfg=06      ctermbg=none    cterm=none
hi Error           ctermfg=01      ctermbg=none    cterm=none
hi ErrorMsg        ctermfg=01      ctermbg=none    cterm=none
hi WarningMsg      ctermfg=09      ctermbg=none    cterm=none
hi Ignore          ctermfg=05      ctermbg=none    cterm=none
hi SpecialKey      ctermfg=06      ctermbg=none    cterm=none

" --------------------------------
" Variable types
" --------------------------------
hi Constant        ctermfg=06      ctermbg=none    cterm=none
hi String          ctermfg=04      ctermbg=none    cterm=none
hi StringDelimiter ctermfg=02      ctermbg=none    cterm=none
hi Character       ctermfg=04      ctermbg=none    cterm=none
hi Number          ctermfg=05      ctermbg=none    cterm=none
hi Boolean         ctermfg=01      ctermbg=none    cterm=none
hi Float           ctermfg=14      ctermbg=none    cterm=none

hi Identifier      ctermfg=04      ctermbg=none    cterm=none
hi Function        ctermfg=01      ctermbg=none    cterm=none

" --------------------------------
" Language constructs
" --------------------------------
hi Statement       ctermfg=01      ctermbg=none    cterm=none
hi Conditional     ctermfg=02      ctermbg=none    cterm=none
hi Repeat          ctermfg=06      ctermbg=none    cterm=none
hi Label           ctermfg=09      ctermbg=none    cterm=none
hi Operator        ctermfg=04      ctermbg=none    cterm=none
hi Keyword         ctermfg=09      ctermbg=none    cterm=none
hi Exception       ctermfg=02      ctermbg=none    cterm=none
hi Comment         ctermfg=08      ctermbg=none    cterm=none

hi Special         ctermfg=06      ctermbg=none    cterm=none
hi SpecialChar     ctermfg=02      ctermbg=none    cterm=none
hi Tag             ctermfg=04      ctermbg=none    cterm=none
hi Delimiter       ctermfg=09      ctermbg=none    cterm=none
hi SpecialComment  ctermfg=04      ctermbg=none    cterm=none
hi Debug           ctermfg=05      ctermbg=none    cterm=none

" ----------
" - C like -
" ----------
hi PreProc         ctermfg=03      ctermbg=none    cterm=none
hi Include         ctermfg=01      ctermbg=none    cterm=none
hi Define          ctermfg=04      ctermbg=none    cterm=none
hi Macro           ctermfg=03      ctermbg=none    cterm=none
hi PreCondit       ctermfg=09      ctermbg=none    cterm=none

hi Type            ctermfg=06      ctermbg=none    cterm=none
hi StorageClass    ctermfg=14      ctermbg=none    cterm=none
hi Structure       ctermfg=01      ctermbg=none    cterm=none
hi Typedef         ctermfg=09      ctermbg=none    cterm=none

" --------------------------------
" Diff
" --------------------------------
hi DiffAdd         ctermfg=03      ctermbg=none    cterm=none
hi DiffChange      ctermfg=02      ctermbg=none    cterm=none
hi DiffDelete      ctermfg=01      ctermbg=none    cterm=none
hi DiffText        ctermfg=05      ctermbg=none    cterm=none

" --------------------------------
" Completion menu
" --------------------------------
hi Pmenu           ctermfg=05      ctermbg=00      cterm=none
hi PmenuSel        ctermfg=00      ctermbg=05      cterm=none
hi PmenuSbar       ctermfg=04      ctermbg=none    cterm=none
hi PmenuThumb      ctermfg=06      ctermbg=none    cterm=none

" --------------------------------
" Spelling
" --------------------------------
hi SpellBad        ctermfg=01     ctermbg=none    cterm=none
hi SpellCap        ctermfg=03     ctermbg=none    cterm=none
hi SpellLocal      ctermfg=04     ctermbg=none    cterm=none
hi SpellRare       ctermfg=02     ctermbg=none    cterm=none

"--------------------------------------------------------------------
" Specific settings                                                 |
"-------------------------------------------------------------------
" PYTHON
hi pythonInclude         ctermfg=05     ctermbg=none     cterm=none
hi pythonRepeat          ctermfg=06     ctermbg=none     cterm=none
hi pythonConditional     ctermfg=02     ctermbg=none     cterm=none
hi pythonBuiltinObj      ctermfg=06     ctermbg=none     cterm=none
hi pythonFunction        ctermfg=05     ctermbg=none     cterm=none
hi pythonDecorator       ctermfg=06     ctermbg=none     cterm=none
hi pythonImport          ctermfg=12     ctermbg=none     cterm=none
hi pythonRun             ctermfg=15     ctermbg=none     cterm=none
hi pythonCoding          ctermfg=05     ctermbg=none     cterm=none
hi pythonOperator        ctermfg=14     ctermbg=none     cterm=none
hi pythonExceptions      ctermfg=09     ctermbg=none     cterm=none
hi pythonBoolean         ctermfg=15     ctermbg=none     cterm=none
hi pythonDot             ctermfg=05     ctermbg=none     cterm=none

" JAVA
hi javaexternal          ctermfg=00     ctermbg=none     cterm=none
hi javascopedecl         ctermfg=04     ctermbg=none     cterm=none
hi javaclassdecl         ctermfg=09     ctermbg=none     cterm=none
hi javaStorageClass      ctermfg=06     ctermbg=none     cterm=none
hi javaBoolean           ctermfg=02     ctermbg=none     cterm=none
hi javaAnnotation        ctermfg=04     ctermbg=none     cterm=none
hi javaElementType       ctermfg=05     ctermbg=none     cterm=none
"hi javaParenT           ctermfg=06     ctermbg=none     cterm=none
hi javatypedef           ctermfg=03     ctermbg=none     cterm=none
hi javaConstant          ctermfg=02     ctermbg=none     cterm=none
hi javaexceptions        ctermfg=01     ctermbg=none     cterm=none

" C/C++
hi cInclude              ctermfg=05     ctermbg=none     cterm=none
hi cIncluded             ctermfg=03     ctermbg=none     cterm=none
hi cPreCondit            ctermfg=02     ctermbg=none     cterm=none
hi cDefine               ctermfg=05     ctermbg=none     cterm=none
hi cStorageClass         ctermfg=01     ctermbg=none     cterm=none

" CMake
hi cmakeStatement        ctermfg=02     ctermbg=none     cterm=none
hi cmakeVariableValue    ctermfg=04     ctermbg=none     cterm=none
hi cmakeArguments        ctermfg=03     ctermbg=none     cterm=none

" SH
hi shVariable            ctermfg=03     ctermbg=none     cterm=none
hi shCommandSub          ctermfg=04     ctermbg=none     cterm=none
hi shStatement           ctermfg=05     ctermbg=none     cterm=none
hi shTestOpr             ctermfg=06     ctermbg=none     cterm=none
hi shRange               ctermfg=02     ctermbg=none     cterm=none
hi shOption              ctermfg=01     ctermbg=none     cterm=none
hi shDeref               ctermfg=03     ctermbg=none     cterm=none
hi shCmdSubRegion        ctermfg=06     ctermbg=none     cterm=none
hi shFor                 ctermfg=02     ctermbg=none     cterm=none

" HTML
hi htmltagname           ctermfg=05     ctermbg=none     cterm=none
hi htmlspecialtagname    ctermfg=06     ctermbg=none     cterm=none
hi htmlString            ctermfg=06     ctermbg=none     cterm=none
hi htmlH1                ctermfg=03     ctermbg=none     cterm=none
hi htmlarg               ctermfg=04     ctermbg=none     cterm=none
hi htmlValue             ctermfg=02     ctermbg=none     cterm=none
hi htmlEvent             ctermfg=07     ctermbg=none     cterm=none
hi htmlEventDQ           ctermfg=01     ctermbg=none     cterm=none

" CSS
hi cssclassname          ctermfg=02     ctermbg=none     cterm=none
hi cssidentifier         ctermfg=02     ctermbg=none     cterm=none
hi csstagname            ctermfg=03     ctermbg=none     cterm=none
hi cssPseudoClassId      ctermfg=04     ctermbg=none     cterm=none
hi cssDimensionProp      ctermfg=05     ctermbg=none     cterm=none
hi cssBorderProp         ctermfg=06     ctermbg=none     cterm=none
hi cssfontprop           ctermfg=02     ctermbg=none     cterm=none
hi csstextprop           ctermfg=02     ctermbg=none     cterm=none
hi cssBackgroundProp     ctermfg=03     ctermbg=none     cterm=none
hi cssPositioningProp    ctermfg=04     ctermbg=none     cterm=none
hi cssuiprop             ctermfg=05     ctermbg=none     cterm=none

" JAVASCRIPT
hi javaScriptIdentifier   ctermfg=12     ctermbg=none     cterm=none
hi javaScriptFunction     ctermfg=01     ctermbg=none     cterm=none
hi javaScriptRepeat       ctermfg=02     ctermbg=none     cterm=none
hi javaScriptConditional  ctermfg=00     ctermbg=none     cterm=none
hi javaScriptGlobal       ctermfg=03     ctermbg=none     cterm=none
hi javaScriptMember       ctermfg=05     ctermbg=none     cterm=none
hi javaScriptMessage      ctermfg=06     ctermbg=none     cterm=none
hi javaScriptStatement    ctermfg=07     ctermbg=none     cterm=none
hi javaScriptBraces       ctermfg=02     ctermbg=none     cterm=none
hi javaScriptStringD      ctermfg=05     ctermbg=none     cterm=none
hi javaScriptStorageClass ctermfg=03     ctermbg=none     cterm=none
