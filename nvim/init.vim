" general {{{
"set clipboard^=unnamed,unnamedplus " use OS clipboard by default
let mapleader=' '                  " change mapleader to space
let g:mapleader=' '
" }}}

" plugin management {{{

" disable unused standard plugins
let g:loaded_gzip = 0
let g:loaded_netrwPlugin = 0
let g:loaded_rrhelper = 0
let g:loaded_tarPlugin = 0
let g:loaded_tutor_mode_plugin = 0
let g:loaded_vimballPlugin = 0
let g:loaded_zipPlugin = 0

" define XDG vars if needed {{{
if empty($XDG_CACHE_HOME)
let $XDG_CACHE_HOME=expand("$HOME/.cache")
endif
if empty($XDG_CONFIG_HOME)
let $XDG_CONFIG_HOME=expand("$HOME/.config")
endif
if empty($XDG_DATA_HOME)
let $XDG_DATA_HOME=expand("$HOME/.local/share")
" }}}

endif

let v_vimplug = $XDG_CONFIG_HOME . '/nvim/autoload/plug.vim'
let v_vimplug_url =
    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if empty(glob(v_vimplug))
    execute '!curl -sfLo ' . v_vimplug . ' ' . v_vimplug_url
endif
unlet v_vimplug
unlet v_vimplug_url

" Plugin settings {{{

" fzf {{{
" jump to the existing window if possible
let g:fzf_buffers_jump = 1

let g:fzf_colors =
          \ { 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'border':  ['fg', 'Ignore'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }
 
" }}}

" vim-gitgutter {{{
let g:gitgutter_enabled = 0
" }}}

" vim-indent-guides {{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 2
" }}}

" vim-polyglot {{{
let g:polyglot_disabled = [
            \'markdown',
            \'terraform',
            \'org'
            \]

" vim-terraform {{{
let g:terraform_align = 1
let g:terraform_fold_sections = 1
let g:terraform_fmt_on_save = 0
" }}}

" vim-json {{{
let g:vim_json_syntax_conceal = 1
" }}}

" }}}

" }}}
call plug#begin($XDG_DATA_HOME . '/nvim/plugged')

" ui
Plug 'chriskempson/base16-vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'equalsraf/neovim-gui-shim'

" file/buffer management
Plug '/usr/share/vim/vimfiles/plugins'
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
Plug 'tpope/vim-eunuch'

" editing
Plug 'mbbill/undotree'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'junegunn/vim-easy-align'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'airblade/vim-matchquote'

" syntax highlighting
Plug 'sheerun/vim-polyglot'
Plug 'hashivim/vim-terraform'

" documentation
Plug 'romainl/vim-devdocs'

call plug#end()
" }}}

" files and buffers {{{
set autoread                " auto read buffer on external change
set autowriteall            " auto write buffer on every buffer switch
set undofile                " keep a persistent undo file
set switchbuf=useopen       " reveal already opened files from the
                            " quickfix window instead of opening new
                            " buffers

" " auto lcd to the current buffer
" autocmd BufEnter * silent! lcd %:p:h
" auto save buffer on losing focus
" autocmd FocusLost * :wa

" }}}


" ui {{{
set textwidth=120            " limit text width to 120 chars
set scrolloff=4             " keep this cursor context when scrolling
set sidescrolloff=4         " 
set cursorline              " highlight the current line

" set cursor shape
" if exists('$TMUX')
"   let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"   let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
" else
"   let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"   let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" endif

" status line {{{
set showcmd                 " show partial command in the status line
set cmdheight=1             " command line height
set laststatus=2            " always show status line

set statusline=%<»%f\ (%{getcwd()})\ %M%R%=%-6.(%c%V%)\ %P

" }}}

set colorcolumn=+1,+2,+3,+4 " color columns at the end of line
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
set termguicolors
colorscheme base16-tomorrow-night
set background=dark

" editing behavour {{{
set linebreak               " wrap lines at whitespace (see breakat)

" tabs and whitespace
set expandtab               " expand tabs by default
set tabstop=4               " a tab is four spaces
set softtabstop=4           " remove four spaces at once as if it were a tab
set shiftwidth=4            " number of spaces for autoindenting
set shiftround              " round to shiftwidth for indenting with > and <

set listchars=tab:»·,trail:·,extends:›,eol:¬ " symbols for tabs, empty trails
                                             " and too long lines

set showmatch               " when inserting a bracket show a matching one
set matchtime=2             " show a matching bracket for <n> msec

" search {{{
set ignorecase              " ignore case when searching
set smartcase               " ignore case if search pattern is lowercase,
                            " otherwise be case-sensitive
set inccommand=nosplit      " interactive substitute command

" use ripgrep instead of grep when available
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
" }}}

" folding {{{
set foldcolumn=2            " add a fold column
set foldmethod=marker       " use foldmarkers as the only folding method
set foldmarker=\ {{{,\ }}}  " adjust foldmarkers to include a space
" }}}

" }}}


" commands and key mappings {{{

" vimrc management
nnoremap <silent> <leader>sv :source $MYVIMRC<cr>
nnoremap <silent> <leader>se :tabe $MYVIMRC<cr>

" cmdline mappings {{{
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Delete>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
cnoremap <M-d> <S-Right><Delete>
" }}}

" browsing {{{

" scroll 3 lines at once
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" jump list
nnoremap <silent> <M-j> :jump<cr>

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

" re-format paragraph
nnoremap <leader>q gqip

" start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" }}}

" windows {{{
"nnoremap <silent> <C-c> :close<cr>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <silent> <C-q> :quit<cr>
nnoremap <silent> <Left> :vertical resize -5<cr>
nnoremap <silent> <Right> :vertical resize +5<cr>
nnoremap <silent> <Up> :resize -5<cr>
nnoremap <silent> <Down> :resize +5<cr>
" }}}

" files, buffers, tabs {{{

" FZF file and buffer list
nnoremap <expr> <M-f> system('git rev-parse') ? ':Files<cr>' : ':GFiles<cr>'
nnoremap <M-F> :Files<cr>
nnoremap <M-b> :Buffers<cr>
nnoremap <M-:> :History:<cr>
nnoremap <M-p> :call fzf#run({'source': '~/.config/nvim/gpf ~/git', 'sink': function('Open_Project')})<cr>

function! Open_Project(project)
    let dir = '~/git/' . a:project
    execute 'tabedit' dir
    execute 'tcd' dir
endfunc

" tab browsing
nnoremap <silent> <M-h> :tabprev<cr>
nnoremap <silent> <M-l> :tabnext<cr>
nnoremap <silent> <M-1> 1gt<cr>
nnoremap <silent> <M-2> 2gt<cr>
nnoremap <silent> <M-3> 3gt<cr>
nnoremap <silent> <M-4> 4gt<cr>
nnoremap <silent> <M-5> 5gt<cr>
nnoremap <silent> <M-6> 6gt<cr>

" delete the current buffer without closing the window
command! Bd bp\|bd \#
" }}}

" registers
nnoremap <silent> <M-r> :registers<cr>

nnoremap <M-g> :Rg<space>
nnoremap <M-t> :Tags<cr>
nnoremap <M-m> :Marks<cr>

" folding
nnoremap z0 :set foldlevel=0<cr>
nnoremap z1 :set foldlevel=1<cr>
nnoremap z2 :set foldlevel=2<cr>
nnoremap z3 :set foldlevel=3<cr>
nnoremap z4 :set foldlevel=4<cr>

" Git
nnoremap <silent> <leader>gg :GitGutterToggle<cr>

nnoremap <F5> :UndotreeToggle<cr>

" }}}

