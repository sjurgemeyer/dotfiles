" Move items from the active dir to the reference dir
call NERDTreeAddMenuItem({
			\ 'text':     '(2) Move to reference',
			\ 'shortcut': '2',
			\ 'callback': 'MoveToReference'
			\ })

function! MoveToReference()
	let current_file = g:NERDTreeFileNode.GetSelected()

	if current_file == {}
		return
	else
		let oldDir = current_file.path.str()
		let newDir = substitute(oldDir, "active", "reference", "")
		silent execute("!mv " . oldDir . " " . newDir)
		silent execute "normal R"
	endif
endfunction

" Move items from the reference dir to the active dir
call NERDTreeAddMenuItem({
			\ 'text':     '(1) Move to active',
			\ 'shortcut': '1',
			\ 'callback': 'MoveToActive'
			\ })

function! MoveToActive()
	let current_file = g:NERDTreeFileNode.GetSelected()

	if current_file == {}
		return
	else
		let oldDir = current_file.path.str()
		let newDir = substitute(oldDir, "reference", "active", "")
		silent execute("!mv " . oldDir . " " . newDir)
		silent execute "normal R"
	endif
endfunction

" Change the dir and cd at the same time
call NERDTreeAddKeyMap({
			\ 'key': 'c',
			\ 'scope': 'all',
			\ 'callback': 'ChangeDir',
			\ 'quickhelpText': 'change dir and cd' })


function! ChangeDir()
	silent execute 'normal C'
	silent execute 'normal cd'
endfunction
