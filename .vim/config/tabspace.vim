let g:add_tabspace_nerdtree_mappings = 1
let g:add_tabspace_mappings = 1

let g:initial_tabspaces_event = ['smartthings', 'bouncer', 'pusher', 'paperboy', 'execution' ]

let g:named_tabspaces = {
	\ 'provisioning' : { 'cwd' : '~/projects/smartthings/active/provisioning', 'label' : 'Provisioning' },
	\ 'bouncer' : { 'cwd' : '~/projects/smartthings/active/bouncer', 'label' : 'Bouncer' },
	\ 'smartthings' : { 'cwd' : '~/projects/smartthings/active', 'label' : 'Root'},
	\ 'pusher' : { 'cwd' : '~/projects/smartthings/active/pusher', 'label' : 'Pusher' },
	\ 'paperboy' : { 'cwd' : '~/projects/smartthings/active/paperboy', 'label' : 'Paperboy' },
	\ 'execution' : { 'cwd' : '~/projects/smartthings/active/execution', 'label' : 'Execution' },
	\ 'datamgmt' : { 'cwd' : '~/projects/smartthings/active/data-management', 'label' : 'Data Management' },
	\ 'dot' : { 'cwd' : '~/projects/dotfiles', 'label' : 'dotfiles' },
	\ 'event' : { 'cwd' : '~/projects/event-common', 'label' : 'event-common' },
	\}

nnoremap <Left> :tabprev<CR>
nnoremap <Right> :tabnext<CR>

