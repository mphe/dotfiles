syn region SynFold
    \ start="\v\<%(param|link|isindex|input|hr|frame|col|br|basefont|base|area|img|meta)@!\z([a-z]+)%(\_s[^>]*[^>/])*\>"
    \ end="</\z1>"
    \ transparent fold keepend extend
    \ containedin=ALLBUT,htmlComment

" syn sync fromstart
" set foldmethod=syntax
" syn region XMLFold start=+^<\([^/?!><]*[^/]>\)\&.*\(<\1\|[[:alnum:]]\)$+ end=+^</.*[^-?]>$+ fold transparent keepend extend
"
" syn match XMLCData "<!\[CDATA\[\_.\{-}\]\]>" fold transparent extend
"
" syn match XMLCommentFold "<!--\_.\{-}-->" fold transparent extend
" set foldtext=XMLFoldLabel()
"  fun! XMLFoldLabel()
"   let getcontent = substitute(getline(v:foldstart), "^[[:space:]]*", "", 'g')
" 	let linestart = substitute(v:folddashes, ".", '»', 'g')
" 	return linestart . " " . getcontent
" endfunction
