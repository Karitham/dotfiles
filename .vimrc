let mapleader = ","

set hlsearch
set ignorecase 
set number 
set nocompatible
set scrolloff=10
set incsearch
set smartcase
set showcmd
set showmode
set showmatch
set history=100
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.pdf,*.xlsx,*.svg

syntax on
filetype on
filetype plugin on
filetype indent on

call plug#begin('~/.vim/plugged')
	Plug 'junegunn/vim-easy-align'
	Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
	Plug 'fatih/vim-go', { 'commit': 'f42b069ffd4ba756461b717411595ffc7b2bccb2' }
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	Plug 'ziglang/zig.vim'
	Plug 'tpope/vim-fugitive'
	Plug 'Shougo/ddc.vim'
call plug#end()

" Autocomplete
let g:deoplete#enable_at_startup = 1

" NT config
nnoremap <F3> :NERDTreeToggle<cr>
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']

" vim-go config
let g:go_fmt_command = "gofumpt"
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1

" Escape insert with jj
inoremap jj <esc>

" Move lines around
nnoremap <A-Down> :m .+1<CR>==
nnoremap <A-Up> :m .-2<CR>==
inoremap <A-Down> <Esc>:m .+1<CR>==gi
inoremap <A-Up> <Esc>:m .-2<CR>==gi
vnoremap <A-Down> :m '>+1<CR>gv=gv
vnoremap <A-Up> :m '<-2<CR>gv=gv 

" Duplicate line down
nnoremap <C-A-Down> Vyp

" Move to side pannel
nnoremap <c-Right> <c-w>l
nnoremap <c-Up> <c-w>k
nnoremap <c-Down> <c-w>j
nnoremap <c-Left> <c-w>h

" Split/Close Pane
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>c :q<CR>

" Remove highlighting
nnoremap <leader>/ :nohlsearch<CR>

" Completion
inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
\ "\<lt>C-n>" :
\ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
\ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
\ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
imap <C-@> <C-Space>

" Def
autocmd FileType go,gohtml nmap <leader>d :GoDef<CR>
