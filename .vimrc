" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif


" Specify plugin directory
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'itchyny/lightline.vim'
Plug 'frazrepo/vim-rainbow'
Plug 'https://tpope.io/vim/surround.git'
Plug 'https://github.com/airblade/vim-gitgutter.git'
Plug 'https://github.com/tpope/vim-sleuth'
Plug 'https://github.com/jnurmine/Zenburn.git'

" Initialize plugin system
call plug#end()

colorscheme zenburn
hi Normal guibg=NONE ctermbg=NONE
let g:rainbow_active = 1
set number
set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab
