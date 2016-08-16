"Syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_mode_map = { 'mode': 'passive',
                               \ 'passive_filetypes': ['groovy','java'] }
                               "\ 'active_filetypes': ['javascript', 'html', 'css'],

let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-", "invalid value \"{{"]

let g:syntastic_groovy_checkers = ['gradlebuild', 'codenarc']
let g:syntastic_java_checkers = ['gradlebuild']

map <Leader>c :SyntasticCheck<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
