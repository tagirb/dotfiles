" vim: fileformat=unix fileencoding=utf-8

" general {{{
scriptencoding utf-8
set nocompatible            " no vi compatibility
set termencoding=utf-8      " set all encodings to utf-8
set encoding=utf-8
set fileencoding=utf-8

set clipboard^=unnamed,unnamedplus       " use OS clipboard by default

set history=1000            " remember more commands and search history
set undolevels=1000         " use more undo levels

set noerrorbells            " disable bells
set conceallevel=0          " disable concealing

set mouse=                  " disable mouse

set updatetime=250          " process buffer changes every 250ms

let mapleader=' '           " change mapleader to space
let g:mapleader=' '
set timeoutlen=500          " set mapleader timeout to 500ms

" }}}

" paths {{{
set backupdir=$XDG_CACHE_HOME/nvim/backup
set runtimepath=$XDG_CONFIG_HOME/nvim,$VIMRUNTIME
set undodir=$XDG_CACHE_HOME/nvim/.undo
set viminfo='20,\"80,<50,s10,h,f0,n"$XDG_CACHE_HOME/nvim/viminfo"
" }}}

" plugin management {{{

let v_vimplug = $XDG_CONFIG_HOME . '/nvim/autoload/plug.vim'
let v_vimplug_url =
    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if empty(glob(v_vimplug))
    execute '!curl -sfLo ' . v_vimplug . ' ' . v_vimplug_url
endif
unlet v_vimplug
unlet v_vimplug_url

call plug#begin($XDG_DATA_HOME . '/nvim/plugged')

" ui
Plug 'morhetz/gruvbox'
Plug 'Yggdroot/indentLine'

" file/buffer management
Plug 'scrooloose/nerdtree'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" version control
Plug 'airblade/vim-gitgutter'

" editing
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'

" syntax highlighting
Plug 'stephpy/vim-yaml'
Plug 'pearofducks/ansible-vim'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'markcornick/vim-terraform'
Plug 'chr4/nginx.vim'

" documentation
Plug 'rizzatti/dash.vim'

call plug#end()
" }}}

" files and buffers {{{
set nobackup                " do a backup only when
set writebackup             " a file is being written
set noswapfile              " disable swap files
set directory=/tmp          " swap file directory if they are ever enabled
set undofile                " keep a persistent undo file
set autoread                " automatically re-read files changed externally
set noautowrite             " do not save files on buffer switch
set hidden                  " hide buffers instead of closing them
set switchbuf=useopen       " reveal already opened files from the
                            " quickfix window instead of opening new
                            " buffers

set fileformat=unix         " file formats
set fileformats=unix,dos
set fileencodings=utf-8,latin1
" }}}


" ui {{{
set title                   " change the terminal title
set titleold=
set textwidth=80            " limit text width to 80 chars
set scrolloff=4             " keep this cursor context when scrolling
set sidescrolloff=4         " 
set fillchars=vert:┊,fold:┈  " window split characters

set noerrorbells            " disable all bells
set novisualbell

"set cursorline              " highlight the current line

" set cursor shape
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" status line {{{
set showcmd                 " show partial command in the status line
set cmdheight=1             " command line height
set laststatus=2            " always show status line

set statusline=%<\ %n»%f\ %M%R%=%-6.(%c%V%)\ %P

" }}}

set colorcolumn=+1,+2,+3    " color columns at the end of line
set nolazyredraw            " force screen redraw on macros execution, etc.


" line numbering {{{
set number                  " enable line numbering
set relativenumber          " use relative line numbering by default

" none -> absolute -> relative -> none
function! NumberToggle()
    if (&number == 1)
        if(&relativenumber == 1)
            set norelativenumber
            set nonumber
        else
            set relativenumber
        endif
    else
        set norelativenumber
        set number
    endif
endfunc

" }}}

" color scheme
set background=dark         " currently favorite background
" enable a 256 color scheme when appropriate
if &t_Co > 255 || has("gui_running")
    set termguicolors
    colorscheme gruvbox
endif

" enable syntax highlighting if the terminal has colors
if &t_Co > 2 || has("gui_running")
    syntax on
endif
set synmaxcol=200           " no syntax highlighting on long lines

" menu {{{

" abbreviate messages
set shortmess=astI

set wildmenu
set wildmode=longest:full
set wildcharm=<C-Z>
" }}}

" }}} 

" editing behavour {{{
set showmode                " always show current editing mode
set wrap                    " wrap lines by default
set linebreak               " wrap lines at whitespace (see breakat)
set showbreak=              " no prepend on wrapped lines

