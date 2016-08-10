" ------------------ General
set t_Co=256
set background=dark
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline
set laststatus=2

" ------------------ Solarized
let g:solarized_termtrans=1
let g:solarized_hitrail=1
let g:solarized_termcolors=256
colorscheme solarized

highlight SignColumn ctermbg=black
highlight CursorLineNr ctermbg=black cterm=bold

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