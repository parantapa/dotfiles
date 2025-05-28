" Vim-Plug Setup {{{1
call plug#begin()

Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'altercation/vim-colors-solarized'

Plug 'numToStr/Comment.nvim'
Plug 'mbbill/undotree'

Plug 'godlygeek/tabular'
Plug 'yssl/QFEnter'

Plug 'junegunn/fzf.vim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'HiPhish/rainbow-delimiters.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'stevearc/conform.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'Julian/lean.nvim'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

" Plug 'GutenYe/json5.vim'
" Plug 'dag/vim-fish'
" Plug 'mitsuhiko/vim-jinja'
" Plug 'cespare/vim-toml'
" Plug 'nono/lezer.vim'
" Plug 'rbberger/vim-singularity-syntax'
" Plug 'rkaminsk/vim-syntax-clingo'

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

" Comment.nvim {{{1

lua <<EOF
require('Comment').setup({
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
        ---Line-comment toggle keymap
        line = 'gcc',
        ---Block-comment toggle keymap
        block = 'gbc',
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = 'gc',
        ---Block-comment keymap
        block = 'gb',
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        -- above = 'gcO',
        above = nil,
        ---Add comment on the line below
        -- below = 'gco',
        below = nil,
        ---Add comment at the end of line
        -- eol = 'gcA',
        eol = nil,
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = false,
    },
    ---Function to call before (un)comment
    pre_hook = nil,
    ---Function to call after (un)comment
    post_hook = nil,
})
EOF

" Undotree {{{1

nnoremap <F5> :UndotreeToggle<CR>

" QFEnter {{{1

let g:qfenter_open_map = ['<CR>', '<2-LeftMouse>']
let g:qfenter_vopen_map = ['<C-V>']
let g:qfenter_hopen_map = ['<C-S>']
let g:qfenter_topen_map = ['<C-T>']

" Nvim TreeSitter {{{1

lua << EOF
require'nvim-treesitter.configs'.setup({
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "python", "lua", "bash", "fish", "vim", "vimdoc", "json", "toml", "sql", "markdown", "markdown_inline", "rst", "javascript"},

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
})

-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
--
-- parser_config.esl = {
--     install_info = {
--         url = "~/workspace/tree-sitter-esl",
--         files = {"src/parser.c"},
--         branch = "main",
--         generate_requires_npm = false,
--         requires_generate_from_grammar = false,
--     },
--     filetype = "esl",
-- }
EOF

" Rainbow Delimiters {{{1

lua <<EOF
vim.g.rainbow_delimiters = {
    strategy = {
        [''] = 'rainbow-delimiters.strategy.global',
        vim = 'rainbow-delimiters.strategy.local',
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    priority = {
        [''] = 110,
        lua = 210,
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
}
EOF


" CMP Setup {{{1

lua <<EOF
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
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
    { name = 'vsnip' },
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

" LSP Configs {{{1
lua << EOF
local lspconfig = require('lspconfig')

lspconfig.vimls.setup{}

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
        diagnostics = {
            globals = { 'vim' }
    }
    }
  }
})

lspconfig.pyright.setup{}

lspconfig.clangd.setup{
    cmd = {'clangd', '--log=info'}
}

lspconfig.bashls.setup{}

lspconfig.cmake.setup{}

lspconfig.ts_ls.setup{}
EOF

" Conform.nvim {{{1

lua << EOF
require("conform").setup({
  formatters_by_ft = {
    python = { "black" },
  },
})

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })
EOF

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

" Markdown Preview {{{1
"

" specify browser to open preview page for path with space
let g:mkdp_browser = '/usr/bin/firefox-developer-edition'

" set to 1, echo preview page URL in command line when opening preview page
" default is 0
let g:mkdp_echo_preview_url = 1

" options for Markdown rendering
" mkit: markdown-it options for rendering
" katex: KaTeX options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: whether to disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: means the cursor position is always at the middle of the preview page
"   top: means the Vim top viewport always shows up at the top of the preview page
"   relative: means the cursor position is always at relative positon of the preview page
" hide_yaml_meta: whether to hide YAML metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
" disable_filename: if disable filename header for preview page, default: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0,
    \ 'toc': {}
    \ }

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

" recognized filetypes
" these filetypes will have MarkdownPreview... commands
let g:mkdp_filetypes = ['markdown']

" set default theme (dark or light)
" By default the theme is defined according to the preferences of the system
let g:mkdp_theme = 'dark'

nmap <Leader>p <Plug>MarkdownPreviewToggle
