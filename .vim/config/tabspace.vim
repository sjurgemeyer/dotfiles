let g:add_tabspace_nerdtree_mappings = 1
let g:add_tabspace_mappings = 1

let g:initial_tabspaces_event = ['serenity', 'miranda', 'reaver' ]

let g:named_tabspaces = {
	\ 'bookie' : { 'cwd' : '~/projects/smartthings/active/bookie', 'label' : 'Bookie' },
	\ 'bouncer' : { 'cwd' : '~/projects/smartthings/active/bouncer', 'label' : 'Bouncer' },
	\ 'build-common' : { 'cwd' : '~/projects/smartthings/active/build-common', 'label' : 'Build Common' },
	\ 'capabilities' : { 'cwd' : '~/projects/smartthings/active/SmartThingsCapabilities', 'label' : 'SmartThingsCapabilities' },
	\ 'datamgmt' : { 'cwd' : '~/projects/smartthings/active/data-management', 'label' : 'Data Management' },
	\ 'dealer' : { 'cwd' : '~/projects/smartthings/active/dealer', 'label' : 'dealer' },
	\ 'devconn' : { 'cwd' : '~/projects/smartthings/active/device-connectivity', 'label' : 'Device Conn' },
	\ 'dot' : { 'cwd' : '~/projects/dotfiles', 'label' : 'dotfiles' },
	\ 'dropwizard' : { 'cwd' : '~/projects/smartthings/active/dropwizard-common', 'label' : 'DropWizard Common' },
	\ 'event' : { 'cwd' : '~/projects/event-common', 'label' : 'event-common' },
	\ 'execution' : { 'cwd' : '~/projects/smartthings/active/execution', 'label' : 'Execution' },
	\ 'incident' : { 'cwd' : '~/projects/smartthings/active/incident', 'label' : 'Incident' },
	\ 'miranda' : { 'cwd' : '~/projects/smartthings/active/miranda', 'label' : 'Miranda' },
	\ 'ocfaccount' : { 'cwd' : '~/projects/smartthings/active/ocf-account-service', 'label' : 'OCF Account' },
	\ 'ocfmapping' : { 'cwd' : '~/projects/smartthings/active/ocf-st-mapping', 'label' : 'Mapping' },
	\ 'ocfrd' : { 'cwd' : '~/projects/smartthings/active/ocf-rd', 'label' : 'OCF RD' },
	\ 'ocfroute' : { 'cwd' : '~/projects/smartthings/active/ocf-route', 'label' : 'OCF Route' },
	\ 'paperboy' : { 'cwd' : '~/projects/smartthings/active/paperboy', 'label' : 'Paperboy' },
	\ 'platform' : { 'cwd' : '~/projects/smartthings/active/platform-api', 'label' : 'Platform API' },
	\ 'pooch' : { 'cwd' : '~/projects/smartthings/active/pooch', 'label' : 'Pooch' },
	\ 'private' : { 'cwd' : '~/projects/smartthings/active/SmartThingsPrivate', 'label' : 'SmartThingsPrivate' },
	\ 'provisioning' : { 'cwd' : '~/projects/smartthings/active/provisioning', 'label' : 'Provisioning' },
	\ 'public' : { 'cwd' : '~/projects/smartthings/active/SmartThingsPublic', 'label' : 'SmartThingsPublic' },
	\ 'pusher' : { 'cwd' : '~/projects/smartthings/active/pusher', 'label' : 'Pusher' },
	\ 'ratpack' : { 'cwd' : '~/projects/smartthings/active/ratpack-common', 'label' : 'Ratpack Common' },
	\ 'reaver' : { 'cwd' : '~/projects/smartthings/active/reaver', 'label' : 'Reaver' },
	\ 'rest' : { 'cwd' : '~/REST', 'label' : 'REST' },
	\ 'serenity' : { 'cwd' : '~/projects/smartthings/active/serenity', 'label' : 'Serenity' },
	\ 'smartthings' : { 'cwd' : '~/projects/smartthings/active', 'label' : 'Root'},
	\ 'tabspace' : { 'cwd' : '~/projects/vim-plugins/vim-tabspace', 'label' : 'tabspace' },
	\ 'ticker' : { 'cwd' : '~/projects/smartthings/active/ticker', 'label' : 'Ticker' },
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
