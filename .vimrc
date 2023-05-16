set encoding=utf-8
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set autoindent
set cindent
set nocp
set noswapfile
set ttimeoutlen=0

set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar right
set guioptions-=L  "scrollbar left
set guioptions-=b  "scrollbar bottom

set number
set background=dark
set nohlsearch
set backspace=indent,eol,start
set t_Co=256
colorscheme gruvbox
syntax on

""""""""">4;2m"""""""""
let &t_TI = ""
let &t_TE = ""
"""""""""""""""""""""""

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

let g:tmux_navigator_no_mappings = 1
if !empty($TMUX)
   nnoremap <silent> <C-w>h :TmuxNavigateLeft<cr>
   nnoremap <silent> <C-w><C-h> :TmuxNavigateLeft<cr>
   nnoremap <silent> <C-w>j :TmuxNavigateDown<cr>
   nnoremap <silent> <C-w><C-j> :TmuxNavigateDown<cr>
   nnoremap <silent> <C-w>k :TmuxNavigateUp<cr>
   nnoremap <silent> <C-w><C-k> :TmuxNavigateUp<cr>
   nnoremap <silent> <C-w>l :TmuxNavigateRight<cr>
   nnoremap <silent> <C-w><C-l> :TmuxNavigateRight<cr>
   nnoremap <silent> <C-w>w :TmuxNavigatePrevious<cr>
   nnoremap <silent> <C-w><C-w> :TmuxNavigatePrevious<cr>
endif

function MoveToPrevTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
        return
    endif
    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')
    if tabpagenr() != 1
        close!
        if l:tab_nr == tabpagenr('$')
            tabprev
        endif
        vert rightbelow split
    else
        close!
        exe "0tabnew"
    endif
    "opening current buffer in new window
    exe "b".l:cur_buf
endfunc
command! -nargs=? MoveToPrevTab call MoveToPrevTab()

function MoveToNextTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
        return
    endif
    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')
    if tabpagenr() < tab_nr
        close!
        if l:tab_nr == tabpagenr('$')
            tabnext
        endif
        vert rightbelow split
    else
        close!
        tabnew
    endif
    "opening current buffer in new window
    exe "b".l:cur_buf
endfunc
command! -nargs=? MoveToNextTab call MoveToNextTab()

function! Cscope(path)
    if !empty(a:path)
        let curPath = getcwd() . '/' . a:path
        let strList = split(curPath, "/")
        let csName = strList[len(strList) - 2] . '_' . strList[len(strList) - 1] . '_cscope.out'
    else
        let curPath = getcwd()
        let csName = 'cscope.out'
    endif
    let ret = system("find ".curPath." -regex ".shellescape('.*/.*\.\(c\|cpp\|cc\|hpp\|h\)$')." > cscope.files")
    let ret = system('cscope -b -q -i cscope.files -f '.csName)
    let ret = system('rm cscope.files')
    execute('cs add '.csName)
endfunction
command! -nargs=? -complete=dir Cscope call Cscope(<q-args>)

function! Cpp_tags(path) "{{{
    if !empty(a:path)
        let curPath= a:path
    else
        let curPath = getcwd()
    endif
    let ctags = 'find ' .curPath. ' \( -name \*.h -o -name \*.cpp -o -name \*.c -o -name \*.cc -o -name \*.hpp \) -not -type l -print | xargs '
    let ctags .= 'ctags '
    let ctags .= '--append=yes '
    let ctags .= '--c++-kinds=+p '
    let ctags .= '--fields=+iaSn '
    let ctags .= '--extras=+q '
    echom ctags
    let ret = system(ctags)
    if !empty(ret)
        echom ret
    else
        echom 'ctags build successful on '.expand(curPath)
    endif
    set tags+=./tags,./TAGS,tags,TAGS
endfunction "}}}
command! -nargs=? -complete=dir CppTags call Cpp_tags(<q-args>)

function! C_tags(path) "{{{
   " !ctags -R --append=yes --C-kinds=+p --fields=+aS --extras=+q --exclude=cscope.out
   " set tags+=./tags,./TAGS,tags,TAGS
    if !empty(a:path)
        let curPath= a:path
    else
        let curPath = getcwd()
    endif
    let ctags = 'ctags -R '
    let ctags .= '--append=yes '
    let ctags .= '--c-kinds=+px '
    let ctags .= '--fields=+aSn '
    let ctags .= '--extras=+q '
    let ctags .= '--exclude=cscope.out '
    let ctags .= curPath
    echom ctags
    let ret = system(ctags)
    if !empty(ret)
        echom ret
    else
        echom 'ctags build successful on '.expand(curPath)
    endif
    set tags+=./tags,./TAGS,tags,TAGS
endfunction "}}}
command! -nargs=? -complete=dir Ctags call C_tags(<q-args>)

if !exists('g:lasttab')
    let g:lasttab = 1
endif
au TabLeave * let g:lasttab = tabpagenr()
command! LastTab :execute "tabnext".g:lasttab
nmap <silent>gT :LastTab <CR>

function! TabNx()
    if tabpagenr() == tabpagenr('$')
        return 'tabn' . (empty(v:count) ? v:count + 1 : v:count)
    elseif tabpagenr() + v:count > tabpagenr('$')
        return 'tabn' . (v:count - (tabpagenr('$') - tabpagenr()))
    else
        return 'tabn+' . (empty(v:count) ? v:count + 1 : v:count)
    endif
endfunction
noremap <expr> gt ':<C-U>' . TabNx() . '<CR>'
noremap <expr> gp ':<C-U>' . (v:count > 1 ? v:count : '') . 'tabprevious<CR>'

" hi Search cterm=NONE ctermfg=black ctermbg=grey
" highlight LineNr ctermfg=grey
hi QuickFixLine ctermbg=None
let Tlist_Use_Right_Window=1
let Tlist_Auto_Update=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Show_One_File=1
let g:airline_powerline_fonts=1 "need https://github.com/powerline/fonts
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#formatter = 'unique_tail'
let airline#extensions#tabline#tabs_label = ''
let airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#show_tab_nr = 0

let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ''

nmap <silent><F2> :TagbarOpenAutoClose <CR>
autocmd BufEnter __Tagbar__* nmap <silent><F2> :TagbarToggle <CR>
autocmd BufHidden __Tagbar__* nmap <silent><F2> :TagbarOpenAutoClose <CR>
" nmap <silent><F2> :TlistToggle <CR>
nmap <silent><F3> :NERDTreeFind  <CR>
autocmd BufEnter NERD_tree_* nmap <silent><F3> :NERDTreeToggle <CR>
autocmd BufHidden NERD_tree_* nmap <silent><F3> :NERDTreeFind  <CR>
nmap <silent><F4> :MundoToggle <CR>
command! GREP :execute 'vimgrep /'.expand('<cword>').'/j '.expand('%') | copen
nmap grep :GREP <CR>
""""""""""""""""""""""""""""""
execute "set <M-p>=\ep"
noremap <silent> <M-p> :PreviewTag <CR>

execute "set <M-u>=\eu"
noremap <silent> <M-u> :PreviewScroll -1 <CR>

execute "set <M-d>=\ed"
noremap <silent> <M-d> :PreviewScroll +1 <CR>

"nmap <silent> <A-Up> :wincmd k<CR>
"nmap <silent> <A-Down> :wincmd j<CR>
"nmap <silent> <A-Left> :wincmd h<CR>
"nmap <silent> <A-Right> :wincmd l<CR>
"nnoremap <C-Left> :tabprevious<CR>
"nnoremap <C-Right> :tabnext<CR>
"nnoremap <silent> gp :tabprevious<CR>
vnoremap <C-c>  "+y
map <C-v>       "+gP
cmap <C-v>      <C-R>+
imap <C-v>      <C-R>+
"""""""""""""""""""""""""""""""
nmap <silent><Leader>s :TagbarCurrentTag <CR>

nnoremap <silent> <plug>(quickr_preview_qf_close) :cclose<CR>:lclose<CR>
nmap <leader>q <plug>(quickr_preview_qf_close)
"""""""""""""""""""""""""""""""

let g:NERDTreeWinSize = 35
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeIgnore = ['\.git$', '\.out$', 'cscope[[file]]', 'tags[[file]]', 'TAGS[[file]]', '\.o$', '\.so$']
let g:NERDTreeMapToggleFilters = 'h'
let g:Tlist_WinWidth = 50
let g:tagbar_width = 60
" let g:mundo_width = 45
" let g:mundo_right = 1

"""""""""""""""""""""""easy motion""""""""""""""""""""""""""""""
"overwin: over window"

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'

