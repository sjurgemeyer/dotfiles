function! CreateJavascriptMappings()
    map <F9> :call RunGruntTests()<CR>
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
