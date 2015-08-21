" All code in this script assumes python is available.
" If not a exception is thrown

if !has("python")
    throw "No python support"
endif

" Load pyvimrc {{{1

python << EOF
import vim
import os
import sys

if "_vim_path_" not in sys.path:
    sys.path.append(os.path.join(os.environ("HOME"), ".vim/python2"))
import pyvimrc
EOF

" PyCall {{{1

" Call the python function
function! PyCall(funcname, ...)
python << EOF
funcname = vim.eval("a:funcname")
func = getattr(pyvimrc, funcname)

args = vim.eval("a:000")
ret = func(*args)
EOF
    return pyeval("ret")
endfunction

" ExtractUrl {{{1

function! ExtractUrl(vmode)
    let saved_unnamed_register = @"
    let saved_selection = &selection

    if a:vmode ==# 1
        silent exe "normal! gvy"
        let url = @"
    else
        silent exe "normal! yiW"
        let url = PyCall("extract_url", @")
        if url ==# ''
            let url = @"
        endif
    endif

    let @" = saved_unnamed_register
    let &selection = saved_selection

    return url
endfunction

" ExtractCite {{{1

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

" Open Url with Firefox {{{1

function! OpenUrl(url)
    call system("firefox " . shellescape(a:url) . " &")
endfunction

command! -nargs=1 OpenUrl call OpenUrl(<q-args>)
cnoreabbrev ou OpenUrl

nnoremap <leader>ou :OpenUrl <C-r>=ExtractUrl(0)<CR>
vnoremap <leader>ou :<C-u>OpenUrl <C-r>=ExtractUrl(1)<CR>

" Search and Open PDFs in SDOCS {{{1

function! OpenPdf(keyword)
    call system("find-pdf " . shellescape(a:keyword) . " 1 &")
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

" Perform a websearch {{{1

function! OpenSearch(xargs)
    echom a:xargs
    echo system("websearch " . shellescape(a:xargs))
endfunction

command! -nargs=1 OpenSearch call OpenSearch(<q-args>)
cnoreabbrev os OpenSearch

nnoremap <leader>os :OpenSearch <C-r><C-w> g
vnoremap <leader>os "zygv:<C-u>OpenSearch <C-r>z g

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

" Setup stuff depending on filename/extension {{{1
augroup ft_setup_custom
    au!

    au BufEnter bookmarks.yaml setlocal foldtext=PyCall('bookmark_fold_text',
        \ v:foldstart, v:foldend, v:foldlevel)
augroup END

" Modescript {{{1

let g:modescript_fname = ".modescript.vim"

function! GetModeScriptFname()
    " If local modescript exists, return that first
    if filereadable(g:modescript_fname)
        return  g:modescript_fname
    endif

    " If repo modescript exists, return that next
    if executable("git")
        let cmd = "git rev-parse --show-toplevel 2>/dev/null"
        let reporoot = Strip(system(cmd))
        if len(reporoot) > 0
            let repo_modescript_fname = reporoot . "/" . g:modescript_fname
            if filereadable(repo_modescript_fname)
                return repo_modescript_fname
            endif
        endif
    endif

    return g:modescript_fname
endfunction

function! LoadModeScript()
    let fname = GetModeScriptFname()
    if filereadable(fname)
        exe "source " . fname
    endif

    " NOTE: Changing built in command
    command! -nargs=0 Mk execute g:makecmd
    command! -nargs=0 Mk1 execute g:makecmd1
    command! -nargs=0 Mk2 execute g:makecmd2
    command! -nargs=0 Mk3 execute g:makecmd3
    command! -nargs=0 Mk4 execute g:makecmd4
    command! -nargs=0 Mk5 execute g:makecmd5
endfunction
command! -nargs=0 LoadModeScript call LoadModeScript()

augroup ft_modescript
    au!

    autocmd BufReadPost,BufNewFile * LoadModeScript
    exe "autocmd BufWritePost " . g:modescript_fname . " LoadModeScript"

    " Redefine mk with abbrev
    " I dont use mk[exrc]
    cnoreabbrev mk Mk
    cnoreabbrev mk1 Mk1
    cnoreabbrev mk2 Mk2
    cnoreabbrev mk3 Mk3
    cnoreabbrev mk4 Mk4
    cnoreabbrev mk5 Mk5

augroup END

cnoreabbrev em edit <C-r>=GetModeScriptFname()<CR>
