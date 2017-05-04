nmap <leader>z <Plug>(FerretAckWord)

command! -nargs=+ -complete=file Ag call Ag(<q-args>)

function! Ag(args)
	execute ":Ack -U " . a:args
endfunction
