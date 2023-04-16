" Simple vimrc
"
" Don't put in anything that depends on extra plugins.
" Also dont assume utf-8 font support in terminal.
"
" Preamble {{{1

filetype plugin indent on

set nocompatible
set nomodeline

" Basic options {{{1

set encoding=utf-8
set autoindent
set showmode
set showcmd
set cursorline
set ttyfast
set lazyredraw
set laststatus=2
set history=1000
set shell=/bin/bash
set matchtime=3
set title
set hidden

set ruler
set nonumber

set splitbelow
set splitright

set notimeout
set nottimeout

set autoread
set autowrite

set listchars=tab:>-,eol:<,extends:>,precedes:<
set fillchars=diff:@
set backspace=indent,eol,start
set showbreak=+++\  " add a space in the end

set cmdheight=1
set updatetime=300
set shortmess+=c

" Use system clipboard as default register {{{1

if has('unnamedplus')
    set clipboard=unnamedplus
endif

" Tabs, spaces, wrapping, Indent {{{1

set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab
set textwidth=80
set formatoptions=qrn1
set shiftround

set colorcolumn=+1

" Tab settings for different filetypes
augroup ft_tab_settings
    autocmd!

    autocmd FileType c setlocal noet sw=4 sts=4
    autocmd FileType cpp setlocal noet sw=4 sts=4
    autocmd FileType go setlocal noet sw=4 sts=4 ts=4

    autocmd FileType html setlocal sw=2 sts=2
    autocmd FileType xml setlocal sw=2 sts=2
    autocmd FileType tex setlocal sw=2 sts=2
    autocmd FileType rst setlocal sw=2 sts=2

    autocmd FileType snippets setlocal noet ts=4
augroup END

" Backups and Spell Files {{{1
set undofile
set undoreload=1000

set backupdir=~/.local/share/nvim/backup//
set backup

let g:my_spellfile = expand("~/quickrefs/myspell.utf-8.add")
if filereadable(g:my_spellfile)
    let &spellfile = g:my_spellfile
    let &dictionary = g:my_spellfile

    " The spell file may be updated outside of vim
    execute "silent mkspell! " . g:my_spellfile
endif
set spelllang=en_us

" Leader {{{1

let mapleader = ","
let maplocalleader = "\\"

" Color scheme {{{1

syntax on
set background=dark
colorscheme desert

" Status line {{{1

augroup ft_statuslinecolor
    au!

    au InsertEnter * hi StatusLine ctermfg=196 guifg=#FF3145
    au InsertLeave * hi StatusLine ctermfg=130 guifg=#CD5907
augroup END

let g:my_statusline = []
" Path, Modifed, Readonly, Preview
call add(g:my_statusline, "%f%m%r%w")
" Right align
call add(g:my_statusline, "%=")
" (Format/Encoding/Filetype)
call add(g:my_statusline, "(%{&ff}/%{strlen(&fenc)?&fenc:&enc}/%{&ft})")
" Line and column position and counts.
call add(g:my_statusline, " (line %l/%L, col %03c)")

let &statusline = join(g:my_statusline, "")


" Searching and movement {{{1

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault
set nowrapscan

set scrolloff=3
set sidescrolloff=10

set wrap
set linebreak
set sidescroll=1

set virtualedit+=block

" Don't move on *
nnoremap * *<C-o>

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L g_

" Replacement for , as movement shortcut
noremap - ,

" Search for Visually selected text with * {{{1
" http://vim.wikia.com/wiki/VimTip171

function! VSetSearch()
    let old_reg = @"
    normal! gvy
    let @/ = '\V' . @"
    normal! gV
    let @" = old_reg
endfunction

" Set the search pattern register and do a search with last pattern
" Then return to the previous position
vnoremap <silent> * :<C-U>call VSetSearch()<CR>/<CR><C-o>

" Folding {{{1

set foldlevelstart=0
set nofoldenable
set foldmethod=marker

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

function! FoldToggle()
    if &foldenable == 1
        normal zRzn
    else
        normal zMzN
    endif
endfunction

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
" nnoremap zO zCzO
command! -nargs=0 FoldToggle :call FoldToggle()<CR>

" Default completion {{{1

set complete=.,w,b,u,t,i,k
set completeopt=menuone

" Strip {{{1

function! Strip(input_string)
    return substitute(a:input_string, '\v\C^[ \t\n\r]*(.{-})[ \t\n\r]*$', '\1', '')
endfunction

" Convenience mappings {{{1

" I dont use ex mode
nnoremap Q gq
vnoremap Q gq

" Better shortcut for copy the rest of the line
nnoremap Y yg_

" Clean whitespace
nnoremap <Leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Emacs bindings in command line mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-k> <C-\>estrpart(getcmdline(), 0, getcmdpos()-1)<CR>

" Sudo to write
cnoremap w!! set buftype=nowrite <bar> w !sudo tee % >/dev/null

" Toggle spell
nnoremap <F3> :setlocal spell!<CR>

" Shortcuts for completion
inoremap <C-f> <C-x><C-f>
inoremap <C-l> <C-x><C-l>
inoremap <C-Space> <C-x><C-o>

" On C-l also set nohlsearch and diffupdate
nnoremap <silent> <C-l> :nohlsearch<CR>:diffupdate<CR><C-l>

nnoremap ,gs yi{:OpenSearch <C-r>" gs

" Quick editing {{{1

cnoreabbrev ev edit <C-r>=$MYVIMRC<CR>

" QuickRefs {{{1

command! -nargs=0 QuickrefSync !git-sync
cnoreabbrev qrs QuickrefSync

command! -nargs=0 QuickrefTag !rstindextags -f
cnoreabbrev qrt QuickrefTag


" General command mode abbreveations {{{1

cnoreabbrev mk !make quick
cnoreabbrev mkf !make
cnoreabbrev mkc !make clean

" Various filetype-specific stuff {{{1


" Latex {{{2

augroup ft_tex
    au!

    au Filetype tex setlocal iskeyword+=-
    au Filetype bib setlocal iskeyword+=-
    "    au Filetype tex setlocal errorformat=%f:%l:\ %m,%f:%l-%\\d%\\+:\ %m
    "    au Filetype bib setlocal errorformat=%f:%l:\ %m,%f:%l-%\\d%\\+:\ %m
augroup END


" Python {{{2

augroup ft_python
    au!

    au FileType python setlocal commentstring=#\ %s
augroup END

" Text {{{2

augroup ft_text
    au!

    au Filetype text setlocal formatoptions-=n
augroup END

" Setup stuff depending on filename/extension {{{1
augroup ft_setup
    au!

    " Setup the proper filetype
    autocmd BufReadPost,BufNewFile *.md setlocal ft=markdown

    autocmd BufReadPost,BufNewFile *.plot setlocal ft=gnuplot
    autocmd BufReadPost,BufNewFile *.js setlocal ft=javascript
    autocmd BufReadPost,BufNewFile *.jinja2 setlocal ft=jinja
    autocmd BufReadPost,BufNewFile *.sshconfig setlocal ft=sshconfig
    autocmd BufReadPost,BufNewFile *.pyx setlocal ft=pyrex

    autocmd BufReadPost,BufNewFile bashrc_* setlocal ft=sh

    autocmd BufReadPost,BufNewFile .babelrc setlocal ft=javascript
    autocmd BufReadPost,BufNewFile .eslintrc setlocal ft=javascript
augroup END

" Use ripgrep when available {{{1

if executable("rg")
    set grepprg=rg\ --vimgrep
    set grepformat^=%f:%l:%c:%m
endif

