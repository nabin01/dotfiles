" TODO
" not auto comment / this is not working at all

set encoding=utf-8

call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
" Plug 'preservim/nerdcommenter'
Plug 'ryanoasis/vim-devicons'
Plug 'dracula/vim'
Plug 'ajh17/spacegray.vim'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'morhetz/gruvbox'
Plug 'vim-scripts/vim-auto-save'
Plug 'majutsushi/tagbar'
" Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" let g:coc_global_extensions = ['coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver']
call plug#end()

" Configuration
set nowrap

set nocompatible

" show line numbers
set nu rnu  
set numberwidth=1

" relative numbers only when not in insert mode
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set rnu
    autocmd BufLeave,FocusLost,InsertEnter * set nornu
augroup END

" Set Proper Tabs
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab

" Buffers
set autoread
set hidden
set splitbelow
set splitright
set switchbuf=useopen
set tabpagemax=50

" Always display the status line
set laststatus=2

" Enable Elite mode
let g:elite_mode=1

" Enable highlighting of the current line
set cursorline

" Theme and Styling
if (has("termguicolors"))
	set termguicolors
endif
syntax enable
set t_Co=256
colorscheme dracula

" Disable auto commenting on next line
"autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
setlocal formatoptions-=cro

filetype plugin on

set mouse=a

" enable auto save by default
let g:auto_save = 0
let g:auto_save_silent = 1

" comment indented left
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTreeShowLineNumbers=0

" Mappings
" Map jj to escape insert mode
let mapleader = ","
inoremap jj <Esc>

nmap <Leader><Leader> <Leader>cc

" copy and paste
vmap <C-c> "+y
nmap <C-v> "+p

" inoremap <C-Enter> <Esc>o

" NerdTree
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>
" Toggle tagbar
map <A-m> :TagbarToggle<CR>

" open new split panes to right and below
set splitright
set splitbelow

" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>

" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | :setlocal nonumber norelativenumber | endif

augroup terminalsettings
    autocmd!
    if has('nvim')
        autocmd TermOpen * setlocal nonumber norelativenumber
        autocmd TermOpen * startinsert
    endif
augroup end

function! OpenTerminal() abort
    if !has('nvim')
        return v:false
    endif

    " Create the terminal buffer
    if !exists('g:terminal') || !g:terminal.term.loaded
        return s:terminalcreate()
    endif

    " Go back to origin buffer if current buffer is terminal.
    if g:terminal.term.bufferid ==# bufnr('')
        silent execute 'buffer' g:terminal.origin.bufferid

    " Launch terminal buffer and start insert mode.
    else
        let g:terminal.origin.bufferid = bufnr('')

        silent execute 'buffer' g:terminal.term.bufferid
        startinsert
    endif
endfunction

function! s:terminalcreate() abort
    if !has('nvim')
        return v:false
    endif

    if !exists('g:terminal')
        let g:terminal = {'opts': {}, 'term': {'loaded': v:null, 'bufferid': v:null}, 'origin': {'bufferid': v:null}}

        function! g:terminal.opts.on_exit(jobid, data, event) abort
            silent execute 'buffer' g:terminal.origin.bufferid
            silent execute 'bdelete!' g:terminal.term.bufferid

            let g:terminal.term.loaded = v:null
            let g:terminal.term.bufferid = v:null
            let g:terminal.origin.bufferid = v:null
        endfunction
    endif

    if g:terminal.term.loaded
        return v:false
    endif

    let g:terminal.origin.bufferid = bufnr('')

    enew
    call termopen(&shell, g:terminal.opts)

    let g:terminal.term.loaded = v:true
    let g:terminal.term.bufferid = bufnr('')
endfunction

tnoremap <silent> <C-z> <C-\><C-n> :call OpenTerminal()<CR>
nnoremap <silent> <C-z> :call OpenTerminal()<CR>

" use alt+hjkl to move between spilt/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" fzf
nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
	\ 'ctrl-t': 'tab split',
	\ 'ctrl-s': 'split',
	\ 'ctrl-v': 'vsplit'
	\}

" Disable arrow movement
if get(g:, 'elite_mode')
    nnoremap <Up>       :resize +2<CR>
    nnoremap <Down>     :resize -2<CR>
    nnoremap <Left>     :vertical resize +2<CR>
    nnoremap <Right>    :vertical resize -2<CR>
endif

" coc settings
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

" <TAB>: completion
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
    imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
