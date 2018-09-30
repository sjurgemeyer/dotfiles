" vim: ts=4 sw=4 et

function! neomake#makers#gradleCheck#gradleCheck() abort
    let g:gradleBin = filereadable('./gradlew') ? './gradlew' : 'gradle'

    return {
        \ 'exe': g:gradleBin,
        \ 'append_file': 0,
        \ 'args': ['check', '--daemon'],
        \ 'mapexpr': s:GetFullFilePaths(),
        \ 'errorformat': '\%+ATask\ %.%#\ not\ found\ %.%#.,'.
        \'%EExecution\ failed\ for\ task\ %m,'.
        \'%E%m\ FAILED,'.
        \'findbugs:\ %tarning\ %f:%l:%c\ %m,'.
        \'pmd:\ %tarning\ %f:%l:%c\ %m,'.
        \'checkstyle:\ %tarning\ %f:%l:%c\ %m,'.
        \'lint:\ %tarning\ %f:%l:%c\ %m,'.
        \'%A>\ %f:%l:%c:\ %trror:\ %m,'.
        \'%A>\ %f:%l:%c:\ %tarning:\ %m,'.
        \'%A%f:%l:\ %trror:\ %m,'.
        \'%A%f:%l:\ %tarning:\ %m,'.
        \'%A%f:%l:\ %trror\ -\ %m,'.
        \'%A%f:%l:\ %tarning\ -\ %m,'.
        \'%E%f:%l\ :\ %m,'.
        \'%E%f:\ %l:\ %m,'.
        \'%E%m %f:%l,'.
        \'%C>\ %m,'.
        \'%-G%p^,'.
        \'%+G\ \ %.%#,'.
        \'%-G%.%#'
        \ }
endfunction

function! s:GetFullFilePaths() abort
    return 'GetFullFilePath(v:val)'
endfunction

function! GetFullFilePath(line) abort
    let searchString = matchstr(a:line, '[a-zA-Z]\+.groovy\|[a-zA-Z]\+.java|[a-zA-Z]\+.kt')
    if (searchString != "")
        let paths = split(globpath('.', '**/' . searchString), '\n')
        if len(paths) == 1
            return substitute(a:line, searchString, paths[0], '')
        endif
    endif
    return a:line
endfunction
let g:neomake_java_gradleCheck_maker = neomake#makers#gradleCheck#gradleCheck()
let g:neomake_groovy_gradleCheck_maker = neomake#makers#gradleCheck#gradleCheck()
