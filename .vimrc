"execute pathogen#infect()
filetype plugin indent on
syntax on
au! BufNewFile,BufRead *.md set filetype=markdown
au! BufNewFile,BufRead *.ledger set filetype=ledger
set t_Co=256
set background=dark
autocmd BufEnter * colorscheme torte
"autocmd BufEnter *.md,wiki colorschem peachpuff
autocmd BufEnter *.md,wiki colorschem slate
set nu
set nocompatible
let mapleader = ","
imap jj <ESC>
set backspace=2
set tabstop=3
set mouse=a
set wildmenu

" Show TABs and spaces
"set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
"set list

set statusline=%t%y%=%c,%l/%L\ %P
set laststatus=2

set spelllang=sv,en

" Search related settings
set incsearch
set hlsearch

" Map Ctrl+l to clear highlighted searches
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
