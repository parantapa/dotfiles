" Extra plugin configs
" Enable these if only if you have python, lua, and Vim8+ support

" Gundo {{{2

nnoremap <F5> :GundoToggle<CR>
let g:gundo_right = 1

" UltiSnips {{{2

let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsEditSplit = "normal"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<s-tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-c-tab>"

let g:snips_author = "Parantapa Bhattachara <pb [at] parantapa [dot] net>"

cnoreabbrev es UltiSnipsEdit

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

" ALE {{{2

let g:ale_linters = {
            \ 'python': ['pylint']
            \}

let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 1

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
    \ 'yank' : 'Unite history/yank',
    \ 'outline' : 'Unite outline',
    \ }

" Use ripgrep when available
if executable('rg')
    let g:unite_source_grep_command = 'rg'
    let g:unite_source_grep_default_opts = '--hidden --no-heading --vimgrep -S'
    let g:unite_source_grep_recursive_opt = ''
endif

nnoremap <C-P> :<C-u>Unite menu:index<CR>
nnoremap <C-B> :<C-u>Unite -start-insert buffer<CR>
nnoremap <C-G> :<C-u>Unite grep:. -wrap<CR>
