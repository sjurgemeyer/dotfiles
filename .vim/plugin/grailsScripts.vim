function! TestResults()
    silent execute ":!open target/test-reports/html/index.html"
endfunction

function! GrailsSearch(pattern)
    :execute "Ack --groovy " . a:pattern
endfunction

function! GrailsSearchNoTests(pattern)
    :execute "Ack --type=groovy -G '.*Tests\.groovy|.*Spec\.groovy' --invert-file-match " . a:pattern
endfunction

function! GrailsSearchOnlyTests(pattern)
    :execute "Ack --type=groovy -G '.*Tests\.groovy|.*Spec\.groovy' " . a:pattern
endfunction

command! -nargs=* GGrep :call GrailsSearch(<q-args>)

function! Groovy_eval_vsplit() range
    :call Eval_vsplit('groovy', a:firstline, a:lastline)
endfunction

"Grails testing

command! TestResults :call TestResults()

function! CompileGrails()
    let fileName = expand("%:t:r")
    let g:working_dir = getcwd()
    silent execute 'cd ' . FindGrailsRoot()
    :compiler grails
    :call RunInTerminal ("grails compile")
    silent execute 'cd ' . g:working_dir
endfunction

function! CompileGradle()
    let fileName = expand("%:t:r")
    let g:working_dir = getcwd()
    silent execute 'cd ' . FindGradleRoot()
    :compiler gradle
    :call RunInTerminal ("gradle assemble")
    silent execute 'cd ' . g:working_dir
endfunction

function! RunGradleTestFile()
    let testName = expand("%:t:r")
    let g:working_dir = getcwd()
    silent execute 'cd ' . FindGradleRoot()
    :compiler gradle
    :call RunInTerminal ("gradle -Dtest.single=" . testName . " test | ~/.vim/tools/filter.groovy")
    silent execute 'cd ' . g:working_dir
endfunction

function! FindGrailsRoot()
    let fileLocation = findfile("application.properties", expand("%:p:h") . ';/')
    return fnamemodify(fileLocation, ":p:h")
endfunction

function! FindTestDir()
    let file = expand("%:p:h")
    let testDir = substitute(file, "/main/", "/test/", "")
    while 1 == 1
        if (isdirectory(testDir))
            return testDir
        endif
        let testDir = substitute(testDir, "/[^/]*$", "", "")
    endwhile

endfunction

function! FindGradleRoot()
    " We have gradle files named different things so the best I could do was
    " search for a build dir and use the parent.  VIM's finddir doesn't allow
    " for wildcards.
    let fileLocation1 = finddir("build", expand("%:p:h") . ';/')
    let splitPath = split(fileLocation1, '/')
    let fileLocation = join(splitPath[0:-2], '/')
    return fnamemodify(fileLocation, ":p:h")
endfunction

"Function to run command in external terminal"
function! RunInTerminal(command)
    if exists("a:command")
        let g:last_run_in_terminal = a:command
        let g:last_command_dir = getcwd()
        :execute "Dispatch " . a:command
    end
endfunction

function! RunLastCommandInTerminal()
    if exists("g:last_run_in_terminal")
        let g:working_dir = getcwd()
        silent execute 'cd ' . g:last_command_dir
        :call RunInTerminal(g:last_run_in_terminal)
        silent execute 'cd ' . g:working_dir
    else
        echo "No last command to execute!"
    endif
endfunction

"Switch between test class and actual class
function! OpenTest()
    let ext = fnamemodify(expand("%:p"), ":t:e")
    let file = expand("%:t:r")
    let is_test = strridx(file, "Tests")
    if is_test < 0
        let is_test = strridx(file, "Spec")
    endif
    if is_test > 0
        let file = strpart(file, 0, is_test)
        execute ":find " . file . "." . ext
    else
        try
            execute ":find " . file . "Spec." . ext
        catch
            "Try for old grails style tests
            try
                execute ":find " . file . "Tests." . ext
            catch
                "Open the test dir (or closest existing dir) if no test exists
                let x = g:NERDTreePath.New(FindTestDir())
                if !nerdtree#isTreeOpen()
                    call g:NERDTreeCreator.TogglePrimary("")
                endif
                call nerdtree#putCursorInTreeWin()
                call b:NERDTreeRoot.reveal(x)
            endtry
        endtry
    endif
endfunction

function! CreateGroovyMappings()
    "map <Leader>h :call FindSubClasses(expand("<cword>"))<CR>
    map <Leader>x :call OpenTest()<CR>
    map <Leader>vv :call GrailsSearch(expand("<cword>"))<CR>
    map <Leader>vc :call GrailsSearchNoTests(expand("<cword>"))<CR>
    map <Leader>vt :call GrailsSearchOnlyTests(expand("<cword>"))<CR>

    "Testing
    map <S-F9> <Esc>:w<CR>:call RunSingleGrailsTest()<CR>
    map <F9> <Esc>:w<CR>:call RunGrailsTestFile()<CR>
    map <F11> :call RunLastCommandInTerminal()<CR>
    map <F9> <Esc>:w<CR>:call RunGrailsTestFile()<CR>
    map <F10> <Esc>:w<CR>:call RunGradleTestFile()<CR>

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

if !exists('g:package_seperators')
    let g:package_seperators = ['domain', 'services', 'groovy', 'java', 'taglib', 'controllers', 'integration', 'unit']
endif

function! GetCurrentPackageFromPath()
    return ConvertPathToPackage(expand("%:r"))
endfunction

function! ConvertPathToPackage(filePath)
    let splitPath = split(a:filePath, '/')

    let idx = len(splitPath)
    for sep in g:package_seperators
        let tempIdx = index(splitPath, sep)
        if tempIdx > 0
            if tempIdx < idx
                let idx = tempIdx + 1
            endif
        endif
    endfor
    let trimmedPath = splitPath[idx :-1]

    return join(split(join(trimmedPath, '.'),'\.')[0:-2], '.')
endfunction
