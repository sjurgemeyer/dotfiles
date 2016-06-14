"http://vim.wikia.com/wiki/Switching_case_of_characters
"Toggle case (UPPER, lower, Mixed) for visual selection
function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction

vnoremap ~ ygv"=TwiddleCase(@")<CR>Pgv
nnoremap <leader>~ ygv"=TwiddleCase(<cword>)<CR>
