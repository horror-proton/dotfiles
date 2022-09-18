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

noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>

" let g:python3_host_prog='/usr/sbin/python3'

filetype plugin indent on
syntax enable

" Plugins managed by vim-plug ================================================
call plug#begin(stdpath('data') . '/plugged') " ~/.local/share/nvim/plugged

Plug 'tpope/vim-surround'

Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="vertical"

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'lervag/vimtex'
let g:vimtex_view_method='general'
let g:vimtex_view_general_viewer='SumatraPDF'

call plug#end()
