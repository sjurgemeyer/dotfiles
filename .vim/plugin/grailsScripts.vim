"let g:vim_terminal="/dev/ttys000"
"let g:run_script = "!osascript ~/.vim/tools/run_command.applescript" 

" Pulled from http://naleid.com/blog/2011/04/25/replace-grails-console-with-the-editor-of-your-choice/
function! s:copy_groovy_buffer_to_temp(first, last)
  " groovy/java scripts can't start with a # and tempname's normally do
  let src = substitute(tempname(), "[^\/]*$", "vim_&.groovy", "") 
 
  " put current buffer's content in a temp file
  silent exe ": " . a:first . "," . a:last . "w " . src
 
  return src
endfunction
 
function! s:select_new_temp_buffer()
  let temp_file = tempname()
 
  " open the preview window to the temp file
  silent exe ":pedit! " . temp_file
 
  " select the temp buffer as active 
  wincmd P
 
  " set options for temp buffer
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal syntax=none
  setlocal bufhidden=delete
 
  return temp_file
endfunction
"End text copied from naleid.com

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
map <Leader>vv :call GrailsSearch(expand("<cword>"))<CR>
"map <Leader>vc :call GrailsSearchNoTests(expand("<cword>"))<CR>
"map <Leader>vt :call GrailsSearchOnlyTests(expand("<cword>"))<CR>

function! Groovy_eval_vsplit() range
  let temp_source = s:copy_groovy_buffer_to_temp(a:firstline, a:lastline)
  let temp_file = s:select_new_temp_buffer()
 
  " replace current buffer with groovy's output
  silent execute ":%! groovy " . temp_source . " 2>&1 "
 
  wincmd p " change back to the source buffer
endfunction
 
au BufNewFile,BufRead *.groovy vmap <silent> <F7> :call Groovy_eval_vsplit()<CR>
au BufNewFile,BufRead *.groovy nmap <silent> <F7> mzggVG<F7>`z
au BufNewFile,BufRead *.groovy imap <silent> <F7> <Esc><F7>a
au BufNewFile,BufRead *.groovy map <silent> <S-F7> :wincmd P<CR>:q<CR>
au BufNewFile,BufRead *.groovy imap <silent> <S-F7> <Esc><S-F7>a
 
 
" set these up as environment variables on your system, or override
" per session by using ':let g:grails_user = foo'
let g:grails_user = $DEFAULT_GRAILS_USER
let g:grails_password = $DEFAULT_GRAILS_PASSWORD
let g:grails_base_url = $DEFAULT_GRAILS_BASE_URL
 
function! Grails_eval_vsplit() range
  let temp_source = s:copy_groovy_buffer_to_temp(a:firstline, a:lastline)
  let temp_file = s:select_new_temp_buffer()
 
  " replace current buffer with grails' output
  silent execute ":%! postCode.groovy -u " . g:grails_user . " -p " . g:grails_password . " -b " . g:grails_base_url . " " . temp_source . " 2>&1 "
 
  wincmd p " change back to the source buffer
endfunction
 
au BufNewFile,BufRead *.groovy vmap <F8> :call Grails_eval_vsplit()<CR>
au BufNewFile,BufRead *.groovy nmap <silent> <F8> mzggVG<F8>`z
au BufNewFile,BufRead *.groovy imap <silent> <F8> <Esc><F8>a
au BufNewFile,BufRead *.groovy map <silent> <S-F8> :wincmd P<CR>:q<CR>
au BufNewFile,BufRead *.groovy imap <silent> <S-F8> <Esc><S-F8>a


"Grails testing
map <S-F9> <Esc>:w<CR>:call RunSingleGrailsTest()<CR>
map <F9> <Esc>:w<CR>:call RunGrailsTestFile()<CR>
map <D-F9> :call RunLastCommandInTerminal()<CR>
map <F9> <Esc>:w<CR>:call RunGrailsTestFile()<CR>
map <F10> <Esc>:w<CR>:call RunGradleTestFile()<CR>

command! TestResults :call TestResults()

