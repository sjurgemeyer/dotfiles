"CtrlP
let g:ctrlp_working_path_mode = 0
"let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'rtscript']
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*\|.*/target/.*\|.*/build/.*|*.orig'
  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v(build|target)$',
    \ 'file': '\v\.(orig|)$',
    \ }
let g:ctrlp_max_files = 30000
let g:ctrlp_max_depth = 40

"Open CTRLP with the current word pre-populated in the search
nmap <Leader>p <C-p><C-\>w 
