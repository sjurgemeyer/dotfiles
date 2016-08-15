
function! SyntaxCheckers_groovy_codenarc_GetLocList() dict
    let root = FindGradleRoot()
    if empty(root)
    else
        let initScript = "/Users/sjurgemeyer/.vim/data/initgradle.gradle"
		let codenarcOutput = root . '/build/reports/codenarc/main.txt'
		let makeprg = self.makeprgBuild({
					\'exe': 'cd ' . root . ';gradle -I ' . initScript . ' codenarcMain;sed "s@File: @File: ' . root . '/src/main/groovy/@g" ' . codenarcOutput,
					\'filetype': 'groovy',
					\'subchecker': 'codenarc'
					\ })

		let errorformat = '%P%.%#File:\ %f,%.%#Violation%.%#Line=%l%.%#Msg=[%m'
		"let errorformat = '%m'
		return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })

    endif
endfunction

function! SyntaxCheckers_groovy_gradlebuild_GetLocList() dict
    let root = FindGradleRoot()
    if empty(root)
    else
		let makeprg = self.makeprgBuild({
					\'exe': 'cd ' . root . ';gradle build;',
					\'filetype': 'groovy',
					\'subchecker': 'gradlebuild'
					\ })
		"groovy/smartthings/pusher/AppConfig.groovy: 28: unexpected token: zipkin @ line 28, column 24.
		let errorformat = '%f:\ %l:\ %m@\ line %.%#,\ column %c%.%#'
		"let errorformat = '%m'
		return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })

    endif
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'groovy',
    \ 'name': 'codenarc',
	\ 'exec': 'pwd'})

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'groovy',
    \ 'name': 'gradlebuild',
	\ 'exec': 'pwd'})


function! FindGradleRoot()
	let root = expand('%:p')
	let previous = ""

	while root !=# previous

		let path = globpath(root, '*.gradle', 1)
		if path == ''
		else
			return fnamemodify(path, ':h')
		endif
		let previous = root
		let root = fnamemodify(root, ':h')
	endwhile
	return ''
endfunction
