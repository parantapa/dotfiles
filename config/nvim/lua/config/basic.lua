-- Simple vimrc
-- Don't put in anything that depends on extra plugins.

-- Preamble {{{1

vim.cmd([[
filetype plugin indent on
]])

vim.opt.modeline = false

-- Basic options {{{1

vim.opt.cursorline = true
vim.opt.lazyredraw = true
vim.opt.shell = '/bin/bash'
vim.opt.title = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.timeout = false
vim.opt.ttimeout = false
vim.opt.autowrite = true
vim.opt.listchars = { tab = '>-', eol = '<', extends = '>', precedes = '<' }
vim.opt.fillchars = { diff = '@' }
vim.opt.showbreak = '+++ '
vim.opt.updatetime = 300
vim.opt.shortmess:append({ c = true })

--  Use system clipboard as default register {{{1

vim.opt.clipboard = 'unnamedplus'

-- Tabs, spaces, wrapping, Indent {{{1

vim.opt.tabstop = 8
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.textwidth = 80
vim.opt.formatoptions = 'qrn1'
vim.opt.shiftround = true

vim.opt.colorcolumn = '+1'

-- Add filetypes

vim.filetype.add({
    extension = {
        esl = 'esl',
    }
})

-- Tab settings for different filetypes

local ft_tab_settings = vim.api.nvim_create_augroup('ft_tab_settings', { clear = true })

for _, pattern in ipairs({ 'c', 'cpp' }) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = pattern,
        group = ft_tab_settings,
        callback = function()
            vim.opt_local.expandtab = false
            vim.opt_local.shiftwidth = 4
            vim.opt_local.softtabstop = 4
        end
    })
end
for _, pattern in ipairs({ 'tex', 'rst' }) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = pattern,
        group = ft_tab_settings,
        callback = function()
            vim.opt_local.expandtab = true
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
        end
    })
end


-- Backups and Spell Files {{{1

vim.opt.undofile = true

vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand('~/.local/share/nvim/backup/')

local my_spellfile = vim.fn.expand('~/quickrefs/myspell.utf-8.add')
if vim.fn.filereadable(my_spellfile) == 1 then
    vim.opt.spellfile = my_spellfile
    vim.opt.dictionary = my_spellfile

    -- The spell file may be updated outside of vim
    vim.cmd('silent mkspell! ' .. my_spellfile)
end

vim.opt.spelllang = 'en_us'

-- Leader {{{1

vim.g.mapleader = ','
vim.g.maplocalleader = '\\'

-- Color scheme {{{1

vim.cmd([[
syntax on
set background=dark
colorscheme desert
]])

-- Searching and movement {{{1

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.hlsearch = true
vim.opt.gdefault = true
vim.opt.wrapscan = false

vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 10

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.sidescroll = 1

vim.opt.virtualedit:append({ block = true })

-- Don't move on *
vim.keymap.set('n', '*', '*<C-o>')

-- Replacement for , as movement shortcut
vim.keymap.set('n', '-', ',')

-- Folding {{{1

vim.opt.foldlevelstart = 0
vim.opt.foldenable = false
vim.opt.foldmethod = 'marker'

-- Space to toggle folds.
vim.keymap.set('n', '<Space>', 'za')
vim.keymap.set('v', '<Space>', 'za')

-- Convenience mappings {{{1

-- I dont use ex mode
vim.keymap.set('n', 'Q', 'gq')
vim.keymap.set('v', 'Q', 'gq')

-- Better shortcut for copy the rest of the line
vim.keymap.set('n', 'Y', 'yg_')

-- Clean whitespace
vim.keymap.set('n', '<Leader>W', [[<Cmd>:%s/\s\+$//<CR>:let @/=''<CR>]])

-- Emacs bindings in command line mode
vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-e>', '<End>')
vim.keymap.set('c', '<C-k>', [[<C-\>estrpart(getcmdline(), 0, getcmdpos()-1)<CR>]])

-- Toggle spell
vim.keymap.set('n', '<F3>', '<Cmd>setlocal spell!<CR>')

-- General command mode abbreviations {{{1

vim.cmd([[
cnoreabbrev mk !make quick
cnoreabbrev mkall !make
cnoreabbrev mkclean !make clean
]])
