-- Bootstrap lazy.nvim {{{1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' }
        },
        {
            "sainnhe/gruvbox-material",
            dependencies = { 'nvim-lualine/lualine.nvim' },
        },
        { 'numToStr/Comment.nvim', },
        { 'mbbill/undotree', },
        {
            "ibhagwan/fzf-lua",
            dependencies = { "nvim-tree/nvim-web-devicons" },
        },
        {
            "nvim-treesitter/nvim-treesitter",
            branch = 'master',
            build = ":TSUpdate"
        },
        { 'HiPhish/rainbow-delimiters.nvim', },
        { 'neovim/nvim-lspconfig', },
        { 'stevearc/conform.nvim', },

        { 'hrsh7th/cmp-nvim-lsp', },
        { 'hrsh7th/cmp-buffer', },
        { 'hrsh7th/cmp-path', },
        { 'hrsh7th/cmp-cmdline', },
        { 'hrsh7th/nvim-cmp', },

        { 'hrsh7th/cmp-vsnip', },
        { 'hrsh7th/vim-vsnip', },
    },
    checker = { enabled = false },
    config = {
        defaults = {
            lazy = false
        }
    }
})

-- Lualine {{{1

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

-- Gurvbox Material {{{1

if vim.env['COLORTERM'] == 'truecolor' then
    vim.opt.termguicolors = true
    vim.opt.background = 'dark'
    vim.g.gruvbox_material_background = 'hard'
    vim.g.gruvbox_material_foreground = 'original'
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_sign_column_background = 'grey'

    vim.cmd([[colorscheme gruvbox-material]])
end

-- Comment.nvim {{{1

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

-- Undotree {{{1

vim.keymap.set('n', '<F5>', '<Cmd>UndotreeToggle<CR>')

-- Fzf.lua {{{1

require("fzf-lua").setup {}

vim.api.nvim_create_user_command('EditConfig', [[lua FzfLua.files({ cwd = '~/.config/nvim/lua/config' })]], {})
vim.api.nvim_create_user_command('Files', [[lua FzfLua.files()]], {})
vim.api.nvim_create_user_command('RecentFiles', [[lua FzfLua.oldfiles()]], {})
vim.api.nvim_create_user_command('Grep', [[lua FzfLua.live_grep_glob()]], {})

-- Nvim Treesitter {{{1

require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all"
    ensure_installed = { "c", "cpp", "python", "lua", "bash", "fish", "vim", "vimdoc", "json", "toml", "sql", "markdown", "markdown_inline", "rst", "javascript" },

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
        updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
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

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.esl = {
    install_info = {
        url = "~/workspace/tree-sitter-esl",    -- local path or git repo
        files = { "src/parser.c" },             -- note that some parsers also require src/scanner.c or src/scanner.cc
        -- optional entries:
        branch = "main",                        -- default branch in case of git repo if different from master
        generate_requires_npm = false,          -- if stand-alone parser without npm dependencies
        requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
    },
    filetype = "esl",                           -- if filetype does not match the parser name
}

-- Rainbow Delimiters {{{1

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

-- LSP Configs {{{1

local lspconfig = require('lspconfig')

lspconfig.vimls.setup {}

lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

lspconfig.pyright.setup {}

lspconfig.clangd.setup {
    cmd = { 'clangd', '--log=info' }
}

lspconfig.bashls.setup {}

lspconfig.cmake.setup {}

lspconfig.ts_ls.setup {}

-- Conform.nvim {{{1

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

-- Nvim CMP Setup {{{1

local cmp = require('cmp')

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

        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
