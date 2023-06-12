set hlsearch    " highlight all search results
set ignorecase  " do case insensitive search 
set incsearch   " show incremental search results as you type
set number      " display line number
set noswapfile  " disable swap file

let g:airline_powerline_fonts = 1
let g:airline_theme = 'sol'

call plug#begin('~/.vim/plugged')
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'scrooloose/nerdtree'
	Plug '/usr/local/opt/fzf'
	Plug 'junegunn/fzf.vim'
	Plug 'jiangmiao/auto-pairs'
	Plug 'sheerun/vim-polyglot'

	Plug 'prettier/vim-prettier', {
  \ 'do': 'npm i',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html', 'typescriptreact', 'javascriptreact'] }

call plug#end()

autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd BufWritePre *.tsx,*.ts Prettier 

set relativenumber
set re=0
set foldmethod=syntax
set cursorcolumn

map <C-e> :NERDTreeToggle<CR>
map <C-f> :FZF<CR>
map <C-v> :vsplit<CR>
map <C-x> :split<CR>


let &t_EI = "\<Esc>[1 q"
let &t_SR = "\<Esc>[3 q"
let &t_SI = "\<Esc>[5 q"

nnoremap <space> za
