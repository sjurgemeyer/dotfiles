let g:neomake_java_enabled_makers = ['gradleCheck']
let g:neomake_groovy_enabled_makers = ['gradleCheck']
let g:neomake_serialize = 1

let g:neomake_open_list=2
call neomake#configure#automake('w', 5000)
nmap <Leader>t :Neomake! gradleCheck<CR>

