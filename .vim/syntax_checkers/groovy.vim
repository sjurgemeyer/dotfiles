function! SyntaxCheckers_groovy_GetLocList()
    let makeprg = 'grails-compile-file '.shellescape(expand('%'))
    let errorformat = '%f:\ %l:\ %m'
    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction

"/Users/sjurgemeyer/projects/bloom/bloom-domain/grails-app/domain/com/bloomhealthco/domain/Member.groovy: 19: expecting EOF, found 'extends' @ line 19, column 13.
