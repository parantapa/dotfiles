" Plugin vimrc
"
" We use pathogen and load plugins using that.
"
" Setup Pathogen {{{1

runtime bundle/pathogen/autoload/pathogen.vim

let g:pathogen_disabled = []
if !has("python")
    call add(g:pathogen_disabled, "ultisnips")
endif
if !( has('lua') && (v:version > 703 || v:version == 703 && has('patch885')) )
    call add(g:pathogen_disabled, "neocomplete.vim")
endif

filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

" Use Molokai as Color scheme {{{1

if has("gui_running") || &t_Co == 256
    set background=dark
    colorscheme molokai
endif

" Add Syntastic and VirtualEnv info in status line {{{1

call insert(g:my_statusline, " %#redbar#%{SyntasticStatuslineFlag()}%*", 1)
call insert(g:my_statusline, "%{virtualenv#statusline()}", 3)

let &statusline = join(g:my_statusline, "")

" Wordnet for Viewdoc {{{1

function! s:ViewDoc_wordnet(topic, ...)
    let cmd = printf('wn %s -over | fold -w 78 -s',  shellescape(a:topic))
    return {'cmd': cmd, 'ft': 'wordnet'}
endf
let g:ViewDoc_wordnet = function('s:ViewDoc_wordnet')

command! -bar -bang -nargs=1 ViewDocWordnet
	\ call ViewDoc('<bang>'=='' ? 'new' : 'doc', <f-args>, 'wordnet')
cnoreabbrev wn ViewDocWordnet
nnoremap <Leader>wn :ViewDocWordnet <C-r><C-w>

augroup au_wordnet
    au!

    autocmd FileType wordnet mapclear <buffer>
    autocmd FileType wordnet syn match overviewHeader /^Overview of .\+/
    autocmd FileType wordnet syn match definitionEntry /\v^[0-9]+\. .+$/ contains=numberedList,word
    autocmd FileType wordnet syn match numberedList /\v^[0-9]+\. / contained
    autocmd FileType wordnet syn match word /\v([0-9]+\.[0-9\(\) ]*)@<=[^-]+/ contained
    autocmd FileType wordnet hi link overviewHeader Title
    autocmd FileType wordnet hi link numberedList Operator
    autocmd FileType wordnet hi def word term=bold cterm=bold gui=bold
augroup end

" Plugin settings {{{1

" NERDTree {{{2

    nnoremap <F2> :NERDTreeToggle<CR>
    let g:NERDTreeMapActivateNode = "<CR>"
    let g:NERDTreeMapOpenInTab = "<C-t>"
    let g:NERDTreeMapOpenSplit = "<C-s>"
    let g:NERDTreeMapOpenVSplit = "<C-v>"

" Latex {{{2

    let g:tex_flavor = 'latex'
    let g:tex_comment_nospell= 1

" Latex-Box {{{2

    let g:LatexBox_no_mappings = 1
    let g:LatexBox_custom_indent = 0

" Syntastic {{{2

    let g:syntastic_enable_signs = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_aggregate_errors = 1
    let g:syntastic_id_checkers = 1

    let g:syntastic_stl_format = '[%E{Error 1/%e: line %fe}%B{, }%W{Warning 1/%w: line %fw}]'

    let g:syntastic_c_compiler_options = ' -Wall -Wextra'
    let g:syntastic_python_checkers = ['pylint']
    let g:syntastic_python_pylint_exec = '/usr/bin/pylint2'
    let g:syntastic_javascript_checkers = ['eslint']

    let g:syntastic_mode_map = {
        \ "mode": "passive",
        \ "active_filetypes": ["python", "javascript"],
        \ "passive_filetypes": ["javascript.jsx"] }

    " Get the current error-code from pylint
    function! MySyntasticPylintCode()
        let line = line(".")
        let baloons = g:SyntasticLoclist.current().balloons()
        if !has_key(baloons, line)
            return ""
        endif

        let message = baloons[line]

        let codergx = '\v\C^\[\zs[a-z\-]+\ze\]'
        let code = matchstr(message, codergx)

        return code
    endfunction

" QFEnter {{{2

    let g:qfenter_open_map = ['<CR>', '<2-LeftMouse>']
    let g:qfenter_vopen_map = ['<C-V>']
    let g:qfenter_hopen_map = ['<C-S>']
    let g:qfenter_topen_map = ['<C-T>']

" TagBar {{{2

    cnoreabbrev tt TagbarToggle

" Virtualenv {{{2

    let g:virtualenv_stl_format = '[%n] '

" ViewDoc {{{2

    let g:viewdoc_pydoc_cmd = "python -m pydoc"

" Slime {{{2

    let g:slime_target = "tmux"
    let g:slime_paste_file = expand("$HOME/.slime_paste")
    let g:slime_no_mappings = 1

    function! SlimeSendText(text)
        execute "SlimeSend1 " . a:text
    endfunction

    nmap <Leader>v <Plug>SlimeMotionSend
    vmap <Leader>v <Plug>SlimeRegionSend
    nmap <Leader>vv <Plug>SlimeLineSend

    command! -nargs=0 SlimeSetIpython let g:slime_python_ipython = 1
    command! -nargs=0 SlimeUnsetIpython unlet g:slime_python_ipython

" Commentary {{{2

    let g:commentary_map_keys = 0
    xmap gc  <Plug>Commentary
    nmap gc  <Plug>Commentary
    nmap gcc <Plug>CommentaryLine
    nmap gcu <Plug>CommentaryUndo

" LanguageTool {{{2

    let g:languagetool_disable_rules = "WHITESPACE_RULE,EN_QUOTES,MORFOLOGIK_RULE_EN_US"

" RainbowParentheses {{{2

    cnoreabbrev rpt RainbowParenthesesToggle
