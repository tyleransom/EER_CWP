version 13.0
clear all
set more off
capture log close
log using all_freqs.log, replace

local DATALIST ACS CPS NLSY PSID SIPP

gen dataset=""
foreach DATA in `DATALIST' {
    disp "`DATA'"
    local data = lower("`DATA'")
    append using `DATA'/`data'_means.dta, gen(`DATA')
    replace dataset="`DATA'" if `DATA'==1
}
recode `DATALIST' (.=0)
order  `DATALIST' dataset, last

lab var birthyr "Birth year"

duplicates drop

keep if inrange(birthyr,1950,1985) & empFT==99 & controls=="Grad4yr" & age1==25 

replace N=. if dataset=="ACS" & (inrange(birthyr,1952,1959) | inrange(birthyr,1962,1969))
replace N=. if dataset=="SIPP" & inrange(birthyr,1983,2000)

tabout birthyr dataset if female==0 using allFreqsMen.tex, replace style(tex) bt c(mean N) f(0c) sum h1(nil) h3(nil) // fn(auto.dta)
tabout birthyr dataset if female==1 using allFreqsWomen.tex, replace style(tex) bt c(mean N) f(0c) sum h1(nil) h3(nil) // fn(auto.dta)

* !sed -i -e '1i\\toprule\' allFreqsMen.tex
!sed -i -e '\$i\\bottomrule\' allFreqsMen.tex
!sed -i -e '$ d' allFreqsMen.tex
* !sed -i -e '\$a\\bottomrule\' allFreqsMen.tex
* !sed -i -e '1i\\toprule\' allFreqsWomen.tex
!sed -i -e '\$i\\bottomrule\' allFreqsWomen.tex
!sed -i -e '$ d' allFreqsWomen.tex
* !sed -i -e '\$a\\bottomrule\' allFreqsWomen.tex


*** Now add wage frequencies

clear

gen dataset=""
foreach DATA in `DATALIST' {
    disp "`DATA'"
    local data = lower("`DATA'")
    append using `DATA'/`data'_regs.dta, gen(`DATA')
    replace dataset="`DATA'" if `DATA'==1
}
recode `DATALIST' (.=0)
order  `DATALIST' dataset, last

lab var birthyr "Birth year"

duplicates drop

keep if inrange(birthyr,1950,1985) & empFT==1 & controls=="Raw" & age1==25 

replace N=. if dataset=="ACS" & (inrange(birthyr,1952,1959) | inrange(birthyr,1962,1969))
replace N=. if dataset=="SIPP" & inrange(birthyr,1983,2000)

tabout birthyr dataset if female==0 using wageFreqsMen.tex, replace style(tex) bt c(mean N) f(0c) sum h1(nil) h3(nil) // fn(auto.dta)
tabout birthyr dataset if female==1 using wageFreqsWomen.tex, replace style(tex) bt c(mean N) f(0c) sum h1(nil) h3(nil) // fn(auto.dta)

* !sed -i -e '1i\\toprule\' wageFreqsMen.tex
!sed -i -e '\$i\\bottomrule\' wageFreqsMen.tex
!sed -i -e '$ d' wageFreqsMen.tex
* !sed -i -e '\$a\\bottomrule\' wageFreqsMen.tex
* !sed -i -e '1i\\toprule\' wageFreqsWomen.tex
!sed -i -e '\$i\\bottomrule\' wageFreqsWomen.tex
!sed -i -e '$ d' wageFreqsWomen.tex
* !sed -i -e '\$a\\bottomrule\' wageFreqsWomen.tex

log close

