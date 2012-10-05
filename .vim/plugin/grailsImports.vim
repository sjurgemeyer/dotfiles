function! InsertImport()
    let classToFind = expand("<cword>")
    let paths = globpath('.', '**/' . classToFind . '.groovy')
    let multiplePaths = split(paths, '\n')
    let filePathList = []
    for p in multiplePaths
        :call add(filePathList, split(p, '/'))
    endfor
    let idx = 0
    
    let pathList = []
    "Looking up class in text file
    if filePathList == []
       for line in s:loaded_data
           let tempClassList = split(line, '\.')
           if len(tempClassList) && tempClassList[-1] == classToFind
               :call add(tempClassList, 'groovy') " Little bit of a hack to make the paths the same length
               :call add(pathList, tempClassList)
           endif
       endfor
    "Found file in current path, so determine package by path
    else 
        for f in filePathList
            let seperators = ['domain', 'services', 'groovy', 'taglib', 'controllers', 'integration', 'unit']

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
            :call add(pathList, trimmedPath)
        endfor
    endif
    if pathList == []
        echoerr "no file found"
    else
        for pa in pathList
            let import = 'import ' . join(split(join(pa, '.'),'\.')[0:-2], '.')
            :let pos = getpos('.')
            :execute "normal ggo"
            :execute "normal I" . import . "\<Esc>"
            :execute "normal " . (pos[1] + 1) . "G"
        endfor
        :call OrganizeImports() 
        if len(pathList) > 1
            echoerr "Warning: Multiple imports created!"
        endif
    endif

endfunction

command! InsertImport :call InsertImport() 
map <D-i> :InsertImport <CR>

function! OrganizeImports()
    :let pos = getpos('.')
    :let start = line('.')
    :let end = search("^import", 'b')
    :let lines = sort(getline(2, end))
    :execute "normal 2G"
    :execute "normal d" . (end-2) . "j"
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
    :execute "normal " . pos[1] . "G"

endfunction

command! OrganizeImports :call OrganizeImports()


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
