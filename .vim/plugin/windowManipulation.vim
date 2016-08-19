"switch windows
map <D-l> <Esc><C-w><C-w>
" https://github.com/neovim/neovim/issues/2048
if has('nvim')
	nmap <BS> <C-W>h
endif
noremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"Resize windows
map <C-S-Left> 8<C-w>>
map <C-S-Up> 4<C-w>+
map <C-S-Down> 4<C-w>-
map <C-S-Right> 8<C-w><

"Close all navigation windows
map <F12> :call CloseNavigation()<CR>

function! CloseNavigation()
    :BuffergatorClose
    :NERDTreeClose
    :TagbarClose
	:UndotreeHide
    :ccl
	:lcl
	:call WipeMatchingBuffers('.*gitv-.*')
	:call WipeMatchingBuffers('.*__HTTP_Client_Response__.*')
endfunction

function! GetBufferList()
    return range(1,bufnr('$'))
endfunction

function! GetMatchingBuffers(pattern)
    return filter(GetBufferList(), 'bufname(v:val) =~ a:pattern')
endfunction

function! WipeMatchingBuffers(pattern)
    let l:matchList = GetMatchingBuffers(a:pattern)

    let l:count = len(l:matchList)
    if l:count < 1
        return
    endif

    if l:count == 1
        let l:suffix = ''
    else
        let l:suffix = 's'
    endif

    exec 'bd ' . join(l:matchList, ' ')

endfunction
