" .vimrc
"
" Preamble ---------------------------------------------------------------- {{{

runtime bundle/pathogen/autoload/pathogen.vim

filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

set nocompatible
set nomodeline

" }}}
" Basic options ----------------------------------------------------------- {{{

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

set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set fillchars=diff:░
set backspace=indent,eol,start
set showbreak=↪

" }}}
" Wildmenu completion ----------------------------------------------------- {{{

set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.pyc                            " Python byte code

" }}}
" Tabs, spaces, wrapping -------------------------------------------------- {{{

set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab
set textwidth=80
set formatoptions=qrn1
set colorcolumn=+1
set shiftround

" }}}
" Backups ----------------------------------------------------------------- {{{

set undodir=~/.vim/tmp/undo//
set undofile
set undoreload=10000

set backupdir=~/.vim/tmp/backup//
set backup

set directory=~/.vim/tmp/swap//

" }}}
" Leader ------------------------------------------------------------------ {{{

let mapleader = ","
let maplocalleader = "\\"

" }}}
" Color scheme ------------------------------------------------------------ {{{

syntax on
set background=dark

colorscheme molokai
if &t_Co < 256
    colorscheme desert
end

" }}}
" Status line ------------------------------------------------------------- {{{

augroup ft_statuslinecolor
    au!

    au InsertEnter * hi StatusLine ctermfg=196 guifg=#FF3145
    au InsertLeave * hi StatusLine ctermfg=130 guifg=#CD5907
augroup END

set statusline=%f       " Path.
set statusline+=%m      " Modified flag.
set statusline+=%r      " Readonly flag.
set statusline+=%w      " Preview window flag.

set statusline+=\ 
set statusline+=%#redbar#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

set statusline+=%=                              " Right align.
set statusline+=(
set statusline+=%{&ff}                          " Format (unix/DOS).
set statusline+=/
set statusline+=%{strlen(&fenc)?&fenc:&enc}     " Encoding (utf-8).
set statusline+=/
set statusline+=%{&ft}                          " Type (python).
set statusline+=)

" Line and column position and counts.
set statusline+=\ (line\ %l\/%L,\ col\ %03c)

" }}}
" Searching and movement -------------------------------------------------- {{{

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault

set scrolloff=3
set sidescrolloff=10

set wrap
set sidescroll=1

set virtualedit+=block

" Don't move on *
nnoremap * *<C-o>

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L g_

" Heresy
inoremap <C-a> <esc>I
inoremap <C-e> <esc>A

" Too many shifts
nnoremap ; :

nnoremap <C-h> :lrewind<CR>
nnoremap <C-j> :lnext<CR>
nnoremap <C-k> :lprev<CR>
" nnoremap <M-k> :cnext<CR>
" nnoremap <M-l> :cprev<CR>

" }}}
" Folding ----------------------------------------------------------------- {{{

set foldlevelstart=0

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO

function! MyFoldText() " {{{
   let line = getline(v:foldstart)

   let nucolwidth = &fdc + &number * &numberwidth
   let windowwidth = winwidth(0) - nucolwidth - 3
   let foldedlinecount = v:foldend - v:foldstart

   " expand tabs into spaces
   let onetab = strpart('          ', 0, &tabstop)
   let line = substitute(line, '\t', onetab, 'g')

   let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
   let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
   return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}
" Various filetype-specific stuff ----------------------------------------- {{{

" C {{{

augroup ft_c
    au!
    au FileType c setlocal foldmethod=syntax
    au FileType c setlocal noet sw=8 sts=8
augroup END

" }}}
" ReStructuredText {{{

augroup ft_rest
    au!

    au Filetype rst nnoremap <buffer> <localleader>1 yypVr=
    au Filetype rst nnoremap <buffer> <localleader>2 yypVr-
    au Filetype rst nnoremap <buffer> <localleader>3 yypVr~
    au Filetype rst nnoremap <buffer> <localleader>4 yypVr`
    au FileType rst setlocal spell spelllang=en
augroup END

" }}}
" Vim {{{

augroup ft_vim
    au!

    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=78
    " au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END

" }}}
" Tex {{{

augroup ft_tex
    au!

    au FileType tex setlocal spell spelllang=en
augroup END

" }}}

" }}}
" Quick editing ----------------------------------------------------------- {{{

nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>et :edit ~/.tmux.conf<cr>

autocmd BufWritePost .vimrc source %

" }}}
" Shell ------------------------------------------------------------------- {{{

function! s:ExecuteInShell(command) " {{{
    let command = join(map(split(a:command), 'expand(v:val)'))
    let winnr = bufwinnr('^' . command . '$')
    silent! execute  winnr < 0 ? 'botright vnew ' . fnameescape(command) : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap nonumber
    echo 'Execute ' . command . '...'
    silent! execute 'silent %!'. command
    silent! redraw
    silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>:AnsiEsc<CR>'
    silent! execute 'nnoremap <silent> <buffer> q :q<CR>'
    silent! execute 'AnsiEsc'
    echo 'Shell command ' . command . ' executed.'
endfunction " }}}
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
nnoremap <leader>! :Shell

" }}}
" Convenience mappings ---------------------------------------------------- {{{

" I dont use ex mode
map Q gq

" Clean whitespace
map <leader>W  :%s/\s\+$//<cr>:let @/=''<CR>

" Substitute
nnoremap <leader>s :%s/\v

" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Toggle paste
set pastetoggle=<F6>

" }}}
" Plugin settings --------------------------------------------------------- {{{

" Gundo {{{

    nnoremap <F5> :GundoToggle<CR>
    let g:gundo_debug = 1
    let g:gundo_preview_bottom = 1

" }}}
" NERD Tree {{{

    noremap  <F2> :NERDTreeToggle<cr>

" }}}
" Latex {{{

    let g:tex_flavor = 'latex'

" }}}
" Syntastic {{{

    let g:syntastic_enable_signs = 1
    let g:syntastic_stl_format = '[%E{Error 1/%e: line %fe}%B{, }%W{Warning 1/%w: line %fw}]'
    let g:syntastic_c_compiler_options = ' -Wall -Wextra'
    let g:syntastic_python_checker = 'pylint'

" }}}
" Ack {{{

    nnoremap <Leader>a :Ack!

" }}}
" Pydoc {{{

    let g:pydoc_cmd = 'pydoc'
    let g:pydoc_open_cmd = 'split'
    let g:pydoc_highlight = 0
    autocmd FileType python nnoremap <leader>pyd :Pydoc 

" }}}
" Pep8 {{{

    let g:no_pep8_maps = 1
    autocmd FileType python noremap <leader>pep :call Pep8()<CR>

" }}}
"
" }}}

