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
nmap <silent> <leader>h1 :call <SID>SynStack()<CR>
"show highlighting color value for word under cursor, valid for gui Vim
if exists('*HexHighlight()')
	nmap <silent> <leader>h2 :call HexHighlight()<CR>
endif
"map gui color to cterm color for colorscheme file in edit
if executable('rgb2cterm')
	nmap <silent> <leader>h3 :so ~/.vim/optional-tools/Vim-toCterm/tocterm.vim<CR>
endif
"map cterm color to GUI on split buffer
nmap <silent> <leader>h4 :XtermColorTable<CR>
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
nmap <silent> <C-F1> :call HelpCmdInfo()<cr>

"terminal setting
if has('terminal')
	if executable('bash')
		nn <silent> <leader>T :ter ++close bash<cr>
		nn <silent> <leader><C-t> :tab ter ++close bash<cr>
	else
		nn <silent> <leader>T :ter ++close<cr>
		nn <silent> <leader><C-t> :tab ter ++close<cr>
	endif

	func! Terminal_ExitNormalMode()
		unm <buffer> <silent> <RightMouse>
		unm <buffer> <silent> <C-w>t
		unm <buffer> <silent> <C-w><C-t>
		unm <buffer> <silent> <C-w>q
		unm <buffer> <silent> <C-w><C-q>
		call feedkeys("A")
	endfunc

	func! Terminal_EnterNormalMode()
		if &buftype == 'terminal' && mode('') == 't'
			call feedkeys("\<c-w>N")
			nor <buffer> <silent> <RightMouse> :<C-u>call Terminal_ExitNormalMode()<cr>
			nor <buffer> <silent> <C-w>t :<C-u>call Terminal_ExitNormalMode()<cr>
			nor <buffer> <silent> <C-w><C-t> :<C-u>call Terminal_ExitNormalMode()<cr>
			nor <buffer> <silent> <C-w>q <C-w>:<C-u>q!<cr>
			nor <buffer> <silent> <C-w><C-q> <C-w>:<C-u>q!<cr>

		endif
	endfunc

	"scroll twice to avoid the middlemouse click trigger incorrectly
	tno <silent> <ScrollWheelUp><ScrollWheelUp> <C-w>:call Terminal_EnterNormalMode()<cr>
	tno <silent> <C-w>n <C-w>:call Terminal_EnterNormalMode()<cr>
	tno <silent> <C-w><C-n> <C-w>:call Terminal_EnterNormalMode()<cr>
	tno <silent> <C-w>q <C-w>:q!<cr>
	tno <silent> <C-w><C-q> <C-w>:q!<cr>
endif

"mouse mode setting
set mouse=nvih
func! MouseModeSwitch()
	if &mouse !=# 'nvih'
		set mouse=nvih
	else
		set mouse=v
	endif
endfunc
map <silent> <C-w><C-m> :call MouseModeSwitch()<cr>
map <silent> <C-w>m :call MouseModeSwitch()<cr>

"indent setting
" set autoindent
set smartindent
set shiftwidth=0	"use &ts value

"popmenu setting
set completeopt=longest,menu ",preview

"vim diff settings
set diffopt=filler,context:10,vertical,foldcolumn:1

"file format setting for <EOL> define
set fileformat=unix
set fileformats=unix,dos

"file encode setting
set encoding=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
if v:lang =~ "utf8$" || v:lang =~ "utf-8$"
  set fencs=utf-8,ucs-bom,latin1
endif

"fix vim9 show keycode ^[[?4m or ^[[>4;2m or ^[[>4;m if terminal use gnome-terminal
set t_RK=
set t_TI=
set t_TE=
"fix vim show keycode ^[[%p1%d q when enter terminal job mode
set t_SH=

"font setting
" set guifont=Courier_New:h11:cANSI
" set guifontwide=新宋体:h11:cGB2312

"fold setting
" set foldmethod=indent "fold by have the same indentation
set foldmethod=syntax
set foldlevel=100
set fdc=0
nmap <silent> <Space>r :if &fdc>0\|set fdc=0\|else\|set fdc=3\|endif<cr>

"select block shortcuts setting
nmap <Space>q	vab
nmap <Space>w	vaB
nmap <Space>e	v%

"window move shortcuts setting
map <A-LEFT> <C-w><LEFT>
map <A-RIGHT> <C-w><RIGHT>
map <A-UP> <C-w><UP>
map <A-DOWN> <C-w><DOWN>
map <S-A-LEFT> <C-w><
map <S-A-RIGHT> <C-w>>
map <S-A-UP> <C-w>+
map <S-A-DOWN> <C-w>-
" <C-W>_<C-x>/H/J/K/L to exchange window

"tab page move shortcuts setting, switch tab page use <c-pageup>/<c-pagedown> or gt/gT, switch to {count} tab page use {count}gt or {count}<c-pagedown>
nmap <silent> > :+tabmove<cr>
nmap <silent> < :-tabmove<cr>

"Quickfix window shortcuts setting
nn <silent> <F5> :if !JumpWinInvalid()\|cp\|endif<cr>
nn <silent> <F6> :if !JumpWinInvalid()\|cn\|endif<cr>
nn <silent> <F8> :call QuickfixWinToggle()<cr>

