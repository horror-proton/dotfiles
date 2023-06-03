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

set showbreak=↪\ 
set list listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨,space:•

set mouse=a

set conceallevel=2

let g:python3_host_prog='/usr/sbin/python3'

filetype plugin indent on
syntax enable

lua require('lazy_nvim')

setlocal spell spelllang=en_us,cjk
set nospell

" write buffer on Ctrl+S
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>

" clang-format
map <C-K>                       :pyf /usr/share/clang/clang-format.py<CR>
imap <C-K>                      <C-O>:pyf /usr/share/clang/clang-format.py<CR>
function! Formatonsave()
  let l:formatdiff = 1
  pyf /usr/share/clang/clang-format.py
endfunction
" autocmd BufWritePre *.h,*.cc,*.cpp,*.hpp call Formatonsave()
