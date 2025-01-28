" Use system python
let g:python3_host_prog="/usr/bin/python"

" Vim-Plug Setup {{{1
call plug#begin()

Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'altercation/vim-colors-solarized'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'sjl/gundo.vim'
Plug 'godlygeek/tabular'
Plug 'yssl/QFEnter'
Plug 'ggandor/lightspeed.nvim'

Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

Plug 'GutenYe/json5.vim'
Plug 'dag/vim-fish'
Plug 'mitsuhiko/vim-jinja'
Plug 'cespare/vim-toml'
Plug 'lark-parser/vim-lark-syntax'
Plug 'nono/lezer.vim'

Plug 'luochen1990/rainbow'
Plug 'rbberger/vim-singularity-syntax'

let g:rainbow_active = 0 "set to 0 if you want to enable it later via :RainbowToggle

" Initialize plugin system
call plug#end()

" Colorscheme {{{1

if $COLORTERM == 'truecolor'
    set termguicolors
    set background=dark
    let g:gruvbox_material_background = 'hard'
    let g:gruvbox_material_foreground = 'original'
    let g:gruvbox_material_enable_bold = 1
    let g:gruvbox_material_enable_italic = 1
    let g:gruvbox_material_sign_column_background = 'grey'
    colorscheme gruvbox-material
endif

" Latex {{{1

" let g:tex_flavor = 'latex'
let g:tex_comment_nospell = 1

" SQL {{{1

let g:sql_type_default = 'mysql'

" QFEnter {{{1

let g:qfenter_open_map = ['<CR>', '<2-LeftMouse>']
let g:qfenter_vopen_map = ['<C-V>']
let g:qfenter_hopen_map = ['<C-S>']
let g:qfenter_topen_map = ['<C-T>']

" Commentary {{{1

let g:commentary_map_keys = 0
xmap gc  <Plug>Commentary
nmap gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine
nmap gcu <Plug>CommentaryUndo

" Surround {{{1

let g:surround_116 = "{{\r}}" " t == 116
let g:surround_102 = "{\r}" " f == 116

" Gundo {{{1

nnoremap <F5> :GundoToggle<CR>
let g:gundo_right = 1
let g:gundo_prefer_python3 = 1

" FZF {{{1

let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }

" FZF Quickref Index {{{1

function! s:JumpListHandler(lines)
    let parts = split(a:lines[1], '\t')

    if a:lines[0] == 'ctrl-t'
        let cmd = printf('tabedit +%d %s', parts[2], parts[1])
    elseif a:lines[0] == 'ctrl-v'
        let cmd = printf('vsplit +%d %s', parts[2], parts[1])
    elseif a:lines[0] == 'ctrl-x'
        let cmd = printf('split +%d %s', parts[2], parts[1])
    else
        let cmd = printf('edit +%d %s', parts[2], parts[1])
    endif

    execute cmd
endfunction

function! s:Headings()
    let spec = {
        \ 'source': 'quickrefs-index heading-jumplist --color',
        \ 'options': '-n 1 --prompt "Headings> " --ansi --delimiter "\t" --tabstop 4 ' .
        \            '--expect=ctrl-t,ctrl-v,ctrl-x' ,
        \ 'sink*': function('s:JumpListHandler')
    \ }

    call fzf#run(fzf#wrap(spec))
endfunction

command! -nargs=0 Headings call s:Headings()
cnoreabbrev he Headings

function! s:BuildQuickrefIndex()
    wall
    call system('quickrefs-index build')
endfunction

command! -nargs=0 BuildQuickrefIndex call s:BuildQuickrefIndex()
cnoreabbrev buildquickrefindex BuildQuickrefIndex

