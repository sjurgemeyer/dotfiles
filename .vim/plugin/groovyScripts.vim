function! Groovy_eval_vsplit() range
    :call Eval_vsplit('groovy', a:firstline, a:lastline)
endfunction

"Grails testing
" Mostly keeping this around for reference in case I feel like doing something
" similar in teh future
"function! TestResults()
    "silent execute ":!open target/test-reports/html/index.html"
"endfunction
"command! TestResults :call TestResults()

"function! CompileGrails()
    "let fileName = expand("%:t:r")
    "let g:working_dir = getcwd()
    "silent execute 'cd ' . FindGrailsRoot()
    ":compiler grails
    ":call RunInTerminal ("grails compile")
    "silent execute 'cd ' . g:working_dir
"endfunction

"function! CompileGradle()
    "let fileName = expand("%:t:r")
    "let g:working_dir = getcwd()
    "silent execute 'cd ' . FindGradleRoot()
    ":compiler gradle
    ":call RunInTerminal ("gradle assemble")
    "silent execute 'cd ' . g:working_dir
"endfunction

"function! RunGradleTestFile()
    "let testName = expand("%:t:r")
    "let g:working_dir = getcwd()
    "silent execute 'cd ' . FindGradleRoot()
    ":compiler gradle
    ":call RunInTerminal ("gradle -Dtest.single=" . testName . " test | ~/.vim/tools/filter.groovy")
    "silent execute 'cd ' . g:working_dir
"endfunction

"function! FindGrailsRoot()
    "let fileLocation = findfile("application.properties", expand("%:p:h") . ';/')
    "return fnamemodify(fileLocation, ":p:h")
"endfunction

""Function to run command in external terminal"
"function! RunInTerminal(command)
    "if exists("a:command")
        "let g:last_run_in_terminal = a:command
        "let g:last_command_dir = getcwd()
        ":execute "Dispatch " . a:command
    "end
"endfunction

"function! RunLastCommandInTerminal()
    "if exists("g:last_run_in_terminal")
        "let g:working_dir = getcwd()
        "silent execute 'cd ' . g:last_command_dir
        ":call RunInTerminal(g:last_run_in_terminal)
        "silent execute 'cd ' . g:working_dir
    "else
        "echo "No last command to execute!"
    "endif
"endfunction

function! CreateGroovyMappings()
	map <Leader>h :call FindSubClasses(expand("<cword>"))<CR>
    "map <Leader>x :call OpenTest()<CR>
    "map <Leader>vv :call GrailsSearch(expand("<cword>"))<CR>
    "map <Leader>vc :call GrailsSearchNoTests(expand("<cword>"))<CR>
    "map <Leader>vt :call GrailsSearchOnlyTests(expand("<cword>"))<CR>

    "Testing
    "map <S-F9> <Esc>:w<CR>:call RunSingleGrailsTest()<CR>
    "map <F9> <Esc>:w<CR>:call RunGrailsTestFile()<CR>
    "map <F11> :call RunLastCommandInTerminal()<CR>
    "map <F9> <Esc>:w<CR>:call RunGrailsTestFile()<CR>
    "map <F10> <Esc>:w<CR>:call RunGradleTestFile()<CR>

    "running arbitrary groovy
    vmap <silent> <F7> :call Groovy_eval_vsplit()<CR>
    nmap <silent> <F7> mzggVG<F7>`z
    imap <silent> <F7> <Esc><F7>a
    map <silent> <S-F7> :wincmd P<CR>:q<CR>
    imap <silent> <S-F7> <Esc><S-F7>a


endfunction

au BufNewFile,BufRead *.groovy :call CreateGroovyMappings()

function! FindSubClasses(filename)
    execute ":GGrep \"(implements|extends) " . a:filename . "\""
endfunction

