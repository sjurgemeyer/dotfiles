
function! GetUrl(remote)

    let remote = 'origin'
    if a:remote != ''
        remote = a:remote
    endif

    let fileLines = readfile('.git/config') " arbitrary limit on number of lines to read
    let line = match(fileLines, "^package")
    if line == -1
        return ''
    endif
    return fileLines[line]
endfunction
