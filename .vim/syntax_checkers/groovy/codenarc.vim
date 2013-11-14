let g:codenarcJar='/Users/sjurgemeyer/.grails/ivy-cache/org.codenarc/CodeNarc/jars/CodeNarc-0.18.1.jar'
let g:groovyDir='/Users/sjurgemeyer/.gvm/groovy/current/lib/'
let g:log4jJar='/Users/sjurgemeyer/.ivy2/cache/log4j/log4j/bundles/log4j-1.2.17.jar'
let g:gmetricsJar='/Users/sjurgemeyer/.ivy2/cache/org.gmetrics/GMetrics/jars/GMetrics-0.5.jar'
let g:rulesFiles='codenarc.groovy'

let g:classpath= './:/Users/sjurgemeyer/.vim/tools/:' . g:gmetricsJar . ':' . g:codenarcJar . ':' . g:groovyDir . '*:' . g:log4jJar

function! SyntaxCheckers_groovy_codenarc_GetLocList() dict
    let makeprg = self.makeprgBuild({
                \'exe': 'codenarc ' . g:classpath . ' ' . g:rulesFiles . ' ' . expand('%'),
                \'filetype': 'groovy',
                \'subchecker': 'codenarc'
                \ })
    let errorformat = '%P%.%#File:\ %f,%.%#Violation%.%#Line=%l%.%#Msg=[%m]%.%#'
    "let errorformat = '%m'
    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'groovy',
    \ 'name': 'codenarc'})
