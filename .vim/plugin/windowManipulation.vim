"switch windows
map <D-l> <Esc><C-w><C-w>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"Resize windows
map <C-S-Left> 8<C-w>>
map <C-S-Up> 4<C-w>+
map <C-S-Down> 4<C-w>-
map <C-S-Right> 8<C-w><

" Full screen
map <D-CR> <C-w>o

" open vertical window and switch to it
nnoremap <D-d> <C-w>v<C-w>l
" open horizontal window and switch to it
nnoremap <D-D> <C-w>s<C-w>j

"Close all navigation windows
map <F12> :call CloseNavigation()<CR>
function! CloseNavigation()
    :BuffergatorClose
    :NERDTreeClose
    :TagbarClose
	:UndotreeHide
    :ccl
	:call WipeMatchingBuffers('.*gitv-.*')
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
        "echo 'No buffers found matching pattern ' . a:pattern
        return
    endif

    if l:count == 1
        let l:suffix = ''
    else
        let l:suffix = 's'
    endif

    exec 'bd ' . join(l:matchList, ' ')

    "echo 'Wiped ' . l:count . ' buffer' . l:suffix . '.'
endfunction
