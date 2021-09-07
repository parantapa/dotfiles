" Vim syntax file
" Language: MKW Forecast Config
" Maintainer: Parantapa Bhattacharya

if exists("b:current_syntax")
  finish
endif

syntax clear

syntax match mkwfComment "\v#.*$"
highlight link mkwfComment Comment

syn keyword mkwfStart cells places priority add_noise_args
syn keyword mkwfEnd end
hi def link mkwfStart Statement
hi def link mkwfEnd Statement

syn keyword mkwfVars disease_model_file initialization_file intervention_file traits_file
syn keyword mkwfVars start_tick end_tick num_replicates default
hi def link mkwfVars Type

syn keyword mkwfPriority US_STATES_AND_DC LARGEST_JOB_FIRST SMALLEST_JOB_FIRST
hi def link mkwfPriority Constant

syntax match mkwfOperator "\v\="
highlight link mkwfOperator Operator

syntax match mkwfID "\v(\W|^)\zs\h\w*\ze(\W|$)"
highlight link mkwfID Identifier

syn match mkwfInteger /\v\d+/
highlight link mkwfInteger Number

syn region mkwfString oneline start=/\v"/ skip=/\v\\./ end=/\v"/ contains=mkwfReplacement
hi def link mkwfString String

syn region mkwfString1 oneline start=/\v'/ skip=/\v\\./ end=/\v'/
hi def link mkwfString1 String

syn region mkwfString2 start=/\v\"\"\"/ end=/\v\"\"\"/
hi def link mkwfString2 String

syn match mkwfReplacement "\v\{cell\}" contained
syn match mkwfReplacement "\v\{place\}" contained
highlight link mkwfReplacement Type

syn region mkwfCellsRegion start='cells:' end='end' fold transparent
syn region mkwfPlacesRegion start='places:' end='end' fold transparent
syn region mkwfReplicateConfigRegion start='simulation:' end='end' fold transparent

let b:current_syntax = "mkwf"
