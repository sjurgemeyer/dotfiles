"CtrlP
let g:ctrlp_working_path_mode = 0
"let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'rtscript']
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*\|.*/target/.*\|.*/build/.*|*.orig'
  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v(build|target)$',
    \ 'file': '\v\.(orig|)$',
    \ }
let g:ctrlp_max_files = 50000
let g:ctrlp_max_depth = 100
let g:ctrlp_lazy_update = 1

"Open CTRLP with current word prepopulated
nmap <Leader>p <C-p><C-\>w
nmap <Leader>m :CtrlPMRUFiles<CR>
