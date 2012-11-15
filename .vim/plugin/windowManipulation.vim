"switch windows
map <D-l> <Esc><C-w><C-w>

"Resize windows
map <C-S-Left> 8<C-w>>
map <C-S-Up> 4<C-w>+
map <C-S-Down> 4<C-w>-
map <C-S-Right> 8<C-w><

" Full screen
map <D-CR> <C-w>o

" open vertical window and switch to it
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <D-d> <C-w>v<C-w>l
nnoremap <leader>s <C-w>s<C-w>j
nnoremap <D-D> <C-w>s<C-w>j

"Close all navigation windows
map <F13> :call CloseNavigation()<CR>
function! CloseNavigation()
    :BuffergatorClose
    :NERDTreeClose
    :ccl
endfunction


