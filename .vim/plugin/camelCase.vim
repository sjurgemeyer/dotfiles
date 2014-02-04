nnoremap <Leader>d :call DeleteCamelCaseWord()<CR>
nnoremap <Leader>s ~hi
function! DeleteCamelCaseWord()
    :let [row, col] = searchpos('\<\|\u', 'Wn')

    :let pos = getpos('.')
    :let chars = (col-pos[2])    

    :execute "normal " . chars . "x~"
endfunction

