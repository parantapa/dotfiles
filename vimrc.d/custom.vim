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
    return py3eval("ret")
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

" Perform a websearch {{{1

function! OpenSearch(xargs)
    echom a:xargs
    echo system("websearch " . shellescape(a:xargs))
endfunction

command! -nargs=1 OpenSearch call OpenSearch(<q-args>)
cnoreabbrev os OpenSearch

nnoremap <leader>os :OpenSearch <C-r><C-w> g
vnoremap <leader>os "zygv:<C-u>OpenSearch <C-r>z g


" Rename the current file {{{1
function! RenameCurrentFile(newfile)
    write
    call PyCall("rename_current_file", a:newfile)
    execute "edit " + a:newfile
endfunction

command! -nargs=1 Rename call RenameCurrentFile(<q-args>)

" Evince SyncTex Setup {{{1

function! SyncSetup(pdf)
python3 << END
from evince_synctex import EvinceMonitor
evince_monitor = EvinceMonitor(vim.eval("a:pdf"), "SyncSource")
END
endfunction

command! -nargs=1 SyncSetup call SyncSetup(<f-args>)
cnoreabbrev ss SyncSetup

function! SyncView()
python3 << END
line = vim.eval('line(".")')
col = vim.eval('col(".")')
src = vim.eval('expand("%")')

evince_monitor.sync_view(src, line, col)
END
endfunction

function! SyncSource(fname, line, col)
    wall
    execute printf('edit %s', a:fname)
    execute printf('normal %sG', a:line)
    normal zz
endfunction

command! SyncView call SyncView()
cnoreabbrev sv SyncView

" Call clipboard-latex {{{1

function! ClipboardLatex(vmode)
    let saved_unnamed_register = @"
    let saved_selection = &selection

    if a:vmode ==# 1
        silent exe "normal! gvy"
        let latex = @"
    else
        silent exe "normal! ^y$"
        let latex = @"
    endif

    let @" = saved_unnamed_register
    let &selection = saved_selection

    let @+ = latex
    let @* = latex
    call system("clipboard-latex")
endfunction

nnoremap <leader>cl :call ClipboardLatex(0)<CR>
vnoremap <leader>cl :<C-u>call ClipboardLatex(1)<CR>
