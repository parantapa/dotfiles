" We use pathogen and load plugins using that.
"
" Setup Pathogen {{{1

runtime bundle/vim-pathogen/autoload/pathogen.vim

" let g:pathogen_disabled = []
" if !has("python")
"     call add(g:pathogen_disabled, "ultisnips")
" endif
" if !( has('lua') && (v:version > 703 || v:version == 703 && has('patch885')) )
"     call add(g:pathogen_disabled, "neocomplete.vim")
" endif

filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

" Use Molokai as Color scheme {{{1

if has("gui_running") || &t_Co == 256
    set background=dark
    colorscheme gruvbox
endif


" Plugin settings {{{1

" Latex {{{2

let g:tex_flavor = 'latex'
let g:tex_comment_nospell = 1

" QFEnter {{{2

let g:qfenter_open_map = ['<CR>', '<2-LeftMouse>']
let g:qfenter_vopen_map = ['<C-V>']
let g:qfenter_hopen_map = ['<C-S>']
let g:qfenter_topen_map = ['<C-T>']

" " TagBar {{{2
"
"     cnoreabbrev tt TagbarToggle
"
" Slime {{{2

let g:slime_target = "vimterminal"
let g:slime_no_mappings = 1

xmap <leader>s <Plug>SlimeRegionSend
nmap <leader>s <Plug>SlimeParagraphSend

command! -nargs=0 IpySlime let g:slime_python_ipython = 1
command! -nargs=0 NoIpySlime unlet g:slime_python_ipython
"
" Commentary {{{2

let g:commentary_map_keys = 0
xmap gc  <Plug>Commentary
nmap gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine
nmap gcu <Plug>CommentaryUndo

" Surround {{{2 

let g:surround_116 = "{{\r}}" " t == 116
let g:surround_102 = "{\r}" " f == 116


" " LanguageTool {{{2
"
"     let g:languagetool_disable_rules = "WHITESPACE_RULE,EN_QUOTES,MORFOLOGIK_RULE_EN_US"
