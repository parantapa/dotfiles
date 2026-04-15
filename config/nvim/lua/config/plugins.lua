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
            branch = 'main',
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

        { 'lark-parser/vim-lark-syntax', },
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
vim.api.nvim_create_user_command('Search', [[lua FzfLua.live_grep()]], {})

-- Nvim Treesitter {{{1

local ts_langs = {
    "c", "cpp", "python", "javascript", "sql",
    "lua", "vim", "vimdoc",
    "bash", "fish",
    "json", "toml", "markdown", "markdown_inline", "rst"
}

require('nvim-treesitter').install(ts_langs)

for _, lang in ipairs(ts_langs) do
    vim.api.nvim_create_autocmd('FileType', {
        pattern = { lang },
        callback = function() vim.treesitter.start() end,
    })
end

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

vim.lsp.config['lua_ls'] = {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

vim.lsp.config['clangd'] = {
    cmd = { 'clangd', '--log=info' },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
}

vim.lsp.enable('vimls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('pyright')
vim.lsp.enable('clangd')
vim.lsp.enable('cmake')
vim.lsp.enable('bashls')
vim.lsp.enable('protols')

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

    if vim.bo.filetype == "cpp" then
        vim.cmd("silent! %s!#pragma omp!// #pragma omp")
    end

    require("conform").format({
            async = true,
            lsp_format = "fallback",
            range = range
        },
        function(err, did_edit)
            if vim.bo.filetype == "cpp" then
                vim.cmd("silent! %s!// #pragma omp!#pragma omp")
            end
        end)
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
