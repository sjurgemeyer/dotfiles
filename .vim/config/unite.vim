let g:unite_source_history_yank_enable = 1
let g:unite_source_file_mru_limit = 1000
"let g:unite_source_file_rec_max_cache_file = 99999
"let g:unite_update_time = 200
"let g:unite_matcher_fuzzy_max_input_length=12
"let g:max_candidates=0		
let g:unite_source_rec_async_command= 'ag --nocolor --nogroup --hidden -g ""'
"let g:unite_source_rec_max_cache_files = 99999

"call unite#filters#matcher_default#use(['matcher_regexp'])
"nnoremap <C-p> :Unite -start-insert file_rec<cr>
nnoremap <C-p> :<C-u>Unite -buffer-name=files -resume -start-insert file_rec/async:!<cr>
nnoremap <leader>b :Unite -quick-match buffer<cr>

nnoremap <leader>y :<C-u>Unite history/yank<CR>

"let g:unite_prompt = '» '
"let g:unite_enable_split_vertically=1
"let g:unite_winheight=10
"let g:unite_winwidth=90
"nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
"nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files   -start-insert file<cr>
"nnoremap <leader>r :<C-u>Unite -no-split -buffer-name=mru     -start-insert file_mru<cr>
"nnoremap <leader>o :<C-u>Unite -no-split -buffer-name=outline -start-insert outline<cr>
"nnoremap <leader>y :<C-u>Unite -no-split -buffer-name=yank    history/yank<cr>
"nnoremap <leader>e :<C-u>Unite -no-split -buffer-name=buffer  buffer<cr>
"
"call unite#custom_source('file_rec,file_rec/async', 'max_candidates', 200)
call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
      \ 'ignore_pattern', join([
      \ '\.git/',
      \ 'tmp/',
      \ 'node_modules/',
      \ 'bower_components/',
      \ 'dist/',
      \ 'build/',
      \ 'target/',
      \ '\.idea/',
      \ '\.gradle/',
      \ '\.iml$'
      \ ], '\|'))
