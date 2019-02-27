@echo off
setlocal enabledelayedexpansion
set todo="help"
set file_type=.h .c .cpp
set file_path=%cd%

set input=%*
:getopts
	for /f "tokens=1,* delims=/" %%i in ("!input!") do (
		set opt=%%i
		set opt_t=!opt:~0,1!
		set opt_v=!opt:~1,1000!
		rem echo !opt_t!: !opt_v!
		if /I !opt_t! == t (set file_type=!opt_v!) else (
		if /I !opt_t! == f (set file_path=!opt_v!) else (
		if /I !opt_t! == i (set todo="install") else (
		if /I !opt_t! == u (set todo="update") else (
		if /I !opt_t! == r (set todo="reinstall") else (
		if /I !opt_t! == c (set todo="clean") else (
		if /I !opt_t! == h (set todo="help") else (
			echo Invalid option: !opt_t!!
			goto help
		)))))))
		set input=/%%j
		goto getopts
	)

:resolve_opts
	if %todo% == "install" (goto install_update_reinstall) else (
	if %todo% == "update" (goto install_update_reinstall) else (
	if %todo% == "reinstall" (goto install_update_reinstall) else (
	if %todo% == "clean" (goto clean) else (
	if %todo% == "help" (goto help) else (
		goto help
	)))))
	goto exit

:install_update_reinstall
	if %todo% == "update" (
		if exist cscope.files (
			del /q cscope.out cscope.po.out cscope.in.out ncscope.out tags  2>nul
			rem cscope -bkq -i cscope.files
			cscope -bk -i cscope.files
			ctags -R --sort=yes --c-kinds=+p --c++-kinds=+p --fields=+ia --extra=+q -L cscope.files
			echo TAG files %todo% done
			goto exit
		) else (
			echo cscope.files not exists!
			goto exit
		)
	) else (
		if %todo% == "install" (
			if exist cscope.files ( echo cscope.files exists! & goto exit )
		)
		del /q cscope.files cscope.out cscope.po.out cscope.in.out ncscope.out tags 2>nul

		set _path=%file_path%
		set "path_pattern="
		:path_resolve
			for /f "tokens=1,* delims= """ %%i in ("!_path!") do (
				if !path_pattern!! == ! (set path_pattern=%%i) else (set path_pattern=!path_pattern! %%i)
				set _path=%%j
				goto path_resolve
			)
		if !path_pattern!! == ! (
			echo Invalid file path.
			goto help
		)
		dir !path_pattern! /s /b 2>nul 1>cscope.files.tmp
		if not exist cscope.files.tmp (
			echo No files were found.
			goto exit
		)

		set _type=%file_type%
		set "type_pattern="
		:type_resolve
			for /f "tokens=1,*" %%i in ("!_type!") do (
				set type_pattern=%%i
				set type_pattern=!type_pattern:.=\.!
				if exist cscope.files (
					findstr !type_pattern!$ cscope.files.tmp >> cscope.files
				) else (
					findstr !type_pattern!$ cscope.files.tmp > cscope.files
				)
				set _type=%%j
				goto type_resolve
			)
		del /q cscope.files.tmp 2>nul
		if !type_pattern!! == ! (
			echo Invalid file type.
			goto help
		)

		if exist cscope.files (
			rem cscope -bkq -i cscope.files
			cscope -bk -i cscope.files
			ctags --sort=yes --c-kinds=+p --c++-kinds=+p --fields=+ia --extra=+q -L cscope.files
		)
	)

	echo TAG files %todo% done
	goto exit

:clean
	del /q cscope.files cscope.out cscope.po.out cscope.in.out ncscope.out tags  2>nul
	echo "clean TAG files."
	goto exit

:help
	echo.
	echo	Usage: %~n0 [/i] [/u] [/r] [/c] [/h] [/t .h .c] [/f .\src .\include]
	echo		/i: install TAG files with /t and /f option, direct return if TAG files exists
	echo		/u: update TAG files as /t and /f option same as the previously used options
	echo		/r: reinstall TAG files with new /t and /f option
	echo		/c: clean TAG files
	echo		/h: display this help and exit
	echo		/t: file type for /i or /r option, if not specified use default ".h .c .cpp"
	echo		/f: file path for /i or /r option, if not specified use default ".\"
	echo.
	echo	list-language-types:
	echo		Ant      *.build.xml
	echo		Asm      *.asm *.ASM *.s *.S *.A51 *.29[kK] *.[68][68][kKsSxX] *.[xX][68][68]
	echo		Asp      *.asp *.asa
	echo		Awk      *.awk *.gawk *.mawk
	echo		Basic    *.bas *.bi *.bb *.pb
	echo		BETA     *.bet
	echo		C        *.c
	echo		C++      *.c++ *.cc *.cp *.cpp *.cxx *.h *.h++ *.hh *.hp *.hpp *.hxx *.C *.H
	echo		C#       *.cs
	echo		Cobol    *.cbl *.cob *.CBL *.COB
	echo		DosBatch *.bat *.cmd
	echo		Eiffel   *.e
	echo		Erlang   *.erl *.ERL *.hrl *.HRL
	echo		Flex     *.as *.mxml
	echo		Fortran  *.f *.for *.ftn *.f77 *.f90 *.f95 *.F *.FOR *.FTN *.F77 *.F90 *.F95
	echo		Go       *.go
	echo		HTML     *.htm *.html
	echo		Java     *.java
	echo		JavaScript *.js
	echo		Lisp     *.cl *.clisp *.el *.l *.lisp *.lsp
	echo		Lua      *.lua
	echo		Make     *.mak *.mk [Mm]akefile GNUmakefile
	echo		MatLab   *.m
	echo		ObjectiveC *.m *.h
	echo		OCaml    *.ml *.mli
	echo		Pascal   *.p *.pas
	echo		Perl     *.pl *.pm *.plx *.perl
	echo		PHP      *.php *.php3 *.phtml
	echo		Python   *.py *.pyx *.pxd *.pxi *.scons
	echo		REXX     *.cmd *.rexx *.rx
	echo		Ruby     *.rb *.ruby
	echo		Scheme   *.SCM *.SM *.sch *.scheme *.scm *.sm
	echo		Sh       *.sh *.SH *.bsh *.bash *.ksh *.zsh
	echo		SLang    *.sl
	echo		SML      *.sml *.sig
	echo		SQL      *.sql
	echo		Tcl      *.tcl *.tk *.wish *.itcl
	echo		Tex      *.tex
	echo		Vera     *.vr *.vri *.vrh
	echo		Verilog  *.v
	echo		VHDL     *.vhdl *.vhd
	echo		Vim      *.vim
	echo		YACC     *.y
	echo.

:exit
