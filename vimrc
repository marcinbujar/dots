"mmd vimrc

colorscheme default

" auto cd to pwd
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

" syntax highlighting
filetype on
syntax on

" tabs
set tabstop=4
set expandtab
set autoindent
set number

" mappings
map <F2> gqip
