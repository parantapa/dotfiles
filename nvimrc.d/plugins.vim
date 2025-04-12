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

Plug 'junegunn/fzf.vim'
Plug 'HiPhish/rainbow-delimiters.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'GutenYe/json5.vim'
Plug 'dag/vim-fish'
Plug 'mitsuhiko/vim-jinja'
Plug 'cespare/vim-toml'
Plug 'nono/lezer.vim'
Plug 'rbberger/vim-singularity-syntax'
Plug 'rkaminsk/vim-syntax-clingo'

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

" Rainbow Delimiters {{{1
let g:rainbow_delimiters = {
    \ 'strategy': {
        \ '': rainbow_delimiters#strategy.global,
        \ 'vim': rainbow_delimiters#strategy.local,
    \ },
    \ 'query': {
        \ '': 'rainbow-delimiters',
        \ 'lua': 'rainbow-blocks',
    \ },
    \ 'priority': {
        \ '': 110,
        \ 'lua': 210,
    \ },
    \ 'highlight': [
        \ 'RainbowDelimiterRed',
        \ 'RainbowDelimiterYellow',
        \ 'RainbowDelimiterBlue',
        \ 'RainbowDelimiterOrange',
        \ 'RainbowDelimiterGreen',
        \ 'RainbowDelimiterViolet',
        \ 'RainbowDelimiterCyan',
    \ ],
\ }

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

" Nvim TreeSitter {{{1

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "python", "lua", "bash", "fish", "vim", "vimdoc", "json", "json5", "toml", "sql", "markdown", "markdown_inline", "rst", "javascript", "rust", "cmake", "latex"},

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

-- parser_config.sqlpygen = {
--     install_info = {
--         url = "~/workspace/sqlpygen3/tree-sitter-sqlpygen", -- local path or git repo
--         files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
--         branch = "main", -- default branch in case of git repo if different from master
--         generate_requires_npm = false, -- if stand-alone parser without npm dependencies
--         requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
--     },
--     filetype = "sqlpygen", -- if filetype does not match the parser name
-- }
--
parser_config.esl = {
    install_info = {
        url = "~/workspace/tree-sitter-esl",
        files = {"src/parser.c"},
        branch = "main",
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
    },
    filetype = "esl",
}
--
-- parser_config.gdsl = {
--     install_info = {
--         url = "~/workspace/tree-sitter-gdsl", -- local path or git repo
--         files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
--         branch = "main", -- default branch in case of git repo if different from master
--         generate_requires_npm = false, -- if stand-alone parser without npm dependencies
--         requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
--     },
--     filetype = "gdsl", -- if filetype does not match the parser name
-- }
--
-- parser_config.jinja2 = {
--     install_info = {
--         url = "~/workspace/tree-sitter-jinja2", -- local path or git repo
--         files = {"src/parser.c",}, -- note that some parsers also require src/scanner.c or src/scanner.cc
--         branch = "main", -- default branch in case of git repo if different from master
--         generate_requires_npm = false, -- if stand-alone parser without npm dependencies
--         requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
--     },
--     filetype = "jinja2", -- if filetype does not match the parser name
-- }
--
-- parser_config.python_wrs = {
--     install_info = {
--         url = "~/workspace/tree-sitter-python-wrs", -- local path or git repo
--         files = {"src/parser.c", "src/scanner.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
--         branch = "main", -- default branch in case of git repo if different from master
--         generate_requires_npm = false, -- if stand-alone parser without npm dependencies
--         requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
--     },
--     filetype = "python_wrs", -- if filetype does not match the parser name
-- }
--

EOF


" LSP Configs {{{1
lua << EOF
local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}
lspconfig.clangd.setup{
    cmd = {'clangd', '--log=info'}
}
lspconfig.vimls.setup{}
lspconfig.bashls.setup{}
lspconfig.lua_ls.setup{}
lspconfig.cmake.setup{}
lspconfig.ts_ls.setup{}
EOF

augroup python_format
    autocmd!

    autocmd FileType python setlocal formatprg=black\ -q\ -
augroup end

command! -nargs=0 Format normal mmgg0gqG'm

" CMP Setup {{{1
"

lua <<EOF
local cmp = require('cmp')

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
        end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })
EOF

