let g:add_tabspace_nerdtree_mappings = 1
let g:add_tabspace_mappings = 1

let g:named_tabspaces = {
	\ 'rest' : { 'cwd' : '~/REST', 'label' : 'REST' },
	\ 'tabspace' : { 'cwd' : '~/projects/vim-plugins/vim-tabspace', 'label' : 'tabspace' },
	\ 'vimopen' : { 'cwd' : '~/projects/vim-plugins/vim-open', 'label' : 'vim-open' },
	\ 'vimport' : { 'cwd' : '~/projects/vim-plugins/vimport', 'label' : 'vimport' },
	\ 'vundleconfig' : { 'cwd' : '~/projects/vim-plugins/vundleconfig', 'label' : 'vundleconfig' },
	\ 'authproxy' : { 'cwd' : '~/projects/ole/authproxy', 'label' : 'authproxy' },
	\ 'batch' : { 'cwd' : '~/projects/ole/batch-consumer', 'label' : 'batch-consumer' },
	\ 'deployments' : { 'cwd' : '~/projects/ole/deployments', 'label' : 'deployments' },
	\ 'event' : { 'cwd' : '~/projects/ole/event', 'label' : 'event' },
	\ 'func' : { 'cwd' : '~/projects/ole/functional-tests', 'label' : 'functional-tests' },
	\ 'inventory' : { 'cwd' : '~/projects/ole/inventory', 'label' : 'inventory' },
	\ 'k8s' : { 'cwd' : '~/projects/ole/k8s-config', 'label' : 'k8s-config' },
	\ 'location' : { 'cwd' : '~/projects/ole/location', 'label' : 'location' },
	\ 'order' : { 'cwd' : '~/projects/ole/order-pool', 'label' : 'order-pool' },
	\ 'support' : { 'cwd' : '~/projects/ole/prod-support', 'label' : 'prod-support' },
	\ 'shipping' : { 'cwd' : '~/projects/ole/shipping', 'label' : 'shipping' },
	\ 'shipping-proxy' : { 'cwd' : '~/projects/ole/shipping-proxy', 'label' : 'shipping-proxy' },
	\ 'tasks' : { 'cwd' : '~/projects/ole/tasks', 'label' : 'tasks' },
	\ 'transfer' : { 'cwd' : '~/projects/ole/transfer-order', 'label' : 'transfer-order' },
	\ 'warehouse' : { 'cwd' : '~/projects/ole/warehouse-management', 'label' : 'warehouse-management' },
	\}



nnoremap <Left> :tabprev<CR>
nnoremap <Right> :tabnext<CR>

command! CtrlPTabBuffers call ctrlp#init(ctrlp#tabbuffers#id())
command! CtrlPTabspaces call ctrlp#init(ctrlp#namedtabspaces#id())

nmap <Leader>b :CtrlPTabBuffers<CR>
nmap <Leader>o :CtrlPTabspaces<CR>
