let g:codenarcJar='$HOME/.grails/ivy-cache/org.codenarc/CodeNarc/jars/CodeNarc-0.17.jar'
let g:groovyDir='$HOME/.gvm/groovy/current/lib/'
let g:log4jJar='$HOME/.gvm/grails/2.2.4/lib/log4j/log4j/jars/log4j-1.2.16.jar'
let g:gmetricsJar='$HOME/.grails/ivy-cache/org.gmetrics/GMetrics/jars/GMetrics-0.5.jar'
" the ruleset files must be in the classpath 
let g:rulesFiles='codenarc.groovy'

let g:classpath= './:$HOME/.vim/tools/:' . g:gmetricsJar . ':' . g:codenarcJar . ':' . g:groovyDir . '*:' . g:log4jJar

function! SyntaxCheckers_groovy_codenarc_GetLocList() dict
    let makeprg = self.makeprgBuild({
                \'exe': 'codenarc ' . g:classpath . ' ' . g:rulesFiles . ' ' . expand('%'),
                \'filetype': 'groovy',
                \'subchecker': 'codenarc'
                \ })
    let errorformat = '%P%.%#File:\ %f,%.%#Violation%.%#Line=%l%.%#Msg=[%m'
    "let errorformat = '%m'
    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'groovy',
    \ 'name': 'codenarc'})
