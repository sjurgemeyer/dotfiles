" fitnesse.vim
" @author: Dan Woodward (dan DOT woodward AT gmail.com)



if version < 600
   syntax clear
elseif exists("b:current_syntax")
   finish
endif

let b:fitnesseEnabled = 1

syntax sync minlines=2

syn match collapsibleSectionStart /!\*\+.*/
syn match collapsibleSectionEnd /\*\+!.*/
" syn match bracesAndBrackets "|\|{\|}\|\[\|\]"
syn match cellBreaks /|/
syn match bang /!/
syn match literalText /!-.\{-}-!/
syn match openCell /|[^|]\+\n/hs=s+1
" syn region colapsableFold start="!\*\{1,}" end="\*!" fold transparent keepend extend
syn sync fromstart
set foldmethod=syntax
syn region cellContents start=+|+hs=s+1 end=+|+he=e-1 oneline contains=ALL
syn region styledText start=+\[+hs=s+1 end=+\]+he=e-1 oneline contains=ALL
syn region styledText2 start=+{+hs=s+1 end=+}+he=e-1 oneline contains=ALL
syn region styledText3 start=+(+hs=s+1 end=+)+he=e-1 oneline contains=ALL
syn region Comment start=/#/ end=/\n/
syn match String /"[^"]\+"/ contains=Identifier
syn match String /'[^']\+'/ contains=Identifier
syn match symbol /$\w*/
syn match extractVariable /${[^}]*}/
syn match bold /'''.*'''/
syn region heading start=/!\d/ end=/\n/
" syn match widget /!\w\+[\[{(]/me=e-1,he=e-1
syn match Keyword /!define /
syn match Keyword /!include /
syn keyword Keyword  scenario script Query: start check reject show Comment comment !see !include !See null begin transaction rollback
syn match scenarioVariable /@\w\+/
syn match wikiWord /\<[A-Z][a-z]\+[A-Za-z]*[A-Z]\+[A-Za-z]*\>/

highlight link collapsibleSectionStart Delimiter
highlight link collapsibleSectionEnd Delimiter
highlight link bracesAndBrackets Delimiter
highlight link cellBreaks Delimiter
highlight link cellContents Constant
highlight link bang Delimiter
highlight link styledText Type
highlight link styledText2 Type
highlight link styledText3 Type
highlight link literalText Special
highlight link symbol Identifier
highlight link extractVariable Identifier
highlight link bold Constant
highlight link heading Identifier
highlight link scenarioVariable Identifier
highlight link styleMarker Special
highlight link widget Statement
highlight link wikiWord Underlined
highlight link openCell Error

let b:current_syntax = "fitnesse"