"search shortcuts setting
vn <silent> <F2> "9y:call TextStr_Search("t0", @9)<cr>
nn <silent> <F2> :call TextStr_Search("t0", expand("<cword>"))<cr>
vn <silent> <C-F2> "9y:call JumpStack_DoJump('TextStr_Search', "t0", @9)<cr>
nn <silent> <C-F2> :call JumpStack_DoJump('TextStr_Search', "t0", expand("<cword>"))<cr>
vn <silent> <F3> "9y:call JumpStack_DoJump('TextStr_Search', "t1", @9)<cr>
nn <silent> <F3> :call JumpStack_DoJump('TextStr_Search', "t1", expand("<cword>"))<cr>
nn <silent> <C-F3> :call JumpStack_DoJump('TextStr_Search', "t1")<cr>
vn <silent> <F4> "9y:call JumpStack_DoJump('TextStr_Search', "t2", @9)<cr>
nn <silent> <F4> :call JumpStack_DoJump('TextStr_Search', "t2", expand("<cword>"))<cr>
nn <silent> <C-F4> :call JumpStack_DoJump('TextStr_Search', "t2")<cr>
func TextStr_Search(_type, ...)
	let input_pat = a:0 > 0 ? a:1 : input("> Find pattern input: ")
	if input_pat != '' && ['t0', 't1', 't2']->count(a:_type)
		if a:_type== "t0" " search one in current file
			if !search(input_pat, 'n')
				let v:errmsg = "Pattern not found: ".input_pat
				echohl WarningMsg | echo v:errmsg | echohl None
				return
			endif
			call feedkeys("\/".input_pat."\<cr>", "L") "use flag 'L' fix last used search pattern can not be changed by the function
			call JumpStack_SetHighLightPattern(input_pat)
		elseif a:_type== "t1" " search all in current file
			exe "vimgrep \/".input_pat."\/ %"
			let @/ = input_pat
			call feedkeys(":set hls\<cr>:echo\<cr>", "L") "use flag 'L' fix last used search pattern can not be changed by the function
			call JumpStack_SetHighLightPattern(input_pat)
		elseif a:_type == "t2" " search all recursively
			exe "vimgrep \/".input_pat."\/ % **"
			let @/ = input_pat
			call feedkeys(":set hls\<cr>:echo\<cr>", "L") "use flag 'L' fix last used search pattern can not be changed by the function
			call JumpStack_SetHighLightPattern(input_pat)
		endif
	else
		if input_pat == ''
			let v:errmsg = "Pattern is null"
		else
			let v:errmsg = "TextStr_Search type invalid"
		endif
		normal! :echo
	endif
endfunc

"TAGS file setting
"auto loading tags and cscope.out
autocmd VimEnter,BufRead * call UpdateTagConnection()
"update tags and cscope.out associated with current edit file
nmap <leader>t :call UpdateTagFile()<CR>

"VIM cscope setting
"for quickfix use <C-b> to search previous, <C-f> to search next, <C-t> to go back search, <C-l> to toggle results window on/off
" set csprg=$HOME/tools/bin/cscope
set cscopequickfix=s-,g0,c-,i-,f-,t-,e-,a-,d- "+: appended to quickfix window; -: clear previous results and add to quickfix window; 0 or unset: don't use quickfix. warning: quickfix no jump stack, instead of JumpStack_xxx() + location list
set cst "use the commands :cstag instead of the default :tag behavior.
nmap <silent> ffs :call JumpStack_DoJump('Cscope_Search', "s", expand("<cword>"))<cr>
nmap <silent> ffg :call Cscope_Search("g", expand("<cword>"))<cr>
nmap <silent> ffc :call JumpStack_DoJump('Cscope_Search', "c", expand("<cword>"))<cr>
nmap <silent> ffi :call JumpStack_DoJump('Cscope_Search', "i", expand("<cword>"))<cr>
nmap <silent> fff :call JumpStack_DoJump('Cscope_Search', "f", expand("<cword>"))<cr>
nmap <silent> fft :call JumpStack_DoJump('Cscope_Search', "t", expand("<cword>"))<cr>
nmap <silent> ffe :call JumpStack_DoJump('Cscope_Search', "e", expand("<cword>"))<cr>
nmap <silent> ffa :call JumpStack_DoJump('Cscope_Search', "a", expand("<cword>"))<cr>
nmap <silent> ffd :call JumpStack_DoJump('Cscope_Search', "d", expand("<cword>"))<cr>
vmap <silent> ffs "9y:call JumpStack_DoJump('Cscope_Search', "s", @9)<cr>
vmap <silent> ffg "9y:call Cscope_Search("g", @9)<cr>
vmap <silent> ffc "9y:call JumpStack_DoJump('Cscope_Search', "c", @9)<cr>
vmap <silent> ffi "9y:call JumpStack_DoJump('Cscope_Search', "i", @9)<cr>
vmap <silent> fff "9y:call JumpStack_DoJump('Cscope_Search', "f", @9)<cr>
vmap <silent> fft "9y:call JumpStack_DoJump('Cscope_Search', "t", @9)<cr>
vmap <silent> ffe "9y:call JumpStack_DoJump('Cscope_Search', "e", @9)<cr>
vmap <silent> ffa "9y:call JumpStack_DoJump('Cscope_Search', "a", @9)<cr>
vmap <silent> ffd "9y:call JumpStack_DoJump('Cscope_Search', "d", @9)<cr>
nmap <silent> ffrs :call JumpStack_DoJump('Cscope_Search', "s")<cr>
nmap <silent> ffrg :call Cscope_Search("g")<cr>
nmap <silent> ffrc :call JumpStack_DoJump('Cscope_Search', "c")<cr>
nmap <silent> ffri :call JumpStack_DoJump('Cscope_Search', "i")<cr>
nmap <silent> ffrf :call JumpStack_DoJump('Cscope_Search', "f")<cr>
nmap <silent> ffrt :call JumpStack_DoJump('Cscope_Search', "t")<cr>
nmap <silent> ffre :call JumpStack_DoJump('Cscope_Search', "e")<cr>
nmap <silent> ffra :call JumpStack_DoJump('Cscope_Search', "a")<cr>
nmap <silent> ffrd :call JumpStack_DoJump('Cscope_Search', "d")<cr>
func Cscope_Search(pat, ...)
	let input_pat = a:0 > 0 ? a:1 : input("> Find pattern input: ")
	if input_pat != '' && ['g', 's', 'c', 'i', 'f', 't', 'e', 'a', 'd']->count(a:pat)
		let cs_find = ''
		if a:pat == "g"
			"If the cursor is not in the valid edit window
			if JumpWinInvalid()
				let v:errmsg = "~^.^~ jump window is invalid!"
				echohl ErrorMsg | echo v:errmsg | echohl None
				return
			endif

			try
				if &shortmess !~# 'A'
					set shortmess+=A
					let shortmess_modified = 1
				endif
				let curidx= gettagstack().curidx
				"continue searching the tags file if no pattern is found in the cscope database
				" let cs_find = "cs find g ".input_pat
				let cs_find = "cstag ".input_pat
				exe cs_find
			catch /.*/
				let v:errmsg = v:exception
				echohl ErrorMsg | echo "Cscope_Search(\'g\', \'".input_pat."\'): ".v:errmsg | echohl None
			finally
				if curidx != gettagstack().curidx
					call JumpStack_UpdateStatus()
				endif
				if exists('shortmess_modified') && shortmess_modified == 1
					set shortmess-=A
				endif
			endtry
			return
		elseif a:pat == "s"
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
		call JumpStack_SetHighLightPattern(input_pat)
	else
		if input_pat == ''
			let v:errmsg = "Pattern is null"
		else
			let v:errmsg = "Cscope_Search mode invalid"
		endif
		normal! :echo
	endif
