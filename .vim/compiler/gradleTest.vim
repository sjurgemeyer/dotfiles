" Vim compiler file

if exists("current_compiler")
  finish
endif
let current_compiler = "gradleTest"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=gradleTest
"CompilerSet errorformat=%m
CompilerSet errorformat=%A%m\ FAILED,%Z%.%#\ at\ %f:%l,%-G%.%#


"com.bloomhealthco.payment.PaymentsByClaimMonthSpec > isEmpty[4] FAILED
    "org.spockframework.runtime.SpockComparisonFailure at PaymentsByClaimMonthSpec.groovy:38
