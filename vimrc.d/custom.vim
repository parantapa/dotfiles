" All code in this script assumes python is available.
" If not a exception is thrown

if !has("python3")
    throw "No python support"
endif

" Load pyvimrc {{{1

python3 << EOF
import vim
import os
import sys

if "_vim_path_" not in sys.path:
    sys.path.append(os.path.join(os.environ("HOME"), ".vim/python3"))
import pyvimrc
EOF

" PyCall {{{1

" Call the python function
function! PyCall(funcname, ...)
python3 << EOF
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

" Open Url {{{1

function! OpenUrl(url)
    call system($BROWSER . " " . shellescape(a:url) . " &")
endfunction

command! -nargs=1 OpenUrl call OpenUrl(<q-args>)
cnoreabbrev ou OpenUrl

nnoremap <leader>ou :OpenUrl <C-r>=ExtractUrl(0)<CR>
vnoremap <leader>ou :<C-u>OpenUrl <C-r>=ExtractUrl(1)<CR>

" Open pdf file under cursor {{{1

function! OpenPdf(fname)
    let cmd = $PDFVIEWER . " " . fnameescape(a:fname) . " &"
    echom cmd
    call system(cmd)
endfunction

command! -nargs=1 OpenPdf call OpenPdf(<q-args>)
cnoreabbrev op OpenPdf

nnoremap <leader>op :OpenPdf <C-r><C-p>
vnoremap <leader>op "zygv:<C-u>OpenPdf <C-r>z

" Call make synctex using position and file under cursor {{{1

function! MakeSyncTex()
    let $SYNCTEX_LINE = line(".")
    let $SYNCTEX_COL = col(".")
    let $SYNCTEX_SRC = expand("%")
    let cmd = "make synctex &"
    echom cmd
    call system(cmd)
endfunction

command! -nargs=0 MakeSyncTex call MakeSyncTex()
cnoreabbrev mst MakeSyncTex

nnoremap <leader>mst :MakeSyncTex

" Perform a websearch {{{1

function! OpenSearch(xargs)
    echom a:xargs
    echo system("websearch " . shellescape(a:xargs))
endfunction

command! -nargs=1 OpenSearch call OpenSearch(<q-args>)
cnoreabbrev os OpenSearch

nnoremap <leader>os :OpenSearch <C-r><C-w> g
vnoremap <leader>os "zygv:<C-u>OpenSearch <C-r>z g


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
