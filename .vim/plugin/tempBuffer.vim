" Pulled from http://naleid.com/blog/2011/04/25/replace-grails-console-with-the-editor-of-your-choice/
function! s:copy_buffer_to_temp(first, last)
  " groovy/java scripts can't start with a # and tempname's normally do
  let src = substitute(tempname(), "[^\/]*$", "vim_&", "") 
 
  " put current buffer's content in a temp file
  silent exe ": " . a:first . "," . a:last . "w " . src
 
  return src
endfunction

function! s:select_new_temp_buffer()
  let temp_file = tempname()
 
  " open the preview window to the temp file
  silent exe ":pedit! " . temp_file
 
  " select the temp buffer as active 
  wincmd P
 
  " set options for temp buffer
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal syntax=none
  setlocal bufhidden=delete
 
  return temp_file
endfunction

function! Eval_vsplit(command, first, last) 
  let temp_source = s:copy_buffer_to_temp(a:first, a:last)
  let temp_file = s:select_new_temp_buffer()
 
  " replace current buffer with groovy's output
  silent execute ":%! " . a:command . " " . temp_source . " 2>&1 "
 
  wincmd p " change back to the source buffer
endfunction