" tabs and whitespace
set expandtab               " expand tabs by default
set smarttab                " use auto indent for tabs at line start
set tabstop=4               " a tab is four spaces
set softtabstop=4           " remove four spaces at once as if it were a tab
set shiftwidth=4            " number of spaces for autoindenting
set shiftround              " round to shiftwidth for indenting with > and <

set backspace=eol,start,indent " backspace over everything in insert mode

set nolist                  " don't show invisible characters by default
set listchars=tab:»·,trail:·,extends:›,eol:¬ " symbols for tabs, empty trails
                                             " and too long lines

set showmatch               " when inserting a bracket show a matching one
set matchtime=2             " show a matching bracket for <n> msec

set formatoptions=qrn1      " insert comment leader, etc.

set nrformats=              " <C-a> and <C-x> only in-/decrement decimals

" search {{{
set ignorecase              " ignore case when searching
set smartcase               " ignore case if search pattern is lowercase,
                            " otherwise be case-sensitive
set hlsearch                " highlight searches
set incsearch               " search during typing
set gdefault                " replace globally by default, /g to disable

" use ripgrep instead of grep when available
if executable('rg') 
    set grepprg=rg\ --vimgrep
    set grepformat=%f:%l:%c%m
endif

" }}}

" indentation and formatting {{{

set autoindent              " always set autoindenting on
set copyindent              " copy the previous indentation on autoindenting
" }}}

" folding {{{
set foldenable              " enable folding
set foldcolumn=2            " add a fold column
set foldmethod=marker       " detect triple-{ style fold markers
set foldlevelstart=99       " start with everything unfolded
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
                            " which commands trigger auto-unfold
" }}}

" }}}


" Plugins {{{

" disable various stock plugins
let g:loaded_rrhelper=0
let g:loaded_gzip=0
let g:loaded_getscriptPlugin=0
let g:loaded_vimballPlugin=0
let g:loaded_zipPlugin=0
let g:loaded_tarPlugin=0

" indentLine {{{
let g:indentLine_enabled = 1
let g:indentLine_char = '¦'
" }}}

" netrw -- disabled {{{
let g:loaded_netrwPlugin=0 
"let g:netrw_altv=1          " open files on right
"let g:netrw_banner=0        " no banner
"let g:netrw_browse_split=0  " open files in the current window
"let g:netrw_home=$XDG_CACHE_HOME.'/nvim'
"let g:netrw_liststyle=3     " tree style
"let g:netrw_preview=1       " open previews vertically
"let g:netrw_winsize=25      " set window width to 25%
"let s:treedepthstring= '¦ '
" }}}

" NERDTree {{{
" }}}

" vim-gitgutter {{{
let g:gitgutter_enabled = 0
nnoremap <silent> <leader>gg :GitGutterToggle<cr>
" }}}

" }}}

" key mappings {{{

" toggle paste mode
"set pastetoggle=<F2>

" quickly reload the vimrc with ,sv
nnoremap <silent> <leader>sv :source $MYVIMRC<cr>

" browsing {{{
" scroll 3 lines at once
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
nnoremap <silent> <leader>j :jump<cr>

" toggle line number modes
nnoremap <leader>N :call NumberToggle()<cr>
" }}}

" editing {{{
" make Y behave same as C and D
nnoremap Y y$
" toggle line wrap
nnoremap <silent> <leader>w :set wrap!<cr>
" show/hide invisible chars
nnoremap <silent> <leader>i :set list!<cr>
" toggle search highlighting
nnoremap <silent> <leader>/ :nohlsearch<cr>

" clean whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<cr>

" re-hardwrap paragraps
nnoremap <leader>q gqip
" }}}

" window management {{{
nnoremap <silent> - :split<cr>
nnoremap <silent> _ :vsplit<cr>
nnoremap <silent> <C-c> :close<cr>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <silent> <C-q> :quit<cr>
nnoremap <silent> <Left> :vertical resize -5<CR>
nnoremap <silent> <Right> :vertical resize +5<CR>
nnoremap <silent> <Up> :resize -5<CR>
nnoremap <silent> <Down> :resize +5<CR>
" }}}

" buffer and tab management {{{
nmap <silent> <M-b> :buffers<cr>
nmap <silent> <M-h> :tabprev<cr>
nmap <silent> <M-j> :bprev<cr>
nmap <silent> <M-k> :bnext<cr>
nmap <silent> <M-l> :tabnext<cr>
nmap <silent> <M-t> :tabs<cr>
" }}}

" marks
nmap <silent> <M-m> :marks<cr>

" registers
nmap <silent> <M-r> :registers<cr>

" folding
nnoremap z0 :set foldlevel=0<cr>
nnoremap z1 :set foldlevel=1<cr>
nnoremap z2 :set foldlevel=2<cr>
" }}}

