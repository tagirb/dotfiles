" vim: fileformat=unix fileencoding=utf-8

" general
scriptencoding utf-8
set nocompatible            " no vi compatibility in the 21st century
set termencoding=utf-8      " set all encodings to utf-8
set encoding=utf-8
set fileencoding=utf-8

let mapleader=","           " change mapleader to comma
let g:mapleader=","
set timeoutlen=500          " set mapleader timeout to 500ms

set runtimepath=$HOME/.vim,$VIMRUNTIME

" plugins {{{
" install vim-plug if needed
let v_vimplug = expand('~/.vim/autoload/plug.vim')
let v_vimplug_url =
    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if !filereadable(v_vimplug)
    silent execute '!curl -sfLo ' . v_vimplug . ' ' . v_vimplug_url
endif
unlet v_vimplug 
unlet v_vimplug_url

call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'scrooloose/nerdcommenter'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'chase/vim-ansible-yaml'
Plug 'houtsnip/vim-emacscommandline'
Plug 'Yggdroot/indentLine'
Plug 'markcornick/vim-terraform'
Plug 'evanmiller/nginx-vim-syntax'
call plug#end()
" }}}

" buffers and files
set nobackup                " do a backup only when
set writebackup             " a file is being written
set backupdir=~/.vim/backup " backup location
set noswapfile              " disable swap file
set directory=~/.vim/.tmp,~/tmp,/tmp
                            " swap file directory if they are ever enabled
set viminfo='20,\"80,<50,s10,h,n~/.vim/viminfo
                            " viminfo parameters
set undofile                " keep a persistent undo file
set undodir=~/.vim/.undo,~/tmp,/tmp
                            " undo file directory
set autoread                " automatically re-read files changed externally
set noautowrite             " do not save files on buffer switch
set hidden                  " hide buffers instead of closing them
set switchbuf=useopen       " reveal already opened files from the
                            " quickfix window instead of opening new
                            " buffers

set fileformat=unix         " file formats
set fileformats=unix,dos
set fileencodings=utf-8,latin1

" history
set history=1000            " remember more commands and search history
set undolevels=1000         " use more undo levels

" ui {{{
set title                   " change the terminal title
set textwidth=80            " limit text width to 80 chars
set scrolloff=4             " number of lines to keep above and below the cursor

set noerrorbells            " disable all bells
set novisualbell
set ttyfast                 " fast TTY mode for better UI

" status line {{{
set showcmd                 " show partial command in the status line
set cmdheight=1             " command line height
set laststatus=2            " always show status line

set statusline=%<\ %n»%f\ %M%R%=%-6.(%c%V%)\ %P

" }}}

set cursorline              " highlight the current line
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

nnoremap <leader>N :call NumberToggle()<cr>

" show/hide line numbers
"nnoremap <leader>N :setlocal norelativenumber<cr>:setlocal number!<cr>
" show absolute/relative line numbers
"nnoremap <leader>R :setlocal relativenumber!<cr>

" }}}

" color scheme
set background=dark         " currently favorite background
" enable a 256 color scheme when appropriate
if &t_Co > 255 || has("gui_running")
    colorscheme solarized
endif

" enable syntax highlighting if the terminal has colors
if &t_Co > 2 || has("gui_running")
    syntax on
endif
set synmaxcol=1000          " no syntax highlighting on long lines

" menu {{{

" abbreviate messages
set shortmess=astI

set wildmenu
set wildmode=longest:full
set wildcharm=<C-Z>
nnoremap <F10> :b <C-Z>
" }}}

" editing behavour
set showmode                " always show current editing mode
set wrap                    " wrap lines by default
set linebreak               " wrap lines at whitespace (see breakat)
set showbreak=              " no prepend on wrapped lines
" toggle line wrap
nnoremap <silent> <leader>w :set wrap!<cr>

" tabs and whitespace
set expandtab               " expand tabs by default
set smarttab                " use auto indent for tabs at line start
set tabstop=4               " a tab is four spaces
set softtabstop=4           " remove four spaces at once as if it were a tab
set shiftwidth=4            " number of spaces for autoindenting
set shiftround              " round to shiftwidth for indenting with > and <

set backspace=eol,start,indent " backspace over everything in insert mode

set nolist                    " don't show invisible characters by default
set listchars=tab:»·,trail:·,extends:›,eol:¬ " symbols for tabs, empty trails
                                             " and too long lines
" show/hide invisible chars
nnoremap <leader>i :set list!<cr>

set formatoptions=qrn1      " insert comment leader, etc.

set showmatch               " when inserting a bracket show a matching one
set matchtime=2             " show a matching bracket for <n> msec
" match bracket pairs with tab in normal and visual mode
nnoremap <tab> %
vnoremap <tab> %

set nrformats=              " <C-a> and <C-x> only in-/decrement decimals

" search {{{
set ignorecase              " ignore case when searching
set smartcase               " ignore case if search pattern is lowercase,
                            " otherwise be case-sensitive
set hlsearch                " highlight searches
set incsearch               " search during typing
set gdefault                " replace globally by default, /g to disable

" use Vim's 'very magic' search syntax, i.e. \( and \{ for braces
" also highlight current position before searching
nnoremap / ms/\v
vnoremap / ms/\v
" toggle search highlighting
nnoremap <silent> <leader>/ :nohlsearch<cr>

" }}}

" indentation and formatting

set autoindent              " always set autoindenting on
set copyindent              " copy the previous indentation on autoindenting

" folding {{{
set foldenable              " enable folding
set foldcolumn=2            " add a fold column
set foldmethod=marker       " detect triple-{ style fold markers
set foldlevelstart=99       " start with everything unfolded
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
                            " which commands trigger auto-unfold

nnoremap z0 :set foldlevel=0<cr>
nnoremap z1 :set foldlevel=1<cr>
nnoremap z2 :set foldlevel=2<cr>
nnoremap z3 :set foldlevel=3<cr>
nnoremap z4 :set foldlevel=4<cr>
nnoremap z5 :set foldlevel=5<cr>
" }}}

" netrw {{
let g:netrw_liststyle=3     " tree style
let g:netrw_banner=0        " no banner
let g:netrw_altv=1          " open files on right
let g:netrw_preview=1       " open previews vertically
let s:treedepthstring= "│ "
" }}

" custom key mappings

" toggle paste mode
set pastetoggle=<F2>

" make Y behave as C and D
nnoremap Y y$
" scroll 3 lines at once
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" scroll by display lines by default
nnoremap j gj
nnoremap k gk
inoremap <Down> <C-o>g<Down>
inoremap <Up> <C-o>g<Up>

" quickly reload the vimrc with ,sv
nmap <silent> <leader>sv :source $MYVIMRC<cr>

" clean whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<cr>

" re-hardwrap paragraps
nnoremap <leader>q gqip

" show buffers
nmap <silent> <leader>b :buffers<cr>

" show marks
nmap <silent> <leader>m :marks<cr>

" show registers
nmap <silent> <leader>r :registers<cr>

" custom commands
command! W w !sudo tee % > /dev/null

" autocommands

"helptags $HOME/.vim/doc

