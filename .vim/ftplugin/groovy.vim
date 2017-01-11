
function! Groovy_eval_vsplit() range
    :call Eval_vsplit('groovy', a:firstline, a:lastline)
endfunction

map <buffer> <Leader>h :call FindSubClasses(expand("<cword>"))<CR>
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
vmap <buffer> <silent> <F7> :call Groovy_eval_vsplit()<CR>
nmap <buffer> <silent> <F7> mzggVG<F7>`z
imap <buffer> <silent> <F7> <Esc><F7>a
map <buffer> <silent> <S-F7> :wincmd P<CR>:q<CR>
imap <buffer> <silent> <S-F7> <Esc><S-F7>a
vnoremap <buffer> <C-E> :ExtractVariable<space>




function! FindSubClasses(filename)
    execute ":GGrep \"(implements|extends) " . a:filename . "\""
endfunction

