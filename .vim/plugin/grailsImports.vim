function! InsertImport()
    :let original_pos = getpos('.')
    let classToFind = expand("<cword>")
    let paths = globpath('.', '**/' . classToFind . '.groovy')
    let multiplePaths = split(paths, '\n')
    let filePathList = []
    for p in multiplePaths
        :call add(filePathList, split(p, '/'))
    endfor
    let idx = 0
    
    let pathList = []
    let currentpackage = GetCurrentPackage()
    "Looking up class in text file
    if filePathList == []
       for line in s:loaded_data
           let tempClassList = split(line, '\.')
           if len(tempClassList) && tempClassList[-1] == classToFind
               " :call add(tempClassList, 'groovy') " Little bit of a hack to make the paths the same length
               :call add(pathList, line)
           endif
       endfor
    "Found file in current path, so determine package by path
    else 
        for f in filePathList
            let trimmedPath = ConvertPathToPackage(f)
            let importPackage = RemoveFileFromPackage(trimmedPath)
            if importPackage != '' 
                if  importPackage != currentpackage
                    :let starredImport = search(importPackage . "\\.\\*", 'nw')
                    if starredImport > 0
                        echom importPackage . '.* exists'
                        return
                    else
                        :let existingImport = search(trimmedPath, 'nw')
                        if existingImport > 0
                            echom 'import already exists'
                            return
                        else
                            :call add(pathList, trimmedPath)
                        endif
                    endif
                else 
                    echom "File is in the same package"
                    return
                endif
            endif
        endfor
    endif
    if pathList == []
        echoerr "no file found"
    else
        for pa in pathList
            let import = 'import ' . pa
            :let pos = getpos('.')
            :execute "normal ggo"
            :execute "normal I" . import . "\<Esc>"
            :execute "normal " . (pos[1] + 1) . "G"
        endfor
        :call RemoveUnneededImports()
        :call OrganizeImports() 
        if len(pathList) > 1
            echom "Warning: Multiple imports created!"
        endif
    endif

    call setpos('.', original_pos)
endfunction

function! GetCurrentPackage()
    return ConvertPathToPackage(split(expand("%:r"),'/'))
endfunction

function! RemoveFileFromPackage(fullpath)
    return join(split(a:fullpath,'\.')[0:-2],'.')
endfunction

function! ConvertPathToPackage(filePath)
    let seperators = ['domain', 'services', 'groovy', 'taglib', 'controllers', 'integration', 'unit']

    let f = a:filePath
    let idx = len(f)
    for sep in seperators
        let tempIdx = index(f, sep) 
        if tempIdx > 0
            if tempIdx < idx
                let idx = tempIdx + 1
            endif
        endif
    endfor
    let trimmedPath = f[idx :-1]

    return join(split(join(trimmedPath, '.'),'\.')[0:-2], '.')
endfunction

command! InsertImport :call InsertImport() 
map <D-i> :InsertImport <CR>

function! OrganizeImports()
    :let pos = getpos('.')

    :let start = search("^import")
    :let end = search("^import", 'b')
    :let lines = getline(start, end)

    :execute "normal " . start . "G"
    if end == start
        :execute 'normal "_dd'
    else
        :execute 'normal "_d' . (end-start) . "j"
    endif
     
    :let currentprefix = ''
    :let currentline = ''

    for line in lines
        let pathList = split(line, '\.')
        
        if len(pathList) > 1
            let newprefix = pathList[0]
            if currentline == line
            else
                :let currentline = line
                if currentprefix == newprefix
                else
                    let currentprefix = newprefix
                    :execute "normal I \<CR>"
                endif
                :execute "normal I" . line . "\<CR>" 
            endif
        endif
    endfor
    call setpos('.', pos)
endfunction

command! OrganizeImports :call OrganizeImports()

function! CountOccurances(searchstring)
    let co = [] 
    :execute "normal gg"
	while search(a:searchstring, "W") > 0
        :call add(co, 'a') 
    endwhile
    return len(co)
endfunction

function! RemoveUnneededImports()
    :let start = search("^import")
    :let end = search("^import", 'b')
    :let lines = sort(getline(start, end))
    :let updatedLines = []

    :execute "normal " . start . "G"
    if end == start
        :execute 'normal "_dd'
    else
        :execute 'normal "_d' . (end-start) . "j"
    endif
        
    for line in lines
        let trimmedLine = substitute(line, '^\s*\(.\{-}\)\s*$', '\1', '')  
        if len(trimmedLine) > 0
            let classname = split(line, '\.')[-1]
            " echoerr classname . " " . CountOccurances(classname)
            if classname == "*" || CountOccurances(classname) > 0
                :call add(updatedLines, substitute(line, '^\(\s\*\)','',''))
            endif
        endif
    endfor
    :execute "normal " . start . "G0"
    for line in updatedLines 
        :execute "normal I" . line . "\<CR>" 
    endfor
endfunction

let s:data_file = $HOME . '/.vim/plugin/groovyImports.csv'
let s:loaded_data = []
function! LoadImports()
    if filereadable(s:data_file)
      for line in readfile(s:data_file)
        :call add(s:loaded_data, line) 
      endfor
    endif
    if !len(s:loaded_data)
      echo 'Error: Could not read highlight data from '.s:data_file
    endif
endfunction
command! LoadImports :call LoadImports()
:call LoadImports()
