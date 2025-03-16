syn match pyClass "\v<\u\w+>"
syn match pyConstant  "\v<[A-Z_]+[A-Z0-9_]*>"

hi def link pyClass Type
hi def link pyConstant Constant
