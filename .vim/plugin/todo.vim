function! SortByDate()
    :let sortString = 't:\d\d\d\d-\d\d-\d\d'
    :let matchString = 't:\d\d\d\d-\d\d-\d\d'
    :call TodoSort(sortString, matchString)
endfunction

function! SortByContext()
    :let sortString = '\@[^\s]+'
    :let matchString = '@[^ $]\+'
    :call TodoSort(sortString, matchString)
endfunction

function! SortByProject()
    :let sortString = '\+[^\s]+'
    :let matchString ='+[^ $]\+'
    :call TodoSort(sortString, matchString)
endfunction

"
function! TodoSort(sortString, matchString)
    :g/^$/d
    :execute "sort /\\v" . a:sortString . '/ r'

    :let start = search(a:matchString)
    :let end = search(a:matchString, 'b')
    :let lines = getline(start, end)
    :execute "normal " . start . "G"
    :execute 'normal "_d' . (end-start) . "j"
    :execute 'normal gg'

    :let lastSortField = ""
    :let firstline = 1
    for line in lines
        if line == ""
        else
            :let newSortField = matchstr(line,a:matchString)

            if lastSortField == newSortField || firstline == 1
            else 
                :execute "normal I\<CR>"
            endif
            :let lastSortField = newSortField
            :let firstline = 0
            :execute "normal I" . line . "\<CR>" 
        endif
    endfor
    :execute "normal I\<CR>"

endfunction

command! SortByDate :call SortByDate() 
command! SortByProject :call SortByProject() 
command! SortByContext :call SortByContext() 
