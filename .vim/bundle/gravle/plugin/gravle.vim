
function! GradleRootDir()
    let root = expand('%:p')
    let previous = ""

    while root !=# previous

        let path = globpath(root, 'settings.gradle', 1)
        let multiplePaths = split(path, '\n')
        for p in multiplePaths
            let path = p
        endfor
        if path !=# ''
            return fnamemodify(path, ':h')
        endif
        let previous = root
        let root = fnamemodify(root, ':h')
    endwhile
    return ''
endfunction

function! GradleSubprojectName()
    let root = expand('%:p')
    let previous = ""

    while root !=# previous

        let path = globpath(root, '*.gradle', 1)
        let multiplePaths = split(path, '\n')
        for p in multiplePaths

            let filename = fnamemodify(path, ':t')
            if (filename != 'settings')
                let path = p
                break
            endif
        endfor
        if path !=# ''
            return fnamemodify(path, ':h:t:r')
        endif
        let previous = root
        let root = fnamemodify(root, ':h')
    endwhile
    return ''
endfunction


function! GetCurrentPackage()
    let packageDeclaration = GetPackageLineForCurrentFile()
    return GetPackageFromDeclaration(packageDeclaration)
endfunction


function GetPackageFromDeclaration(packageDeclaration)
    if a:packageDeclaration ==# ''
        return ''
    endif
    let package = split(a:packageDeclaration, '\s')[-1]
    let package = substitute(package, ';', '', '')

    return package
endfunction

function! GetPackageLineForCurrentFile()
    let line = GetPackageLineNumberForCurrentFile()
    if line == -1
        return ''
    endif
    return getline(line+1)
endfunction

function! GetPackageLineNumberForCurrentFile()
    " Can't use the other method because it reads from disk and the file may
    " be modified
    let lines = getline(1, 20)
    let val = match(lines, "^package")
    return val
endfunction
