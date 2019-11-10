" ------------------ General
set t_Co=256
set background=dark
set guifont="xos4 Terminus"

" ------------------ Solarized
let g:solarized_termtrans=1
let g:solarized_hitrail=1

" comment out if using alacritty
" let g:solarized_termcolors=256

if &term == 'xterm-termite'
    let g:solarized_termcolors=256
endif

colorscheme solarized
" colorscheme flattened_dark

highlight SignColumn ctermbg=black
highlight CursorLineNr ctermfg=3 ctermbg=black cterm=bold

" Solid background color for YCM indicators
highlight YcmWarningSign cterm=bold ctermbg=black ctermfg=red
highlight YcmErrorSign cterm=bold ctermbg=black ctermfg=red
highlight YcmErrorSection cterm=underline ctermfg=darkred

" Search highlight color
highlight EasyMotionMoveHL ctermbg=240 ctermfg=black

" ------------------ Cursorline
set cursorline
highlight CursorLine ctermbg=Black cterm=NONE

" No underline in folds
highlight Folded cterm=bold

" Syntastic Errors
highlight SpellBad term=underline ctermfg=160 gui=undercurl guisp=Orange 

highlight Normal ctermbg=none

highlight PmenuSbar ctermfg=12 ctermbg=0
