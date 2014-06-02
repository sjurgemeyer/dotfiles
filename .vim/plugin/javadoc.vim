function! LookupJavadoc()
    let word = expand("<cword>")
    :execute "!open https://www.google.com/search?q=" . word . "+javadoc"
endfunction 
command! LookupJavadoc :call LookupJavadoc()
map <D-j> <Esc>:LookupJavadoc<CR>


