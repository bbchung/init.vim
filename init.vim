""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" bbchung init.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

"Vim-Plug {
let s:vim_plug_dir=expand($HOME.'/.config/nvim/autoload')
if !filereadable(s:vim_plug_dir.'/plug.vim')
    execute '!wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -P '.s:vim_plug_dir
    let s:install_plug=1
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'nanotech/jellybeans.vim'
Plug 'twerth/ir_black'
Plug 'itchyny/lightline.vim'
"Plug 'bling/vim-airline'
"Plug 'Shougo/unite.vim'
"Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf'
Plug 'majutsushi/tagbar'
Plug 'Valloric/YouCompleteMe'
Plug 'rhysd/vim-clang-format'
Plug 'bbchung/Clamp'
Plug 'bbchung/gtags.vim'
"Plug 'klen/python-mode'
"Plug 'scrooloose/syntastic'
Plug 'benekastah/neomake'
Plug 'jlanzarotta/bufexplorer'
"Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'Raimondi/delimitMate'
Plug 'terryma/vim-multiple-cursors'
Plug 'a.vim'
Plug 'CSApprox'
call plug#end()

if exists('s:install_plug')
    augroup PlugInstall
        au!
        au VimEnter * PlugInstall
    augroup END
endif
"}

" General vim settings {

colorscheme clamp
syntax on

"set lazyredraw
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif
if !&diff
    set cursorline
endif
set title               " show title in console title bar
set novisualbell        " turn off visual bell
set mouse=a
set conceallevel=0
set concealcursor=nc
set ls=2                " allways show status line
set ruler               " show the cursor position all the time
set number              " show line numbers
set showcmd             " display incomplete commands
set softtabstop=4       " numbers of spaces of tab character
set shiftwidth=4        " numbers of spaces to (auto)indent
set colorcolumn=0
set nowrap
set scrolloff=3         " keep 3 lines when scrolling
set sidescrolloff=1
set incsearch           " do incremental searching
set nobackup            " do not keep a backup file
set modeline            " document sets vim mode
set ignorecase
set smartcase
set pumheight=12
set previewheight=4
set nospell             " disable spell checking
set foldlevelstart=20
set tabpagemax=100
set wildmode=longest,full
set wildmenu
set cot=longest,menuone
set grepprg=grep\ -nH\ $*
set ssop=buffers,curdir,folds,winsize,options,globals
set tenc=utf8
set fencs=utf8,big5,gb2312,utf-16
set ff=unix
set updatetime=700
set hls
set undofile

let &undodir=$HOME."/.vim/undo"
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif

command! W silent execute "w !sudo > /dev/null tee %"
" }

" AutoInit {
let s:session_file = '.nvim_session'

fun! s:save_session()
    if exists('s:mksession')
        execute('silent! mksession! '.s:session_file)
    endif
endf

fun! s:source_session()
    if index(["c", "cpp", "objc", "objcpp", "python"], &filetype) != -1
        let s:mksession=1
    endif

    if argc() == 0 && filereadable(s:session_file)
        echohl MoreMsg |
                    \ echomsg "Session Loaded" |
                    \ echohl None
        execute('silent! source '.s:session_file)
        let s:mksession=1
    endif
endf

fun! s:build_gtags()
    if index(["c", "cpp"], &filetype) == -1
        return
    endif

    if executable('gtags') && !filereadable('GTAGS')
        echohl MoreMsg |
                    \ echomsg "building gtags" |
                    \ echohl None
        silent call system('gtags')
    endif
endf

augroup AutoInit
    au!
    au VimLeavePre * call s:save_session()
    au VimEnter * call s:source_session()
    au VimEnter * call s:build_gtags()
augroup END
" }

" FileTypeConfig {
augroup FileTypeConfig
    au!
    au FileType c,cpp,objc,objcpp,python,nasm,vim setlocal tw=0 expandtab fdm=syntax
    au FileType python setlocal ts=4 formatprg=autopep8\ -aa\ -
    au FileType tex,help,markdown setlocal tw=78 cc=78 formatprg=
    au FileType asm setlocal filetype=nasm formatprg=
