" @fILE              : .vimrc for ttpearso

" I'm deprecated these until otherwise deemed necessary
" filetype on          " USE <CTRL>+P to autocomplete 
" set clipboard=unnamed
" set backspace=indent,eol,start   " allow backspacing over everything in insert mode
" retab               " force all Tab characters to match current Tab prefferences
" Turn off search wrapping 
"  " 'gg' go on top and serch with '/'
"  " 'G' go at bootom and search with '?' 
" set nowrapscan
" set vb t_vb=         " don't notify (no audio/visual bell)
" set textwidth=99     " break line at 100 chars
" set viminfo='10,\"100,:20,%,n~/.viminfo

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
filetype on 

" VUNDLE PLUGINS
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

let g:vim_markdown_folding_disabled=1

colorscheme elflord
set nu               " Set line numbering
set nocompatible     " Not like Vi

syntax on            " Enable syntax highlighting
set autoindent       " Autoidentation on
set showmatch        " Blink back to closing bracket (using % key)

set smartindent
set showmatch

set background=dark  " Highlighting depends on background color (dark or light)

set ignorecase       " Ignore case in search
set smartcase        " Consider case only when typing Uppercase
set incsearch        " Show search results when typing
set hlsearch         " highlight search pattern
set showmode         " display mode INSERT/REPLACE/...
set scrolloff=3      " dont let the curser get too close to the edge
set laststatus=2     " laststatus:  show status line?  Yes, always!

set tabstop=3        " Set Tab size
set expandtab        " Expand Tabs (pressing Tab inserts spaces)
set shiftwidth=3     " Number of spaces to use for each step of (auto)indent 
set softtabstop=3    " makes the spaces feel like real tabs; one backspace goes back 3 spaces :)

" In visual mode: TAB and Shift-TAB for indenting
vmap <TAB>     >
vmap <S-TAB>   <

au BufRead,BufNewFile *.todo setfiletype todo
filetype plugin indent on

fun! Getchar()
   let c = getchar()
   if c != 0
      let c = nr2char(c)
   endif
   return c
endfun

fun! Eatchar(pat)
   let c = Getchar()
   return (c =~ a:pat) ? '' : c
endfun

au BufRead,BufNewFile *.cf set ft=cf3

au BufRead,BufNewFile *.js set ft=javascript
autocmd FileType javascript nmap <F12> :call RunWith("node")<cr>

call vundle#end()            " required
filetype plugin indent on    " required