augroup ft_quickrefs
    au!

    autocmd BufWritePost /home/parantapa/quickrefs/*.rst BuildQuickrefIndex
augroup END

inoremap <expr> <c-x><c-h> fzf#vim#complete('quickrefs-index print-all-headings')

function! s:PopulateHeadingQFList()
    execute 'normal! "hyi`'
    let lines = systemlist(printf("quickrefs-index jump-to-heading '%s'", @h))
    let qflist = []
    for line in lines
        let parts = split(line, '\t')
        if len(parts) == 2
            let qf = {'filename': parts[0], 'lnum': str2nr(parts[1])}
            call add(qflist, qf)
        endif
    endfor
    if empty(qflist)
        echom printf("Heading not found: '%s'", @h)
    else
        call setqflist(qflist)
        cc!
    endif
endfunction

command! -nargs=0 PopulateHeadingQFList call s:PopulateHeadingQFList()
nnoremap gh :<C-u>PopulateHeadingQFList<CR>

function! s:Deadlines()
    let spec = {
        \ 'source': 'quickrefs-index deadline-jumplist --color',
        \ 'options': '-n 1 --prompt "Deadlines> " --ansi --delimiter "\t" --tabstop 4 ' .
        \            '--expect=ctrl-t,ctrl-v,ctrl-x' ,
        \ 'sink*': function('s:JumpListHandler')
    \ }

    call fzf#run(fzf#wrap(spec))
endfunction

command! -nargs=0 Deadlines call s:Deadlines()
cnoreabbrev deadlines Deadlines

function! s:TODOs()
    let spec = {
        \ 'source': 'quickrefs-index todo-jumplist --color',
        \ 'options': '-n 1 --prompt "TODOs> " --ansi --delimiter "\t" --tabstop 4 ' .
        \            '--expect=ctrl-t,ctrl-v,ctrl-x' ,
        \ 'sink*': function('s:JumpListHandler')
    \ }

    call fzf#run(fzf#wrap(spec))
endfunction

command! -nargs=0 TODOs call s:TODOs()
cnoreabbrev todos TODOs


" Coc.nvim {{{1

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" " Mappings for CoCList
" " Show all diagnostics
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

let g:coc_filetype_map = { 'python_wrs': 'python' } 


" CoC Snippets {{{1

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

" Edit user snippet of current filetype
cnoreabbrev es CocCommand snippets.editSnippets

" Nvim TreeSitter {{{1

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "python", "javascript", "svelte", "lua", "bash", "fish", "vim", "json", "json5", "toml", "sql", "julia"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

parser_config.sqlpygen = {
    install_info = {
        url = "~/workspace/sqlpygen3/tree-sitter-sqlpygen", -- local path or git repo
        files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
        branch = "main", -- default branch in case of git repo if different from master
        generate_requires_npm = false, -- if stand-alone parser without npm dependencies
        requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
    },
    filetype = "sqlpygen", -- if filetype does not match the parser name
}

parser_config.esl = {
    install_info = {
        url = "~/workspace/tree-sitter-esl", -- local path or git repo
        files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
        branch = "main", -- default branch in case of git repo if different from master
        generate_requires_npm = false, -- if stand-alone parser without npm dependencies
        requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
    },
    filetype = "esl", -- if filetype does not match the parser name
}

parser_config.gdsl = {
    install_info = {
        url = "~/workspace/tree-sitter-gdsl", -- local path or git repo
        files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
        branch = "main", -- default branch in case of git repo if different from master
        generate_requires_npm = false, -- if stand-alone parser without npm dependencies
        requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
    },
    filetype = "gdsl", -- if filetype does not match the parser name
}

parser_config.jinja2 = {
    install_info = {
        url = "~/workspace/tree-sitter-jinja2", -- local path or git repo
        files = {"src/parser.c",}, -- note that some parsers also require src/scanner.c or src/scanner.cc
        branch = "main", -- default branch in case of git repo if different from master
        generate_requires_npm = false, -- if stand-alone parser without npm dependencies
        requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
    },
    filetype = "jinja2", -- if filetype does not match the parser name
}

parser_config.python_wrs = {
    install_info = {
        url = "~/workspace/tree-sitter-python-wrs", -- local path or git repo
        files = {"src/parser.c", "src/scanner.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
        branch = "main", -- default branch in case of git repo if different from master
        generate_requires_npm = false, -- if stand-alone parser without npm dependencies
        requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
    },
    filetype = "python_wrs", -- if filetype does not match the parser name
}


parser_config.stan = {
    install_info = {
        url = "~/workspace/tree-sitter-stan", -- local path or git repo
        files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
        branch = "main", -- default branch in case of git repo if different from master
        generate_requires_npm = false, -- if stand-alone parser without npm dependencies
        requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
    },
    filetype = "stan", -- if filetype does not match the parser name
}

EOF

