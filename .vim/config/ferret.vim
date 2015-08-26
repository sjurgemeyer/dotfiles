nmap <leader>z <Plug>(FerretAckWord)

command! -nargs=+ -complete=file Ag call Ag(<q-args>)
 
function! Ag(args)
	let testArgs = ' -t ' . a:args
	call ferret#private#ack(testArgs)
endfunction
