map <F2> <Esc>:NERDTreeToggle<CR>
map <F4> <Esc>:NERDTreeFind<CR>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeShowHidden = 1
let NERDTreeIgnore=['\.iml$']
let NERDTreeWinSize = 45

" Close vim when nerdtree is the only open window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
