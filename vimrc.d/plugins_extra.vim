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


" nvim-yarp {{{1

" Use system python
let g:python3_host_prog="/usr/bin/python"

" Denite {{{1

" Change file/rec command.
call denite#custom#var('file/rec', 'command',
    \ ['scantree.py', '--path', ':directory'])

" Change grep command to use ripgrep
call denite#custom#var('grep', {
        \ 'command': ['rg'],
        \ 'default_opts': ['-i', '--vimgrep', '--no-heading'],
        \ 'recursive_opts': [],
        \ 'pattern_opt': ['--regexp'],
        \ 'separator': ['--'],
        \ 'final_opts': [],
        \ })

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
    \ ['file/rec', 'Denite file/rec -start-filter'],
    \ ['file/mru', 'Denite file_mru -start-filter'],
    \ ['grep', 'Denite grep -path=.'],
    \ ['tag', 'Denite tag -start-filter'],
    \ ['context', 'Denite contextMenu'],
    \ ]

call denite#custom#var('menu', 'menus', s:menus)

nnoremap <C-P> :<C-u>Denite menu:index<CR>
nnoremap <C-B> :<C-u>Denite buffer<CR>


" Voom {{{1

let g:voom_ft_modes = {
    \ 'markdown': 'markdown',
    \ 'tex': 'latex',
    \ 'rst': 'rest'}


" Evince SyncTex Setup {{{1

function! SyncSetup(pdf)
python3 << END
from evince_synctex import EvinceMonitor
evince_monitor = EvinceMonitor(vim.eval("a:pdf"), "SyncSource")
END
endfunction

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