endfunc

"VIM tags setting
let g:jumpstack_disable_default_tag_highlight = 0
" set <C-]> check &cst option, g<C-]> use default tags file, use g<LeftMouse> as an alternative to <C-LeftMouse> for some terminals
nn <silent> <C-]> :call Tag_Search(v:false)<CR>
nn <silent> g<C-]> :call Tag_Search(v:true)<CR>
nn <silent> <C-LeftMouse> <LeftMouse>:call Tag_Search(v:false)<CR>
nn <silent> g<LeftMouse> <LeftMouse>:call Tag_Search(v:false)<CR>
vn <silent> <C-]> "9y:call Tag_Search(v:false, @9)<CR>
vn <silent> g<C-]> "9y:call Tag_Search(v:true, @9)<CR>
vn <silent> <C-LeftMouse> "9y:call Tag_Search(v:false, @9)<CR>
vn <silent> g<LeftMouse> "9y:call Tag_Search(v:false, @9)<CR>
map <silent> <C-RightMouse> :<c-u>call JumpStack_GoBack()<cr>
map <silent> g<RightMouse> :<c-u>call JumpStack_GoBack()<cr>
map <silent> <C-t> :<c-u>call JumpStack_GoBack()<cr>
nn <silent> <C-l> :call JumpStack_Select()<cr>
nn <silent> <c-b> :call JumpStack_Previous()<cr>
nn <silent> <c-f> :call JumpStack_Next()<cr>
set autochdir "$PWD is auto change to directory of jump
func Tag_Search(search_tag_only, ...)
	let input_pat = a:0 > 0 ? a:1 : expand("<cword>")
	let curidx= gettagstack().curidx

	if input_pat == ''
		let v:errmsg = "Search pattern is null"
		echohl ErrorMsg | echo v:errmsg | echohl None
		return
	endif

	try
		if &shortmess !~# 'A'
			set shortmess+=A
			let shortmess_modified = 1
		endif

		if a:search_tag_only || !&cst
			exe "tjump ".input_pat
		else
			exe "cstag ".input_pat
			" call feedkeys("\<c-]>", "!nx")
		endif
	catch /.*/
		let v:errmsg = v:exception
		echohl ErrorMsg | echo "Tag_Search(): ".v:errmsg | echohl None
	finally
		if curidx != gettagstack().curidx
			call JumpStack_UpdateStatus()
		endif
		if exists('shortmess_modified') && shortmess_modified == 1
			set shortmess-=A
		endif
	endtry
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
" Plug 'jistr/vim-nerdtree-tabs'		"extended nerdtree for all tabs
Plug 'Xuyuanp/nerdtree-git-plugin'	"extended git status in nerdtree
Plug 'scrooloose/nerdcommenter'		"section comment and uncomment
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'		"file search and buffer manager
Plug 'airblade/vim-gitgutter' | Plug 'tpope/vim-fugitive'
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'	"Common useful snippets for the ultisnips engine.
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
	" need check blocking
	Plug 'vim-scripts/OmniCppComplete'
	Plug 'vim-scripts/AutoComplPop'
endif
call plug#end()
nmap <silent> <F9> :PlugStatus<cr>
nmap <silent> <C-F9> :PlugInstall<cr>
nmap <silent> <S-F9> :PlugUpdate<cr>
nmap <silent> <A-F9> :PlugClean<cr>

au BufNewFile,BufReadPost * call LoadingFileTypeSetting()

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
nmap <silent> <leader>c :MarkClear<cr>

"Plug 'Shaiya2688/bracket-highlight'
let g:rainbow_active = 0 "command is :RainbowToggle
nmap <silent> <leader>5 :RainbowToggle<cr>
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
func! TagbarWinList()
	let winid_list = []
	let tabnr = tabpagenr()
	let winnum = tabpagewinnr(tabnr, '$')
	let winidx = 1
	while winidx <= winnum
		let name = bufname(winbufnr(winidx))
		if name =~# "__Tagbar__.*"
			let winid = win_getid(winidx, tabnr)
			if winid > 0
				call add(winid_list, winid)
			endif
		endif
		let winidx = winidx + 1
	endwhile
	return winid_list
endfunc
func! TagbarToggleSingleWin()
	let winid_list = TagbarWinList()
	if (len(winid_list) > 0)
		for winid in winid_list
			call win_execute(winid, 'q')
		endfor
	else
		silent! exe 'TagbarToggle'
	endif
endfunc
func! TagbarAutoUpdate()
	if JumpWinInvalid()
		return
	endif
	let curr_bufnr = bufnr()
	if exists("t:valid_bufnr") && t:valid_bufnr == curr_bufnr
		return
	endif
	let t:valid_bufnr = curr_bufnr
	let curr_winid = win_getid()
	let winid_list = TagbarWinList()
	if (len(winid_list) > 0)
		for winid in winid_list
			" call win_execute(winid, 'normal s')
			" call win_execute(winid, 'normal s')
			call win_gotoid(winid)
			" exe "normal s"
			" exe "normal s"
			silent! exe "normal s"
			silent! exe "normal s"
			call win_gotoid(curr_winid)
			return
		endfor
	endif
endfunc
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
" nmap <silent> , :TagbarToggle<cr>
nmap <silent> , :call TagbarToggleSingleWin()<cr>
autocmd BufEnter * call TagbarAutoUpdate() "fix tagbar not auto update

"Plug 'scrooloose/nerdtree'
autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":q\<cr>") | endif
" autocmd BufEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif
" autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    " \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
let NERDTreeWinPos='right'
let NERDTreeWinSize=48
let NERDTreeShowLineNumbers=0
let NERDTreeShowBookmarks=1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
"replace with NERDTreeTabsToggle to manager for all tabs
nmap <silent> . :NERDTreeToggle<CR>
"
" toggle NERDTree in current tab and match the state in all other tabs
" func! NERDTreeToggleAllTabs()
"   if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
"       " tabdo doesn't preserve current tab - save it and restore it afterwards
"       let current_tab = tabpagenr()
"       tabdo silent NERDTreeClose
"       exe 'tabn ' . current_tab
"   else
"       " call s:NERDTreeOpenAllTabs()
"       NERDTreeToggle
"       " force focus to NERDTree in current tab
"       " wincmd p
"       if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
"           exe bufwinnr(t:NERDTreeBufName) . "wincmd w"
"       endif
"   endif
" endfun
" nmap <silent> . :call NERDTreeToggleAllTabs()<cr>


