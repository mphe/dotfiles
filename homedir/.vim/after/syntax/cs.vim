syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
setl foldmethod=syntax
set fillchars=fold:\ 
function! FoldText()
return substitute(getline(v:foldstart), '{.*', '{...}', '')
endfunction
setl foldtext=FoldText()
