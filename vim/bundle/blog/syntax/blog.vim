let b:current_syntax = ''
unlet b:current_syntax
runtime! syntax/rst.vim

let b:current_syntax = ''
unlet b:current_syntax
syntax include @RST syntax/rst.vim

let b:current_syntax = ''
unlet b:current_syntax
syntax include @YaML syntax/yaml.vim

syntax region yamlEmbedded matchgroup=Snip start='\v^\-\-\-$' end='\v^\.\.\.$' containedin=@RST contains=@YaML

hi link Snip SpecialComment
let b:current_syntax = 'rst.yaml'