" JK motions: Line motions
"nmap <Leader>j <Plug>(easymotion-j)
map <C-j> <Plug>(easymotion-j)
"nmap <Leader>k <Plug>(easymotion-k)
map <C-k> <Plug>(easymotion-k)

" <Leader>f{char} to move to {char}
"vmap <Leader>f <Plug>(easymotion-bd-f)
"nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
" nmap s <Plug>(easymotion-overwin-f2) Need one more keystroke, 
" but on average, it may be more comfortable.
"nmap F <Plug>(easymotion-overwin-f2)
nmap f <Plug>(easymotion-bd-w)

" Move to line
"map <Leader>l <Plug>(easymotion-bd-jk)
"nmap <Leader>l <Plug>(easymotion-overwin-line)

" Move to word
"map  <Leader>w <Plug>(easymotion-bd-w)
"nmap <Leader>w <Plug>(easymotion-overwin-w)

map <C-h> <Plug>(easymotion-bl)
map <C-l> <Plug>(easymotion-wl)

" Gif config
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to
" EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
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
nmap <Leader>] <Plug>MarkSet
xmap <Leader>] <Plug>MarkSet
nmap <Leader>[ <Plug>MarkClear
nmap <Leader>n <Plug>MarkAllClear
nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
nmap <Leader>1  <Plug>MarkSearchGroup1Next
nmap <Leader>2  <Plug>MarkSearchGroup2Next
nmap <Leader>3  <Plug>MarkSearchGroup3Next
nmap <Leader>4  <Plug>MarkSearchGroup4Next
nmap <Leader>5  <Plug>MarkSearchGroup5Next
nmap <Leader>6  <Plug>MarkSearchGroup6Next
nmap <Leader>7  <Plug>MarkSearchGroup7Next
"""""""""""""""""""""""end"""""""""""""""""""""""""""""""""

"""""""""""""""""""""""Omni""""""""""""""""""""""""""""""""
" OmniCppComplete
"let OmniCpp_NamespaceSearch = 1
"let OmniCpp_GlobalScopeSearch = 1
"let OmniCpp_ShowAccess = 1
"let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
"let OmniCpp_MayCompleteDot = 1 " autocomplete after .
"let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
"let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
"let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
" au InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest
"""""""""""""""""""""""end"""""""""""""""""""""""""""""""""

"""""""""""""""""""""""CCTree""""""""""""""""""""""""""""""
let CCTreeEnhancedSymbolProcessing = 1	"CCTreeOptsEnable EnhancedSymbolProcessing
highlight CCTreeHiSymbol  gui=bold guibg=darkblue guifg=peachpuff ctermfg=blue
highlight CCTreeHiMarkers  gui=bold guifg=darkgreen guibg=lightyellow
"""""""""""""""""""""""end"""""""""""""""""""""""""""""""""

""""""""""""""""""""auto-pair""""""""""""""""""""""
execute "set <M-q>=\eq"
let g:AutoPairsShortcutFastWrap = '<M-q>'

let g:AutoPairsShortcutToggle = ''
""""""""""""""""""""""END""""""""""""""""""""""""""

""""""""""""""""""qf-preview"""""""""""""""""
augroup qfpreview
    autocmd!
    autocmd FileType qf nmap <buffer> p <plug>(qf-preview-open)
augroup END
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:NERDCreateDefaultMappings = 0
nmap <BS> <Plug>NERDCommenterSexy
vmap <BS> <Plug>NERDCommenterSexy

let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_auto_hover=""
nmap <F1> <plug>(YCMHover)

""""""""""""""""""""""""Vundle"""""""""""""""""""""""""""""
call plug#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
"Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
" To ignore plugin indent changes, instead use:
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
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
let g:snipMate = { 'snippet_version' : 1 }

" Optional:
Plug 'ycm-core/YouCompleteMe'
Plug 'honza/vim-snippets'
Plug 'simnalamburt/vim-mundo'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
Plug 'kshenoy/vim-signature'
Plug 'hari-rangarajan/CCTree'
Plug 'scrooloose/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'majutsushi/tagbar'
Plug 'skywind3000/vim-preview'
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'vim-scripts/Auto-Pairs'
Plug 'terryma/vim-multiple-cursors'
Plug 'preservim/nerdcommenter'
Plug 'yueyihui/autoloadcscope'
Plug 'bfrg/vim-qf-preview'
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'christoomey/vim-tmux-navigator'
call plug#end()

""""""""""""""""codefmt""""""""""""""""
call glaive#Install()
" Optional: Enable codefmt's default mappings on the <Leader>= prefix.
"Glaive codefmt plugin[mappings]
Glaive codefmt plugin[mappings]='='
Glaive codefmt shfmt_options=`['-sr', '-ci']`

"augroup autoformat_settings
  "autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
"augroup END
"""""""""""""""""""""""""""""""""""""""

function! s:CustomizeYcmQuickFixWindow()
  " Move the window to the top of the screen.
  wincmd K
  " Set the window height to 5.
  5wincmd _
endfunction

autocmd User YcmQuickFixOpened call s:CustomizeYcmQuickFixWindow()

function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzyword#converter()],
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> F incsearch#go(<SID>config_easyfuzzymotion())
