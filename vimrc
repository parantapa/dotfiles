" .vimrc
"
" Preamble {{{1

runtime bundle/pathogen/autoload/pathogen.vim

let g:pathogen_disabled = []
if !has("python")
    call add(g:pathogen_disabled, "ultisnips")
endif
if !( has('lua') && (v:version > 703 || v:version == 703 && has('patch885')) )
    call add(g:pathogen_disabled, "neocomplete.vim")
endif

if has("python")
python << EOF
import vim
import sys

if "_vim_path_" not in sys.path:
    sys.path.append(vim.eval("$HOME . '/.vim/python2'"))
import pyvimrc
EOF
endif

filetype off
call pathogen#infect()
call pathogen#helptags()
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

set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set fillchars=diff:░
set backspace=indent,eol,start
set showbreak=↪

" Wildmenu completion {{{1

set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.pyc                            " Python byte code

" Tabs, spaces, wrapping {{{1

set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab
set textwidth=80
set formatoptions=qrn1
set colorcolumn=+1
set shiftround

" Backups and Spell Files {{{1

set undodir=~/.vim/tmp/undo//
set undofile
set undoreload=1000

set backupdir=~/.vim/tmp/backup//
set backup

set directory=~/.vim/tmp/swap//

if filereadable($HOME_QUICKREFS . "/myspell.utf-8.add")
    execute "set spellfile=" . $HOME_QUICKREFS . "/myspell.utf-8.add"

    " The spell file may be updated outside of vim
    execute "silent mkspell! " . &spellfile
    let &dictionary = &spellfile
endif
set spelllang=en

" Leader {{{1

let mapleader = ","
let maplocalleader = "\\"

" Color scheme {{{1

syntax on
set background=dark
if has("gui_running") || &t_Co == 256
    colorscheme molokai
else
    colorscheme desert
endif

" Status line {{{1

augroup ft_statuslinecolor
    au!

    au InsertEnter * hi StatusLine ctermfg=196 guifg=#FF3145
    au InsertLeave * hi StatusLine ctermfg=130 guifg=#CD5907
augroup END

set statusline=%f       " Path.
set statusline+=%m      " Modified flag.
set statusline+=%r      " Readonly flag.
set statusline+=%w      " Preview window flag.

set statusline+=\       " Add blank space
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

" Searching and movement {{{1

" Use plain text match case search by default.
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

" Open a new file
nnoremap <Leader>n :edit <cfile><CR>

" Folding {{{1

set foldlevelstart=0
set nofoldenable
set foldmethod=marker

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

function! ToggleFolding()
    if &foldenable == 1
        normal zRzn
    else
        normal zMzN
    endif
endfunction

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
" nnoremap zO zCzO

nnoremap <Leader>z :call ToggleFolding()<CR>

" DefaultPyCall {{{1

" Call the python function if python is available
" Otherwise just return the default value
function! DefaultPyCall(default, funcname, ...)
    if has("python")
python << EOF
funcname = vim.eval("a:funcname")
func = getattr(pyvimrc, funcname)

args = vim.eval("a:000")
ret = func(*args)
EOF
        return pyeval("ret")
    else
        return a:default
endfunction

" DiffOrig {{{1

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
command! DiffOrig
    \ let g:difforig_ft = &ft |
    \ vert new |
    \ set bt=nofile |
    \ read ++edit # |
    \ 0d_ |
    \ let &ft = g:difforig_ft |
    \ diffthis |
    \ wincmd p |
    \ diffthis

" ToggleHtml {{{1

" Toggle simple html in buffer
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

" Open URL with Firefox {{{1

