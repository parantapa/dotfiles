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

" Deoplete {{{1

" Use deoplete.
let g:deoplete#enable_at_startup = 1
" Use smartcase.
call deoplete#custom#option('smart_case', v:true)

" " <CR>: close popup and save indent.
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function() abort
"     return deoplete#close_popup() . "\<CR>"
" endfunction

" inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

let g:my_deoplete_sources = {
    \ '_': ['around', 'buffer', 'file', 'tag', 'ultisnips'],
    \ 'c': ['around', 'buffer', 'file', 'tag', 'ultisnips', 'LanguageClient'],
    \ 'cpp': ['around', 'buffer', 'file', 'tag', 'ultisnips', 'LanguageClient'],
    \ 'tex': ['around', 'buffer', 'file', 'tag', 'ultisnips', 'LanguageClient'],
    \ 'bib': ['around', 'buffer', 'file', 'tag', 'ultisnips', 'LanguageClient'],
    \ 'sh': ['around', 'buffer', 'file', 'tag', 'ultisnips', 'LanguageClient'],
    \ 'vim': ['around', 'buffer', 'file', 'tag', 'ultisnips', 'LanguageClient'],
    \}

" Set default Source(
call deoplete#custom#option('sources', my_deoplete_sources)

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

" LanguageClient {{{1

nmap <silent> K  <Plug>(lcn-hover)
nmap <silent> gd <Plug>(lcn-definition)
command! -nargs=0 LCRename call LanguageClient#textDocument_rename()
command! -nargs=0 LCFormat call LanguageClient#textDocument_formatting()

let g:LanguageClient_settingsPath = ['.language_client_settings.json']

let g:LanguageClient_serverCommands = {}
let g:LanguageClient_serverCommands['c'] = { 'name': 'ccls', 'command': ['ccls'] }
let g:LanguageClient_serverCommands['cpp'] = { 'name': 'ccls', 'command': ['ccls'] }
let g:LanguageClient_serverCommands['tex'] = { 'name': 'texlab', 'command': ['texlab'] }
let g:LanguageClient_serverCommands['bib'] = { 'name': 'texlab', 'command': ['texlab'] }
let g:LanguageClient_serverCommands['sh'] = { 'name': 'bash-language-server', 'command': ['bash-language-server', 'start'] }
let g:LanguageClient_serverCommands['vim'] = { 'name': 'texlab', 'command': ['vim-language-server', '--stdio'] }

let my_conda_root = '/home/parantapa/miniconda3'
function! LCPythonSetup(conda_env)
    let cmd = g:my_conda_root . '/envs/' . a:conda_env . '/bin/pyls'
    let g:LanguageClient_serverCommands['python'] = { 'name': 'pyls', 'command': [cmd] }

    let g:my_deoplete_sources['python'] = deepcopy(g:my_deoplete_sources['_'])
    call add(g:my_deoplete_sources['python'], 'LanguageClient')
    call deoplete#custom#option('sources', g:my_deoplete_sources)
endfunction
command! -nargs=1 LCPythonSetup call LCPythonSetup(<q-args>)
