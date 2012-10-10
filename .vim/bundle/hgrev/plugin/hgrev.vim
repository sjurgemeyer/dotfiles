" vim: set noet nosta sw=4 ts=4 fdm=marker :
"
" HGRev
" Mahlon E. Smith <mahlon@martini.nu>
" $Id: hgrev.vim,v 595320486f69 2012/09/12 17:45:25 mahlon $
"
" Simplistic file revision checker, meant for adding current revision
" information to the statusbar, a la:
"
" 	set statusline=[r%{HGRev()}]
"

if exists( 'hgrev_loaded' )
	finish
endif
let hgrev_loaded = '$Rev: 595320486f69 $'

" }}}
" Defaults for misc settings {{{
"
if !exists( 'g:hgrevFlags' )
	let g:hgrevFlags = '-nbt'
endif

if !exists( 'g:hgrevAddStatus' )
	let g:hgrevAddStatus = 1
endif

if !exists( 'g:hgrevAutoUpdate' )
	let g:hgrevAutoUpdate = 0
endif

if !exists( 'g:hgrevNoRepoChar' )
	let g:hgrevNoRepoChar = '-'
endif



"}}}
" Commands {{{
"
command! RefreshMercurialRev :call <SID>RefreshMercurialRev()


" HGRev() {{{
" Return the current buffer rev id from the global dictionary.
"
function! HGRev()
	if exists( 'g:hg_revs' )
		let l:key = getcwd() . '/' . bufname('%')
		return has_key(g:hg_revs, l:key) ? g:hg_revs[l:key] : g:hgrevNoRepoChar
	else
		call <SID>RefreshMercurialRev()
		call HGRev()
	endif
endfunction


" }}}
" RefreshMercurialRev() {{{
"
" Locate the hgroot and fetch the current rev id, populating the global
" dictionary.
"
function! <SID>RefreshMercurialRev()
	if ! exists( 'g:hg_revs' )
		let g:hg_revs = {}
	endif

	" Find the closest HG root for the buffer. 'hg root' won't do it, since
	" it works off the cwd, and we need the nearest root from the filename.
	"

	" (we're unlikely to get lucky finding '.hg' in http:// or similar)
	"
	if matchstr(bufname('%'), "^[^:/]\\+://") != ''
		return
	endif

	let l:searchpaths = split( expand('%:p:h'), '/' )
	let l:dircount = len(l:searchpaths)
	let l:root = ''
	while l:dircount > 0
		let l:root = '/' . join( l:searchpaths[0 : l:dircount], '/' )
		if isdirectory( l:root . '/' . '.hg' )
			break
		endif
		let l:dircount = l:dircount - 1
	endwhile

	if l:dircount == -1
		return
	endif

	let l:key = getcwd() . '/' . bufname('%')

	" Find the rev for the repo containing the current file buffer.
	"
	let l:cmd     = 'hg id ' . g:hgrevFlags . ' ' . l:root
	let l:rev     = system( l:cmd )
	let l:hg_exit = v:shell_error

	if l:hg_exit == 0
		let l:rev = substitute( l:rev, '\n', '', 'g' )
		let g:hg_revs[ l:key ] = l:rev
	endif

	" Add file repo status.
	"
	if g:hgrevAddStatus == 1
		let l:cmd     = 'hg stat ' . bufname('%')
		let l:stat    = system( l:cmd )
		let l:hg_exit = v:shell_error

		if l:hg_exit == 0 && len(l:stat) > 0
			let l:stat = split( l:stat, '\s\+' )[0]
			let g:hg_revs[ l:key ] = g:hg_revs[ l:key ] . ' ' . l:stat
		endif
	endif

	return
endfunction
"}}}


" Refresh the rev for the current buffer on reads/writes.
"
if g:hgrevAutoUpdate == 1
	autocmd BufReadPost          * call <SID>RefreshMercurialRev()
	autocmd BufWritePost         * call <SID>RefreshMercurialRev()
	autocmd FileChangedShellPost * call <SID>RefreshMercurialRev()
endif

