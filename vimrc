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
set undoreload=1000

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
if has("gui_running") || &t_Co == 256
    colorscheme molokai
else
    colorscheme desert
endif

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

" Continuous window resizing
nmap         <C-W>+     <C-W>+<SID>winsize
nmap         <C-W>-     <C-W>-<SID>winsize
nmap         <C-W><     <C-W><<SID>winsize
nmap         <C-W>>     <C-W>><SID>winsize
nn <script>  <SID>winsize+   <C-W>+<SID>winsize
nn <script>  <SID>winsize-   <C-W>-<SID>winsize
nn <script>  <SID>winsize<   5<C-W><<SID>winsize
nn <script>  <SID>winsize>   5<C-W>><SID>winsize
nmap         <SID>winsize    <Nop>

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
" CPP {{{

augroup ft_cpp
    au!
    au FileType cpp setlocal foldmethod=syntax
    au FileType cpp setlocal noet sw=8 sts=8
augroup END

" }}}
" GO {{{

augroup ft_go
    au!
    au FileType go setlocal foldmethod=syntax
    au FileType go setlocal noet sw=8 sts=8
augroup END

" }}}
" HTML {{{

augroup ft_html
    au!
    au FileType html setlocal sw=2 sts=2
augroup END

" }}}
" ReStructuredText {{{

augroup ft_rest
    au!

    au Filetype rst nnoremap <buffer> <localleader>1 yypVr=
    au Filetype rst nnoremap <buffer> <localleader>2 yypVr-
    au Filetype rst nnoremap <buffer> <localleader>3 yypVr~
    au Filetype rst nnoremap <buffer> <localleader>4 yypVr`
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
" Markdown {{{

    autocmd BufReadPost *.md setlocal filetype=markdown

" }}}

" }}}
" Quick editing ----------------------------------------------------------- {{{

function! Open_ft_snippets()
    let cmd = "edit ~/.vim/bundle/snipmate-snippets/snippets/%s.snippets"
    let cmd = printf(cmd, &ft)
    execute cmd
endf

nnoremap <Leader>ev :edit $MYVIMRC<CR>
nnoremap <Leader>et :edit ~/.tmux.conf<CR>
nnoremap <Leader>es :call Open_ft_snippets()<CR>

autocmd BufWritePost .vimrc source ~/.vimrc
autocmd BufWritePost vimrc source ~/.vimrc

if has("gui_running")
    autocmd BufWritePost .gvimrc source ~/.gvimrc
    autocmd BufWritePost gvimrc source ~/.gvimrc
endif

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
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>q :q<CR>'
    silent! execute 'AnsiEsc'
    echo 'Shell command ' . command . ' executed.'
endfunction " }}}
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
nnoremap <Leader>! :Shell

" }}}
" Convenience mappings ---------------------------------------------------- {{{

" I dont use ex mode
map Q gq

" Clean whitespace
map <Leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Substitute
nnoremap <Leader>s :%s/\v

" Emacs bindings in command line mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Sudo to write
cnoremap w!! set buftype=nowrite <bar> w !sudo tee % >/dev/null

" Toggle paste
set pastetoggle=<F6>

" Toggle spell
nnoremap <F3> :setlocal spell! spelllang=en_us<CR>

" Dont use Syntastic when exiting
nnoremap :wq :au! syntastic<cr>:wq

" Use MoinMoin wiki syntax
nnoremap <Leader>moin :se ft=moin<CR>

" }}}
" Plugin settings --------------------------------------------------------- {{{

" Ctrl-P {{{

    let g:ctrlp_dotfiles = 1

" }}}
" Gundo {{{

    nnoremap <F5> :GundoToggle<CR>
    let g:gundo_right = 1

" }}}
" NERDTree {{{

    nmap <F2> :NERDTreeToggle<CR>

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

    nmap <Leader>a :Ack!

" }}}
" Tabbing {{{

    nmap <Leader>T :Tab /\v
    vmap <Leader>T :Tab /\v

" }}}
" Snippets {{{

    let g:snips_author = "Parantapa Bhattacharya <pb@parantapa.net>"

" }}}
" TagBar {{{

    nmap <F8> :TagbarToggle<CR>

" }}}
" Rainbow Parenthesis {{{

    nmap <Leader>R :RainbowParenthesesToggleAll<CR>

" }}}
" SuperTab {{{

    let g:SuperTabDefaultCompletionType = "context"
    let g:SuperTabClosePreviewOnPopupClose = 1

" }}}
" Virtualenv {{{

    if $VIRTUAL_ENV
        VirtualEnvActivate
    endif

" }}}
" RopeVim {{{

    let g:ropevim_enable_shortcuts = 0
    let g:ropevim_guess_project = 1
    " autocmd FileType python setlocal omnifunc=RopeCompleteFunc

" }}}
" NERD Commenter {{{

    let g:NERDCreateDefaultMappings = 0
    nmap <Leader>c <Plug>NERDCommenterToggle
    vmap <Leader>c <Plug>NERDCommenterToggle

"}}}
"
" }}}

