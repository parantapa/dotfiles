" Extra plugin configs
" Enable these if only if you have python, lua, and Vim8+ support

" Gundo {{{1

nnoremap <F5> :GundoToggle<CR>
let g:gundo_right = 1
let g:gundo_prefer_python3 = 1

" UltiSnips {{{1

" let g:UltiSnipsUsePythonVersion = 2
" let g:UltiSnipsEditSplit = "normal"
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<s-tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-c-tab>"
" 
" let g:snips_author = "Parantapa Bhattachara <pb [at] parantapa [dot] net>"
" 
" cnoreabbrev es UltiSnipsEdit

" ALE {{{1

" let g:ale_linters = {
"     \ 'python': ['pylint', 'pyflakes', 'pydocstyle']
"     \}
" 
" let g:ale_python_pydocstyle_options = '--convention=numpy'
" 
" let g:ale_lint_on_text_changed = 1
" let g:ale_lint_on_insert_leave = 1
" let g:ale_lint_on_enter = 1
" let g:ale_lint_on_save = 1
" let g:ale_lint_on_filetype_changed = 1
" 
" let g:ale_fixers = {
"     \ 'python': ['black']
"     \}

