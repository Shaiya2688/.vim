" ----------------------------- VIM common settings Start -----------------------------
set nocompatible	"first option, enable VIM extended functionality based on VI
filetype off		"Some plugins need to turn this off
set rtp+=~/.vim/optional-tools
set t_Co=256		"Color setting, force Vim into 256 color mode to bypass the automatic detection of terminal colors
if has('termguicolors') || has('vcon')
	set tgc			"set Vim into 24-bit true color mode if terminal supported
endif
hi clear Normal		"clear Normal for &background
set bg&
syntax on			"enable syntax highlighting and overwrite before hi setting at Vim start
if &bg == "dark"	"set shaiya-light as default colorscheme if &background not define
	echoh WarningMsg | echo "current not support dark colorscheme" | echoh None
	" colo shaiya-dark
else
	colo shaiya-light
endif
let mapleader = '\'	"set defalut mapleader to use to keymap
"show syntax highlighting groups for word under cursor
nmap <leader>h1 :call <SID>SynStack()<CR>
"show highlighting color value for word under cursor, valid for gui Vim
if exists('*HexHighlight()')
  nmap <leader>h2 :call HexHighlight()<CR>
endif
"map gui color to cterm color for colorscheme file in edit
if executable('rgb2cterm')
	nmap <leader>h3 :so ~/.vim/optional-tools/Vim-toCterm/tocterm.vim<CR>
endif
"map cterm color to GUI on split buffer
nmap <leader>h4 :XtermColorTable<CR>
set hlsearch
set cursorline
set clipboard^=autoselect "copy visual mode selected to * register for middlemouse paste
"sync vim clipboard register to OS clipboard
if &clipboard !~# 'unnamedplus' && has('unnamedplus')
	set clipboard^=unnamedplus
endif
set ruler			"show the cursor position all the time(Vi default: off)
set showmode		"show current mode(Vim default: on, Vi default: off)
set showtabline=1	"show tabline for multi-tabs
set wildmenu		"enable command line complete by use tab
set wildmode=longest,list,full
set nowrap			"no wrap long line
set nu				"view line number
set ts=4			"set tab view size
set ignorecase		"ignore character case
" set smartcase
set backspace=indent,eol,start	"set backspace can remove autoindent or join previous line(VI is disable)
set showmatch		"when a bracket is inserted, briefly jump to the matching one if the match can be seen on the screen.
delmarks!			"clear position of a-z marks, m{a-zA-Z} to mark position, `{a-zA-Z} or '{a-zA-Z} to jump assigned position
set ttimeoutlen=50	"The time in milliseconds that is waited for a key code or mapped key sequence to complete.

"Help key map for show defined commands"
nmap <C-F1> :call HelpCmdInfo()<cr>

"mouse mode setting
set mouse=nvih
map <s-z> :set<Space>mouse=nvih<cr>
map <s-x> :set<Space>mouse=v<cr>

"indent setting
" set autoindent
set smartindent
set shiftwidth=0	"use &ts value

"vim diff settings
set diffopt=filler,context:10,vertical,foldcolumn:1
" set crb (be temporarily set by default)
" set scb (be temporarily set by default)

"file format setting for <EOL> define
set fileformat=unix
set fileformats=unix,dos

"file encode setting
set encoding=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
if v:lang =~ "utf8$" || v:lang =~ "utf-8$"
  set fencs=utf-8,ucs-bom,latin1
endif

"font setting
" set guifont=Courier_New:h11:cANSI
" set guifontwide=新宋体:h11:cGB2312

"fold setting
" set foldmethod=indent "fold by have the same indentation
set foldmethod=syntax
set foldlevel=100
set fdc=0
nmap <Space>r :if &fdc>0\|set fdc=0\|else\|set fdc=3\|endif<cr>

"popmenu setting
set completeopt=longest,menu ",preview

"common shortcuts setting ,help keycodes fot more information
map <C-a> <esc>ggVG

"select block shortcuts setting
nmap <Space>q	vab
nmap <Space>w	vaB
nmap <Space>e	v%

"window move shortcuts setting
map <A-LEFT> <C-w><C-h>
map <A-RIGHT> <C-w><C-l>
map <A-UP> <C-w><C-k>
map <A-DOWN> <C-w><C-j>
map <S-A-LEFT> <C-w><
map <S-A-RIGHT> <C-w>>
map <S-A-UP> <C-w>+
map <S-A-DOWN> <C-w>-
" <C-W><C-x/H/J/K/L> to exchange window

"tab page move shortcuts setting, switch tab page use <c-pageup>/<c-pagedown>
nmap > :+tabmove<cr>
nmap < :-tabmove<cr>

