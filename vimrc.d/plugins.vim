" Plugin vimrc
"
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
    colorscheme molokai
endif


" " Plugin settings {{{1
" 
" " NERDTree {{{2
" 
"     nnoremap <F2> :NERDTreeToggle<CR>
"     let g:NERDTreeMapActivateNode = "<CR>"
"     let g:NERDTreeMapOpenInTab = "<C-t>"
"     let g:NERDTreeMapOpenSplit = "<C-s>"
"     let g:NERDTreeMapOpenVSplit = "<C-v>"
" 
" " Latex {{{2
" 
"     let g:tex_flavor = 'latex'
"     let g:tex_comment_nospell= 1
" 
" " QFEnter {{{2
" 
"     let g:qfenter_open_map = ['<CR>', '<2-LeftMouse>']
"     let g:qfenter_vopen_map = ['<C-V>']
"     let g:qfenter_hopen_map = ['<C-S>']
"     let g:qfenter_topen_map = ['<C-T>']
" 
" " TagBar {{{2
" 
"     cnoreabbrev tt TagbarToggle
" 
" " ViewDoc {{{2
" 
"     let g:viewdoc_pydoc_cmd = "python -m pydoc"
" 
" " Slime {{{2
" 
"     let g:slime_target = "tmux"
"     let g:slime_paste_file = expand("$HOME/.slime_paste")
"     let g:slime_no_mappings = 1
" 
"     function! SlimeSendText(text)
"         execute "SlimeSend1 " . a:text
"     endfunction
" 
"     nmap <Leader>v <Plug>SlimeMotionSend
"     vmap <Leader>v <Plug>SlimeRegionSend
"     nmap <Leader>vv <Plug>SlimeLineSend
" 
"     command! -nargs=0 SlimeSetIpython let g:slime_python_ipython = 1
"     command! -nargs=0 SlimeUnsetIpython unlet g:slime_python_ipython
" 
" " Commentary {{{2
" 
"     let g:commentary_map_keys = 0
"     xmap gc  <Plug>Commentary
"     nmap gc  <Plug>Commentary
"     nmap gcc <Plug>CommentaryLine
"     nmap gcu <Plug>CommentaryUndo
" 
" " LanguageTool {{{2
" 
"     let g:languagetool_disable_rules = "WHITESPACE_RULE,EN_QUOTES,MORFOLOGIK_RULE_EN_US"
