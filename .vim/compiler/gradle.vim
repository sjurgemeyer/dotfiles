" Vim compiler file

if exists("current_compiler")
  finish
endif
let current_compiler = "gradle"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=gradle
"CompilerSet errorformat=%m

CompilerSet errorformat=%A%f:\ %l:\ %m,%-G%.%#
"/Users/sjurgemeyer/projects/bloom/lib_paymentSchedule/src/main/groovy/com/bloomhealthco/payment/Payment.groovy: 12: unexpected token: aymentType @ line 12, column 5.
