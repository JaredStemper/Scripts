if has('python3')
  silent! python3 1
endif

set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

" Keep Plugin commands between vundle#begin/end.
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'ycm-core/YouCompleteMe'


call vundle#end()            " required
filetype plugin indent on    " required




set rnu nu autoindent noexpandtab tabstop=4 shiftwidth=4
au BufNewFile,BufRead * if &syntax == '' | set syntax=python | endif
set foldmethod=indent 
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview
map <F3> ggg?G``
nmap <F5> :exec &nu==&rnu? "se nu!" : "se rnu!"<CR>
set laststatus=2
set statusline=%f%m%r%h%w\ [%Y]\ [0x%02.2B]%<\ %F%4v,%4l\ %3p%%\ of\ %L\ lines
set foldignore=
set ignorecase smartcase

" let g:ycm_python_interpreter_path = ''
" let g:ycm_python_sys_path = []
" let g:ycm_extra_conf_vim_data = [
" 	\ 'g:ycm_python_interpreter_path',
" 	\ 'g:ycm_python_sys_path'
" 	\]
" let g:ycm_global_ycm_extra_conf = '~/.vim/global_extra_conf.py'
let g:ycm_confirm_extra_conf = 0


set backspace=indent,eol,start
syntax on