"Plug 'jistr/vim-nerdtree-tabs'
" map <silent> . <plug>NERDTreeTabsToggle<CR>
"use NERDTreeTabsToggle to manager for all tabs
" map <silent> <leader>. <plug>NERDTreeFocusToggle<CR>

"Plug 'Xuyuanp/nerdtree-git-plugin'
let g:NERDTreeGitStatusEnable = 0 "default enable set
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

"Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
":AirlineExtensions can list extensions of supported and current loaded
if &bg == "dark"
	echoh WarningMsg | echo "vim-airline-themes: please add color settings for dark colorscheme" | echoh None
else
	let g:airline_theme='base16_summerfruit' "base16_colors, see :h airline-themes-list for more information, :AirlineTheme <theme> can set the theme
endif
let g:airline_powerline_fonts = 1	"need install fonts: sudo apt-get install fonts-powerline or git clone https://github.com/powerline/fonts.git --depth=1 && cd fonts && ./install.sh && mkdir ~/.config/fontconfig/conf.d/ -p && cp fontconfig/50-enable-terminess-powerline.conf ~/.config/fontconfig/conf.d/ && fc-cache -vf && cd .. && rm -rf fonts
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
if exists('g:airline_powerline_fonts') && g:airline_powerline_fonts == 1
	set ambiwidth=double
	" powerline symbols
	let g:airline_left_sep = ''
	let g:airline_left_alt_sep = ''
	let g:airline_right_sep = ''
	let g:airline_right_alt_sep = ''
	let g:airline_symbols.branch = '⎇'
	let g:airline_symbols.readonly = ''
	let g:airline_symbols.linenr = '☰'
	" let g:airline_symbols.maxlinenr = ''
	let g:airline_symbols.maxlinenr = ' '
endif
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#searchcount#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline#extensions#tabline#tabnr_formatter = 'AirLineTabNrFormatter'
let g:airline#extensions#tabline#tabtitle_formatter = 'AirLineTabTitleFormatter'
let g:airline#extensions#hunks#non_zero_only = 1
autocmd User AirlineAfterInit call AirlineInit()
func! AirLineTabNrFormatter(tab_nr_type, nr)
  if (len(tabpagebuflist(a:nr)) > 1)
	  return ' '. a:nr. '.[%{tabpagewinnr('.a:nr.')}/%{len(tabpagebuflist('.a:nr.'))}]'
  else
	  return ' '. a:nr
  endif