augroup END
" }

" Plugin: Tagbar {
let g:tagbar_left = 1
let g:tagbar_width = 28
nmap <silent> <F2> :TagbarToggle<CR>
" }

" Plugin: vim-clang-format {
let g:clang_format#command = "clang-format-3.7"
let g:clang_format#auto_formatexpr=1
let g:clang_format#style_options = {
            \ "BasedOnStyle" : "LLVM",
            \ "UseTab" : "Never",
            \ "IndentWidth" : 4,
            \ "BreakBeforeBraces" : "Allman",
            \ "AllowShortIfStatementsOnASingleLine" : "false",
            \ "IndentCaseLabels" : "false",
            \ "ColumnLimit" : 0,
            \ "PointerAlignment" : "Right",
            \ "AccessModifierOffset" : -4,
            \ "AllowShortLoopsOnASingleLine" : "false",
            \ "AllowShortFunctionsOnASingleLine" : "false",
            \ "MaxEmptyLinesToKeep" : 2,
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "Auto",
            \ "BreakConstructorInitializersBeforeComma" : "true",
            \ "AllowAllParametersOfDeclarationOnNextLine" : "false",
            \ "BinPackParameters" : "false",
            \}
" }

" Plugin: YouCompleteMe {
let g:ycm_confirm_extra_conf=0
nmap <silent> <C-]> :YcmCompleter GoTo<CR>
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_error_symbol = '🚫'
let g:ycm_warning_symbol = '⚠️'
let g:ycm_style_error_symbol = '💡'
let g:ycm_style_warning_symbol = '💡'
" }

" Plugin: NeoMake {
let g:neomake_error_sign = { 'text': '🚫', 'texthl': 'SyntasticErrorSign'}
let g:neomake_warning_sign = { 'text': '⚠️', 'texthl': 'SyntasticWarningSign'}
" }

" Plugin: syntastic {
let g:syntastic_cursor_columns = 0
let g:syntastic_loc_list_height=5
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list = 1
let g:syntastic_enable_signs = 1
let g:syntastic_python_checkers = ['pylint', 'pyflakes', 'pep8']
let g:syntastic_mode_map = {'passive_filetypes': ["python"] }
let g:syntastic_error_symbol = '🚫'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_error_symbol = '💡'
let g:syntastic_style_warning_symbol = '💡'
" }

" Plugin: UltiSnips {
let g:UltiSnipsExpandTrigger = '<Leader><tab>'
" }

" Plugin: Clamp {
nmap <silent> <Leader>r :call ClampRename()<CR>
let g:clamp_highlight_blacklist = ['clampNamespaceRef', 'clampFunctionDecl', 'clampFieldDecl', 'clampDeclRefExprCall', 'clampMemberRefExprCall', 'clampMemberRefExprVar', 'clampNamespace', 'clampNamespaceRef', 'clampInclusionDirective', 'clampVarDecl', 'clampTypeRef', 'clampParmDecl']
let g:clamp_libclang_path='/usr/lib/x86_64-linux-gnu/libclang-3.6.so.1'
if &diff == 1
    let g:clamp_autostart = 0
endif
" }

" Plugin: gtags.vim {
nmap <silent><C-\>s :GtagsCursor<CR>
nmap <silent><C-\>r :execute("Gtags -r ".expand('<cword>'))<CR>
nmap <silent><C-\>d :execute("Gtags ".expand('<cword>'))<CR>

let g:Gtags_Auto_Update = 1
" }

" Plugin: unite.vim {
"silent! nmap <silent> <Leader>be :Unite -here buffer<CR>
"nmap <silent> <C-p> :Unite -start-insert -here file_rec<CR>
" }

" Plugin: FZF {
nmap <silent> <C-p> :FZF<CR>
" }

" Plugin: CtrlP.vim {
"silent! nmap <silent> <Leader>b :CtrlPBuffer<CR>
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif
" }

" vim:foldmarker={,}:foldlevel=0:foldmethod=marker:
