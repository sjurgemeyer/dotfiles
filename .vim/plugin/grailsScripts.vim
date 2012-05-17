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

function! TestResults()
    silent execute ":!open target/test-reports/html/index.html" 
endfunction

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

command! TestResults :call TestResults()

function! RunSingleGrailsTest()
    let testName = expand("%:t:r.") . "." . expand("<cword>")
    :call RunGrailsTest(testName)
endfunction

function! RunGrailsTestFile()
    let testName = expand("%:t:r")
    :call RunGrailsTest(testName)
endfunction

function! RunGrailsTest(testName)
    let path = expand("%:r")
    if path =~ "integration"
        let flag = "integration:"
    else
        let flag = "unit:"
    endif
    ":call RunInTerminal ("grails -classpath /Users/sjurgemeyer/projects/groovy-debugger/build/libs/gdb.jar -Dprintln.test.logs=true test-app " . flag . " " . a:testName) 
    :call RunInTerminal ("grails -Dprintln.test.logs=true test-app " . flag . " " . a:testName) 
    ":call RunInVim ("grails -Dprintln.test.logs=true test-app " . flag . " " . a:testName) 
endfunction

"Function to run command in external terminal"
function! RunInTerminal(command)
  if exists("a:command")
    let g:last_run_in_terminal = a:command
"    silent execute ":up"
    silent execute g:run_script . " '" . a:command . "' " . g:vim_terminal . " &"
"    silent execute ":redraw!"
  else
    echo "Couldn't figure out how to run " . a:file 
  end
endfunction

function! RunLastCommandInTerminal()
    if exists("g:last_run_in_terminal")
        silent execute g:run_script . " '" . g:last_run_in_terminal. "' " . g:vim_terminal . " &"
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
map <D-i> :call OpenFileUnderCursor(expand("<cword>"))<CR>
map <Leader>h :call FindSubClasses(expand("<cword>"))<CR>

function! FindSubClasses(filename) 
    execute ":Grep \\(implements\\|extends\\) " . a:filename
endfunction

function! OpenFileUnderCursor(filename)
   let ext = fnamemodify(expand("%:p"), ":t:e")
   execute ":find " . a:filename . "." . ext 
endfunction