endfunc
func! AirLineTabTitleFormatter(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let bufnr = buflist[winnr - 1]
	let winid = win_getid(winnr, a:n)
	let name = bufname(bufnr)

	if empty(name)
		if getqflist({'qfbufnr' : 0}).qfbufnr == bufnr
			let title = airline#extensions#tabline#formatters#default#wrap_name(bufnr, '[Quickfix List]')
		elseif winid && getloclist(winid, {'qfbufnr' : 0}).qfbufnr == bufnr
			let title = airline#extensions#tabline#formatters#default#wrap_name(bufnr, '[Location List]')
		else
			let title = airline#extensions#tabline#formatters#default#wrap_name(bufnr, '[No Name]')
		endif
	else
		if name =~ 'term://'
			"Neovim Terminal
			let tail = substitute(name, '\(term:\)//.*:\(.*\)', '\1 \2', '')
		else
			let tail = fnamemodify(name, ':s?/\+$??:t')
		endif
		let title = airline#extensions#tabline#formatters#default#wrap_name(bufnr, tail)
	endif

	return title != '' ? title : airline#extensions#tabline#formatters#default#format(bufnr, buflist)
endfunc
function! AirlineInit()
	let spc = g:airline_symbols.space
	if exists("+autochdir") && &autochdir == 1
		let g:airline_section_c = airline#section#create(['%<', 'path', spc, 'readonly', spc, '%{GetFileTime()}'])
	else
		let g:airline_section_c = airline#section#create(['%<', 'file', spc, 'readonly', 'coc_status', spc, '%{GetFileTime()}'])
	endif
endfunc

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

"Plug 'airblade/vim-gitgutter' | Plug 'tpope/vim-fugitive'
let g:gitgutter_enabled = 1
" let g:gitgutter_preview_win_floating = 1
nmap <silent> git :GitGutterToggle<cr>
nmap <silent> gs :GitGutterLineHighlightsToggle<cr>
nmap <silent> gd :call JumpStack_DoJump('GitGutterQuickFix')<cr>
nmap <silent> gv :Gdiff<cr>
nmap <silent> gb :Git blame<cr>
nmap <silent> gl :call JumpStack_DoJump('Gllog')<cr>
nmap <silent> gp <Plug>(GitGutterPrevHunk)
nmap <silent> gn <Plug>(GitGutterNextHunk)
nmap <silent> ghp <Plug>(GitGutterPreviewHunk)
nmap <silent> ghs <Plug>(GitGutterStageHunk)
nmap <silent> ghu <Plug>(GitGutterUndoHunk)
nmap <silent> ghf :GitGutterFold<cr>
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
nmap <silent> <S-F8> :SrcExplToggle<cr>
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

func JumpStack_SetHighLightPattern(...)
	let input_pat = a:0 > 0 ? a:1 : expand('<cword>')
	if type(input_pat) != v:t_string
		echoerr "highlight pattern is invalid type"
		return
	else
		let t:jumpstack_hlpattern = input_pat
	endif
endfunc

func JumpStack_Begin(...)
	if JumpWinInvalid()
		echohl ErrorMsg | echo "~^.^~ jump window is invalid!" | echohl None
		return
	endif
	"Store where we're jumping from before we jump.
	let tag = a:0 > 0 ? a:1 : 'JumpStack_UnknownString'
	let pos = [bufnr()] + getcurpos()[1:3]
	let t:jumpstack_item = {'bufnr': pos[0], 'from': pos, 'tagname': tag}
	let t:jumpstack_winid = win_getid()
	let t:jumpstack_qf_title = getqflist({'title' : 0}).title
	let t:jumpstack_qf_id = getqflist({'id' : 0}).id
	let t:jumpstack_loc_title = getloclist(0, {'title' : 0}).title
	let t:jumpstack_loc_id = getloclist(0, {'id' : 0}).id
	let t:jumpstack_qf_winid = getqflist({'winid' : 0}).winid
	let t:jumpstack_hlpattern = ''
	let v:errmsg = ''
	let t:jumpstack_done = 0
endfunc

func JumpStack_Done()
	"Not have tag item or has been written to the tag stack.
	if !exists('t:jumpstack_item') || !exists('t:jumpstack_done') || t:jumpstack_done == 1
		return
	endif
	"exclude tabpage switch
	let t:jumpstack_done = 1
	"Jump was successful, write previous location to tag stack.
	if JumpWinInvalid()
		let winid = t:jumpstack_winid
	else
		let winid = win_getid()
	endif
	let stack = gettagstack(winid)
	if t:jumpstack_qf_id != getqflist({'id' : 0}).id || t:jumpstack_qf_title !=# getqflist({'title' : 0}).title "assert tag match results in quickfix
		let qftitle = getqflist({'title' : 0}).title
		let t:jumpstack_item['tagname'] = qftitle
		let stack['items'] = [t:jumpstack_item]
		call settagstack(winid, stack, 't')
		"create locationlist if not exist, move results from quickfix to locationlist
		call setloclist(winid, getqflist())
		call setloclist(winid, [], 'r', {'title': qftitle, 'context': {'from': t:jumpstack_item['from'], 'hlpattern': t:jumpstack_hlpattern}})
		"restore quickfix window status
		if !t:jumpstack_qf_winid
			silent! cclose
		endif
		"clear quickfix
		call setqflist([], "r")
		silent! colder
	elseif winid == t:jumpstack_winid && (t:jumpstack_loc_id != getloclist(winid, {'id' : 0}).id || t:jumpstack_loc_title !=# getloclist(winid, {'title' : 0}).title) "assert tag match results in locationlist
		let loctitle = getloclist(winid, {'title' : 0}).title
		let t:jumpstack_item['tagname'] = loctitle
		let stack['items'] = [t:jumpstack_item]
		call settagstack(winid, stack, 't')
		"create locationlist if not exist
		call setloclist(winid, [], 'r', {'context': {'from': t:jumpstack_item['from'], 'hlpattern': t:jumpstack_hlpattern}})
	else
		let pos = [bufnr()] + getcurpos()[1:3]
		if t:jumpstack_item['from'] ==# pos && (v:errmsg != '' || v:exception != '')
			return
		endif
		if !empty(t:jumpstack_hlpattern) && t:jumpstack_item.tagname ==# 'JumpStack_UnknownString'
			if &ignorecase && t:jumpstack_hlpattern  !~# '\\\@<!\\C'
				let t:jumpstack_hlpattern = '\c'.t:jumpstack_hlpattern
			endif
			let t:jumpstack_item.tagname = t:jumpstack_hlpattern
		endif
		let stack['items'] = [t:jumpstack_item]
		call settagstack(winid, stack, 't')
	endif
	call JumpStack_UpdateStatus(winid, t:jumpstack_hlpattern, v:true)
endfunc

func JumpStack_DoJump(jumpmethod, ...)
	"If the cursor is not in the valid edit window
	if JumpWinInvalid()
		echohl ErrorMsg | echo "~^.^~ jump window is invalid!" | echohl None
		return
	endif

	call JumpStack_Begin()
	try
		if &shortmess !~# 'A'
			set shortmess+=A
			let shortmess_modified = 1
		endif
		if exists("*".a:jumpmethod)
			let Func = function(a:jumpmethod, a:000)
			call Func()
		else
			exe a:jumpmethod
		endif
	catch /.*/
		let v:errmsg = v:exception
		echohl ErrorMsg | echo "JumpStack_DoJump(\'".a:jumpmethod."\'): ".v:errmsg | echohl None
	finally
		call JumpStack_Done()
		if exists('shortmess_modified') && shortmess_modified == 1
			set shortmess-=A
		endif
	endtry
endfunc

func JumpStack_GoBack()
	"If the cursor is not in the valid edit window
	if JumpWinInvalid()
		echohl ErrorMsg | echo "~^.^~ jump window is invalid!" | echohl None
		return
	endif

	try
		if &shortmess !~# 'A'
			set shortmess+=A
			let shortmess_modified = 1
		endif

		let stack = gettagstack()
		silent pop
		if (stack['length'] > 0 && stack['curidx'] > 1) "assert if :pop success
			let popitems = stack['items'][stack['curidx'] - 2]
			let popfrom = popitems.from
			let poptagname = popitems.tagname
			let loctitle = getloclist(0, {'title' : 0}).title
			let locctx = getloclist(0, {'context' : 0}).context
			if type(locctx) == v:t_dict && has_key(locctx, 'from') && type(locctx.from) == v:t_list
				let locfrom = locctx.from
				"the line number of the jump buffer stored in tagstack changes dynamically as the buffer is updated
				if len(locfrom) == 4 && len(popfrom) == 4 &&
							\ locfrom[0] ==# popfrom[0] && locfrom[2:3] ==# popfrom[2:3] &&
							\ loctitle ==# poptagname
					let locidx = getloclist(0, {'nr' : 0}).nr
					if locidx < 2 "at location list stack bottom
						silent! lclose
						call setloclist(0, [], "f")
					else
						silent! lolder
					endif
				endif
			endif
			call JumpStack_UpdateStatus()
		endif
	catch /.*/
		let v:errmsg = v:exception
		echohl ErrorMsg | echo v:errmsg | echohl None
	finally
		if exists('shortmess_modified') && shortmess_modified == 1
			set shortmess-=A
		endif
	endtry
endfunc

func JumpStack_Select()
	"If the cursor is not in the valid edit window
	if JumpWinInvalid() && !JumpStack_LocationTagActive()
		echohl ErrorMsg | echo "~^.^~ jump window is invalid!" | echohl None
		return
	endif

	let stack = gettagstack()
	let winid = win_getid()

	if (!stack['length'] || stack['curidx'] < 2)
		echohl WarningMsg | echo "tag stack empty" | echohl None
		return
	endif

	try
		if JumpStack_LocationTagActive()
			let locwinid = getloclist(winid, {'winid' : 0}).winid
			if locwinid == winid
				let winid = getloclist(locwinid, {'filewinid': 0}).filewinid
			endif
			if !exists('t:jumpstack_defclosed_locwin')
				let t:jumpstack_defclosed_locwin = {}
			endif
			if locwinid
				let t:jumpstack_defclosed_locwin[winid] = v:true
			else
				let t:jumpstack_defclosed_locwin[winid] = v:false
			endif
			call JumpStack_UpdateStatus(winid)
		else
			ts
		endif
	catch /.*/
		let v:errmsg = v:exception
		echohl WarningMsg | echo v:errmsg | echohl None
	finally
		"tag stack may be modified
		call settagstack(winid, stack, 'r')
		call settagstack(winid, {'curidx' : stack['curidx']})
	endtry
endfunc

func JumpStack_Previous()
	"If the cursor is not in the valid edit window
	if JumpWinInvalid()
		echohl ErrorMsg | echo "~^.^~ jump window is invalid!" | echohl None
		return
	endif

	let stack = gettagstack()
	let winid = win_getid()

	if (!stack['length'] || stack['curidx'] < 2)
		echohl WarningMsg | echo "tag stack empty" | echohl None
		return
	endif

	try
		if JumpStack_LocationTagActive()
			lp
		else
			tp
			if (stack['items'][stack['curidx'] - 2].matchnr > 1) "update if :tp success
				let stack['items'][stack['curidx'] - 2].matchnr = stack['items'][stack['curidx'] - 2].matchnr - 1
			endif
		endif
	catch /.*/
		let v:errmsg = v:exception
		echohl WarningMsg | echo v:errmsg | echohl None
	finally
		"tag stack may be modified
		call settagstack(winid, stack, 'r')
		call settagstack(winid, {'curidx' : stack['curidx']})
	endtry
endfunc

func JumpStack_Next()
	"If the cursor is not in the valid edit window
	if JumpWinInvalid()
		echohl ErrorMsg | echo "~^.^~ jump window is invalid!" | echohl None
		return
	endif

	let stack = gettagstack()
	let winid = win_getid()

	if (!stack['length'] || stack['curidx'] < 2)
		echohl WarningMsg | echo "tag stack empty" | echohl None
		return
	endif

	try
		if JumpStack_LocationTagActive()
			lne
		else
			tn
			let stack['items'][stack['curidx'] - 2].matchnr = stack['items'][stack['curidx'] - 2].matchnr + 1 "update if :tn success
		endif
	catch /.*/
		let v:errmsg = v:exception
		echohl WarningMsg | echo v:errmsg | echohl None
	finally
		"tag stack may be modified
		call settagstack(winid, stack, 'r')
		call settagstack(winid, {'curidx' : stack['curidx']})
	endtry
endfunc

func JumpStack_LocationTagActive(...)
	let winid = (a:0 > 0 && a:1 > 0) ? a:1 : win_getid()
	let locwinid = getloclist(winid, {'winid' : 0}).winid
	if locwinid == winid
		let winid = getloclist(locwinid, {'filewinid': 0}).filewinid
	endif
	let stack = gettagstack(winid)
	if (stack['length'] > 0 && stack['curidx'] > 1) "if have tag in stack
		let items = stack['items'][stack['curidx'] - 2]
		let from = items.from
		let tagname = items.tagname
		let loctitle = getloclist(winid, {'title' : 0}).title
		let locctx = getloclist(winid, {'context' : 0}).context
		if type(locctx) == v:t_dict && has_key(locctx, 'from') && type(locctx.from) == v:t_list
			let locfrom = locctx.from
			"the line number of the jump buffer stored in tagstack changes dynamically as the buffer is updated
			if len(locfrom) == 4 && len(from) == 4 && locfrom[0] ==# from[0] && locfrom[2:3] ==# from[2:3] &&
						\ loctitle ==# tagname
				return 1
			endif
		endif
	endif
	return 0
endfunc

hi JumpStack_HighLight_Red ctermfg=0 ctermbg=9 guifg=Black guibg=#FF7272
hi JumpStack_HighLight_Cyan ctermfg=0 ctermbg=14 guifg=Black guibg=#8CCBEA
hi JumpStack_HighLight_Green ctermfg=0 ctermbg=10 guifg=Black guibg=#A4E57E
hi JumpStack_HighLight_Yellow ctermfg=0 ctermbg=11 guifg=Black guibg=#FFDB72
hi JumpStack_HighLight_Magenta ctermfg=0 ctermbg=13 guifg=Black guibg=#FFB3FF
hi link JumpStack_HighLight_Default JumpStack_HighLight_Magenta
hi link JumpStack_HighLight_Tag JumpStack_HighLight_Magenta
func JumpStack_UpdateStatus(...)
	let highlight = 'JumpStack_HighLight_Default'
	let highlighttag = 'JumpStack_HighLight_Tag'
	let priority = 10
	let matchid = 1000
	let winid = (a:0 > 0 && a:1 > 0) ? a:1 : win_getid()
	let hlpattern = a:0 > 1 ? a:2 : ''
	let jumpsel = a:0 > 2 ? a:3 : v:false
	let locwinid = getloclist(winid, {'winid' : 0}).winid
	if locwinid == winid
		let winid = getloclist(locwinid, {'filewinid': 0}).filewinid
	endif
	if !empty(hlpattern) && &ignorecase && hlpattern !~# '\\\@<!\\C'
		let hlpattern = '\c'.hlpattern
	endif

	if exists('t:jumpstack_defclosed_locwin')
		for key in keys(t:jumpstack_defclosed_locwin)
			if !win_id2win(key)
				unlet t:jumpstack_defclosed_locwin[key]
			endif
		endfor
	endif

	if JumpStack_LocationTagActive(winid)
		if winid == win_getid() || locwinid == win_getid()
			if jumpsel
				"select first item, ignore none items or other errors
				silent! exe "normal :lopen\<cr>\<cr>"
			elseif exists('t:jumpstack_defclosed_locwin') && has_key(t:jumpstack_defclosed_locwin, winid) && t:jumpstack_defclosed_locwin[winid]
				lclose
			elseif !locwinid
				lopen
				call win_gotoid(winid)
			endif
		endif
		let locctx = getloclist(winid, {'context' : 0}).context
		if type(locctx) == v:t_dict && has_key(locctx, 'hlpattern') && type(locctx.hlpattern) == v:t_string
			let hlpattern = locctx.hlpattern
			if !empty(hlpattern) && &ignorecase && hlpattern !~# '\\\@<!\\C'
				let hlpattern = '\c'.hlpattern
			endif
		endif
	else
		if winid == win_getid() || locwinid == win_getid()
			lclose
		endif
		if !exists('g:jumpstack_disable_default_tag_highlight') || g:jumpstack_disable_default_tag_highlight == 0
			let stack = gettagstack(winid)
			if (stack['length'] > 0 && stack['curidx'] > 1) "if have tag in stack
				let highlight = highlighttag 
				let tagname = stack['items'][stack['curidx'] - 2].tagname
				if empty(hlpattern) && tagname !=# 'JumpStack_UnknownString'
					let hlpattern = tagname
					"cscope tag use ignorecase, tag not use, so ???
					" if !empty(hlpattern) && &ignorecase && hlpattern !~# '\\\@<!\\C'
					"     let hlpattern = '\c'.hlpattern
					" endif
				endif
			endif
		endif
	endif

	silent! call matchdelete(matchid, winid)
	let locwinid = getloclist(winid, {'winid' : 0}).winid
	if locwinid
		silent! call matchdelete(matchid, locwinid)
		if JumpStack_LocationTagActive(winid)
			call matchadd(highlight, hlpattern, priority, matchid, {'window': locwinid})
		endif
	endif
	call matchadd(highlight, hlpattern, priority, matchid, {'window': winid})
endfunc

func LocationlistWinToggle()
	if getloclist(0, {'winid' : 0}).winid
		silent! lclose
	else
		silent! lopen
		let locnum = getloclist(0, {'nr' : '$'}).nr
		if !locnum
			echohl WarningMsg | echo "Location List not exist!" | echohl None
		endif
	endif
endfunc

func QuickfixWinToggle()
	if getqflist({'winid' : 0}).winid
		silent! cclose
	else
		silent! bo copen
	endif
endfunc

func QuickfixWinCleanClose()
	call setqflist([], "f")
	silent! cclose
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
	"Aslo filter the Quickfix/Locationlist window
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
			let tmp = tags_search_path
			let tags_search_path = GetPathParent(tags_search_path)
			"check if a wrong path leads to an infinite loop
			if tmp ==# tags_search_path
				break
			endif
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
		let tmp = parent
		let parent = GetPathParent(parent)
		"check if a wrong path leads to an infinite loop
		if tmp ==# parent
			break
		endif
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
		echohl ErrorMsg | echo "~^.^~ Invalid file" | echohl None
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

" reference https://en.wikipedia.org/wiki/Characters_per_line
func LoadingFileTypeSetting()
	"check VIMRUNTIME/filetype.vim
	if &ft  == ''
		return
	endif
	if ['c', 'cpp']->count(&ft)
		set fo+=tcq
		"lastest linux scan scripts has removed 80-column warning, increase to 100 but 80 is still preferred
		set tw=80
		" set cc=+1,+2
	elseif ['python']->count(&ft)
		set fo+=tcq
		set tw=79
	elseif ['java']->count(&ft)
		set fo+=tcq
		"use Google java code style
		set tw=100
	elseif ['sh', 'vim', 'make', 'markdown']->count(&ft)
		" TODO
		return
	endif
endfunc

func GetPathParent(path)
	let parent = substitute(a:path, '[\/][^\/]\+[\/:]\?$', '', '')
	if parent == '' || parent !~ '[\/]'
		let parent .= '/'
	en
	retu parent
endfunc

func GetFileTime(...)
	let fname = a:0 > 0 ? a:1 : expand("%:p")
	let ftime = ''
	if fname != '' && getftime(fname) != -1 && exists("*strftime")
		let ftime = strftime("%Y/%m/%d %T", getftime(fname))
		" let ftime = strftime("%Y/%m/%d %T %A", getftime(fname))
	endif
	return ftime
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

	echoh Comment | echo "terminal setting" | echoh None
	call HelpCmdString("NORMAL", "<leader>T", "Open terminal current tabpage, 'bash' as the preferred shell")
	call HelpCmdString("NORMAL", "<leader><C-T>", "Open terminal in new tabpage, 'bash' as the preferred shell")
	call HelpCmdString("NORMAL", "<C-W>q", "Close terminal")
	call HelpCmdString("NORMAL", "<C-W>n or <ScrollWheelUp>", "Enter terminal normal mode")
	call HelpCmdString("NORMAL", "<C-W>t or <RightMouse>", "Exit terminal normal mode")

	echoh Comment | echo "mouse mode setting" | echoh None
	call HelpCmdString("COMMON", "<C-W>m", "switch mouse between 'nvih' and 'v'")

	echoh Comment | echo "fold setting" | echoh None
	call HelpCmdString("NORMAL", "<Space>r", "set fdc=3/0")

	echoh Comment | echo "block select setting" | echoh None
	call HelpCmdString("NORMAL", "<Space>q", "vab: from ( to the matching )")
	call HelpCmdString("NORMAL", "<Space>w", "vaB: from { to the matching }")
	call HelpCmdString("NORMAL", "<Space>e", "v% : smart matching {()}")

	echoh Comment | echo "window setting" | echoh None
	call HelpCmdString("COMMON", "<A-LEFT> or <C-W><LEFT>", "move cursor to left window")
	call HelpCmdString("COMMON", "<A-RIGHT> or <C-W><RIGHT>", "move cursor to right window")
	call HelpCmdString("COMMON", "<A-UP> or <C-W><UP>", "move cursor to above window")
	call HelpCmdString("COMMON", "<A-DOWN> or <C-W><DOWN>", "move cursor to below window")
	call HelpCmdString("COMMON", "<S-A-LEFT>", "Decrease current window width")
	call HelpCmdString("COMMON", "<S-A-RIGHT>", "Increase current window width")
	call HelpCmdString("COMMON", "<S-A-UP>", "Increase current window height")
	call HelpCmdString("COMMON", "<S-A-DOWN>", "Decrease current window height")
	call HelpCmdString("COMMON", "<C-W>{<C-x>/H/J/K/L}", "exchange window with next/left/below/above/right")
	call HelpCmdString("COMMON", "<C-W>{<C-s>/<C-v>}", "split window vertically/horizontally")

	echoh Comment | echo "tab page setting" | echoh None
	call HelpCmdString("NORMAL", "<C-PageUp> or gT", "switch to previous tab page")
	call HelpCmdString("NORMAL", "<C-PageDown> or gt", "switch to next tab page")
	call HelpCmdString("NORMAL", "{n}<C-PageDown> or {n}gt", "switch to {n} tab page")
	call HelpCmdString("NORMAL", "<S-,>", "exchange tab page with previous")
	call HelpCmdString("NORMAL", "<S-.>", "exchange tab page with next")

	echoh Comment | echo "search setting" | echoh None
	call HelpCmdString("NONE-I", "<F2>", "search this or selected pattern, can not use <C-t> to jump back")
	call HelpCmdString("NONE-I", "<C-F2>", "search this or selected pattern, can use <C-t> to jump back")
	call HelpCmdString("NONE-I", "<F3>", "search all of this or selected pattern in current file and list results in Locationlist window")
	call HelpCmdString("NONE-I", "<C-F3>", "search all of input pattern in current file and list results in Locationlist window")
	call HelpCmdString("NONE-I", "<F4>", "recursive search all of this or selected pattern below current directory and list results in Locationlist window")
	call HelpCmdString("NONE-I", "<C-F4>", "recursive search all of input pattern below current directory and list results in Locationlist window")

	echoh Comment | echo "Quickfix window setting" | echoh None
	call HelpCmdString("NORMAL", "<F5>", "Jump to Quickfix next item")
	call HelpCmdString("NORMAL", "<F6>", "Jump to Quickfix previous item")
	call HelpCmdString("NORMAL", "<F8>", "Toggle Quickfix window")

	echoh Comment | echo "TAGS file setting" | echoh None
	call HelpCmdString("NORMAL", "<leader>t", "Update TAG files associated with current edit file artificially")

	echoh Comment | echo "VIM tags setting" | echoh None
	call HelpCmdString("NONE-I", "<C-]>", "list definition and Put it in the tag stack")
	call HelpCmdString("NORMAL", "<C-l>", "list results of current tag definition or Locationlist items")
	call HelpCmdString("NORMAL", "<C-t>", "JumpBack and Pop current tag and Locationlist out the stack")
	call HelpCmdString("NONE-I", "<C-LeftMouse>", "Same as <C-]>")
	call HelpCmdString("NONE-I", "g<LeftMouse>", "Same as <C-]>")
	call HelpCmdString("NONE-I", "<C-RightMouse>", "Same as <C-t>")
	call HelpCmdString("NONE-I", "g<RightMouse>", "Same as <C-t>")
	call HelpCmdString("NORMAL", "<c-b>", "Jump to current tag or Locationlist previous item")
	call HelpCmdString("NORMAL", "<c-f>", "Jump to current tag or Locationlist next item")

	echoh Comment | echo "VIM cscope setting" | echoh None
	call HelpCmdString("NONE-I", "ffs/ffrs", "Find C symbol and list results in Locationlist window")
	call HelpCmdString("NONE-I", "ffg/ffrg", "Find definition")
	call HelpCmdString("NONE-I", "ffc/ffrc", "Find functions calling this function and list results in Locationlist window")
	call HelpCmdString("NONE-I", "ffi/ffri", "Find files #including this file and list results in Locationlist window")
	call HelpCmdString("NONE-I", "fff/ffrf", "Find this file and list results in Locationlist window")
	call HelpCmdString("NONE-I", "fft/ffrt", "Find text string and list results in Locationlist window")
	call HelpCmdString("NONE-I", "ffe/ffre", "Find egrep pattern and list results in Locationlist window")
	call HelpCmdString("NONE-I", "ffa/ffra", "Find places where this symbol is assigned a value and list results in Locationlist window")

	echoh Comment | echo "Vim Plugin Manager setting" | echoh None
	call HelpCmdString("NORMAL", "<F9>", "Vim-Plug PlugStatus")
	call HelpCmdString("NORMAL", "<C-F9>", "Vim-Plug PlugInstall")
	call HelpCmdString("NORMAL", "<S-F9>", "Vim-Plug PlugUpdate")
	call HelpCmdString("NORMAL", "<A-F9>", "Vim-Plug PlugClean")

	echoh Comment | echo "Color Mark setting" | echoh None
	call HelpCmdString("NONE-I", "<leader>m or <leader>r", "mark and unmark pattern with different color")
	call HelpCmdString("NORMAL", "<leader>/ or <leader>?", "search previous or next mark pattern")
	call HelpCmdString("NORMAL", "<leader>c", "unmark all marked pattern")
	call HelpCmdString("NORMAL", "<leader>5", "show bracket with different color")

	echoh Comment | echo "Block or Line Comment setting, more information see :h nerdcommenter or :map" | echoh None
	call HelpCmdString("NONE-I", "<leader>ca", "switch alternative delimiter")
	call HelpCmdString("NONE-I", "<leader>cb", "line or selected line comment")
	call HelpCmdString("NONE-I", "<leader>cc", "line or selected block comment")
	call HelpCmdString("NONE-I", "<leader>cm", "block comment use one /**/")
	call HelpCmdString("NONE-I", "<leader>cu", "uncomment")
	call HelpCmdString("NONE-I", "<leader>cA", "append comment end of line")
	call HelpCmdString("NONE-I", "<leader>cs", "style comment")

	echoh Comment | echo "Auto complete Pop setting" | echoh None
	call HelpCmdString("INSERT", "<C-p>", "trigger complete popmenu")

	echoh Comment | echo "TAGS list setting" | echoh None
	call HelpCmdString("NORMAL", ",", "Tagbar Toggle")

	echoh Comment | echo "File explorer setting" | echoh None
	call HelpCmdString("NONE-I", ".", "NERDTree Toggle")
	call HelpCmdString("NONE-I", "<leader>.", "Focus NERDTree window")

	echoh Comment | echo "CtrlP plugin setting" | echoh None
	call HelpCmdString("NORMAL", "<C-p>", "load CtrlP for file searching, ? for help")

	echoh Comment | echo "Git Plugin setting" | echoh None
	call HelpCmdString("NORMAL", "git", "Git Plugin Enable or Disable")
	call HelpCmdString("NORMAL", "gs", "Highlight changed line")
	call HelpCmdString("NORMAL", "gd", "Show all git changes in Locationlist window")
	call HelpCmdString("NORMAL", "gv", "View current file unstaged changes in vertical diff mode")
	call HelpCmdString("NORMAL", "gb", "Run git blame on the current file and open in a vertical split window, g? for help")
	call HelpCmdString("NORMAL", "gl", "Run git log to load commit history in Locationlist window")
	call HelpCmdString("NORMAL", "gp", "Jump to previous change")
	call HelpCmdString("NORMAL", "gn", "Jump to next change")
	call HelpCmdString("NORMAL", "ghp", "Show hunk changes in Preview window")
	call HelpCmdString("NORMAL", "ghs", "Stage hunk changes")
	call HelpCmdString("NORMAL", "ghu", "Undo hunk changes")
	call HelpCmdString("NORMAL", "ghf", "Fold all unchanged lines")

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
