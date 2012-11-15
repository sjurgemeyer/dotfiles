"SOURCE NEEDED: This might have been pulled from the vim tips wiki or something similar.
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


