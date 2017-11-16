let g:vimport_lookup_gradle_classpath = 1
let g:vimport_auto_organize = 1
let g:vimport_gradle_cache_file = "~/.vimGradleCache"
let g:vimport_import_groups = [
    \ {
        \ 'name' : 'java',
        \ 'matcher' : 'import java\..*'
    \ },
    \ {
        \ 'name' : 'javax',
        \ 'matcher' : 'import javax\..*'
    \ },
    \ {
        \ 'name' : 'static',
        \ 'matcher' : 'import static .*'
    \ },
\]

"nmap <C-m> :VimportImportAll<CR>
"nmap <C-n> :VimportReloadCaches<CR>
