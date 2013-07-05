if exists("current_compiler")
  finish
endif
let current_compiler = "grailsTest"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=grailsTest
CompilerSet errorformat=%m
"CompilerSet errorformat=%A%.%#Failure:%m,%Z%.%#at\ %.%#(%f:%l),%-G%.%#

"|| | Failure:  isValidForAgeAndType ageFrom:0 ageTo:0 age:30 type:null(com.bloomhealthco.domain.AgeBandSpec)
"|| |  Condition not satisfied:
"|| 
"|| result == ageBand.isValidForAgeAndType(age, type)
"|| |      |  |       |                    |    |
"|| true   |  |       false                30   null
"||        |  Age Band: 0-0: productType:null (EE - EE+S - EE+C - EE+Ch - Fam - OptOut - NoBloom) 100 - 100 - 100 - 100 - 100 - 100 - 0
"||        false
"|| 
"|| 	at com.bloomhealthco.domain.AgeBandSpec.isValidForAgeAndType ageFrom:#ageFrom ageTo:#ageTo age:#age type:#type(./test/unit/com/bloomhealthco/domain/AgeBandSpec.groovy:46)