" Extract web url form string
function! OpenWithFirefoxOperator(type)
    let saved_unnamed_register = @"
    let saved_winview = winsaveview()
    let saved_selection = &selection

    let &selection = "inclusive"

    if a:type == '__whole_line__'
        silent exe "normal! yy"
    elseif a:type == 'line'
        silent exe "normal! '[V']y"
    elseif a:type == 'block'
        silent exe "normal! `[\<C-V>`]y"
    elseif a:type == 'char'
        silent exe "normal! `[v`]y"
    else " Invoked from Visual mode, use '< and '> marks.
        silent exe "normal! `<" . a:type . "`>y"
    endif

    let url = DefaultPyCall(@", "extract_url", @")
    if url ==# ''
        echom printf("Cant find url in '%s'", @")
    else
        echom printf("Opening '%s' ...", url)
        call system("firefox " . shellescape(url) . " &")
    endif

    call winrestview(saved_winview)
    let @" = saved_unnamed_register
    let &selection = saved_selection
endfunction

nnoremap <leader>f :set operatorfunc=OpenWithFirefoxOperator<cr>g@
vnoremap <leader>f :<c-u>call OpenWithFirefoxOperator(visualmode())<cr>
nnoremap <leader>ff :call OpenWithFirefoxOperator('__whole_line__')<cr>

" Search and Open PDFs {{{1

" Search and open pdf files
fun! CopyAlnumKeyword()
    let oldkwd = &iskeyword
    set iskeyword=a-z,A-Z,48-57,_,-
    normal! yiw
    let &iskeyword = oldkwd
endf

" Strip whitespace
fun! Strip(input_string)
    return substitute(a:input_string, '\v^[ \t\n\r]*(.{-})[ \t\n\r]*$', '\1', '')
endf

fun! SearchAndOpenPdf(keyword)
    let cmd = printf("find %s -name *%s*.pdf", fnameescape($HOME_SDOCS), shellescape(a:keyword))
    let fnames_str = system(cmd)
    let fnames = split(fnames_str, "\n", 0)
    let fnames = map(fnames, 'Strip(v:val)')

    if len(fnames) >= 1
        echom printf("Found %d files ...", len(fnames))
        echom printf("Opening '%s' ...", fnames[0])

        let cmd = printf("evince %s 2>/dev/null &", fnameescape(fnames[0]))
        call system(cmd)
    else
        echom printf("No pdf files found matching '%s'", a:keyword)
    endif
endf
nnoremap <Leader>w :call CopyAlnumKeyword()<CR>:call SearchAndOpenPdf(@")<CR>
vnoremap <Leader>w y:call SearchAndOpenPdf(@")<CR>
command! -nargs=1 SearchAndOpenPdf call SearchAndOpenPdf(<f-args>)

" External Filters {{{1

" Replace current dl.acm.org paper url with bib and abstract

fun! DlacmRead(url)
    execute "read !" . $HOME_QUICKREFS . "/scripts/parse-dlacm.sh '" . Strip(a:url) . "'"
endfunction
command! -nargs=1 DlacmRead call DlacmRead(<f-args>)

" Modescript {{{1

let g:modescript_fname = ".modescript.vim"

function! GetModeScriptFname()
    " If local modescript exists, return that first
    if filereadable(g:modescript_fname)
        return  g:modescript_fname
    endif

    " If repo modescript exists, return that next
    if executable("git")
        let reporoot=Strip(system("git rev-parse --show-toplevel 2>/dev/null"))
        if len(reporoot) > 0
            let repo_modescript_fname = reporoot . "/" . g:modescript_fname
            if filereadable(repo_modescript_fname)
                return repo_modescript_fname
            endif
        endif
    endif

    return g:modescript_fname
endfunction

function! LoadModeScript()
    let fname = GetModeScriptFname()
    if filereadable(fname)
        exe "source " . fname
    endif

    " NOTE: Changing built in command
    command! -nargs=0 Mk execute g:makecmd
    command! -nargs=0 Mk1 execute g:makecmd1
    command! -nargs=0 Mk2 execute g:makecmd2
    command! -nargs=0 Mk3 execute g:makecmd3
    command! -nargs=0 Mk4 execute g:makecmd4
    command! -nargs=0 Mk5 execute g:makecmd5
endfunction
command! -nargs=0 LoadModeScript call LoadModeScript()

augroup ft_modescript
    au!

    autocmd BufReadPost,BufNewFile * LoadModeScript
    exe "autocmd BufWritePost " . g:modescript_fname . " LoadModeScript"

    " Redefine mk with abbrev
    " I dont use mk[exrc]
    cnoreabbrev mk Mk
    cnoreabbrev mk1 Mk1
    cnoreabbrev mk2 Mk2
    cnoreabbrev mk3 Mk3
    cnoreabbrev mk4 Mk4
    cnoreabbrev mk5 Mk5

augroup END

" Convenience mappings {{{1

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


" Shortcuts for completion
inoremap <C-f> <C-x><C-f>
inoremap <C-l> <C-x><C-l>
inoremap <C-Space> <C-x><C-o>

" On C-l also set nohlsearch and diffupdate
nnoremap <silent> <C-l> :nohlsearch<CR>:diffupdate<CR><C-l>

" Wordnet for Viewdoc {{{1

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

" Editing GPG encrypted files {{{1

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

" Multiple Syntax Highlight {{{1
" Code copied from
" http://vim.wikia.com/wiki/Different_syntax_highlighting_within_regions_of_a_file

function! TextEnableCodeSnip(filetype, start, end, textSnipHl)
    let ft = toupper(a:filetype)
    let group = 'textGroup' . ft

    if exists('b:current_syntax')
        let s:current_syntax=b:current_syntax
        " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
        " do nothing if b:current_syntax is defined.
        unlet b:current_syntax
    endif

    let cmd = 'syntax include @%s syntax/%s.vim'
    let cmd = printf(cmd, group, a:filetype)
    execute cmd
    try
        let cmd = 'syntax include @%s after/syntax/%s.vim'
        let cmd = printf(cmd, group, a:filetype)
        execute cmd
    catch
    endtry

    if exists('s:current_syntax')
        let b:current_syntax = s:current_syntax
    else
        unlet b:current_syntax
    endif

    let cmd = 'syntax region textSnip%s matchgroup=%s start=%s end=%s contains=@%s'
    let cmd = printf(cmd, ft, a:textSnipHl, a:start, a:end, group)
    execute cmd
endfunction

" Quick editing {{{1

nnoremap <Leader>ev :edit $MYVIMRC<CR>
nnoremap <Leader>et :edit ~/.tmux.conf<CR>
nnoremap <Leader>es :UltiSnipsEdit
nnoremap <Leader>em :exe "exe \"edit \" . GetModeScriptFname()"<CR>
nnoremap <Leader>r :call ReloadConfigs()<CR>

if !exists("*ReloadConfigs")
    function! ReloadConfigs()
        source ~/.vimrc

        if has("gui_running")
            source ~/.gvimrc
        endif

        if has("python")
            python reload(pyvimrc)
        endif
    endfunction
endif

" Various filetype-specific stuff {{{1

" C {{{2

augroup ft_c
    au!
    au FileType c setlocal noet sw=8 sts=8
augroup END

" CPP {{{2

augroup ft_cpp
    au!
    au FileType cpp setlocal noet sw=8 sts=8
augroup END

" GO {{{2

augroup ft_go
    au!
    au FileType go setlocal noet sw=8 sts=8
augroup END

" HTML {{{2

augroup ft_html
    au!
    au FileType html setlocal sw=2 sts=2
augroup END

" HAML {{{2

augroup ft_haml
    au!
    au FileType haml setlocal sw=2 sts=2
augroup END

" ReStructuredText {{{2

augroup ft_rest
    au!

    au Filetype rst nnoremap <buffer> <localleader>1 yypVr=
    au Filetype rst nnoremap <buffer> <localleader>2 yypVr-
    au Filetype rst nnoremap <buffer> <localleader>3 yypVr~
    au Filetype rst nnoremap <buffer> <localleader>4 yypVr`
augroup END

" Markdown {{{2

function! MarkdownLevel()
    if strpart(getline(v:lnum), 0, 2) ==# "# "
        return ">1"
    elseif strpart(getline(v:lnum), 0, 3) ==# "## "
        return ">2"
    elseif strpart(getline(v:lnum), 0, 4) ==# "### "
        return ">3"
    elseif strpart(getline(v:lnum), 0, 5) ==# "#### "
        return ">4"
    elseif strpart(getline(v:lnum), 0, 6) ==# "##### "
        return ">5"
    elseif strpart(getline(v:lnum), 0, 7) ==# "###### "
        return ">6"
    elseif strpart(getline(v:lnum), 0, 8) ==# "####### "
        return ">7"
    else
        return "="
    endif
endfunction

augroup ft_markdown
    au!

    au Filetype markdown nnoremap <buffer> <localleader>1 0i# <Esc>
    au Filetype markdown nnoremap <buffer> <localleader>2 0i## <Esc>
    au Filetype markdown nnoremap <buffer> <localleader>3 0i### <Esc>
    au Filetype markdown nnoremap <buffer> <localleader>4 0i#### <Esc>
    au Filetype markdown let b:surround_105 = "*\r*"
    au Filetype markdown let b:surround_98 = "**\r**"
    au Filetype markdown setlocal nofoldenable
    au Filetype markdown setlocal suffixesadd=.md
    au Filetype markdown setlocal iskeyword+=-
    au Filetype markdown setlocal formatoptions-=n
augroup END

" Vim {{{2

augroup ft_vim
    au!

    au FileType help setlocal textwidth=78
    " au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END

" MoinMoin {{{2

augroup ft_moin
    au!

    au Filetype moin nnoremap <buffer> <localleader>1 0i= <Esc>$a =<Esc>
    au Filetype moin nnoremap <buffer> <localleader>2 0i== <Esc>$a ==<Esc>
    au Filetype moin nnoremap <buffer> <localleader>3 0i=== <Esc>$a ===<Esc>
    au Filetype moin nnoremap <buffer> <localleader>4 0i==== <Esc>$a ====<Esc>
    au Filetype moin let b:surround_105 = "''\r''"
    au Filetype moin let b:surround_98 = "'''\r'''"
augroup END

" Latex {{{2

augroup ft_tex
    au!

    au FileType tex setlocal sw=2 sts=2
    au Filetype tex let b:surround_105 = "\\textit{\r}"
    au Filetype tex let b:surround_98 = "\\textbf{\r}"
    au Filetype tex nnoremap <buffer> <Localleader>t :Tab /\v(\&<Bar>\\\\ \\hline)
    if ! (filereadable("makefile") || filereadable("Makefile"))
        au Filetype tex setlocal makeprg=latexmk\ %
    endif
    au Filetype tex setlocal formatoptions-=n
augroup END


" Python {{{2

augroup ft_python
    au!

    au FileType python setlocal commentstring=#\ %s
augroup END

" PHP {{{2

" let g:php_folding = 2

augroup ft_php
    au!

augroup END

" Text {{{2

augroup ft_text
    au!

    au Filetype text setlocal formatoptions-=n
augroup END

" Snippets {{{2
augroup ft_snip
    au!

    au FileType snippets setlocal noet sw=4 sts=4 ts=4
augroup end

" Mail {{{2
augroup ft_mail
    au!

    au FileType mail setlocal tw=78
augroup end

" Bookmark {{{2

function! BookmarkLevel()
    if getline(v:lnum) ==# "-"
        return ">1"
    else
        return "="
    endif
endfunction

" Sass {{{2

augroup ft_sass
    au!

    au FileType sass setlocal et sw=4 sts=4
augroup end

" Plugin settings {{{1

" Gundo {{{2

    nnoremap <F5> :GundoToggle<CR>
    let g:gundo_right = 1

" NERDTree {{{2

    nnoremap <F2> :NERDTreeToggle<CR>
    let g:NERDTreeMapActivateNode = "<CR>"
    let g:NERDTreeMapOpenInTab = "<C-t>"
    let g:NERDTreeMapOpenSplit = "<C-s>"
    let g:NERDTreeMapOpenVSplit = "<C-v>"

" Latex {{{2

    let g:tex_flavor = 'latex'
    let g:tex_comment_nospell= 1

" Syntastic {{{2

    let g:syntastic_enable_signs = 1
    let g:syntastic_stl_format = '[%E{Error 1/%e: line %fe}%B{, }%W{Warning 1/%w: line %fw}]'
    let g:syntastic_c_compiler_options = ' -Wall -Wextra'
    let g:syntastic_python_checkers = ['pylint']
    let g:syntastic_javascript_checkers = ['jslint']
    let g:syntastic_javascript_jslint_conf = "--sloppy"

" Ag.vim {{{2

    nnoremap <Leader>a :Ag!

" Tabbing {{{2

    nnoremap <Leader>T :Tabularize /\V
    vnoremap <Leader>T :Tabularize /\V

" TagBar {{{2

    nnoremap <F8> :TagbarToggle<CR>

" Rainbow Parenthesis {{{2

    nnoremap <Leader>R :RainbowParenthesesToggleAll<CR>

" Virtualenv {{{2

    let g:virtualenv_stl_format = '[%n] '
    if $VIRTUAL_ENV
        VirtualEnvActivate
    endif

" ViewDoc {{{2

    let g:viewdoc_pydoc_cmd = "python -m pydoc"
    let g:viewdoc_open = "tab drop [ViewDoc]"

" Slime {{{2

    let g:slime_target = "tmux"
    let g:slime_paste_file = "$HOME/.slime_paste"

    function! SlimeSendText(text)
        execute "SlimeSend1 " . a:text
    endfunction

" Commentary {{{2

    let g:commentary_map_keys = 0
    xmap gc  <Plug>Commentary
    nmap gc  <Plug>Commentary
    nmap gcc <Plug>CommentaryLine
    nmap gcu <Plug>CommentaryUndo

" LanguageTool {{{2

    let g:languagetool_disable_rules = "WHITESPACE_RULE,EN_QUOTES,MORFOLOGIK_RULE_EN_US"

" UltiSnips {{{2

    let g:UltiSnipsUsePythonVersion = 2
    let g:UltiSnipsEditSplit = "normal"
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<s-tab>"
    let g:UltiSnipsJumpBackwardTrigger="<s-c-tab>"

    let g:snips_author = "Parantapa Bhattachara <pb [at] parantapa [dot] net>"

" Marvim {{{2

    let g:marvim_store = $HOME_QUICKREFS . '/marvim'
    let g:marvim_find_key = '<Leader>mf'
    let g:marvim_store_key = '<Leader>ms'
    let g:marvim_prefix = 0

" NeoComplete {{{2

    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#disable_auto_complete = 0

    let g:neocomplete#enable_ignore_case = 1
    let g:neocomplete#enable_auto_delimiter = 1
    let g:neocomplete#enable_fuzzy_completion = 1
    let g:neocomplete#enable_refresh_always = 1

    " By default use all buffers
    if !exists('g:neocomplete#same_filetypes')
        let g:neocomplete#same_filetypes = {}
    endif
    let g:neocomplete#same_filetypes._ = '_'

    " By default use all sources
    if !exists('g:neocomplete#sources')
        let g:neocomplete#sources = {}
    endif
    let g:neocomplete#sources._ = ["_"]

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = { '_' : &spellfile }

    if index(g:pathogen_disabled, "neocomplete.vim") == -1
        " Recommended key-mappings.
        " <CR>: close popup and save indent.
        inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
        function! s:my_cr_function()
            return pumvisible() ? neocomplete#close_popup() : "\<CR>"
        endfunction

        " <C-h>, <BS>: close popup and delete backword char.
        inoremap <expr><C-h> neocomplete#smart_close_popup() . "\<C-h>"
        inoremap <expr><BS> neocomplete#smart_close_popup() . "\<C-h>"

        " " For smart TAB completion.
        " inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
        "     \ <SID>check_back_space() ? "\<TAB>" :
        "     \ neocomplete#start_manual_complete()
        " function! s:check_back_space()
        "     let col = col('.') - 1
        "     return !col || getline('.')[col - 1]  =~ '\s'
        " endfunction
    endif

    nnoremap <F9> :NeoCompleteToggle<CR>

" QFEnter {{{2

    let g:qfenter_open_map = ['<CR>', '<2-LeftMouse>']
    let g:qfenter_vopen_map = ['<C-V>']
    let g:qfenter_hopen_map = ['<C-S>']
    let g:qfenter_topen_map = ['<C-T>']

" Unite {{{2

    let g:unite_source_history_yank_enable = 1

    " Like ctrlp.vim settings.
    call unite#custom#profile('default', 'context', {
        \   'start_insert': 1,
        \   'winheight': 10,
        \   'direction': 'botright',
        \ })
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    call unite#filters#sorter_default#use(['sorter_rank'])

    " nnoremap <C-P><C-P> :<C-u>Unite -start-insert buffer<CR>
    " nnoremap <C-P>f :<C-u>Unite -start-insert file_rec<CR>
    " nnoremap <C-P>m :<C-u>Unite -start-insert file_mru<CR>
    " nnoremap <C-P>y :<C-u>Unite history/yank<CR>

    autocmd FileType unite call s:unite_my_settings()
    function! s:unite_my_settings()

	inoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
	inoremap <silent><buffer><expr> <C-s> unite#do_action('split')
	inoremap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

	nnoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
	nnoremap <silent><buffer><expr> <C-s> unite#do_action('split')
	nnoremap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

        nmap <silent><buffer> <Esc> <Plug>(unite_exit)

    endfunction

    let g:unite_source_menu_menus = {}
    let g:unite_source_menu_menus.index = {
        \ 'description' : 'Unite Index',
        \ }
    let g:unite_source_menu_menus.index.command_candidates = {
        \ 'file' : 'Unite -start-insert file_rec',
        \ 'mru' : 'Unite -start-insert file_mru',
        \ 'buffer' : 'Unite -start-insert buffer',
        \ 'yank' : 'Unite history/yank',
        \ 'outline' : 'Unite outline'
        \ }

    nnoremap <C-P> :<C-u>Unite menu:index<CR>

" Indent Guides {{{2

    nnoremap <Leader>I :IndentGuidesToggle<CR>

" EasyAlign {{{1

    vmap <Enter> <Plug>(EasyAlign)

" Setup stuff depending on filename/extension {{{1
augroup ft_setup
    au!

    " Setup the proper filetype
    autocmd BufReadPost,BufNewFile *.md setlocal ft=markdown
    au BufEnter *.md setlocal foldexpr=MarkdownLevel()
    au BufEnter *.md setlocal foldmethod=expr

    au BufEnter bookmarks.yaml setlocal foldexpr=BookmarkLevel()
    au BufEnter bookmarks.yaml setlocal foldmethod=expr
    au BufEnter bookmarks.yaml setlocal foldtext=DefaultPyCall('--','bookmark_fold_text',v:foldstart,v:foldend,v:foldlevel)

    autocmd BufReadPost,BufNewFile *.plot setlocal ft=gnuplot
    autocmd BufReadPost,BufNewFile *.php setlocal ft=php.html
    autocmd BufReadPost,BufNewFile *.jsx setlocal ft=javascript
    autocmd BufReadPost,BufNewFile *.jinja2 setlocal ft=jinja
    autocmd BufReadPost,BufNewFile *.blog setlocal ft=markdown
    autocmd BufReadPost,BufNewFile *.twig setlocal ft=htmljinja
    autocmd BufReadPost,BufNewFile *.sshconfig setlocal ft=sshconfig

    autocmd BufReadPost,BufNewFile *.html.jinja2 setlocal ft=htmljinja

    autocmd BufReadPost,BufNewFile bashrc_* setlocal ft=sh

    autocmd BufReadPost,BufNewFile *.blog call TextEnableCodeSnip("yaml", '/\v%^/', '/\V.../', "yaml")

    " These files get the \S shortcut to repo sync
    execute "autocmd BufReadPost,BufNewFile " . $HOME_QUICKREFS . "/* nnoremap <buffer> <Localleader>S :wall <bar> !repo-sync<CR>"
    execute "autocmd BufReadPost,BufNewFile " . $HOME_SDOCS . "/* nnoremap <buffer> <Localleader>S :wall <bar> !repo-sync<CR>"

    " Files opened via pentadacytl need some special setup
    autocmd BufReadPost pentadactyl.mail.google.com.txt setlocal ft=mail
    autocmd BufReadPost pentadactyl.mail.google.com.txt call ToggleHtmlInBuf()
    autocmd BufWritePre pentadactyl.mail.google.com.txt call ToggleHtmlInBuf()

    autocmd BufReadPost pentadactyl.wiki.mpi-sws.org.txt setlocal ft=moin
    autocmd BufReadPost pentadactyl.cnerg.iitkgp.ac.in.txt setlocal ft=moin

    autocmd BufReadPost pentadactyl.requester.mturk.com.txt setlocal ft=html

augroup END

