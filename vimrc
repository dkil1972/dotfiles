source ~/.vim/bundle/pathogen/autoload/pathogen.vim
call pathogen#runtime_append_all_bundles()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" Now call pathogen
silent! call pathogen#infect()
silent! call pathogen#helptags()

filetype plugin indent on         " Turn on file type detection.

runtime macros/matchit.vim        " Load the matchit plugin.
runtime macros/rails.vim        " Load the matchit plugin.

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
" Always display the status line
set laststatus=2
set visualbell                    " No beeping.
set nobackup			  " No automatic backups
set nowritebackup
set directory=$HOME/.vim/tmp//,.  " Keep swap files in one location
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
set gcr=n-c-v:nCursor
set gcr=i-ci:Cursor
" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
" set completeopt=longest,menu
set wildmode=longest,list
" set complete=.,t
" case only matters with mixed case expressions
set ignorecase
set smartcase
" Numbers
set number
set numberwidth=5
set winwidth=84
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winheight=5
set winminheight=5
set winheight=999
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
colorscheme vividchalk 
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
nmap <leader>, <C-^>
vmap <Tab> >gv
vmap <S-Tab> <gv
" Hide search highlighting
map <Leader>h :set invhls <CR>
" Opens an edit command with the path of the currently edited file filled in
" Normal mode: %%
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%



" For Haml
au! BufRead,BufNewFile *.haml         setfiletype haml

" No Help, please
nmap <F1> <Esc>
" Press ^F from insert mode to insert the current file name
imap <C-F> <C-R>=expand("%")<CR>

" Maps autocomplete to tab
imap <Tab> <C-N>

imap <C-L> <Space>=><Space>


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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
map <leader>c :w\|:!script/features<cr>
map <leader>w :w\|:!script/features --profile wip<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SNIPPETS 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:snippetsEmu_key = "<S-Tab>"
let g:snippets_dir = "~/.vim/bundle/snipmate/snippets"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RAILS COMMANDS 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! Rroutes :e config/routes.rb
command! Rschema :e db/schema.rb
" Edit the README_FOR_APP (makes :R commands work)
map <Leader>R :e doc/README_FOR_APP<CR>
map <Leader>m :Rmodel 
map <Leader>c :Rcontroller 
map <Leader>v :Rview 
map <Leader>u :Runittest 
map <Leader>rf :Rfunctionaltest 
map <Leader>l :Rlayout 
map <Leader>tm :RTmodel 
map <Leader>tc :RTcontroller 
map <Leader>tv :RTview 
map <Leader>tu :RTunittest 
map <Leader>tf :RTfunctionaltest 
map <Leader>sm :RSmodel 
map <Leader>sc :RScontroller 
map <Leader>sv :RSview 
map <Leader>su :RSunittest 
map <Leader>sf :RSfunctionaltest 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FILE NAVIGATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-j> <C-W>j
map <C-h> <C-W>h
map <C-k> <C-W>k
map <C-l> <C-W>l
map <F2> :NERDTreeToggle<CR>
nmap <F3> <leader>be
" Move lines up and down
map <C-U> :m +1 <CR>
map <C-m> :m -2 <CR>
