version 13.0
clear all
set more off
capture log using quick_stats.log, replace

!gunzip -f ../../Data/NLSY/yCombinedAnalysis.dta.gz
use        ../../Data/NLSY/yCombinedAnalysis.dta
!gzip   -f ../../Data/NLSY/yCombinedAnalysis.dta

*** 79
* Command from data_append.do
reg lnwage     gradHS grad4yr if cohortFlag==1979 & inrange(age,25,34) & empFT==1 & !female
reg lnwage hgc gradHS grad4yr if cohortFlag==1979 & inrange(age,25,34) & empFT==1 & !female

* Command from data_append.do (different age range)
reg lnwage     gradHS grad4yr if cohortFlag==1979 & inrange(age,16,28) & empFT==1 & !female
reg lnwage hgc gradHS grad4yr if cohortFlag==1979 & inrange(age,16,28) & empFT==1 & !female

* Modified commands
reg lnwage gradHS grad4yr        if cohortFlag==1979 & inrange(age,25,34)  & !female
reg lnwage gradHS grad4yr empPT  if cohortFlag==1979 & inrange(age,25,34)  & !female
reg lnwage gradHS grad4yr empPT  if cohortFlag==1979 & inrange(age,25,34)  & !female & inlist(birthyr,1959,1960)
reg lnwage gradHS grad4yr empPT  if cohortFlag==1979 & inrange(age,25,34)  & !female & inlist(birthyr,1961,1962,1963,1964)

*** 97
* Command from data_append.do
reg lnwage     gradHS grad4yr if cohortFlag==1997 & inrange(age,25,34) & empFT==1 & !female
reg lnwage hgc gradHS grad4yr if cohortFlag==1997 & inrange(age,25,34) & empFT==1 & !female

* Command from data_append.do
reg lnwage     gradHS grad4yr if cohortFlag==1997 & inrange(age,16,28) & empFT==1 & !female
reg lnwage hgc gradHS grad4yr if cohortFlag==1997 & inrange(age,16,28) & empFT==1 & !female

* Modified commands
reg lnwage gradHS grad4yr        if cohortFlag==1997 & inrange(age,25,34)  & !female
reg lnwage gradHS grad4yr empPT  if cohortFlag==1997 & inrange(age,25,34)  & !female
reg lnwage gradHS grad4yr empPT  if cohortFlag==1997 & inrange(age,25,34)  & !female & inlist(birthyr,1980,1981,1982,1983,1984)

* Even after this, there are still large discrepancies

log close
