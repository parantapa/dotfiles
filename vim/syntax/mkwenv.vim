" Vim syntax file
" Language: MKW Env Config
" Maintainer: Parantapa Bhattacharya

if exists("b:current_syntax")
  finish
endif

syn keyword mkwStart import vars export
syn keyword mkwEnd end
hi def link mkwStart Type
hi def link mkwEnd Type

syn region mkwString oneline start=/\v"/ skip=/\v\\./ end=/\v"/
hi def link mkwString String

syntax match mkwComment "\v#.*$"
highlight link mkwComment Comment

syntax match mkwOperator "\v/"
syntax match mkwOperator "\v\="
highlight link mkwOperator Operator

syntax match mkwID "\v(\W|^)\zs\h\w*\ze(\W|$)"
highlight link mkwID Identifier

syn match mkwInteger /\v\d+/
highlight link mkwInteger Number

syn region importRegion start='import:' end='end' fold transparent
syn region varsRegion start='vars:' end='end' fold transparent
syn region exportRegion start='export:' end='end' fold transparent

let b:current_syntax = "mkwenv"
