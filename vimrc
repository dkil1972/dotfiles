""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" Now call pathogen
silent! call pathogen#infect()
silent! call pathogen#helptags()

filetype plugin indent on         " Turn on file type detection.

set backspace=indent,eol,start
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
" Always display the status line
set laststatus=2
set visualbell                    " No beeping.
set history=1000			  " keep 50 lines of command line history
set ruler			  " show the cursor position all the time
set showcmd			  " display incomplete commands
set showmode   			  
set incsearch			  " do incremental searching
set hidden                        " Handle multiple buffers better.
set wildmenu                      " Enhanced command line completion.
set nowrap			  " Switch wrap off for everything
set scrolloff=3                   " Show 3 lines of context around the cursor.
set title                         " Set the terminal's title
set cpoptions+=$                  " Places a dollar sign at the end of the 'to be' changed text.
" case only matters with mixed case expressions
set ignorecase
set smartcase
" Numbers
set number
set numberwidth=5

let mapleader = ","

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Set File type to 'text' for files ending in .txt
  autocmd BufNewFile,BufRead *.txt setfiletype text

  " Enable soft-wrapping for text files
  autocmd FileType text,markdown,html,xhtml,eruby setlocal wrap linebreak nolist

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  " autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Automatically load .vimrc source when saved
  autocmd BufWritePost .vimrc source $MYVIMRC

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")


""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax highlighting
""""""""""""""""""""""""""""""""""""""""""""""""
"Will not work under Teminal.app on Mac OS X - causes certain colors and characters to 'flash'.
set t_Co=256

syntax enable                     " Turn on syntax highlighting (compare with syntax on below)
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
  set incsearch                     " Highlight matches as you type
  set hlsearch                      " Highlight matches.
endif

if &diff
  "I'm only interested in diff colours
  syntax off
endif

" Color scheme
colorscheme distinguished
highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0


"syntax highlight shell scripts as per POSIX,
"not the original Bourne shell which very few use
let g:is_posix = 1

"flag problematic whitespace (trailing and spaces before tabs)
"Note you get the same by doing let c_space_errors=1 but
"this rule really applys to everything.
"highlight RedundantSpaces term=standout ctermbg=red guibg=red
"match RedundantSpaces /\s\+$\| \+\ze\t/ "\ze sets end of match so only spaces highlighted
"use :set list! to toggle visible whitespace on/off
set listchars=tab:>-,trail:.,extends:>

""""""""""""""""""""""""""""""""""""""""""""""""
" Key bindings
""""""""""""""""""""""""""""""""""""""""""""""""
map <CR> o<Esc>
map <C-d> VYp
map <S-Enter> O<Esc>j
"allow deleting selection without updating the clipboard (yank buffer)
vnoremap x "_x
vnoremap X "_X
vmap <Tab> >gv
vmap <S-Tab> <gv
" Opens an edit command with the path of the currently edited file filled in
" Normal mode: %%
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" For Haml
au! BufRead,BufNewFile *.haml         setfiletype haml

" No Help, please
nmap <F1> <Esc>
" Maps autocomplete to tab
imap <Tab> <C-N>

let g:fuf_splitPathMatching=1

vmap <C-c> :<Esc>`>a<CR><Esc>mx`<i<CR><Esc>my'xk$v'y!xclip -selection c<CR>u
map <Insert> :set paste<CR>i<CR><CR><Esc>k:.!xclip -o<CR>JxkJx:set nopaste<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>p :PromoteToLet<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COMMAND T
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Open files with <leader>f
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
" Open files, limited to the directory of the current file, with <leader>gf
" This requires the %% mapping found below.
map <leader>gf :CommandTFlush<cr>\|:CommandT %%<cr>
" Esc not working properly out of the box
let g:CommandTCancelMap=['<ESC>','<C-c>']

map <Leader>f :CtrlP<cr>
map <leader>/ :TComment<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUBY/RAILS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
imap <C-L> <Space>=><Space>


""""""""""""""""""""""""""""""""""""""""""""""""
" Leader bindings
""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>e :edit %%
nmap <leader>, <C-^>
" Hide search highlighting
map <Leader>h :set invhls <CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FILE NAVIGATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-j> <C-W>j
map <C-h> <C-W>h
map <C-k> <C-W>k
map <C-l> <C-W>l
nmap <F3> <leader>be
" Move lines up and down
map <C-U> :m +1 <CR>
map <C-m> :m -2 <CR>
