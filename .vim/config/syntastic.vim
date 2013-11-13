"Syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_mode_map = { 'mode': 'passive',
                               \ 'active_filetypes': ['javascript'],
                               \ 'passive_filetypes': ['groovy'] }
map <Leader>c :SyntasticCheck<CR>


