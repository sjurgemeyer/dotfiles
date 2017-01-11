map <buffer> <F9> :call RunGruntTests()<CR>
"running arbitrary javascript
vmap <buffer> <silent> <F7> :call Javascript_eval_vsplit()<CR>
nmap <buffer> <silent> <F7> mzggVG<F7>`z
imap <buffer> <silent> <F7> <Esc><F7>a
map <buffer> <silent> <S-F7> :wincmd P<CR>:q<CR>
imap <buffer> <silent> <S-F7> <Esc><S-F7>a

function! Javascript_eval_vsplit() range
    :call Eval_vsplit('node', a:firstline, a:lastline)
endfunction
