function! SyntaxCheckers_groovy_grails_GetLocList()
    let makeprg = syntastic#makepgr#build({
                \'exe': 'grails-compile-file '. shellescape(expand('%')),
                \'filetype': 'groovy',
                \'subchecker': 'grails'
                \ })
    let errorformat = '%f:\ %l:\ %m'
    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'groovy',
    \ 'name': 'grails'})

"/Users/sjurgemeyer/projects/bloom/bloom-domain/grails-app/domain/com/bloomhealthco/domain/Member.groovy: 19: expecting EOF, found 'extends' @ line 19, column 13.
