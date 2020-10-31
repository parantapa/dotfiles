" Extra plugin configs
" Enable these if only if you have python, lua, pynvim, and Vim8+ support

" Gundo {{{1

nnoremap <F5> :GundoToggle<CR>
let g:gundo_right = 1
let g:gundo_prefer_python3 = 1

" UltiSnips {{{1

let g:UltiSnipsEditSplit = "normal"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<s-tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-c-tab>"

let g:snips_author = "Parantapa Bhattachara <pb [at] parantapa [dot] net>"

cnoreabbrev es UltiSnipsEdit

" ALE {{{1

let g:ale_linters = {
    \ 'python': ['pylint', 'pyflakes', 'pydocstyle']
    \}

let g:ale_python_pydocstyle_options = '--convention=numpy'

let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 1
" let g:ale_linters_explicit = 1

let g:ale_fixers = {
    \ 'python': ['black']
    \}

" Denite {{{1

" Change file/rec command.
call denite#custom#var('file/rec', 'command',
    \ ['rg', '--files', '--glob', '!.git', '--color', 'never'])

" Change matchers.
call denite#custom#source(
    \ 'file/rec', 'matchers', ['matcher/fuzzy'])

" Change default action.
call denite#custom#kind('file', 'default_action', 'split')

" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d
    \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
    \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
    \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
    \ denite#do_map('toggle_select').'j'

    inoremap <silent><buffer><expr> <C-v> denite#do_map('do_action', 'vsplit')
    inoremap <silent><buffer><expr> <C-s> denite#do_map('do_action', 'split')
    inoremap <silent><buffer><expr> <C-t> denite#do_map('do_action', 'tabopen')

    nnoremap <silent><buffer><expr> <C-v> denite#do_map('do_action', 'vsplit')
    nnoremap <silent><buffer><expr> <C-s> denite#do_map('do_action', 'split')
    nnoremap <silent><buffer><expr> <C-t> denite#do_map('do_action', 'tabopen')

    nnoremap <silent><buffer><expr> <Esc> denite#do_map('quit')
endfunction

" Add custom menus
let s:menus = {}

let s:menus.index = {
    \ 'description': 'Denite Menu Index'
    \ }
let s:menus.index.command_candidates = [
    \ ['file/rec', 'Denite file/rec'],
    \ ['file/mru', 'Denite file_mru'],
    \ ['grep', 'Denite grep'],
    \ ['tag', 'Denite tag'],
    \ ['buffer', 'Denite buffer'],
    \ ]

call denite#custom#var('menu', 'menus', s:menus)

nnoremap <C-P> :<C-u>Denite menu:index<CR>
nnoremap <C-B> :<C-u>Denite buffer<CR>
nnoremap <C-M> :<C-u>Denite file_mru<CR>

" Deoplete {{{1

" Use deoplete.
let g:deoplete#enable_at_startup = 1
" Use smartcase.
call deoplete#custom#option('smart_case', v:true)

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
    return deoplete#close_popup() . "\<CR>"
endfunction

" Set default Source(
call deoplete#custom#option('sources', {
    \ '_': ['around', 'buffer', 'file', 'tag', 'ultisnips'],
    \})
