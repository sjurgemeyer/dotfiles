"Syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_mode_map = { 'mode': 'passive',
                               \ 'passive_filetypes': ['groovy'] }
                               "\ 'active_filetypes': ['javascript', 'html', 'css'],

let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-", "invalid value \"{{"]

let g:syntastic_groovy_checkers = ['codenarc']

map <Leader>c :SyntasticCheck<CR>

let g:syntastic_always_populate_loc_list=1
