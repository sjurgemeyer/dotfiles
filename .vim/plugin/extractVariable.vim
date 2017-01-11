"Script for extracting visually selected text into a varable declaration
"(for Groovy)
function! ExtractVariable(foo)
   let [lnum1, col1] = getpos("'<")[1:2]
   normal! gv"hd
   execute "normal hi" . a:foo
   normal! ko
   execute "normal Idef " . a:foo . " = " . @h
endfun
command! -range=% -nargs=+ ExtractVariable call ExtractVariable(<q-args>)
