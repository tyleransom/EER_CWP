version 13.0
clear all
set more off
capture log using data_append.log, replace

********************************************************************
* This do-file appends the 79 and 97 datasets for ease of comparison
*  for tabulations, etc.
********************************************************************

local EY = int(10000*uniform()) // NO seed; needs to be random
!gunzip -fc y79/master.dta.gz > tmp79`EY'.dta
!gunzip -fc y97/master.dta.gz > tmp97`EY'.dta
use          tmp79`EY'.dta, clear
append using tmp97`EY'.dta, generate(cohortFlag)
!rm tmp79`EY'.dta
!rm tmp97`EY'.dta

recode  cohortFlag (0 = 1979) (1 = 1997)
lab var cohortFlag "Cohort Flag (1979 or 1997)"

sort    cohortFlag id year

*consolidate the cohort-specific variables:
ren famIncAsTeen   famInc
ren m_famIncAsTeen m_famInc

bys cohortFlag id: gen firstObs     = (_n==1)
lab def RACE 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian" 5 "Mixed"
lab val race RACE

gen potExp = age-hgc-6

*-------------------------------------------------------------------------------
* Create period variable (=1 for each person in first period, regardless of age)
*  and uniqueid to xtset data
*-------------------------------------------------------------------------------
bys cohortFlag id (year): gen period = _n
gen uniqueid = (cohortFlag-1900)*100000 + id

* Check Stata
bys uniqueid (year): gen period2 = _n
assert period==period2
drop period2

xtset uniqueid period

sum lnwage if cohortFlag==1979, d
sum lnwage if cohortFlag==1997, d
reg lnwage gradHS grad4yr gradGrad if cohortFlag==1979 & inrange(age,25,34) & empFT==1 & !female
reg lnwage gradHS grad4yr gradGrad if cohortFlag==1997 & inrange(age,25,34) & empFT==1 & !female
reg lnwage gradHS grad4yr gradGrad if cohortFlag==1979 & inrange(age,25,34) & empFT==1 &  female
reg lnwage gradHS grad4yr gradGrad if cohortFlag==1997 & inrange(age,25,34) & empFT==1 &  female

reg lnwage hgc gradHS grad4yr gradGrad if cohortFlag==1979 & inrange(age,25,34) & empFT==1 & !female
reg lnwage hgc gradHS grad4yr gradGrad if cohortFlag==1997 & inrange(age,25,34) & empFT==1 & !female
reg lnwage hgc gradHS grad4yr gradGrad if cohortFlag==1979 & inrange(age,25,34) & empFT==1 &  female
reg lnwage hgc gradHS grad4yr gradGrad if cohortFlag==1997 & inrange(age,25,34) & empFT==1 &  female

reg lnwage hgc c.potExp##c.potExp gradHS grad4yr gradGrad if cohortFlag==1979 & inrange(age,25,34) & empFT==1 & !female
reg lnwage hgc c.potExp##c.potExp gradHS grad4yr gradGrad if cohortFlag==1997 & inrange(age,25,34) & empFT==1 & !female
reg lnwage hgc c.potExp##c.potExp gradHS grad4yr gradGrad if cohortFlag==1979 & inrange(age,25,34) & empFT==1 &  female
reg lnwage hgc c.potExp##c.potExp gradHS grad4yr gradGrad if cohortFlag==1997 & inrange(age,25,34) & empFT==1 &  female

reg lnwage hgc c.exper##c.exper gradHS grad4yr gradGrad if cohortFlag==1979 & inrange(age,25,34) & empFT==1 & !female
reg lnwage hgc c.exper##c.exper gradHS grad4yr gradGrad if cohortFlag==1997 & inrange(age,25,34) & empFT==1 & !female
reg lnwage hgc c.exper##c.exper gradHS grad4yr gradGrad if cohortFlag==1979 & inrange(age,25,34) & empFT==1 &  female
reg lnwage hgc c.exper##c.exper gradHS grad4yr gradGrad if cohortFlag==1997 & inrange(age,25,34) & empFT==1 &  female

reg lnwage i.race hgc c.exper##c.exper gradHS grad4yr gradGrad if cohortFlag==1979 & inrange(age,25,34) & empFT==1 & !female
reg lnwage i.race hgc c.exper##c.exper gradHS grad4yr gradGrad if cohortFlag==1997 & inrange(age,25,34) & empFT==1 & !female
reg lnwage i.race hgc c.exper##c.exper gradHS grad4yr gradGrad if cohortFlag==1979 & inrange(age,25,34) & empFT==1 &  female
reg lnwage i.race hgc c.exper##c.exper gradHS grad4yr gradGrad if cohortFlag==1997 & inrange(age,25,34) & empFT==1 &  female

save yCombined.dta, replace
!gzip -f yCombined.dta
save yCombinedAnalysis.dta, replace
!gzip -f yCombinedAnalysis.dta

log close
