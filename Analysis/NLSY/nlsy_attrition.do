version 13.0
clear all
set more off
capture log close
log using nlsy_attrition.log, replace

* y79attritionAge2930ByBirthYr.dta
* y79cumAttritionAge2930ByBirthYr.dta

foreach panel in 79 97 {
    append using ../../Data/NLSY/y`panel'/y`panel'attritionByCalYr.dta
}
generat panel = 1997
replace panel = 1979 if _n<=25
l

twoway ( line missInt round if panel==1979 , lwidth(medthick) lcolor(black) lpattern(solid)) ///
       ( line missInt round if panel==1997 , lwidth(medthick) lcolor(black) lpattern(shortdash_dot)) ///
, legend(order(1 2) label(1 "NLSY79") label(2 "NLSY97") cols(2) symxsize(10) keygap(1) ) ///
xscale(range(1 25)) xlabel(1(2)25) xtitle(Survey round) ytitle(Proportion missing current round interview) graphregion(color(white))
graph export ../PDFs/nlsy_rd_by_rd_attrition.pdf, replace
graph export  ../PSs/nlsy_rd_by_rd_attrition.eps, replace

clear
foreach panel in 79 97 {
    append using ../../Data/NLSY/y`panel'/y`panel'cumAttritionByCalYr.dta
}
generat panel = 1997
replace panel = 1979 if _n<=25
l

twoway ( line missInt round if panel==1979 , lwidth(medthick) lcolor(black) lpattern(solid)) ///
       ( line missInt round if panel==1997 , lwidth(medthick) lcolor(black) lpattern(shortdash_dot)) ///
, legend(order(1 2) label(1 "NLSY79") label(2 "NLSY97") cols(2) symxsize(10) keygap(1) ) ///
xscale(range(1 25)) xlabel(1(2)25) xtitle(Survey round) ytitle("Proportion ever missed interview" "in current or any previous round") graphregion(color(white))
graph export ../PDFs/nlsy_cum_attrition.pdf, replace
graph export  ../PSs/nlsy_cum_attrition.eps, replace

