"mmd vimrc

colorscheme default

" auto cd
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

" syntax highlighting
filetype on
syntax on

" tabs
set tabstop=4
set expandtab
set autoindent
set number

" search
set ignorecase
set smartcase
set hlsearch
set incsearch 

" cmd autocomplete
set wildmenu
set wildmode=longest:full,full

" splits
set splitright
set splitbelow

" mappings
map <F2> gqip
