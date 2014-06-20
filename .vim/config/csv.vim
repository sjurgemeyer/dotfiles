"let g:csv_highlight_column = 'y'

function! CSVUnHighlight() 
    :set filetype=csv
    :execute "unlet g:csv_highlight_column"
    :CSVInit
    :filetype detect
endfunction
command! CSVUnHighlight silent call CSVUnHighlight()

function! CSVHighlight() 
    let g:csv_highlight_column='y'
    :CSVInit
endfunction
command! CSVHighlight silent call CSVHighlight()
