" .vimrc
"
" Preamble ---------------------------------------------------------------- {{{

runtime bundle/pathogen/autoload/pathogen.vim

filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

" Setup yankstack early.
" Otherwise it interferes with surround.
call yankstack#setup()

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
" Backups and Spell Files ------------------------------------------------- {{{

set undodir=~/.vim/tmp/undo//
set undofile
set undoreload=1000

set backupdir=~/.vim/tmp/backup//
set backup

set directory=~/.vim/tmp/swap//

set spellfile=~/quickrefs/myspell.utf-8.add
set spelllang=en_us

" The spell file may be updated outside of vim
execute "silent mkspell! " . &spellfile

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
set statusline+=%{virtualenv#statusline()}      " Virtualenv
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

" Use plain text search by default.
nnoremap / /\V
vnoremap / /\V

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
set sidescroll=1

set virtualedit+=block

" Don't move on *
nnoremap * *<C-o>

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L g_

" Replacement for , as movement shortcut
noremap - ,

nnoremap ]q :lnext<CR>
nnoremap [q :lprev<CR>
nnoremap ]]q :lfirst<CR>
nnoremap [[q :llast<CR>

nnoremap ]w :cnext<CR>
nnoremap [w :cprev<CR>
nnoremap ]]w :cfirst<CR>
nnoremap [[w :clast<CR>

" Hitting parenthesis is hard
noremap } )
noremap { (
noremap \] }
noremap \[ {

" Open using firefox
nnoremap <Leader>oo yiW:call system("firefox " . shellescape(@"))<CR>
vnoremap <Leader>oo y:call system("firefox " . shellescape(@"))<CR>
nnoremap <Leader>ot yiw:call system("firefox thesaurus.com/browse/" . shellescape(@"))<CR>
nnoremap <Leader>od yiw:call system("firefox dictionary.reference.com/browse/" . shellescape(@"))<CR>
nnoremap <Leader>os yiW:call system("firefox google.com/search?q=" . shellescape(@"))<CR>
vnoremap <Leader>os y:call system("firefox google.com/search?q=" . shellescape(@"))<CR>

" Open a new file
nnoremap <Leader>n :edit <cfile><CR>

" }}}
" Folding ----------------------------------------------------------------- {{{

set foldlevelstart=0
set nofoldenable
set foldmethod=marker

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
" Markdown {{{

augroup ft_markdown
    au!

    au Filetype mkd nnoremap <buffer> <localleader>1 yypVr=
    au Filetype mkd nnoremap <buffer> <localleader>2 yypVr-
    au Filetype mkd nnoremap <buffer> <localleader>3 0i### <Esc>
    au Filetype mkd nnoremap <buffer> <localleader>4 0i#### <Esc>
    au Filetype mkd let b:surround_105 = "*\r*"
    au Filetype mkd let b:surround_98 = "**\r**"
    au Filetype mkd setlocal nofoldenable
    au Filetype mkd setlocal suffixesadd=.md
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
" MoinMoin {{{

augroup ft_moin
    au!

    au Filetype moin nnoremap <buffer> <localleader>1 0i= <Esc>$a =<Esc>
    au Filetype moin nnoremap <buffer> <localleader>2 0i== <Esc>$a ==<Esc>
    au Filetype moin nnoremap <buffer> <localleader>3 0i=== <Esc>$a ===<Esc>
    au Filetype moin nnoremap <buffer> <localleader>4 0i==== <Esc>$a ====<Esc>
    au Filetype moin let b:surround_105 = "''\r''"
    au Filetype moin let b:surround_98 = "'''\r'''"
augroup END
" }}}
" Latex {{{

augroup ft_tex
    au!

    au FileType tex setlocal sw=2 sts=2
    au Filetype tex let b:surround_105 = "\\textit{\r}"
    au Filetype tex let b:surround_98 = "\\textbf{\r}"
    au Filetype tex nmap <buffer> <Localleader>t :Tab /\v(\&<Bar>\\\\ \\hline)
augroup END
" }}}
" Gnuplot {{{

augroup ft_gnuplot
    au!

    autocmd BufReadPost *.plot setlocal ft=gnuplot
augroup END

" }}}
" Python {{{

augroup ft_python
    au!

    au FileType python setlocal foldmethod=indent
    au FileType python setlocal commentstring=#\ %s
augroup END

" }}}
" PHP {{{

let g:php_folding = 2

augroup ft_php
    au!

    au FileType php setlocal foldmethod=syntax
augroup END

" }}}

" }}}
" Quick editing ----------------------------------------------------------- {{{

nnoremap <Leader>ev :edit $MYVIMRC<CR>
nnoremap <Leader>et :edit ~/.tmux.conf<CR>
nnoremap <Leader>es :UltiSnipsEdit

augroup ft_vimrc_autoread:
    au!

    autocmd BufWritePost .vimrc source ~/.vimrc
    autocmd BufWritePost vimrc source ~/.vimrc

    if has("gui_running")
        autocmd BufWritePost .gvimrc source ~/.gvimrc
        autocmd BufWritePost gvimrc source ~/.gvimrc
    endif
augroup END

" }}}
" Misc -------------------------------------------------------------------- {{{

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

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

function! ToggleHtmlInBuf()
    silent! normal g0vG$"zy
    if stridx(@z, "<br>") ==# -1
        silent! execute "%s/\\V>/\\&gt;/"
        silent! execute "%s/\\V</\\&lt;/"
        silent! execute "%s/\\V\\n/<br>/"
    else
        silent! execute "%s/\\V<br>/\\r/"
        silent! execute "%s/\\V&gt;/>/"
        silent! execute "%s/\\V&lt;/</"
    endif
endf
nnoremap <F7> :call ToggleHtmlInBuf()<CR>

" }}}
" Convenience mappings ---------------------------------------------------- {{{

" I dont use ex mode
nnoremap Q gq

" Better shortcut for copy the rest of the line
nnoremap Y y$

" Clean whitespace
nnoremap <Leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Substitute
nnoremap <Leader>s :%s/\V

" Emacs bindings in command line mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Sudo to write
cnoremap w!! set buftype=nowrite <bar> w !sudo tee % >/dev/null

" Toggle paste
set pastetoggle=<F6>

" Toggle spell
nnoremap <F3> :setlocal spell!<CR>

" Dont use Syntastic when exiting
nnoremap :wq :au! syntastic<cr>:wq

" Use MoinMoin wiki syntax
nnoremap <Leader>moin :se ft=moin<CR>

" Do a repo sync
nnoremap <Leader>S :wall <bar> !repo-sync<CR>

" Shortcuts for completion
inoremap <C-f> <C-x><C-f>
inoremap <C-l> <C-x><C-l>
inoremap <C-Space> <C-x><C-o>

" On C-l remove hlsearch
nnoremap <silent> <C-l> :nohlsearch<CR>:diffupdate<CR><C-l>

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

    nnoremap <F2> :NERDTreeToggle<CR>
    let g:NERDTreeMapActivateNode = "<CR>"
    let g:NERDTreeMapOpenInTab = "<C-t>"
    let g:NERDTreeMapOpenSplit = "<C-s>"
    let g:NERDTreeMapOpenVSplit = "<C-v>"

" }}}
" Latex {{{

    let g:tex_flavor = 'latex'
    let g:tex_comment_nospell= 1

" }}}
" Syntastic {{{

    let g:syntastic_enable_signs = 1
    let g:syntastic_stl_format = '[%E{Error 1/%e: line %fe}%B{, }%W{Warning 1/%w: line %fw}]'
    let g:syntastic_c_compiler_options = ' -Wall -Wextra'
    let g:syntastic_python_checkers = ['pylint']
    let g:syntastic_javascript_checkers = ['jslint']
    let g:syntastic_javascript_jslint_conf = "--sloppy"

" }}}
" Ack {{{

    nnoremap <Leader>a :Ack!

" }}}
" Tabbing {{{

    nnoremap <Leader>T :Tab /\V
    vnoremap <Leader>T :Tab /\V

" }}}
" TagBar {{{

    nnoremap <F8> :TagbarToggle<CR>

" }}}
" Rainbow Parenthesis {{{

    nnoremap <Leader>R :RainbowParenthesesToggleAll<CR>

" }}}
" SuperTab {{{

    let g:SuperTabDefaultCompletionType = "<c-p>"
    let g:SuperTabClosePreviewOnPopupClose = 1

" }}}
" Virtualenv {{{

    let g:virtualenv_stl_format = '[%n] '
    if $VIRTUAL_ENV
        VirtualEnvActivate
    endif

" }}}
" ViewDoc {{{

    let g:viewdoc_pydoc_cmd="python -m pydoc"

" }}}
" Slime {{{

    let g:slime_target = "tmux"
    let g:slime_paste_file = "$HOME/.slime_paste"

" }}}
" YankStack {{{

    let g:yankstack_map_keys = 1

" }}}
" Commentary {{{

    let g:commentary_map_keys = 0
    xmap gc  <Plug>Commentary
    nmap gc  <Plug>Commentary
    nmap gcc <Plug>CommentaryLine
    nmap gcu <Plug>CommentaryUndo

" }}}
" LanguageTool {{{

    let g:languagetool_disable_rules = "WHITESPACE_RULE,EN_QUOTES,MORFOLOGIK_RULE_EN_US"

" }}}
" Jedi Vim {{{

    let g:jedi#use_tabs_not_buffers = 0
    let g:jedi#popup_on_dot = 0
    let g:jedi#show_call_signatures = 0
    let g:jedi#auto_vim_configuration = 0

" }}}
" UltiSnips {{{

    let g:UltiSnipsUsePythonVersion = 2
    let g:UltiSnipsEditSplit = "normal"
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

    let g:snips_author = "Parantapa Bhattachara <pb [at] parantapa [dot] net>"

" }}}
" Marvim {{{

    let g:marvim_store = $HOME . '/quickrefs/marvim'
    let g:marvim_find_key = '<Leader>mf'
    let g:marvim_store_key = '<Leader>ms'
    let g:marvim_prefix = 0

" }}}
"
" }}}
" Wordnet for Viewdoc ----------------------------------------------------- {{{

function! s:ViewDoc_wordnet(topic, ...)
        return { 'cmd' : printf('wn %s -over | fold -w 78 -s', shellescape(a:topic, 1)),
                \ 'ft' : 'wordnet' }
endf
let g:ViewDoc_wordnet = function('s:ViewDoc_wordnet')

command! -bar -bang -nargs=1 ViewDocWordnet
	\ call ViewDoc('<bang>'=='' ? 'new' : 'doc', <f-args>, 'wordnet')
cnoreabbrev wn ViewDocWordnet

augroup au_wordnet
    au!

    autocmd FileType wordnet mapclear <buffer>
    autocmd FileType wordnet syn match overviewHeader /^Overview of .\+/
    autocmd FileType wordnet syn match definitionEntry /\v^[0-9]+\. .+$/ contains=numberedList,word
    autocmd FileType wordnet syn match numberedList /\v^[0-9]+\. / contained
    autocmd FileType wordnet syn match word /\v([0-9]+\.[0-9\(\) ]*)@<=[^-]+/ contained
    autocmd FileType wordnet hi link overviewHeader Title
    autocmd FileType wordnet hi link numberedList Operator
    autocmd FileType wordnet hi def word term=bold cterm=bold gui=bold
augroup end

" }}}
" Set filetype for files opened with pentadactyl -------------------------- {{{

augroup au_pentadactyl
    au!

    autocmd BufReadPost */pentadactyl.mail.google.com.txt setlocal ft=mail
    autocmd BufReadPost */pentadactyl.mail.google.com.txt setlocal tw=72
    autocmd BufReadPost */pentadactyl.mail.google.com.txt call ToggleHtmlInBuf()
    autocmd BufWritePre */pentadactyl.mail.google.com.txt call ToggleHtmlInBuf()

    autocmd BufRead */pentadactyl.wiki.mpi-sws.org.txt setlocal ft=moin
augroup end

" }}}
" Editing GPG encrypted files --------------------------------------------- {{{

" Following block is copied from
" http://vim.wikia.com/wiki/Encryption

" Transparent editing of gpg encrypted files.
" By Wouter Hanegraaff
augroup encrypted
  au!

  " First make sure nothing is written to ~/.viminfo while editing
  " an encrypted file.
  autocmd BufReadPre,FileReadPre *.gpg set viminfo=
  " We don't want a various options which write unencrypted data to disk
  autocmd BufReadPre,FileReadPre *.gpg set noswapfile noundofile nobackup

  " Switch to binary mode to read the encrypted file
  autocmd BufReadPre,FileReadPre *.gpg set bin
  autocmd BufReadPre,FileReadPre *.gpg let ch_save = &ch|set ch=2
  " (If you use tcsh, you may need to alter this line.)
  autocmd BufReadPost,FileReadPost *.gpg '[,']!gpg -d 2> /dev/null

  " Switch to normal mode for editing
  autocmd BufReadPost,FileReadPost *.gpg set nobin
  autocmd BufReadPost,FileReadPost *.gpg let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

  " Convert all text to encrypted text before writing
  " (If you use tcsh, you may need to alter this line.)
  autocmd BufWritePre,FileWritePre *.gpg '[,']!gpg -ac 2>/dev/null
  " Undo the encryption so we are back in the normal text, directly
  " after the file has been written.
  autocmd BufWritePost,FileWritePost *.gpg u
augroup END

" }}}