"search shortcuts setting
vn <F2> y:call TextStr_Search("t0", @0)<cr>
nn <F2> :call TextStr_Search("t0", expand("<cword>"))<cr>
vn <C-F2> y:call JumpStack_DoJump('TextStr_Search', "t0", @0)<cr>
nn <C-F2> :call JumpStack_DoJump('TextStr_Search', "t0", expand("<cword>"))<cr>
vn <F3> y:call JumpStack_DoJump('TextStr_Search', "t1", @0)<cr>
nn <F3> :call JumpStack_DoJump('TextStr_Search', "t1", expand("<cword>"))<cr>
nn <C-F3> :call JumpStack_DoJump('TextStr_Search', "t1")<cr>
vn <F4> y:call JumpStack_DoJump('TextStr_Search', "t2", @0)<cr>
nn <F4> :call JumpStack_DoJump('TextStr_Search', "t2", expand("<cword>"))<cr>
nn <C-F4> :call JumpStack_DoJump('TextStr_Search', "t2")<cr>
func TextStr_Search(_type, ...)
	let input_pat = a:0 > 0 ? a:1 : input("> Find pattern input: ")
	if input_pat != ""
		if a:_type== "t0" " search one in current file
			if !search(input_pat, 'n')
				let v:errmsg = "Pattern not found: ".input_pat
				echohl WarningMsg | echo v:errmsg | echohl None
				return
			endif
			call feedkeys("\/".input_pat."\<CR>", "n")
		elseif a:_type== "t1" " search all in current file
			exe "vimgrep \/".input_pat."\/ %"
			call feedkeys(":bo copen\<CR>/".input_pat."\<CR>\<CR>", "n")
		elseif a:_type == "t2" " search all recursively
			exe "vimgrep \/".input_pat."\/ % **"
			call feedkeys(":bo copen\<CR>/".input_pat."\<CR>\<CR>", "n")
		endif
	else
		let v:errmsg = "Pattern is null"
		call feedkeys(":echo\<cr>", "n")
	endif
endfunc

"Quickfix window shortcuts setting
nn <F5> :if !JumpWinInvalid()\|cp\|endif<cr>
nn <F6> :if !JumpWinInvalid()\|cn\|endif<cr>
nn <F8> :call QuickfixWinToggle()<cr>

"TAGS file setting
"auto loading tags and cscope.out
autocmd VimEnter,BufRead * call UpdateTagConnection()
"update tags and cscope.out associated with current edit file
nmap <leader>t :call UpdateTagFile()<CR>

"VIM tags setting
nn <C-l> :ts<cr>
map <C-]> g<C-]>
map <C-RightMouse> :<c-u>call JumpStack_GoBack()<CR>
map g<RightMouse> :<c-u>call JumpStack_GoBack()<CR>
nn <c-b> :tp<cr>
nn <c-f> :tn<cr>
set autochdir "$PWD is auto change to directory of jump
map <C-T> :<c-u>call JumpStack_GoBack()<CR>

"VIM cscope setting
"for quickfix use <F5> to search previous, <F6> to search next, <C-t> to go back search, <F8> to toggle quickfix window
" set csprg=$HOME/tools/bin/cscope
set cscopequickfix=s-,g0,c-,i-,f-,t-,e-,a-,d- "+: appended to quickfix window; -: clear previous results and add to quickfix window; 0 or unset: don't use quickfix. warning: quickfix no jump stack, instead of JumpStack_xxx()
set cst "use the commands :cstag instead of the default :tag behavior.
nmap fs :call JumpStack_DoJump('Cscope_Search', "s", expand("<cword>"))<cr>
nmap fg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap fc :call JumpStack_DoJump('Cscope_Search', "c", expand("<cword>"))<cr>
nmap fi :call JumpStack_DoJump('Cscope_Search', "i", expand("<cword>"))<cr>
nmap ff :call JumpStack_DoJump('Cscope_Search', "f", expand("<cword>"))<cr>
nmap ft :call JumpStack_DoJump('Cscope_Search', "t", expand("<cword>"))<cr>
nmap fe :call JumpStack_DoJump('Cscope_Search', "e", expand("<cword>"))<cr>
nmap fa :call JumpStack_DoJump('Cscope_Search', "a", expand("<cword>"))<cr>
nmap fd :call JumpStack_DoJump('Cscope_Search', "d", expand("<cword>"))<cr>
vmap fs y:call JumpStack_DoJump('Cscope_Search', "s", @0)<cr>
vmap fg y:cs find g <C-R>0<CR>
vmap fc y:call JumpStack_DoJump('Cscope_Search', "c", @0)<cr>
vmap fi y:call JumpStack_DoJump('Cscope_Search', "i", @0)<cr>
vmap ff y:call JumpStack_DoJump('Cscope_Search', "f", @0)<cr>
vmap ft y:call JumpStack_DoJump('Cscope_Search', "t", @0)<cr>
vmap fe y:call JumpStack_DoJump('Cscope_Search', "e", @0)<cr>
vmap fa y:call JumpStack_DoJump('Cscope_Search', "a", @0)<cr>
vmap fd y:call JumpStack_DoJump('Cscope_Search', "d", @0)<cr>
nmap frs :call JumpStack_DoJump('Cscope_Search', "s")<cr>
nmap frg :cs find g<space>
nmap frc :call JumpStack_DoJump('Cscope_Search', "c")<cr>
nmap fri :call JumpStack_DoJump('Cscope_Search', "i")<cr>
nmap frf :call JumpStack_DoJump('Cscope_Search', "f")<cr>
nmap frt :call JumpStack_DoJump('Cscope_Search', "t")<cr>
nmap fre :call JumpStack_DoJump('Cscope_Search', "e")<cr>
nmap fra :call JumpStack_DoJump('Cscope_Search', "a")<cr>
nmap frd :call JumpStack_DoJump('Cscope_Search', "d")<cr>
func Cscope_Search(pat, ...)
	let input_pat = a:0 > 0 ? a:1 : input("> Find pattern input: ")
	if input_pat != ""
		if a:pat == "s"
			let cs_find = "cs find s ".input_pat
		elseif a:pat == "c"
			let cs_find = "cs find c ".input_pat
		elseif a:pat == "i"
			let cs_find = "cs find i ".input_pat
		elseif a:pat == "f"
			let cs_find = "cs find f ".input_pat
		elseif a:pat == "t"
			let cs_find = "cs find t ".input_pat
		elseif a:pat == "e"
			let cs_find = "cs find e ".input_pat
		elseif a:pat == "a"
			let cs_find = "cs find a ".input_pat
		elseif a:pat == "d"
			let cs_find = "cs find d ".input_pat
		endif
		exe cs_find
		call feedkeys("/".input_pat."\<CR>:bo copen\<CR>\<CR>", "n")
	else
		let v:errmsg = "Pattern is null"
		call feedkeys(":echo\<cr>", "n")
	endif
