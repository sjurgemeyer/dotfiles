"Script for extracting visually selected text into a varable declaration 
"(for Groovy)
function! ExtractVariable(foo)
   let [lnum1, col1] = getpos("'<")[1:2]
   normal! gv"hd
   let temp = a:foo
   let @i = temp
   normal! h"ip
   normal! ko
   :execute "normal I def " . a:foo . " = " . @h
   echom a:foo
endfun
command! -range=% -nargs=+ ExtractVariable call ExtractVariable(<q-args>)
vnoremap <C-E> :ExtractVariable<space>
