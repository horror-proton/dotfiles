source /usr/share/vim/vimfiles/archlinux.vim

set number
set ruler
set scrolloff=5
set relativenumber
set nowrap
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab
set smarttab

set conceallevel=2

noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>

let g:python3_host_prog='/usr/sbin/python3'

filetype plugin indent on
syntax enable

lua require('plugins')