endfunc
" ----------------------------- VIM common settings End -------------------------------

" ----------------------------- vim-plug Plugin Manager Start -----------------------------
so ~/.vim/bundle/vim-plug/plug.vim
call plug#begin('~/.vim/bundle')
Plug 'junegunn/vim-plug'	"vim-plug, more information: https://github.com/junegunn/vim-plug
Plug 'yianwillis/vimcdoc'	"vim cn help doc
Plug 'flazz/vim-colorschemes'	"colorschemes resources can be referenced
Plug 'guns/xterm-color-table.vim'	"map 256 color to 24-bit true color
Plug 'inkarkat/vim-mark' | Plug 'inkarkat/vim-ingo-library'	"vim-mark required
Plug 'Shaiya2688/bracket-highlight'
"TagList or Tagbar for tag window
Plug 'majutsushi/tagbar'
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'		"extended nerdtree for all tabs
Plug 'Xuyuanp/nerdtree-git-plugin'	"extended git status in nerdtree
Plug 'scrooloose/nerdcommenter'		"section comment and uncomment
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes' | Plug 'tpope/vim-fugitive'	"indicate git branch in airline
"TODO check below
Plug 'ctrlpvim/ctrlp.vim'		"file search and buffer manager
Plug 'airblade/vim-gitgutter'	"or Plug 'mhinz/vim-signify'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'	"Common useful snippets for the ultisnips engine.
Plug 'Shaiya2688/SrcExpl'		"Plug 'wesleyche/SrcExpl', A context window, fix a bug in function SrcExpl_AdaptPlugins()
"vim-lsp or coc.nvim as LSP client for Vim editor, see https://langserver.org for LSP client and language server implementations select
" Plug 'prabirshrestha/vim-lsp'
if executable('node')
	let nodejs_version = trim(system('node --version'))
	let nodejs_ms = matchlist(nodejs_version, 'v\(\d\+\).\(\d\+\).\(\d\+\)')
	if !empty(nodejs_ms) && str2nr(nodejs_ms[1]) > 10
		" Plug 'neoclide/coc.nvim', {'branch': 'release'}
	endif
endif
if has_key(g:plugs, "vim-lsp")
	"TODO: experience the vim-lsp
elseif has_key(g:plugs, 'coc.nvim')
else
	"OmniCppComplete + AutoComplPop combination or YouCompleteMe(need compile manually)
	Plug 'vim-scripts/OmniCppComplete'
	Plug 'vim-scripts/AutoComplPop'
endif
call plug#end()
nmap <F9> :PlugStatus<cr>
nmap <S-F9> :PlugClean<cr>
nmap <F10> :PlugInstall<cr>
nmap <S-F10> :PlugUpdate<cr>

"Plug 'yianwillis/vimcdoc'
set helplang=cn		"if have found cn help doc

"Plug 'inkarkat/vim-mark'
hi MarkWord1 gui=None guifg=black guibg=#00ffff cterm=None ctermfg=0 ctermbg=14
hi MarkWord2 gui=None guifg=black guibg=#00ff00 cterm=None ctermfg=0 ctermbg=10
hi MarkWord3 gui=None guifg=black guibg=#ff0000 cterm=None ctermfg=0 ctermbg=9
hi MarkWord4 gui=None guifg=black guibg=#ff00ff cterm=None ctermfg=0 ctermbg=13
hi MarkWord5 gui=None guifg=black guibg=#ff8700 cterm=None ctermfg=0 ctermbg=208
hi MarkWord6 gui=None guifg=black guibg=#87af00 cterm=None ctermfg=0 ctermbg=106
hi MarkWord7 gui=None guifg=black guibg=#00afff cterm=None ctermfg=0 ctermbg=39
hi MarkWord8 gui=None guifg=black guibg=#ffdf87 cterm=None ctermfg=0 ctermbg=222
hi MarkWord9 gui=None guifg=black guibg=#af5fff cterm=None ctermfg=0 ctermbg=135
hi MarkWord10 gui=None guifg=black guibg=#dfafdf cterm=None ctermfg=0 ctermbg=182
hi MarkWord11 gui=None guifg=black guibg=#87ffaf cterm=None ctermfg=0 ctermbg=121
hi MarkWord12 gui=None guifg=black guibg=#87afff cterm=None ctermfg=0 ctermbg=111
hi MarkWord13 gui=None guifg=black guibg=#008700 cterm=None ctermfg=0 ctermbg=28
hi MarkWord14 gui=None guifg=black guibg=#5f5fff cterm=None ctermfg=0 ctermbg=63
hi MarkWord15 gui=bold guifg=white guibg=#800000 cterm=bold ctermfg=255 ctermbg=1
hi MarkWord16 gui=bold guifg=white guibg=#008000 cterm=bold ctermfg=255 ctermbg=2
hi MarkWord17 gui=bold guifg=white guibg=#808000 cterm=bold ctermfg=255 ctermbg=3
hi MarkWord18 gui=bold guifg=white guibg=#000080 cterm=bold ctermfg=255 ctermbg=4
hi MarkWord19 gui=bold guifg=white guibg=#800080 cterm=bold ctermfg=255 ctermbg=5
hi MarkWord20 gui=bold guifg=white guibg=#008080 cterm=bold ctermfg=255 ctermbg=6
"to add more in this order....
"use \m or \r to mark and unmark, use \/ or \? to search
nmap \c :MarkClear<cr>

