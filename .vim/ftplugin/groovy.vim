function! Groovy_eval_vsplit() range
    :call Eval_vsplit('groovy', a:firstline, a:lastline)
endfunction

map <buffer> <Leader>h :call FindSubClasses(expand("<cword>"))<CR>

"running arbitrary groovy
vmap <buffer> <silent> <F7> :call Groovy_eval_vsplit()<CR>
nmap <buffer> <silent> <F7> mzggVG<F7>`z
imap <buffer> <silent> <F7> <Esc><F7>a
map <buffer> <silent> <S-F7> :wincmd P<CR>:q<CR>
imap <buffer> <silent> <S-F7> <Esc><S-F7>a
vnoremap <buffer> <C-E> :ExtractVariable<space>
set iskeyword=@,48-57,_,192-255,#,-

function! FindSubClasses(filename)
    execute ":GGrep \"(implements|extends) " . a:filename . "\""
endfunction

