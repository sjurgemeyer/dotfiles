let g:add_tabspace_nerdtree_mappings = 1
let g:add_tabspace_mappings = 1

let g:named_tabspaces = {
	\ 'rest' : { 'cwd' : '~/REST', 'label' : 'REST' },
	\ 'tabspace' : { 'cwd' : '~/projects/vim-plugins/vim-tabspace', 'label' : 'tabspace' },
	\ 'dot' : { 'cwd' : '~/projects/dotfiles', 'label' : 'dotfiles' },
	\ 'vimopen' : { 'cwd' : '~/projects/vim-plugins/vim-open', 'label' : 'vim-open' },
	\ 'vimport' : { 'cwd' : '~/projects/vim-plugins/vimport', 'label' : 'vimport' },
	\ 'vundleconfig' : { 'cwd' : '~/projects/vim-plugins/vundleconfig', 'label' : 'vundleconfig' },
	\ 'authproxy' : { 'cwd' : '~/projects/ole/authproxy', 'label' : 'authproxy' },
	\ 'common' : { 'cwd' : '~/projects/ole/ole-common', 'label' : 'ole-common' },
	\ 'deployments' : { 'cwd' : '~/projects/ole/deployments', 'label' : 'deployments' },
	\ 'dp' : { 'cwd' : '~/projects/ole/demand-pick', 'label' : 'demand-pick' },
	\ 'eachventory' : { 'cwd' : '~/projects/ole/eachventory', 'label' : 'eachventory' },
	\ 'event' : { 'cwd' : '~/projects/ole/event', 'label' : 'event' },
	\ 'eventconsumer' : { 'cwd' : '~/projects/ole/event-consumer', 'label' : 'event-consumer' },
	\ 'publisher' : { 'cwd' : '~/projects/ole/event-publisher', 'label' : 'event-publisher' },
	\ 'func' : { 'cwd' : '~/projects/ole/functional-tests', 'label' : 'functional-tests' },
	\ 'funclibs' : { 'cwd' : '~/projects/ole/functional-tests', 'label' : 'functional-test-libs' },
	\ 'gradle' : { 'cwd' : '~/projects/ole/ole-gradle-plugins', 'label' : 'gradle plugins' },
	\ 'inventory' : { 'cwd' : '~/projects/ole/inventory', 'label' : 'inventory' },
	\ 'k8s' : { 'cwd' : '~/projects/ole/k8s-config', 'label' : 'k8s-config' },
	\ 'location' : { 'cwd' : '~/projects/ole/location', 'label' : 'location' },
	\ 'object' : { 'cwd' : '~/projects/ole/object-proxy', 'label' : 'object-proxy' },
	\ 'oldshipping' : { 'cwd' : '~/projects/ole/old-shipping-notices', 'label' : 'old-shipping-notice' },
	\ 'order' : { 'cwd' : '~/projects/ole/order-pool', 'label' : 'order-pool' },
	\ 'retrofit' : { 'cwd' : '~/projects/ole/retrofit-common', 'label' : 'retrofit-common' },
	\ 'support' : { 'cwd' : '~/projects/ole/prod-support', 'label' : 'prod-support' },
	\ 'shipping' : { 'cwd' : '~/projects/ole/shipping', 'label' : 'shipping' },
	\ 'shipping-proxy' : { 'cwd' : '~/projects/ole/shipping-proxy', 'label' : 'shipping-proxy' },
	\ 'tap' : { 'cwd' : '~/projects/ole/tap-deploy', 'label' : 'tap-deploy' },
	\ 'tasks' : { 'cwd' : '~/projects/ole/taskcleanup', 'label' : 'tasks' },
	\ 'transfer' : { 'cwd' : '~/projects/ole/transfer-order', 'label' : 'transfer-order' },
	\ 'warehouse' : { 'cwd' : '~/projects/ole/warehouse-management', 'label' : 'warehouse-management' },
	\ 'yard' : { 'cwd' : '~/projects/ole/yard-management', 'label' : 'yard-management' }
	\}

nnoremap <Left> :tabprev<CR>
nnoremap <Right> :tabnext<CR>

command! CtrlPTabBuffers call ctrlp#init(ctrlp#tabbuffers#id())
command! CtrlPTabspaces call ctrlp#init(ctrlp#namedtabspaces#id())

"nmap <Leader>b :CtrlPTabBuffers<CR>
"nmap <Leader>o :CtrlPTabspaces<CR>

let g:tabspace_tab_highlight = "TabspaceDarkgray"
let g:tabspace_selected_tab_highlight = "TabspaceBlack"
let g:tabspace_fill_highlight = "TabspaceDarkgray"
