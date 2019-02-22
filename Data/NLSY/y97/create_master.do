version 14.1
clear all
set more off
capture log close
set maxvar 32000

log using "create_master.log", replace

**************************************************
* Create all permanent variables and save all data
**************************************************
local EY = int(10000*uniform()) // NO seed; needs to be random
!gunzip -fc raw.dta.gz > tmp`EY'.dta
use tmp`EY'.dta, clear
!rm tmp`EY'.dta

* survey rounds by year
generat svyRound = .
replace svyRound =  1 if year==1997
replace svyRound =  2 if year==1998
replace svyRound =  3 if year==1999
replace svyRound =  4 if year==2000
replace svyRound =  5 if year==2001
replace svyRound =  6 if year==2002
replace svyRound =  7 if year==2003
replace svyRound =  8 if year==2004
replace svyRound =  9 if year==2005
replace svyRound = 10 if year==2006
replace svyRound = 11 if year==2007
replace svyRound = 12 if year==2008
replace svyRound = 13 if year==2009
replace svyRound = 14 if year==2010
replace svyRound = 15 if year==2011
replace svyRound = 16 if year==2012
replace svyRound = 16 if year==2013
replace svyRound = 17 if year==2014
replace svyRound = 17 if year==2015
replace svyRound = 17 if year==2016

xtset id year

* Bring in data on CPI and minimum wage
run cpi_min_wage.do

* Create various demographic variables
do create_demog.do

* Create enrollment status and hgc
do create_school.do

* Create work status vars, wages, and job characteristics
do create_work.do

* Variables to keep:
keep ${keeperdemog} ${keeperschool} ${keeperwork}

* Save attrition rates to external data set
preserve
    collapse missInt if year>=1997 & !inlist(year,2012,2014,2016), by(year)
    gen round = _n
    l
    save y97attritionByCalYr, replace
restore

preserve
    collapse missIntEverBefore if year>=1997 & !inlist(year,2012,2014,2016), by(year)
    gen round = _n
    l
    save y97cumAttritionByCalYr, replace
restore

preserve
    collapse missInt if year>=1997 & inlist(age,29,30) & !inlist(year,2012,2014,2016), by(birthyr)
    gen round = _n
    l
    save y97attritionAge2930ByBirthYr, replace
restore

preserve
    collapse missIntEverBefore if year>=1997 & inlist(age,29,30) & !inlist(year,2012,2014,2016), by(birthyr)
    gen round = _n
    l
    save y97cumAttritionAge2930ByBirthYr, replace
restore

l id year missInt year_miss_int yrFirstMissInt yrFirstMissIntFull missIntEverBefore if id<=10, sepby(id)

xtsum id if year>=1997
logit missInt i.birthyr afqt female i.race hgcMoth hgcFath liveWithMom14 femaleHeadHH14 m_hgcMoth m_hgcFath m_afqt c.age##c.age if year>=1997 & !inlist(year,2012,2014,2016)
logit missInt i.birthyr afqt female i.race hgcMoth hgcFath liveWithMom14 femaleHeadHH14 m_hgcMoth m_hgcFath m_afqt c.age##c.age if year>=1997 & !inlist(year,2012,2014,2016) & age<=34
tab year, sum(missInt)
tab year, sum(missIntEverBefore)
tab birthyr if inlist(age,29,30) & !inlist(year,2012,2014,2016), sum(missInt)
drop if missInt
xtsum id if year>=1997 & !missInt

xtsum id if year>=1997
xtsum id if year>=1997 & female
xtsum id if year>=1997 & !female

xtsum id if year>=1997 & !mi(hgc)
xtsum id if year>=1997 & !mi(hgc) & female
xtsum id if year>=1997 & !mi(hgc) & !female

xtsum id if year>=1997 & !mi(hgc) & age==25
xtsum id if year>=1997 & !mi(hgc) & age==25 & female
xtsum id if year>=1997 & !mi(hgc) & age==25 & !female

drop if year<=1996

compress
save master, replace
!gzip -f master.dta
log close
