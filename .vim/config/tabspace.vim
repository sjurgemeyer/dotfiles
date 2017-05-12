let g:add_tabspace_nerdtree_mappings = 1
let g:add_tabspace_mappings = 1

let g:named_tabspaces = {
	\ 'rest' : { 'cwd' : '~/REST', 'label' : 'REST' },
	\ 'tabspace' : { 'cwd' : '~/projects/vim-plugins/vim-tabspace', 'label' : 'tabspace' },
	\ 'vimopen' : { 'cwd' : '~/projects/vim-plugins/vim-open', 'label' : 'vim-open' },
	\ 'vimport' : { 'cwd' : '~/projects/vim-plugins/vimport', 'label' : 'vimport' },
	\ 'vundleconfig' : { 'cwd' : '~/projects/vim-plugins/vundleconfig', 'label' : 'vundleconfig' },
	\}

nnoremap <Left> :tabprev<CR>
nnoremap <Right> :tabnext<CR>

command! CtrlPTabBuffers call ctrlp#init(ctrlp#tabbuffers#id())
command! CtrlPTabspaces call ctrlp#init(ctrlp#namedtabspaces#id())

nmap <Leader>b :CtrlPTabBuffers<CR>
nmap <Leader>o :CtrlPTabspaces<CR>
