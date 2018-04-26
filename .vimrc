set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set cindent

"if &term=="xterm"
"	set t_Co=8
"	set t_Sb=^[[4%dm
"	set t_Sf=^[[3%dm
"endif

set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar right
set guioptions-=L  "scrollbar left
set guioptions-=b  "scrollbar bottom

set hls
set number
set background=dark
colorscheme gruvbox

hi Search cterm=NONE ctermfg=black ctermbg=grey
highlight LineNr ctermfg=grey
let Tlist_Use_Right_Window=1
let Tlist_Auto_Update=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Show_One_File=1
nmap <silent><F2> :TlistToggle <CR>
nmap <silent><F3> :NERDTreeFind <CR>
nmap <silent><F4> :NERDTreeClose <CR> 
nmap <Leader>es diwmb      " exchange words begin
nmap <Leader>ee viwp`bP    " exchange words end
let g:NERDTreeWinSize=35
let g:Tlist_WinWidth=50


"""""""""""""""""""""""easy motion""""""""""""""""""""""""""""""
"overwin: over window"

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f2)
nmap <Leader>f <Plug>(easymotion-overwin-f2)

" s{char}{char} to move to {char}{char}
" nmap s <Plug>(easymotion-overwin-f2) Need one more keystroke, 
" but on average, it may be more comfortable.
" nmap s <Plug>(easymotion-overwin-f)

" Move to line
map <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
""""""""""""""""""""""""end""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""Vundle"""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
""""""""""""""""""""""""""""end"""""""""""""""""""""""""""""""""
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'

" Optional:
Plugin 'honza/vim-snippets'