function! CompileGrails()
    let fileName = expand("%:t:r")
    silent execute 'cd ' . FindGrailsRoot()
    :compiler grails
    :call RunInTerminal ("grails compile") 
    silent execute 'cd -'
endfunction

function! RunSingleGrailsTest()
    let testName = expand("%:t:r.") . "." . expand("<cword>")
    :call RunGrailsTest(testName)
endfunction

function! RunGrailsTestFile()
    let testName = expand("%:t:r")
    :call RunGrailsTest(testName)
endfunction

function! CompileGradle()
    let fileName = expand("%:t:r")
    silent execute 'cd ' . FindGradleRoot()
    :compiler gradle
    :call RunInTerminal ("gradle assemble") 
    silent execute 'cd -'
endfunction

function! RunGradleTestFile()
    let testName = expand("%:t:r")
    silent execute 'cd ' . FindGradleRoot()
    :compiler gradle
    :call RunInTerminal ("gradle -Dtest.single=" . testName . " test | ~/.vim/tools/filter.groovy") 
    silent execute 'cd -'
endfunction

function! FindGrailsRoot() 
    let fileLocation = findfile("application.properties", expand("%:p:h") . ';/')
    return fnamemodify(fileLocation, ":p:h")
endfunction

function! FindGradleRoot() 
    let fileLocation = findfile("build.gradle", expand("%:p:h") . ';/')
    return fnamemodify(fileLocation, ":p:h")
endfunction

function! RunGrailsTest(testName)
    let path = expand("%:r")
    if path =~ "Spec"
        if path =~ "integration"
            let flag = "integration:spock"
        else
            let flag = "unit:spock"
        endif
    else 
        if path =~ "Test"
            if path =~ "integration"
                let flag = "integration:integration"
            else
                let flag = "unit:unit"
            endif
        else 
            echoerr "The current file is not a test"
            return
        endif
    endif
    silent execute 'cd ' . FindGrailsRoot()
    :compiler grails
    :call RunInTerminal ("grails -Duser.timezone=UTC test-app " . flag . " " . a:testName . ' | ~/.vim/tools/filter.groovy') 
    silent execute 'cd -'
endfunction

"Function to run command in external terminal"
function! RunInTerminal(command)
  if exists("a:command")
    let g:last_run_in_terminal = a:command
    :execute "Dispatch " . a:command
  end
endfunction

function! RunLastCommandInTerminal()
    if exists("g:last_run_in_terminal")
        RunInTerminal(g:last_run_in_terminal)
    else
        echo "No last command to execute!"
    endif
endfunction

"Switch between test class and actual class
map <Leader>x :call OpenTest()<CR>
function! OpenTest() 
   let ext = fnamemodify(expand("%:p"), ":t:e")
   let file = expand("%:t:r")
   let is_test = strridx(file, "Tests")
   if is_test > 0
       let file = strpart(file, 0, is_test) 
       execute ":find " . file . "." . ext
   else
       execute ":find " . file . "Tests." . ext
   endif
endfunction

"Open file under cursor
map <D-y> :call OpenFileUnderCursor(expand("<cword>"))<CR>
map <D-u> :call SplitOpenFileUnderCursor(expand("<cword>"))<CR>
map <Leader>h :call FindSubClasses(expand("<cword>"))<CR>

function! FindSubClasses(filename) 
    execute ":Grep \\(implements\\|extends\\) " . a:filename
endfunction

function! OpenFileUnderCursor(filename)
   let ext = fnamemodify(expand("%:p"), ":t:e")
   let fname = toupper(strpart(a:filename, 0, 1)) . strpart(a:filename, 1, strlen(a:filename))
   execute ":find " . fname . "." . ext 
endfunction

function! SplitOpenFileUnderCursor(filename)
   let ext = fnamemodify(expand("%:p"), ":t:e")
   let fname = toupper(strpart(a:filename, 0, 1)) . strpart(a:filename, 1, strlen(a:filename))
   execute ":rightb vert sfind " . fname . "." . ext 
endfunction



