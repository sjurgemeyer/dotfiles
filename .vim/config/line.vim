    "LineJump NERDTree key map
    augroup LineJumpNerdTree
        "I find nerdtree's f map to something not that useful!
        autocmd BufEnter NERD_tree_\d\+ nnoremap <buffer> <nowait> <silent> f <ESC>:silent! call LineJumpSelectForward()<cr>
        autocmd BufEnter NERD_tree_\d\+ nnoremap <buffer> <nowait> <silent> ; <ESC>:silent! call LineJumpMoveForward()<cr>
        autocmd BufEnter NERD_tree_\d\+ nnoremap <buffer> <nowait> <silent> b <ESC>:silent! call LineJumpSelectBackward()<cr>
        autocmd BufEnter NERD_tree_\d\+ nnoremap <buffer> <nowait> <silent> , <ESC>:silent! call LineJumpMoveBackward()<cr>

        autocmd BufEnter NERD_tree_\d\+ nnoremap <buffer> <nowait> <silent> gh <ESC>:silent! call LineJumpMoveTop()<cr>
        autocmd BufEnter NERD_tree_\d\+ nnoremap <buffer> <nowait> <silent> gm <ESC>:silent! call LineJumpMoveMiddle()<cr>
        autocmd BufEnter NERD_tree_\d\+ nnoremap <buffer> <nowait> <silent> gl <ESC>:silent! call LineJumpMoveBottom()<cr>
    augroup END

    "LineJump TagBar key map
    augroup LineJumpTagbar
        autocmd BufEnter __Tagbar__ nnoremap <buffer> <nowait> <silent> f <ESC>:silent! call LineJumpSelectForward()<cr>
        autocmd BufEnter __Tagbar__ nnoremap <buffer> <nowait> <silent> ; <ESC>:silent! call LineJumpMoveForward()<cr>
        autocmd BufEnter __Tagbar__ nnoremap <buffer> <nowait> <silent> b <ESC>:silent! call LineJumpSelectBackward()<cr>
        autocmd BufEnter __Tagbar__ nnoremap <buffer> <nowait> <silent> , <ESC>:silent! call LineJumpMoveBackward()<cr>

        autocmd BufEnter __Tagbar__ nnoremap <buffer> <nowait> <silent> gh <ESC>:silent! call LineJumpMoveTop()<cr>
        autocmd BufEnter __Tagbar__ nnoremap <buffer> <nowait> <silent> gm <ESC>:silent! call LineJumpMoveMiddle()<cr>
        autocmd BufEnter __Tagbar__ nnoremap <buffer> <nowait> <silent> gl <ESC>:silent! call LineJumpMoveBottom()<cr>
    augroup END
