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

" Load pyvimrc {{{1

if has("python")
python << EOF
import vim
import os
import sys

if "_vim_path_" not in sys.path:
    sys.path.append(os.path.join(os.environ("HOME"), ".vim/python2"))
import pyvimrc
EOF
endif

" Use system clipboard as default register {{{1

if has('xterm_clipboard')
    set clipboard=unnamed
endif

" Use Molokai as Color scheme {{{1

if has("gui_running") || &t_Co == 256
    set background=dark
    colorscheme molokai
endif

" Add Syntastic and VirtualEnv info in status line {{{1

set statusline=%f       " Path.
set statusline+=%m      " Modified flag.
set statusline+=%r      " Readonly flag.
set statusline+=%w      " Preview window flag.

set statusline+=\       " Add blank space
set statusline+=%#redbar#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

set statusline+=%=                              " Right align.
set statusline+=%{virtualenv#statusline()}      " Virtualenv
set statusline+=(
set statusline+=%{&ff}                          " Format (unix/DOS).
set statusline+=/
set statusline+=%{strlen(&fenc)?&fenc:&enc}     " Encoding (utf-8).
set statusline+=/
set statusline+=%{&ft}                          " Type (python).
set statusline+=)

" Line and column position and counts.
set statusline+=\ (line\ %l\/%L,\ col\ %03c)

" DefaultPyCall {{{1

" Call the python function if python is available
" Otherwise just return the default value
function! DefaultPyCall(default, funcname, ...)
    if has("python")
python << EOF
funcname = vim.eval("a:funcname")
func = getattr(pyvimrc, funcname)

args = vim.eval("a:000")
ret = func(*args)
EOF
        return pyeval("ret")
    else
        return a:default
endfunction

" Open URL with Firefox {{{1

function! ExtractUrl(vmode)
    let saved_unnamed_register = @"
    let saved_selection = &selection

    if a:vmode ==# 1
        silent exe "normal! gvy"
        let url = @"
    else
        silent exe "normal! ^yg_"
        let url = DefaultPyCall(@", "extract_url", @")
        if url ==# ''
            let url = @"
        endif
    endif

    let @" = saved_unnamed_register
    let &selection = saved_selection

    return url
endfunction

function! OpenUrl(url)
    call system("firefox " . shellescape(a:url) . " &")
endfunction

command! -nargs=1 OpenUrl call OpenUrl(<q-args>)
cnoreabbrev ou OpenUrl

nnoremap <leader>ou :OpenUrl <C-r>=ExtractUrl(0)<CR>
vnoremap <leader>ou :<C-u>OpenUrl <C-r>=ExtractUrl(1)<CR>

" Search and Open PDFs in SDOCS with Evince {{{1

function! ExtractCite(vmode)
    let saved_unnamed_register = @"
    let saved_selection = &selection
    let saved_keyword = &iskeyword

    if a:vmode
        silent exe "normal! gvy"
        let cite = @"
    else
        set iskeyword=a-z,A-Z,48-57,_,-
        normal! yiw
        let cite = @"
    endif

    let &iskeyword = saved_keyword
    let @" = saved_unnamed_register
    let &selection = saved_selection

    return cite
endfunction

" Open Pdf in SDOCS
function! OpenPdf(keyword)
    let cmd = printf("find %s -name *%s*.pdf", fnameescape($HOME_SDOCS), shellescape(a:keyword))
    let fnames_str = system(cmd)
    let fnames = split(fnames_str, "\n", 0)
    let fnames = map(fnames, 'Strip(v:val)')

    if len(fnames) >= 1
        echom printf("Found %d files ...", len(fnames))
        echom printf("Opening '%s' ...", fnames[0])

        let cmd = printf("evince %s 2>/dev/null &", fnameescape(fnames[0]))
        call system(cmd)
    else
        echom printf("No pdf files found matching '%s'", a:keyword)
    endif
endfunction

command! -nargs=1 OpenPdf call OpenPdf(<q-args>)
cnoreabbrev op OpenPdf

nnoremap <leader>op :OpenPdf <C-r>=ExtractCite(0)<CR>
vnoremap <leader>op :<C-u>OpenPdf <C-r>=ExtractCite(1)<CR>

" Search for citation in Quickrefs sdocs-paper*.md {{{1

" Open Cite in sdocs-papers in Quickrefs
function! OpenCite(keyword)
    let cmd = 'vimgrep /\V\C%s/gj %s/sdocs-papers*.md'
    let cmd = printf(cmd, a:keyword, fnameescape($HOME_QUICKREFS))
    silent! execute cmd
    execute "copen"
endfunction

command! -nargs=1 OpenCite call OpenCite(<q-args>)
cnoreabbrev oc OpenCite

nnoremap <leader>oc :OpenCite <C-r>=ExtractCite(0)<CR>
vnoremap <leader>oc :<C-u>OpenCite <C-r>=ExtractCite(1)<CR>

" External Filters {{{1

" Replace current dl.acm.org paper url with bib and abstract

fun! DlacmRead(url)
    let url = shellescape(Strip(a:url))
    let script = expand("$HOME_QUICKREFS/scripts/parse-dlacm.sh")

    execute "read ! " . script . " " . url
endfunction
nnoremap <Leader>Xda yy:call DlacmRead(@")<CR>

" Replace current aaai paper url with bib and abstract

fun! AaaiRead(url)
    let url = shellescape(Strip(a:url))
    let script = expand("$HOME_QUICKREFS/scripts/parse-aaai.sh")

    execute "read ! " . script . " " . url
endfunction
nnoremap <Leader>Xaa yy:call AaaiRead(@")<CR>

" Wordnet for Viewdoc {{{1

function! s:ViewDoc_wordnet(topic, ...)
        return { 'cmd' : printf('wn %s -over | fold -w 78 -s', shellescape(a:topic, 1)),
                \ 'ft' : 'wordnet' }
endf
let g:ViewDoc_wordnet = function('s:ViewDoc_wordnet')

command! -bar -bang -nargs=1 ViewDocWordnet
	\ call ViewDoc('<bang>'=='' ? 'new' : 'doc', <f-args>, 'wordnet')
cnoreabbrev wn ViewDocWordnet

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

" Gundo {{{2

    nnoremap <F5> :GundoToggle<CR>
    let g:gundo_right = 1

" NERDTree {{{2

    nnoremap <F2> :NERDTreeToggle<CR>
    let g:NERDTreeMapActivateNode = "<CR>"
    let g:NERDTreeMapOpenInTab = "<C-t>"
    let g:NERDTreeMapOpenSplit = "<C-s>"
    let g:NERDTreeMapOpenVSplit = "<C-v>"

" Latex {{{2

    let g:tex_flavor = 'latex'
    let g:tex_comment_nospell= 1

" Syntastic {{{2

    let g:syntastic_enable_signs = 1
    let g:syntastic_stl_format = '[%E{Error 1/%e: line %fe}%B{, }%W{Warning 1/%w: line %fw}]'
    let g:syntastic_c_compiler_options = ' -Wall -Wextra'
    let g:syntastic_python_checkers = ['pylint']
    let g:syntastic_python_pylint_exec = '/usr/bin/pylint2'
    let g:syntastic_javascript_checkers = ['jslint']
    let g:syntastic_javascript_jslint_conf = "--sloppy"

    " Dont use Syntastic when exiting
    nnoremap :wq :au! syntastic<cr>:wq

" Tabbing {{{2

    cnoreabbrev tab Tabularize /\V

" TagBar {{{2

    nnoremap <F8> :TagbarToggle<CR>

" Rainbow Parenthesis {{{2

    nnoremap <Leader>R :RainbowParenthesesToggleAll<CR>

" Virtualenv {{{2

    let g:virtualenv_stl_format = '[%n] '

" ViewDoc {{{2

    let g:viewdoc_pydoc_cmd = "python -m pydoc"
    let g:viewdoc_open = "tab drop [ViewDoc]"

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

" Commentary {{{2

    let g:commentary_map_keys = 0
    xmap gc  <Plug>Commentary
    nmap gc  <Plug>Commentary
    nmap gcc <Plug>CommentaryLine
    nmap gcu <Plug>CommentaryUndo

" LanguageTool {{{2

    let g:languagetool_disable_rules = "WHITESPACE_RULE,EN_QUOTES,MORFOLOGIK_RULE_EN_US"

" UltiSnips {{{2

    let g:UltiSnipsUsePythonVersion = 2
    let g:UltiSnipsEditSplit = "normal"
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<s-tab>"
    let g:UltiSnipsJumpBackwardTrigger="<s-c-tab>"

    let g:snips_author = "Parantapa Bhattachara <pb [at] parantapa [dot] net>"

    cnoreabbrev es UltiSnipsEdit

" Marvim {{{2

    let g:marvim_store = expand("$HOME_QUICKREFS/marvim")
    let g:marvim_find_key = '<Leader>mf'
    let g:marvim_store_key = '<Leader>ms'
    let g:marvim_prefix = 0

" NeoComplete {{{2

    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#disable_auto_complete = 0

    let g:neocomplete#enable_ignore_case = 1
    let g:neocomplete#enable_auto_delimiter = 1
    let g:neocomplete#enable_fuzzy_completion = 1
    let g:neocomplete#enable_refresh_always = 1

    " By default use all buffers
    if !exists('g:neocomplete#same_filetypes')
        let g:neocomplete#same_filetypes = {}
    endif
    let g:neocomplete#same_filetypes._ = '_'

    " By default use all sources
    if !exists('g:neocomplete#sources')
        let g:neocomplete#sources = {}
    endif
    let g:neocomplete#sources._ = ["_"]

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = { '_' : &spellfile }

    if index(g:pathogen_disabled, "neocomplete.vim") == -1
        " Recommended key-mappings.
        " <CR>: close popup and save indent.
        inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
        function! s:my_cr_function()
            return pumvisible() ? neocomplete#close_popup() : "\<CR>"
        endfunction

        " <C-h>, <BS>: close popup and delete backword char.
        inoremap <expr><C-h> neocomplete#smart_close_popup() . "\<C-h>"
        inoremap <expr><BS> neocomplete#smart_close_popup() . "\<C-h>"

        " " For smart TAB completion.
        " inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
        "     \ <SID>check_back_space() ? "\<TAB>" :
        "     \ neocomplete#start_manual_complete()
        " function! s:check_back_space()
        "     let col = col('.') - 1
        "     return !col || getline('.')[col - 1]  =~ '\s'
        " endfunction
    endif

    nnoremap <F9> :NeoCompleteToggle<CR>

" QFEnter {{{2

    let g:qfenter_open_map = ['<CR>', '<2-LeftMouse>']
    let g:qfenter_vopen_map = ['<C-V>']
    let g:qfenter_hopen_map = ['<C-S>']
    let g:qfenter_topen_map = ['<C-T>']

" Unite {{{2

    let g:unite_source_history_yank_enable = 1

    " Like ctrlp.vim settings.
    call unite#custom#profile('default', 'context', {
        \   'start_insert': 1,
        \   'winheight': 10,
        \   'direction': 'botright',
        \ })
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    call unite#filters#sorter_default#use(['sorter_rank'])

    " nnoremap <C-P><C-P> :<C-u>Unite -start-insert buffer<CR>
    " nnoremap <C-P>f :<C-u>Unite -start-insert file_rec<CR>
    " nnoremap <C-P>m :<C-u>Unite -start-insert file_mru<CR>
    " nnoremap <C-P>y :<C-u>Unite history/yank<CR>

    autocmd FileType unite call s:unite_my_settings()
    function! s:unite_my_settings()

	inoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
	inoremap <silent><buffer><expr> <C-s> unite#do_action('split')
	inoremap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

	nnoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
	nnoremap <silent><buffer><expr> <C-s> unite#do_action('split')
	nnoremap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

        nmap <silent><buffer> <Esc> <Plug>(unite_exit)

    endfunction

    let g:unite_source_menu_menus = {}
    let g:unite_source_menu_menus.index = {
        \ 'description' : 'Unite Index',
        \ }
    let g:unite_source_menu_menus.index.command_candidates = {
        \ 'file' : 'Unite -start-insert file_rec',
        \ 'mru' : 'Unite -start-insert file_mru',
        \ 'buffer' : 'Unite -start-insert buffer',
        \ 'yank' : 'Unite history/yank',
        \ 'outline' : 'Unite outline'
        \ }

    nnoremap <C-P> :<C-u>Unite menu:index<CR>

" Indent Guides {{{2

    nnoremap <Leader>I :IndentGuidesToggle<CR>

" EasyAlign {{{2

    vmap <Enter> <Plug>(EasyAlign)

" Setup stuff depending on filename/extension {{{1
augroup ft_setup_extra
    au!

    au BufEnter bookmarks.yaml setlocal foldtext=DefaultPyCall('--','bookmark_fold_text',v:foldstart,v:foldend,v:foldlevel)
augroup END

