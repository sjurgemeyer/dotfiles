"CtrlP
let g:ctrlp_working_path_mode = 0
"let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'rtscript']
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*\|.*/target/.*\|.*/build/.*|*.orig'
let g:ctrlp_custom_ignore = {
\ 'dir':  '(.*/build|target|\.git|\.hg|\.svn|\.sass-cache|node_modules|dist|\.gradle)',
\ 'file': '\.(orig|class)$',
\ }
let g:ctrlp_max_files = 50000
let g:ctrlp_max_depth = 100
let g:ctrlp_lazy_update = 1
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_match_current_file = 1

" Use ag for searching
let g:ctrlp_use_caching = 1
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor

    let g:ctrlp_user_command = {
		\ 'types': {},
		\ 'fallback': 'ag %s -l --nocolor -g ""',
		\ 'ignore': 1
	\ }
else
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
  let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
    \ }
endif

"Open CTRLP with current word prepopulated
nmap <Leader>p <C-p><C-\>w
nmap <Leader>m :CtrlPMRUFiles<CR>

let g:ctrlp_extensions = ['tabspace']
command! CtrlPTabspace call ctrlp#init(ctrlp#tabspace#id())
nmap <Leader>b :CtrlPTabspace<CR>
