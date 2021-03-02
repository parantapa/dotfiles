" Extra plugin configs
" Enable these if only if you have python, lua, pynvim, and Vim8+ support

" Gundo {{{1

nnoremap <F5> :GundoToggle<CR>
let g:gundo_right = 1
let g:gundo_prefer_python3 = 1


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
    \ ['file/mru', 'Denite file_mru -start-filter'],
    \ ['file/rec', 'Denite file/rec -start-filter'],
    \ ['grep', 'Denite grep -path=.'],
    \ ['tag', 'Denite tag -start-filter'],
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

" Coc.nvim and coc-snippets {{{1

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" " Use tab for trigger completion with characters ahead and navigate.
" " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" " other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Make <tab> used for trigger completion, completion confirm, snippet expand and jump.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Use <c-space> to trigger completion.
" if has('nvim')
"  inoremap <silent><expr> <c-space> coc#refresh()
" else
"  inoremap <silent><expr> <c-@> coc#refresh()
" endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible()
    \ ? coc#_select_confirm()
    \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
" if has('nvim-0.4.0') || has('patch-8.2.0750')
"   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <localleader>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <localleader>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <localleader>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <localleader>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <localleader>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <localleader>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <localleader>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <localleader>p  :<C-u>CocListResume<CR>

 " Use <C-l> for trigger snippet expand.
" imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
" vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
" imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

" Edit user snippet of current filetype
cnoreabbrev es CocCommand snippets.editSnippets