"Plug 'Shaiya2688/bracket-highlight'
let g:rainbow_active = 0 "command is :RainbowToggle
nmap \5 :RainbowToggle<cr>
let g:rainbow_conf = {
	\	'cterms': ['NONE', 'NONE', 'NONE', 'NONE', 'NONE', 'bold', 'bold', 'bold', 'bold', 'bold'],
	\	'ctermbgs': ['14', '10', '9', '13', '208', '106', '39', '222', '135', '182'],
	\	'ctermfgs': ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0'],
	\	'guibgs': ['#00ffff', '#00ff00', '#ff0000', '#ff00ff', '#ff8700', '#87af00', '#00afff', '#ffdf87', '#af5fff', '#dfafdf'],
	\	'guifgs': ['black', 'black', 'black', 'black', 'black', 'black', 'black', 'black', 'black', 'black'],
	\	'operators': '',
	\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\	'separately': {
	\		'*': {},
	\		'tex': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
	\		},
	\		'lisp': {
	\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
	\		},
	\		'vim': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
	\		},
	\		'html': {
	\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
	\		},
	\		'css': 0,
	\	}
	\}

"Plug 'vim-scripts/OmniCppComplete'
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 "show function parameters
let OmniCpp_MayCompleteDot = 1 "autocomplete after .
let OmniCpp_MayCompleteArrow = 1 "autocomplete after ->
let OmniCpp_MayCompleteScope = 1 "autocomplete after ::

"Plug 'vim-scripts/AutoComplPop'
let g:acp_enableAtStartup = 1 "enable on start vim, if cause VIM be slow down in insert mode in some case, please use '<C-o>:AcpLock/Unlock' to enable/disble it
let g:acp_ignorecaseOption = 1 "set to 'ignorecase' temporarily
let g:acp_completeOption = '.,w,b,k' " set to 'complete' temporarily
let g:acp_behaviorKeywordCommand = "\<C-p>"
" let g:acp_completeoptPreview = 1

"Plug 'majutsushi/tagbar'
let g:tagbar_left = 1
let g:tagbar_width=33
let g:tagbar_sort = 0
let g:tagbar_indent = 1
let g:tagbar_zoomwidth = 0
let g:tagbar_autoclose = 0
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 0
let g:tagbar_previewwin_pos = 'bo'
" let g:tagbar_ctags_bin='/usr/bin/ctags'
nmap , :TagbarToggle<cr>

"Plug 'scrooloose/nerdtree'
autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeWinPos='right'
let NERDTreeWinSize=48
let NERDTreeShowLineNumbers=0
let NERDTreeShowBookmarks=1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
" nmap . :NERDTreeToggle<CR> "use NERDTreeTabsToggle to manager for all tabs

"Plug 'jistr/vim-nerdtree-tabs'
map . <plug>NERDTreeTabsToggle<CR>
map <leader>. <plug>NERDTreeFocusToggle<CR>

"Plug 'Xuyuanp/nerdtree-git-plugin'
let g:NERDTreeGitStatusPorcelainVersion = 1	"set to 1 if git --version < v2.11.0
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

"Plug 'scrooloose/nerdcommenter'
"\ca(switch alternative delimiter),\cb(line or selected line comment),\cc(line or selected block comment),\cm(block comment use one /**/),\cu(uncomment),\cA(append comment end of line),\cs(style comment), more see :h nerdcommenter or :map
let g:NERDSpaceDelims = 1				" Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1			" Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'both' 		" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDTrimTrailingWhitespace = 1	" Enable trimming of trailing whitespace when uncommenting
let g:NERDToggleCheckAllLines = 1		" Enable NERDCommenterToggle(\c<space>) to check all selected lines is commented or not
let NERDLPlace="/*"						" Specifies what to use as the left delimiter placeholder when nesting comments.
let NERDRPlace="*/"						" Specifies what to use as the left delimiter placeholder when nesting comments.

"Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes' | Plug 'tpope/vim-fugitive'
":AirlineExtensions can list extensions of supported and current loaded
":AirlineTheme <theme> can set the theme
let g:airline_theme='base16_summerfruit' "base16_colors, see :h airline-themes-list for more information
let g:airline#extensions#tabline#formatter = 'unique_tail'
let b:airline_whitespace_disabled = 1
let g:airline_powerline_fonts = 0	"need install fonts: sudo apt-get install fonts-powerline or git clone https://github.com/powerline/fonts.git --depth=1 && cd fonts && ./install.sh && mkdir ~/.config/fontconfig/conf.d/ -p && cp fontconfig/50-enable-terminess-powerline.conf ~/.config/fontconfig/conf.d/ && fc-cache -vf && cd .. && rm -rf fonts
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
if exists('g:airline_powerline_fonts') && g:airline_powerline_fonts == 1
	" powerline symbols
	let g:airline_left_sep = ''
	let g:airline_left_alt_sep = ''
	let g:airline_right_sep = ''
	let g:airline_right_alt_sep = ''
	let g:airline_symbols.branch = '⎇'
	let g:airline_symbols.readonly = ''
	let g:airline_symbols.linenr = '☰'
	" let g:airline_symbols.maxlinenr = ''
	let g:airline_symbols.maxlinenr = ' '
