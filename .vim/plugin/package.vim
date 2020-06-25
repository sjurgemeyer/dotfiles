" Script for determining the java/groovy package from the current path.
" Mostly useful for snippets.
if !exists('g:package_seperators')
    let g:package_seperators = ['groovy', 'java', 'kotlin', 'domain', 'services', 'taglib', 'controllers', 'integration', 'unit']
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
