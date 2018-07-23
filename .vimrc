set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set cindent

set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar right
set guioptions-=L  "scrollbar left
set guioptions-=b  "scrollbar bottom

set laststatus=2   "show statusline
set statusline=%f  "F full path
set number
set background=dark
colorscheme gruvbox

if filereadable('cscope.out')
	cs add cscope.out
endif

if !exists('*Cpp_tags')
	function Cpp_tags() "{{{
		!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --exclude=cscope.out
		set tags+=./tags,./TAGS,tags,TAGS
	endfunction "}}}
endif

if !exists('*C_tags')
	function C_tags() "{{{
		!ctags -R --C-kinds=+p --fields=+aS --extra=+q --exclude=cscope.out
		set tags+=./tags,./TAGS,tags,TAGS
	endfunction "}}}
endif

if !exists('*Func_call')
	function! Func_call() "{{{
		let maker = input('Enter maker: ')
		SignatureListMarkers maker, 3
	endfunction "}}}

	nmap <silent><F1> :call Func_call() <CR>
endif

" hi Search cterm=NONE ctermfg=black ctermbg=grey
" highlight LineNr ctermfg=grey
let Tlist_Use_Right_Window=1
let Tlist_Auto_Update=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Show_One_File=1
let g:airline_powerline_fonts=1 "need https://github.com/powerline/fonts
let b:airline_whitespace_disabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
nmap <silent><F2> :TagbarOpenAutoClose <CR>
autocmd BufEnter __Tagbar__* nmap <silent><F2> :TagbarToggle <CR>
autocmd BufHidden __Tagbar__* nmap <silent><F2> :TagbarOpenAutoClose <CR>
" nmap <silent><F2> :TlistToggle <CR>
nmap <silent><F3> :NERDTreeFind  <CR>
autocmd BufEnter NERD_tree_* nmap <silent><F3> :NERDTreeToggle <CR>
autocmd BufHidden NERD_tree_* nmap <silent><F3> :NERDTreeFind  <CR>
nmap <silent><F4> :MundoToggle <CR>

" exchange words begin
nmap <Leader>es diwmb

" exchange words end
nmap <Leader>ee viwp`bP

" nmap <Leader>st :TlistShowTag <CR>
nmap <silent><Leader>s :TagbarCurrentTag <CR>

" "hy is yank words to h
" <C-r>h is past h
" c is confirm,
" <left> move cursor to one left.
" vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
vnoremap <C-r> "hy:%s/<C-r>h//g<left><left>| noh

let g:NERDTreeWinSize=35
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeIgnore = ['\.git$', '\.out$', 'tags[[file]]', 'TAGS[[file]]', '\.o$', '\.so$']
let g:NERDTreeMapToggleFilters = ""
let g:Tlist_WinWidth=50
let g:tagbar_width=60
" let g:mundo_width = 45
" let g:mundo_right = 1

"""""""""""""""""""""""easy motion""""""""""""""""""""""""""""""
"overwin: over window"

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" <Leader>f{char} to move to {char}
vmap <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
" nmap s <Plug>(easymotion-overwin-f2) Need one more keystroke, 
" but on average, it may be more comfortable.
nmap f <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" Gif config
" map  / <Plug>(easymotion-sn)
" omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to
" EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)
""""""""""""""""""""""""end""""""""""""""""""""""""""""""""

""""""""""""""""""""""""signature""""""""""""""""""""""""""
nnoremap <silent>[1 :call signature#marker#Goto('prev', 1, v:count) <CR>
nnoremap <silent>]1 :call signature#marker#Goto('next', 1, v:count) <CR>
nnoremap <silent>[2 :call signature#marker#Goto('prev', 2, v:count) <CR>
nnoremap <silent>]2 :call signature#marker#Goto('next', 2, v:count) <CR>
nnoremap <silent>[3 :call signature#marker#Goto('prev', 3, v:count) <CR>
nnoremap <silent>]3 :call signature#marker#Goto('next', 3, v:count) <CR>
""""""""""""""""""""""""""end""""""""""""""""""""""""""""""

"""""""""""""""""""""""Mark""""""""""""""""""""""""""""""""
nmap <unique> <Leader>] <Plug>MarkSet
xmap <unique> <Leader>] <Plug>MarkSet
nmap <unique> <Leader>[ <Plug>MarkClear
nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
"""""""""""""""""""""""end"""""""""""""""""""""""""""""""""

"""""""""""""""""""""""Omni""""""""""""""""""""""""""""""""
set completeopt=menu,menuone
let OmniCpp_MayCompleteDot=1    "打开  . 操作符
let OmniCpp_MayCompleteArrow=1  "打开 -> 操作符
let OmniCpp_MayCompleteScope=1  "打开 :: 操作符
let OmniCpp_NamespaceSearch=1   "打开命名空间
let OmniCpp_GlobalScopeSearch=1
let OmniCpp_DefaultNamespace=["std"]
let OmniCpp_ShowPrototypeInAbbr=1  "打开显示函数原型
let OmniCpp_SelectFirstItem = 2 "自动弹出时自动跳至第一个
"""""""""""""""""""""""end"""""""""""""""""""""""""""""""""

"""""""""""""""""""""""CCTree""""""""""""""""""""""""""""""
let CCTreeEnhancedSymbolProcessing = 1	"CCTreeOptsEnable EnhancedSymbolProcessing
highlight CCTreeHiSymbol  gui=bold guibg=darkblue guifg=peachpuff ctermfg=blue
highlight CCTreeHiMarkers  gui=bold guifg=darkgreen guibg=lightyellow
"""""""""""""""""""""""end"""""""""""""""""""""""""""""""""

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
Plugin 'wincent/command-t'
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
Plugin 'dradtke/OmniCppComplete'
Plugin 'othree/vim-autocomplpop'
Plugin 'vim-scripts/L9'
Plugin 'honza/vim-snippets'
Plugin 'simnalamburt/vim-mundo'
Plugin 'inkarkat/vim-ingo-library'
Plugin 'inkarkat/vim-mark'
Plugin 'kshenoy/vim-signature'
Plugin 'hari-rangarajan/CCTree'
Plugin 'scrooloose/nerdtree'
Plugin 'easymotion/vim-easymotion'
Plugin 'majutsushi/tagbar'
Plugin 'skywind3000/vim-preview'
Plugin 'vim-airline/vim-airline'
Plugin 'morhetz/gruvbox'
