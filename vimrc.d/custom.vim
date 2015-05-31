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

" Search and Open PDFs in SDOCS with Evince {{{1

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

" Setup stuff depending on filename/extension {{{1
augroup ft_setup_custom
    au!

    au BufEnter bookmarks.yaml setlocal foldtext=PyCall('bookmark_fold_text',
        \ v:foldstart, v:foldend, v:foldlevel)
augroup END
