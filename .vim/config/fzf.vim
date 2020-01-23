nnoremap <C-p> :Files<Cr>
nnoremap <Leader>m :History<Cr>
nnoremap <Leader>b :Buffers<CR>

nnoremap <leader>j :call fzf#vim#tags(expand('<cword>'), {'options': '--exact --select-1 --exit-0'})<CR>
nnoremap <leader>k :BTags<CR>
