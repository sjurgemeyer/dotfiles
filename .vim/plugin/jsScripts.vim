function! CreateJavascriptMappings()
    map <F9> :call RunGruntTests()<CR>
    "running arbitrary javascript
    vmap <silent> <F7> :call Javascript_eval_vsplit()<CR>
    nmap <silent> <F7> mzggVG<F7>`z
    imap <silent> <F7> <Esc><F7>a
    map <silent> <S-F7> :wincmd P<CR>:q<CR>
    imap <silent> <S-F7> <Esc><S-F7>a

endfunction

function RunGruntTests()
    silent execute 'cd ' . FindGruntRoot()
    :call RunInTerminal('grunt dev-test')
    silent execute 'cd -'
endfunction

function! FindGruntRoot() 
    let fileLocation = findfile("Gruntfile.js", expand("%:p:h") . ';/')
    return fnamemodify(fileLocation, ":p:h")
endfunction

au BufNewFile,BufRead *.js :call CreateJavascriptMappings()

function! Javascript_eval_vsplit() range
    :call Eval_vsplit('node', a:firstline, a:lastline)
endfunction
