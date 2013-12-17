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
    :ccl
endfunction


