nnoremap <Leader>d :call DeleteCamelCaseWord()<CR>
function! DeleteCamelCaseWord()
	:let char = getline('.')[col('.')-1]
    :let [row, col] = searchpos('\<\|\u', 'Wn')

    :let pos = getpos('.')
    :let chars = (col-pos[2])

    :execute "normal " . chars . "x"
	if matchstr(char, '[a-z]') >= 0
		:execute "normal ~"
	endif
endfunction

