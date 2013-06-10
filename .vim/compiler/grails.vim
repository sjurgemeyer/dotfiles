  
	":if exists("current_compiler")
	":  finish
	":endif
:let current_compiler = "grails"

if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif
CompilerSet errorformat&		" use the default 'errorformat'
CompilerSet makeprg=grails 