endif

"Plug 'ctrlpvim/ctrlp.vim' <c-p>? for help
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['tags', 'cscope.out']
let g:ctrlp_by_filename = 1		"<c-d> switch whether match directory
let g:ctrlp_regexp = 1		"<c-r> switch whether match use regexp
let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:10,results:50'
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_max_files = 100000
let g:ctrlp_types = ['mru', 'buf', 'fil']	"<c-b>/<c-f>/<c-up>/<c-down> switch search mode
" let g:ctrlp_reuse_window = 'netrw\|help\|quickfix'

"Plug 'airblade/vim-gitgutter'
let g:gitgutter_enabled = 1		"enable at startup, enable git will cause VIM be slow down
nmap <Space>t :GitGutterToggle<cr>
nmap git :GitGutterToggle<cr>
nmap gits :GitGutterLineHighlightsToggle<cr>
nmap gitd <Plug>(GitGutterPreviewHunk)
nmap gp <Plug>(GitGutterPrevHunk)
nmap gn <Plug>(GitGutterNextHunk)
set updatetime=100
let g:gitgutter_sign_added              = '+'
let g:gitgutter_sign_modified           = '~'
let g:gitgutter_sign_removed            = '_'
let g:gitgutter_sign_removed_first_line = '='
let g:gitgutter_sign_modified_removed   = '~_'
if &bg == "dark"
	echoh WarningMsg | echo "GitGutter: please add color settings for dark colorscheme" | echoh None
else
	hi GitGutterAdd guifg=#a3e29e guibg=#a3e29e ctermfg=157 ctermbg=157
	hi GitGutterAddLine guibg=#d9ffcd ctermbg=194
	hi GitGutterChange guifg=#c3d6e8 guibg=#c3d6e8 ctermfg=153 ctermbg=153
	hi GitGutterChangeLine guibg=#c3d6e8 ctermbg=153
	hi GitGutterDelete guifg=#ff0000 guibg=NONE ctermfg=9 ctermbg=NONE
	hi GitGutterDeleteLine gui=None cterm=None
	hi link GitGutterChangeDelete GitGutterChange
	hi link GitGutterChangeDeleteLine GitGutterChangeLine
	hi diffAdded guifg=#008000 ctermfg=28
	hi diffRemoved guifg=#ff0000 ctermfg=1
endif

"Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<c-k>"	"<tab>/<c-i> be used to insert a \t character
let g:UltiSnipsListSnippets="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "optional-tools"] "snippet file found from &rtp/&g:UltiSnipsSnippetDirectories/{ &ft/*, &ft.snippets, &ft_*.snippets }
let g:snips_author= "Huanhuan Zhuang"
let g:snips_email = "yourname@email.com"

"Plug 'wesleyche/SrcExpl'
nmap <S-F8> :SrcExplToggle<cr>
let g:SrcExpl_prevDefKey = "<S-F5>"    "Set \"<S-F5>\" key for displaying the previous definition in the jump list
let g:SrcExpl_nextDefKey = "<S-F6>"    "Set \"<S-F6>\" key for displaying the next definition in the jump list
let g:SrcExpl_updateTagsKey = ""    "not allow updating the tags file, tags are managed in other ways
let g:SrcExpl_winHeight = 8    "Set the height of Source Explorer window
let g:SrcExpl_refreshTime = 100    "Set 100 ms for refreshing the Source Explorer
let g:SrcExpl_jumpKey = "<cr>"    "Set \"Enter\" key to jump into the exact definition context
let g:SrcExpl_gobackKey = "<Space>"    "Set \"Space\" key for back from the definition context
"In order to avoid conflicts, the Source Explorer should know what plugins, except itself are using buffers. And you need add their buffer names into below listaccording to the command ':buffers!'
let g:SrcExpl_pluginList = [
\ "__Tagbar__.*",
\ "__Tag_List__",
\ "NERD_tree_.*",
\ "ControlP",
\ "Source_Explorer"
\ ]
let g:SrcExpl_searchLocalDef = 1    "Enable/Disable the local definition searching, and note that this is not guaranteed to work, the Source Explorer doesn't check the syntax for now. It only searches for a match with the keyword according to command 'gd'
let g:SrcExpl_isUpdateTags = 0    "Do not let the Source Explorer update the tags file when opening
" ----------------------------- vim-plug Plugin Manager End -----------------------------

" -------------------------------- Common Utils Start -----------------------------------
func! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

func JumpStack_Begin(...)
	"Store where we're jumping from before we jump.
	let tag = a:0 > 0 ? a:1 : expand('<cword>')
	let pos = [bufnr()] + getcurpos()[1:]
	let t:jumpstack_item = {'bufnr': pos[0], 'from': pos, 'tagname': tag}
	let t:jumpstack_qf_title = getqflist({'title' : 0}).title
	let t:jumpstack_qf_id = getqflist({'id' : 0}).id
	let v:errmsg = ""
	let t:jumpstack_done = 0
endfunc

func JumpStack_Done()
	"Not have tag item or has been written to the tag stack.
	if !exists('t:jumpstack_item') || !exists('t:jumpstack_done') || t:jumpstack_done == 1
		return
	endif
	let pos = [bufnr()] + getcurpos()[1:]
	if t:jumpstack_item['from'] ==# pos && (v:errmsg != '' || v:exception != '')
		return
	endif
	"Jump was successful, write previous location to tag stack.
	let winid = win_getid()
	let stack = gettagstack(winid)
	let stack['items'] = [t:jumpstack_item]
	call settagstack(winid, stack, 't')
	if t:jumpstack_qf_id != getqflist({'id' : 0}).id || t:jumpstack_qf_title != getqflist({'title' : 0}).title
		let t:jumpstack_open_with_quickfix = 1
	endif
	let t:jumpstack_done = 1
endfunc

func JumpStack_DoJump(jumpfunc, ...)
	"If the cursor is not in the valid edit window
	if JumpWinInvalid()
		echohl ErrorMsg | echo "Jump win invalid" | echohl None
		return
	endif

	let Func = function(a:jumpfunc, a:000)
	call JumpStack_Begin()
	try
		if &shortmess !~# 'A'
			set shortmess+=A
			let shortmess_modified = 1
		endif
		call Func()
	catch /.*/
		let v:errmsg = v:exception
		echohl WarningMsg | echo "JumpStack_DoJump(\'".a:jumpfunc."\'): ".v:errmsg | echohl None
	finally
		if exists('shortmess_modified') && shortmess_modified == 1
			set shortmess-=A
		endif
		call JumpStack_Done()
	endtry
endfunc

func JumpStack_GoBack()
	"If the cursor is not in the valid edit window
	if JumpWinInvalid()
		echohl ErrorMsg | echo "Jump win invalid" | echohl None
		return
	endif

	try
		if &shortmess !~# 'A'
			set shortmess+=A
			let shortmess_modified = 1
		endif

		"back to previous location from tag stack.
		pop
		if exists("t:jumpstack_open_with_quickfix") && t:jumpstack_open_with_quickfix == 1
			call QuickfixWinCleanClose()
			let t:jumpstack_open_with_quickfix = 0
		endif
	catch /.*/
		let v:errmsg = v:exception
		echohl WarningMsg | echo v:errmsg | echohl None
	finally
		if exists('shortmess_modified') && shortmess_modified == 1
			set shortmess-=A
		endif
	endtry

endfunc

func QuickfixWinToggle()
	if  getqflist({'winid' : 0}).winid
		exec ":cclose"
	else
		exec ":bo copen"
	endif
endfunc

func QuickfixWinCleanClose()
	call setqflist([], "f")
	exec ":cclose"
endfunc

let g:JumpDisableWinList = [
\ "__Tagbar__.*",
\ "__Tag_List__",
\ "NERD_tree_.*",
\ "ControlP",
\ "Source_Explorer"
\ ]
"Aslo sync to g:SrcExpl_pluginList
let g:SrcExpl_pluginList = deepcopy(g:JumpDisableWinList)
func JumpWinInvalid()
	for item in g:JumpDisableWinList
		if bufname("%") =~# item
			return -1
		endif
	endfor
	"Aslo filter the Quickfix window
	if &buftype ==# "quickfix"
		return -1
	endif
	return 0
endfunc

func UpdateTagConnection()
	let tags_search_path = expand("%:p")
	let tags_search_path_list = []
	if !empty(tags_search_path)
		"Resolve invalid path, eg.: ../a/../.. , a not exists or no permission to access
		while !isdirectory(tags_search_path)
			let tags_search_path = GetPathParent(tags_search_path)
		endwhile
		"Convert path with .. to absolute path
		let tags_search_path = system("cd ".tags_search_path." && echo -n $PWD")
	endif
	"No Permission to loading directory"
	if empty(tags_search_path) || !isdirectory(tags_search_path)
		let tags_search_path = getcwd()
	endif
	let parent = tags_search_path
	"Not include root directory(/)
	while parent != "/"
		call add(tags_search_path_list, parent)
		let parent = GetPathParent(parent)
	endwhile
	if empty(tags_search_path_list)
		return
	endif
	let tags_ctags_list = []
	let tags_cscope_list = []
	for item in tags_search_path_list
		if filereadable(item."/tags")
			call add(tags_ctags_list, item."/tags")
		endif
		if filereadable(item."/cscope.out")
			call add(tags_cscope_list, item."/cscope.out")
		endif
	endfor
	for item in tags_ctags_list
		silent! exec "set tags+=".item
	endfor
	for item in tags_cscope_list
		silent! exec "cs add ".item
	endfor
endfunc

func UpdateTagFile()
	"If the cursor is not in the valid file window
	if JumpWinInvalid()
		echohl ErrorMsg | echo "Invalid file" | echohl None
		return
	endif

    let tag_connected_list = tagfiles()
	if !len(tag_connected_list)
		echohl ErrorMsg | echo "No TAG files found" | echohl None
	else
		let file_src = expand('%:p:h')
		for item in tag_connected_list
			let tag_scope=item[:-6]."/cscope.files"
			if filereadable(tag_scope) && len(system("grep \'".file_src."\' ".tag_scope))
				let tmp = getcwd()
				silent! exe "cd " . item[:-6]
				call system("tag -u")
				echo "[  update  ]  ".item[:-6]
				silent! exe "cd " .tmp
				silent! exe "cs reset"
			else
				echo "[non-update]  ".item[:-6]
			endif
		endfor
	endif
endfunc

func GetPathParent(path)
	let parent = substitute(a:path, '[\/][^\/]\+[\/:]\?$', '', '')
	if parent == '' || parent !~ '[\/]'
		let parent .= '/'
	en
	retu parent
endfunc

func HelpCmdString(mode, cmd, comment)
	if a:mode ==? "COMMON"
		echoh Visual | echo printf("[%.6s]", a:mode)
	elseif a:mode ==? "NORMAL"
		echoh Statement | echo printf("[%.6s]", a:mode)
	elseif a:mode ==? "INSERT"
		echoh Special | echo printf("[%.6s]", a:mode)
	elseif a:mode ==? "NONE-I"
		echoh ColorColumn | echo printf("[%.6s]", a:mode)
	else
		echoh Visual | echo printf("[%.6s]", a:mode)
	endif
	echoh Constant | echon printf(" %-20s ", a:cmd)
	echoh Comment | echon a:comment
	echoh None
endfunc
func HelpCmdInfo()
	call HelpCmdString("NORMAL", "<C-F1>", "Show this message for key map information, detail map information see :map command")
	echoh Comment | echo "colorscheme setting" | echoh None
	call HelpCmdString("NORMAL", "<leader>h1", "show syntax highlighting groups for word under cursor")
	call HelpCmdString("NORMAL", "<leader>h2", "show color value with Hex format for word under cursor(GUI only)")
	call HelpCmdString("NORMAL", "<leader>h3", "[optional-tools] map GUI color to cterm for colorscheme file in edit")
	call HelpCmdString("NORMAL", "<leader>h4", "map cterm color to GUI on split buffer")

	echoh Comment | echo "mouse mode setting" | echoh None
	call HelpCmdString("COMMON", "<s-z>", "set mouse=nvih")
	call HelpCmdString("COMMON", "<s-x>", "set mouse=v")

	echoh Comment | echo "fold setting" | echoh None
	call HelpCmdString("NORMAL", "<Space>r", "set fdc=1/0")

	echoh Comment | echo "block select setting" | echoh None
	call HelpCmdString("NORMAL", "<Space>q", "vab: from ( to the matching )")
	call HelpCmdString("NORMAL", "<Space>w", "vaB: from { to the matching }")
	call HelpCmdString("NORMAL", "<Space>e", "v% : smart matching {()}")

	echoh Comment | echo "window setting" | echoh None
	call HelpCmdString("COMMON", "<A-LEFT>", "move cursor to left window")
	call HelpCmdString("COMMON", "<A-RIGHT>", "move cursor to right window")
	call HelpCmdString("COMMON", "<A-UP>", "move cursor to above window")
	call HelpCmdString("COMMON", "<A-DOWN>", "move cursor to below window")
	call HelpCmdString("COMMON", "<S-A-LEFT>", "Decrease current window width")
	call HelpCmdString("COMMON", "<S-A-RIGHT>", "Increase current window width")
	call HelpCmdString("COMMON", "<S-A-UP>", "Increase current window height")
	call HelpCmdString("COMMON", "<S-A-DOWN>", "Decrease current window height")
	call HelpCmdString("COMMON", "<C-W><C-x/H/J/K/L>", "exchange window with next/left/below/above/right")
	call HelpCmdString("COMMON", "<C-W><C-s/v>", "split window vertically/horizontally")

	echoh Comment | echo "tab page setting" | echoh None
	call HelpCmdString("NORMAL", "<C-PageUp>", "switch to previous tab page")
	call HelpCmdString("NORMAL", "<C-PageDown>", "switch to next tab page")
	call HelpCmdString("NORMAL", "<S-,>", "exchange tab page with previous")
	call HelpCmdString("NORMAL", "<S-.>", "exchange tab page with next")

	echoh Comment | echo "search setting" | echoh None
	call HelpCmdString("NONE-I", "<F2>", "search this or selected pattern, can not use <C-t> to jump back")
	call HelpCmdString("NONE-I", "<C-F2>", "search this or selected pattern, can use <C-t> to jump back")
	call HelpCmdString("NONE-I", "<F3>", "search all of this or selected pattern in current file and list results in Quickfix window")
	call HelpCmdString("NONE-I", "<C-F3>", "search all of input pattern in current file and list results in Quickfix window")
	call HelpCmdString("NONE-I", "<F4>", "recursive search all of this or selected pattern below current directory and list results in Quickfix window")
	call HelpCmdString("NONE-I", "<C-F4>", "recursive search all of input pattern below current directory and list results in Quickfix window")

	echoh Comment | echo "Quickfix window setting" | echoh None
	call HelpCmdString("NORMAL", "<F5>", "Jump to Quickfix next item")
	call HelpCmdString("NORMAL", "<F6>", "Jump to Quickfix previous item")
	call HelpCmdString("NORMAL", "<C-t>", "clean Quickfix list and Close and JumpBack")
	call HelpCmdString("NORMAL", "<F8>", "Toggle Quickfix window")

	echoh Comment | echo "TAGS file setting" | echoh None
	call HelpCmdString("NORMAL", "<leader>t", "Update TAG files associated with current edit file artificially")

	echoh Comment | echo "VIM tags setting" | echoh None
	call HelpCmdString("NONE-I", "<C-]>", "list definition and Put it in the tag stack")
	call HelpCmdString("NORMAL", "<C-l>", "list definition of current tag")
	call HelpCmdString("NORMAL", "<C-t>", "JumpBack and Pop current tag out the tag stack")
	call HelpCmdString("NONE-I", "<C-LeftMouse>", "Same as <C-]>")
	call HelpCmdString("NONE-I", "g<LeftMouse>", "Same as <C-]>")
	call HelpCmdString("NONE-I", "<C-RightMouse>", "Same as <C-t>")
	call HelpCmdString("NONE-I", "g<RightMouse>", "Same as <C-t>")
	call HelpCmdString("NORMAL", "<c-b>", "Jump to current tag previous definition")
	call HelpCmdString("NORMAL", "<c-f>", "Jump to current tag next definition")

	echoh Comment | echo "VIM cscope setting" | echoh None
	call HelpCmdString("NONE-I", "fs/frs", "Find C symbol and list results in Quickfix window")
	call HelpCmdString("NONE-I", "fg/frg", "Find definition")
	call HelpCmdString("NONE-I", "fc/frc", "Find functions calling this function and list results in Quickfix window")
	call HelpCmdString("NONE-I", "fi/fri", "Find files #including this file and list results in Quickfix window")
	call HelpCmdString("NONE-I", "ff/frf", "Find this file and list results in Quickfix window")
	call HelpCmdString("NONE-I", "ft/frt", "Find text string and list results in Quickfix window")
	call HelpCmdString("NONE-I", "fe/fre", "Find egrep pattern and list results in Quickfix window")
	call HelpCmdString("NONE-I", "fa/fra", "Find places where this symbol is assigned a value and list results in Quickfix window")

	echoh Comment | echo "Vim Plugin Manager setting" | echoh None
	call HelpCmdString("NORMAL", "<F9>", "Vim-Plug PlugStatus")
	call HelpCmdString("NORMAL", "<S-F9>", "Vim-Plug PlugClean")
	call HelpCmdString("NORMAL", "<F10>", "Vim-Plug PlugInstall")
	call HelpCmdString("NORMAL", "<S-F10>", "Vim-Plug PlugUpdate")

	echoh Comment | echo "Color Mark setting" | echoh None
	call HelpCmdString("NONE-I", "\\m or \\r", "mark and unmark pattern with different color")
	call HelpCmdString("NORMAL", "\\/ or \\?", "search previous or next mark pattern")
	call HelpCmdString("NORMAL", "\\c", "unmark all marked pattern")
	call HelpCmdString("NORMAL", "\\5", "show bracket with different color")

	echoh Comment | echo "Block or Line Comment setting, more information see :h nerdcommenter or :map" | echoh None
	call HelpCmdString("NONE-I", "\ca", "switch alternative delimiter")
	call HelpCmdString("NONE-I", "\cb", "line or selected line comment")
	call HelpCmdString("NONE-I", "\cc", "line or selected block comment")
	call HelpCmdString("NONE-I", "\cm", "block comment use one /**/")
	call HelpCmdString("NONE-I", "\cu", "uncomment")
	call HelpCmdString("NONE-I", "\cA", "append comment end of line")
	call HelpCmdString("NONE-I", "\cs", "style comment")

	echoh Comment | echo "Auto complete Pop setting" | echoh None
	call HelpCmdString("INSERT", "<C-p>", "trigger complete popmenu")

	echoh Comment | echo "TAGS list setting" | echoh None
	call HelpCmdString("NORMAL", ",", "Tagbar Toggle")

	echoh Comment | echo "File explorer setting" | echoh None
	call HelpCmdString("NONE-I", ".", "NERDTree Toggle")
	call HelpCmdString("NONE-I", "<leader>.", "NERDTree Focus Toggle")

	echoh Comment | echo "CtrlP plugin setting" | echoh None
	call HelpCmdString("NORMAL", "<C-p>", "load CtrlP for file searching, ? for help")

	echoh Comment | echo "Git Plugin setting" | echoh None
	call HelpCmdString("NORMAL", "<Space>t", "Git status column toggle")
	call HelpCmdString("NORMAL", "git", "Git Plugin Enable or Disable")
	call HelpCmdString("NORMAL", "gits", "Highlight changed line")
	call HelpCmdString("NORMAL", "gitd", "Show detail change in Preview window")
	call HelpCmdString("NORMAL", "gp", "Jump to previous change")
	call HelpCmdString("NORMAL", "gn", "Jump to next change")

	echoh Comment | echo "Snips Plugin setting" | echoh None
	call HelpCmdString("INSERT", "<C-k>", "Trigger expanding a snippet")
	call HelpCmdString("INSERT", "<C-l>", "List all matched snippets according current context")
	call HelpCmdString("INSERT", "<C-f>", "Jump variable Forward within a snippet")
	call HelpCmdString("INSERT", "<C-b>", "Jump variable Backward within a snippet")

	echoh Comment | echo "TAGS Relation window setting" | echoh None
	call HelpCmdString("NORMAL", "<S-F8>", "TAGS Relation window Toggle")
	call HelpCmdString("NORMAL", "<S-F5>", "Displaying the previous definition in the relation list")
	call HelpCmdString("NORMAL", "<S-F6>", "Displaying the next definition in the relation list")
	call HelpCmdString("NORMAL", "<Space>", "JumpBack from the definition context")
endfunc
" -------------------------------- Common Utils End -------------------------------------

filetype plugin indent on "last option after some plugin has run over, Enable VIM to use different plugins and indentation based on file types, HTML indent use 2 space, Python is 4
