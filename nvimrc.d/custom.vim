" All code in this script assumes python is available.
" If not a exception is thrown

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
    " call system("clipboard-latex")
    new | lua vim.fn.termopen("clipboard-latex")
endfunction

nnoremap <leader>cl :call ClipboardLatex(0)<CR>
vnoremap <leader>cl :<C-u>call ClipboardLatex(1)<CR>
