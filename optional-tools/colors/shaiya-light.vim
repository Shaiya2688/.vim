" Vim color file - shaiya-light
" This is the default color scheme for &bg == light.
"
set background=light
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

set t_Co=256
if has('termguicolors') || has('vcon')
	set tgc
endif
let g:colors_name = "shaiya-light"

" ---------------- highlight-default ----------------
hi ColorColumn gui=None guibg=#add8e6 cterm=None
"hi Conceal -- no settings --
"hi Cursor -- no settings --
"hi CursorIM -- no settings --
hi CursorColumn gui=None guibg=#e5e5e5 cterm=None
hi CursorLine gui=None guibg=#e0e0e0 cterm=None
hi Directory gui=None guifg=#0000ff cterm=None
hi DiffAdd gui=None guibg=#ffd5cc guifg=#ff0000 cterm=None
hi DiffChange gui=None guibg=#ffd5cc guifg=#000000 cterm=None
hi DiffDelete gui=None guibg=#ffd5cc guifg=#000000 cterm=None
hi DiffText gui=None guibg=#ffd5cc guifg=#ff0000 cterm=None
hi link EndOfBuffer NonText
hi ErrorMsg gui=None guifg=#ffffff guibg=#ff0000 cterm=None
hi VertSplit gui=reverse cterm=reverse
hi Folded gui=None guifg=#00008b guibg=#d3d3d3 cterm=None
hi FoldColumn gui=None guifg=#00008b guibg=#e0e0e0 cterm=None
hi SignColumn gui=None guifg=#00008b guibg=bg cterm=None
"hi IncSearch -- no settings --
hi LineNr gui=None guifg=#a9a9a9 cterm=None
hi clear LineNrAbove
hi clear LineNrBelow
hi CursorLineNr gui=bold guifg=#4d4d4d guibg=#e0e0e0 cterm=bold
hi MatchParen gui=None guibg=#00ffff cterm=None
hi ModeMsg gui=bold cterm=bold
hi MoreMsg gui=bold guifg=#008000 cterm=bold
hi NonText gui=None guifg=#0000ff cterm=None
hi Normal gui=None guifg=#000000 guibg=#efffef cterm=None
hi PMenu gui=None guibg=#b2d9ff guifg=#000000 cterm=None
hi PMenuSel gui=bold guibg=#449e9e guifg=#ffff00 cterm=bold
hi PMenuSbar gui=None guibg=#a9a9a9 cterm=None
hi PMenuThumb gui=None guibg=#449e9e cterm=None
hi Question gui=bold guifg=#008000 cterm=None
hi QuickFixLine gui=None guifg=#000000 guibg=#60e0ff cterm=None
hi Search gui=None guifg=#000000 guibg=#ffff00 cterm=None
"hi SpecialKey -- no settings --
"hi SpellBad -- no settings --
"hi SpellCap -- no settings --
"hi SpellLocal -- no settings --
"hi SpellRare -- no settings --
hi StatusLine gui=bold guibg=#000000 guifg=#ffa500 cterm=bold
hi StatusLineNC gui=italic guibg=#262626 guifg=#ffffff cterm=italic
hi StatusLineTerm gui=bold guibg=#449e9e guifg=#ffff00 cterm=bold
hi StatusLineTermNC gui=italic guibg=#449e9e guifg=#ffffff cterm=italic
hi TabLine gui=underline guibg=#d3d3d3 cterm=underline
hi TabLineFill gui=reverse cterm=reverse
hi TabLineSel gui=bold cterm=bold
hi link Terminal Normal
hi Title gui=bold guifg=#ff00ff cterm=None
hi Visual gui=None guibg=#d3d3d3 cterm=None
" hi VisualNOS -- no settings --
hi WarningMsg gui=None guifg=#ff0000 cterm=None
hi WildMenu  gui=bold guifg=#000000 guibg=#ffff00 cterm=bold
"hi User1 -- no settings --
"hi User2 -- no settings --
"hi User3 -- no settings --
"hi User4 -- no settings --
"hi User5 -- no settings --
"hi User6 -- no settings --
"hi User7 -- no settings --
"hi User8 -- no settings --
"hi User9 -- no settings --
"hi Menu -- no settings --
"hi Scrollbar -- no settings --
"hi Tooltip -- no settings --

" ----------- highlight-groups for common group-name ------------
" *Comment			any comment
hi Comment gui=None guifg=#0000ff cterm=None

" *Constant			any constant
hi constant gui=None guifg=#ff00ff cterm=None
" String			a string constant: "this is a string"
hi String gui=None guifg=#a52a2a cterm=None
" Character			a character constant: 'c', '\n'
hi link Character Constant
" Number			a number constant: 234, 0xff
hi link Number Constant
" Boolean			a boolean constant: TRUE, false
hi link Boolean Constant
" Float				a floating point constant: 2.3e10
hi link Float Number

" *Identifier		any variable name
hi Identifier gui=None guifg=#008b8b cterm=None
" Function			function name (also: methods for classes)
hi link Function Identifier

" *Statement		any statement
hi Statement gui=bold guifg=#a52a2a cterm=None
" Conditional		if, then, else, endif, switch, etc.
hi link Conditional Statement
" Repeat			for, do, while, etc.
hi link Repeat Statement
" Label				case, default, etc.
hi link Label Statement
" Operator			"sizeof", "+", "*", etc.
hi link Operator Statement
" Keyword			any other keyword
hi link Keyword Statement
" Exception			try, catch, throw
hi link Exception Statement

" *PreProc			generic Preprocessor
hi PreProc gui=None guifg=#6a0dad cterm=None
" Include			preprocessor #include
hi link Include PreProc
" Define			preprocessor #define
hi link Define PreProc
" Macro				same as Define
hi link Macro PreProc
" PreCondit			preprocessor #if, #else, #endif, etc.
hi link PreCondit PreProc

" *Type				int, long, char, etc.
hi Type gui=bold guifg=#008000 cterm=None
" StorageClass		static, register, volatile, etc.
hi link StorageClass Type
" Structure			struct, union, enum, etc.
hi link Structure Type
" Typedef			A typedef
hi link Typedef Type

" *Special			any special symbol
hi Special gui=None guifg=#6a0dad cterm=None
" SpecialChar		special character in a constant
hi link SpecialChar Special
" Tag				you can use CTRL-] on this
hi link Tag Special
" Delimiter			character that needs attention
hi link Delimiter Special
" SpecialComment	special things inside a comment
hi link SpecialComment Special
" Debug				debugging statements
hi link Debug Special

" *Underlined		text that stands out, HTML links
hi Underlined gui=underline guifg=#6a5acd cterm=underline

" *Ignore			left blank, hidden  |hl-Ignore|
hi Ignore gui=None guifg=bg cterm=None

" *Error			any erroneous construct
hi Error gui=None guifg=#ffffff guibg=#ff0000 cterm=None

" *Todo				anything that needs extra attention; mostly the keywords TODO FIXME and XXX
hi Todo gui=None guifg=#0000ff guibg=#ff8c00 cterm=None


" ---------------------- highlight for ME -----------------------
" ## cterm 256 colors View ##
for num_col in range(256)
	exec "hi ColorView".num_col." ctermfg=0 ctermbg=".num_col
endfor

" ---- highlight-groups for group-name with special filetype ----
" ## vim ##
"

" ## bash ##
"

" ## c ##
"

" ## cpp ##
"

" ## java ##
"

" ## html ##
"

" ## more ##
"
