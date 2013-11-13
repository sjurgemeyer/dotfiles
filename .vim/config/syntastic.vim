"Syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_mode_map = { 'mode': 'passive',
                               \ 'active_filetypes': ['javascript', 'html'],
                               \ 'passive_filetypes': ['groovy'] }
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-", "invalid value \"{{"]

map <Leader>c :SyntasticCheck<CR>

