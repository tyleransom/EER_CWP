version 14.1
clear all
set maxvar 20000
capture log close
log using sipp_96to08_master.log, replace

/* This file follows sipp_96to08_master_readin.do */
/* This file combines the SIPP files and transforms them into person-record format so we can use them, then combines all the years */

* Two changes to the file:
*  1: drop all obs for which "hours vary"; this will only impact later 
*     years (2003-2013), but it should help with the drop off
*     - This is the first thing done now after saving Temp/full`foo'_data.dta
*     - Requires 8 lines of code or so for each survey
*  2: change hour requirement from 35 to 30; this will help with all years
*     - global find and replace of: 
*       'hours_job1_month`k' >= 35' to 'hours_job1_month`k' >= 30'
*       'hours_job2_month`k' >= 35' to 'hours_job2_month`k' >= 30'

/* First, 1996 */
forvalues k=1(1)12 {

use "Temp/sipp96_core`k'.dta", clear

gen refmonth = (swave-1)*4 + srefmon
tab refmonth

/* The goal is to rename variables to what they are for pre-1996 data, so I can use the same files I used for those */
rename tage age
gen male = (esex == 1)

gen hispanic = (eorigin >= 20 & eorigin <= 28)
gen black = (erace == 2 & hispanic != 1)

/* Earnings */
rename tpmsum1 earnings_job1_month
rename tpmsum2 earnings_job2_month

gen earnings_se1_month = 0
gen earnings_se2_month = 0

/* wages */
rename tpyrate1 wage_month

/* Usual hours per month */
rename ejbhrs1 hours_job1_month
rename ejbhrs2 hours_job2_month

/* Enrollment */
rename eenrlm enrl_m
replace enrl_m = 0 if enrl_m == -1 | enrl_m == 2

/* State of residence */
rename tfipsst state

/* Survey weight */
rename wpfinwgt weight

/* Will need to take avg of weights across the months in a year */

/* Employed */
rename rmwkwjb wksem_month
replace wksem_month = 0 if wksem_month < 0

/* Occupation and industry */
rename tjbocc1 occ1_month
rename ejbind1 ind1_month

rename srotaton rot

keep refmonth age male hispanic black earnings_job* wage_month hours_job* enrl_m state weight wksem_month occ1_month ind1_month ssuid eentaid epppnum rot tbyear

egen pid= group(ssuid eentaid epppnum)

reshape wide age male hispanic black earnings_job1_month earnings_job2_month hours_job1_month hours_job2_month wage_month enrl_m state weight wksem_month occ1_month ind1_month, i(pid) j(refmonth)

sort ssuid eentaid epppnum
compress
save "Temp/sipp96_core`k'_personrecord.dta", replace

clear
}

use Temp/sipp96_core1_personrecord.dta, clear

forvalues k=2(1)12 {
sort  ssuid eentaid epppnum
merge ssuid eentaid epppnum using "Temp/sipp96_core`k'_personrecord.dta"
*drop if _merge != 3
drop _merge
}

compress
save Temp/sipp96_full.dta, replace

* JA: Sometimes "hours_job1" = -8,
*  which means "hours vary" for now, just drop these obs
forvalues k=1(1)48 {
	foreach X in state`k' weight`k' age`k' enrl_m`k' wksem_month`k' earnings_job1_month`k' wage_month`k' ind1_month`k' occ1_month`k' hours_job2_month`k' earnings_job2_month`k' male`k' hispanic`k' black1 {
		qui replace `X'=. if hours_job1_month`k'==-8
	}
	qui replace hours_job1_month`k'=. if hours_job1_month`k'==-8

	qui replace earnings_job2_month`k'=. if hours_job2_month`k'==-8
	qui replace hours_job2_month`k'=.    if hours_job2_month`k'==-8
}


/* Age at survey */
gen age1996 = age3
gen age1997 = age15
gen age1998 = age27
gen age1999 = age39

/* Gender */
gen male1996 = male1
gen male1997 = male1
gen male1998 = male1
gen male1999 = male1

/* Race */
gen hispanic1996 = hispanic1
gen hispanic1997 = hispanic1
gen hispanic1998 = hispanic1
gen hispanic1999 = hispanic1

gen black1996 = black1
gen black1997 = black1
gen black1998 = black1
gen black1999 = black1

forvalues k=2(1)48 {
forvalues j=1996(1)1999 {
replace male`j' = male`k' if male`j' == .
replace black`j' = black`k' if black`j' == .
replace hispanic`j' = hispanic`k' if hispanic`j' == .
}
}

sum male* black* hispanic*

gen months_seen1996 = 0
gen months_seen1997 = 0
gen months_seen1998 = 0
gen months_seen1999 = 0

forvalues k=2(1)13 {
replace months_seen1996 = months_seen1996 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}

forvalues k=14(1)25 {
replace months_seen1997 = months_seen1997 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}

forvalues k=26(1)37 {
replace months_seen1998 = months_seen1998 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}

forvalues k=38(1)48 {
replace months_seen1999 = months_seen1999 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}


forvalues k=1(1)12 {
replace months_seen1996 = months_seen1996 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}

forvalues k=13(1)24 {
replace months_seen1997 = months_seen1997 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}

forvalues k=25(1)36 {
replace months_seen1998 = months_seen1998 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}

forvalues k=37(1)48 {
replace months_seen1999 = months_seen1999 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}



forvalues k=1(1)11 {
replace months_seen1996 = months_seen1996 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}

forvalues k=12(1)23 {
replace months_seen1997 = months_seen1997 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}

forvalues k=24(1)35 {
replace months_seen1998 = months_seen1998 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}

forvalues k=36(1)47 {
replace months_seen1999 = months_seen1999 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}


forvalues k=1(1)10 {
replace months_seen1996 = months_seen1996 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}

forvalues k=11(1)22 {
replace months_seen1997 = months_seen1997 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}

forvalues k=23(1)34 {
replace months_seen1998 = months_seen1998 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}

forvalues k=35(1)46 {
replace months_seen1999 = months_seen1999 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}

sum months_seen*


/* Each wave asks about the past four months */

/* The first survey is in April 1996, so we don't have obs for many people in 1995 */
/*
/* We see everyone through almost all of 1996 */
replace months_seen1996 = 12 if rot == 2
replace months_seen1996 = 11 if rot == 3
replace months_seen1996 = 10 if rot == 4
replace months_seen1996 = 12 if rot == 1

/* We see everyone through all of 1997 */
replace months_seen1997 = 12 if rot == 2
replace months_seen1997 = 12 if rot == 3
replace months_seen1997 = 12 if rot == 4
replace months_seen1997 = 12 if rot == 1

/* We see everyone through all of 1998 */
replace months_seen1998 = 12 if rot == 2
replace months_seen1998 = 12 if rot == 3
replace months_seen1998 = 12 if rot == 4
replace months_seen1998 = 12 if rot == 1

/* We see everyone through all of 1999 */
replace months_seen1999 = 12 if rot == 2
replace months_seen1999 = 12 if rot == 3
replace months_seen1999 = 12 if rot == 4
replace months_seen1999 = 11 if rot == 1
*/


/* Enrollment */
/* Enrolled? */

/* I will code you as enrolled in the year if you are enrolled at least 2 months of the year */
gen months_enrolled1996 = 0
gen months_enrolled1997 = 0
gen months_enrolled1998 = 0
gen months_enrolled1999 = 0

forvalues k=2(1)13 {
replace months_enrolled1996 = months_enrolled1996 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=14(1)25 {
replace months_enrolled1997 = months_enrolled1997 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=26(1)37 {
replace months_enrolled1998 = months_enrolled1998 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=38(1)48 {
replace months_enrolled1999 = months_enrolled1999 + 1 if enrl_m`k' == 1 & rot == 1
}


forvalues k=1(1)12 {
replace months_enrolled1996 = months_enrolled1996 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=13(1)24 {
replace months_enrolled1997 = months_enrolled1997 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=25(1)36 {
replace months_enrolled1998 = months_enrolled1998 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=37(1)48 {
replace months_enrolled1999 = months_enrolled1999 + 1 if enrl_m`k' == 1 & rot == 2
}



forvalues k=1(1)11 {
replace months_enrolled1996 = months_enrolled1996 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=12(1)23 {
replace months_enrolled1997 = months_enrolled1997 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=24(1)35 {
replace months_enrolled1998 = months_enrolled1998 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=36(1)47 {
replace months_enrolled1999 = months_enrolled1999 + 1 if enrl_m`k' == 1 & rot == 3
}


forvalues k=1(1)10 {
replace months_enrolled1996 = months_enrolled1996 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=11(1)22 {
replace months_enrolled1997 = months_enrolled1997 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=23(1)34 {
replace months_enrolled1998 = months_enrolled1998 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=35(1)46 {
replace months_enrolled1999 = months_enrolled1999 + 1 if enrl_m`k' == 1 & rot == 4
}

gen enrolled1996 = (months_enrolled1996/months_seen1996)
gen enrolled1997 = (months_enrolled1997/months_seen1997)
gen enrolled1998 = (months_enrolled1998/months_seen1998)
gen enrolled1999 = (months_enrolled1999/months_seen1999)

sum enrolled*
sum months_enrolled* months_seen*

/**** ANNUAL EARNINGS ****/

/* Earnings are by month. Month #s to actual month mapping differs by rotation group */
forvalues k=1(1)48 {
replace earnings_job1_month`k' = 0 if earnings_job1_month`k' < 0 | earnings_job1_month`k' == .
replace earnings_job2_month`k' = 0 if earnings_job2_month`k' < 0 | earnings_job2_month`k' == .
gen earnings_se1_month`k' = 0
gen earnings_se2_month`k' = 0
}

gen earnings_job1_1996 = 0
gen earnings_job1_1997 = 0
gen earnings_job1_1998 = 0
gen earnings_job1_1999 = 0

gen earnings_job2_1996 = 0
gen earnings_job2_1997 = 0
gen earnings_job2_1998 = 0
gen earnings_job2_1999 = 0

gen earnings_se1_1996 = 0
gen earnings_se1_1997 = 0
gen earnings_se1_1998 = 0
gen earnings_se1_1999 = 0

gen earnings_se2_1996 = 0
gen earnings_se2_1997 = 0
gen earnings_se2_1998 = 0
gen earnings_se2_1999 = 0

gen earnings_annual1996 = 0
gen earnings_annual1997 = 0
gen earnings_annual1998 = 0
gen earnings_annual1999 = 0

/* Rotation group 1: 1996 is months 2-13, 1997 is months 14-25, 1998 is 26-37, 1999 is 38-48 */
forvalues k=2(1)13 {
replace earnings_annual1996 = earnings_annual1996 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=14(1)25 {
replace earnings_annual1997 = earnings_annual1997 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=26(1)37 {
replace earnings_annual1998 = earnings_annual1998 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=38(1)48 {
replace earnings_annual1999 = earnings_annual1999 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}

replace earnings_annual1996 = (earnings_annual1996/(months_seen1996-months_enrolled1996)) * 12  if rot == 1
replace earnings_annual1997 = (earnings_annual1997/(months_seen1997-months_enrolled1997)) * 12  if rot == 1
replace earnings_annual1998 = (earnings_annual1998/(months_seen1998-months_enrolled1998)) * 12  if rot == 1
replace earnings_annual1999 = (earnings_annual1999/(months_seen1999-months_enrolled1999)) * 12  if rot == 1

replace earnings_annual1996 = 0 if months_enrolled1996 == months_seen1996 & rot == 1
replace earnings_annual1997 = 0 if months_enrolled1997 == months_seen1997 & rot == 1
replace earnings_annual1998 = 0 if months_enrolled1998 == months_seen1998 & rot == 1
replace earnings_annual1999 = 0 if months_enrolled1999 == months_seen1999 & rot == 1

/* Rotation group 2: 1996 is months 1-12, 1997 is months 13-24, 1998 is 25-36, 1999 is 37-48 */
forvalues k=1(1)12 {
replace earnings_annual1996 = earnings_annual1996 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=13(1)24 {
replace earnings_annual1997 = earnings_annual1997 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=25(1)36 {
replace earnings_annual1998 = earnings_annual1998 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=37(1)48 {
replace earnings_annual1999 = earnings_annual1999 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}


replace earnings_annual1996 = (earnings_annual1996/(months_seen1996-months_enrolled1996)) * 12  if rot == 2
replace earnings_annual1997 = (earnings_annual1997/(months_seen1997-months_enrolled1997)) * 12  if rot == 2
replace earnings_annual1998 = (earnings_annual1998/(months_seen1998-months_enrolled1998)) * 12  if rot == 2
replace earnings_annual1999 = (earnings_annual1999/(months_seen1999-months_enrolled1999)) * 12  if rot == 2

replace earnings_annual1996 = 0 if months_enrolled1996 == months_seen1996 & rot == 2
replace earnings_annual1997 = 0 if months_enrolled1997 == months_seen1997 & rot == 2
replace earnings_annual1998 = 0 if months_enrolled1998 == months_seen1998 & rot == 2
replace earnings_annual1999 = 0 if months_enrolled1999 == months_seen1999 & rot == 2

/* Rotation group 3: 1996 is months 1-11, 1997 is months 12-23, 1998 is 24-35, 1999 is 36-47 */
forvalues k=1(1)11 {
replace earnings_annual1996 = earnings_annual1996 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=12(1)23 {
replace earnings_annual1997 = earnings_annual1997 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=24(1)35 {
replace earnings_annual1998 = earnings_annual1998 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=36(1)47 {
replace earnings_annual1999 = earnings_annual1999 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}

replace earnings_annual1996 = (earnings_annual1996/(months_seen1996-months_enrolled1996)) * 12  if rot == 3
replace earnings_annual1997 = (earnings_annual1997/(months_seen1997-months_enrolled1997)) * 12  if rot == 3
replace earnings_annual1998 = (earnings_annual1998/(months_seen1998-months_enrolled1998)) * 12  if rot == 3
replace earnings_annual1999 = (earnings_annual1999/(months_seen1999-months_enrolled1999)) * 12  if rot == 3

replace earnings_annual1996 = 0 if months_enrolled1996 == months_seen1996 & rot == 3
replace earnings_annual1997 = 0 if months_enrolled1997 == months_seen1997 & rot == 3
replace earnings_annual1998 = 0 if months_enrolled1998 == months_seen1998 & rot == 3
replace earnings_annual1999 = 0 if months_enrolled1999 == months_seen1999 & rot == 3

/* Rotation group 4: 1996 is months 1-10, 1997 is months 11-22, 1998 is 22-34, 1999 is 35-46 */
forvalues k=1(1)10 {
replace earnings_annual1996 = earnings_annual1996 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=11(1)22 {
replace earnings_annual1997 = earnings_annual1997 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=23(1)34 {
replace earnings_annual1998 = earnings_annual1998 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=35(1)46 {
replace earnings_annual1999 = earnings_annual1999 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}

replace earnings_annual1996 = (earnings_annual1996/(months_seen1996-months_enrolled1996)) * 12  if rot == 4
replace earnings_annual1997 = (earnings_annual1997/(months_seen1997-months_enrolled1997)) * 12  if rot == 4
replace earnings_annual1998 = (earnings_annual1998/(months_seen1998-months_enrolled1998)) * 12  if rot == 4
replace earnings_annual1999 = (earnings_annual1999/(months_seen1999-months_enrolled1999)) * 12  if rot == 4

replace earnings_annual1996 = 0 if months_enrolled1996 == months_seen1996 & rot == 4
replace earnings_annual1997 = 0 if months_enrolled1997 == months_seen1997 & rot == 4
replace earnings_annual1998 = 0 if months_enrolled1998 == months_seen1998 & rot == 4
replace earnings_annual1999 = 0 if months_enrolled1999 == months_seen1999 & rot == 4

sum earnings_annual*

bysort rot: sum earnings_annual*

/**** WAGES ****/
/* For hourly workers, we actually have an hourly rate of pay variable */

/* Annual wage measure will be the average of the non-missing wage measures in the year (for job 1 only) */

/* Need to get # of non-missing wage measures each year */
gen wage_count1996 = 0
gen wage_count1997 = 0
gen wage_count1998 = 0
gen wage_count1999 = 0

forvalues k=2(1)13 {
replace wage_count1996 = wage_count1996 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=14(1)25 {
replace wage_count1997 = wage_count1997 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=26(1)37 {
replace wage_count1998 = wage_count1998 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=38(1)48 {
replace wage_count1999 = wage_count1999 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}


forvalues k=1(1)12 {
replace wage_count1996 = wage_count1996 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=13(1)24 {
replace wage_count1997 = wage_count1997 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=25(1)36 {
replace wage_count1998 = wage_count1998 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=37(1)48 {
replace wage_count1999 = wage_count1999 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}



forvalues k=1(1)11 {
replace wage_count1996 = wage_count1996 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=12(1)23 {
replace wage_count1997 = wage_count1997 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=24(1)35 {
replace wage_count1998 = wage_count1998 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=36(1)47 {
replace wage_count1999 = wage_count1999 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}


forvalues k=1(1)10 {
replace wage_count1996 = wage_count1996 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=11(1)22 {
replace wage_count1997 = wage_count1997 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=23(1)34 {
replace wage_count1998 = wage_count1998 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=35(1)46 {
replace wage_count1999 = wage_count1999 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

/* Now, we construct the annual wage measure */
gen hrlypay1996 = .
gen hrlypay1997 = .
gen hrlypay1998 = .
gen hrlypay1999 = .

gen hrlypayv11996 = .
gen hrlypayv11997 = .
gen hrlypayv11998 = .
gen hrlypayv11999 = .

gen hrlypayv21996 = .
gen hrlypayv21997 = .
gen hrlypayv21998 = .
gen hrlypayv21999 = .


gen total_wage1996 = 0
gen total_wage1997 = 0
gen total_wage1998 = 0
gen total_wage1999 = 0


forvalues k=2(1)13 {
replace total_wage1996 = total_wage1996 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=14(1)25 {
replace total_wage1997 = total_wage1997 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=26(1)37 {
replace total_wage1998 = total_wage1998 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=38(1)48 {
replace total_wage1999 = total_wage1999 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}


forvalues k=1(1)12 {
replace total_wage1996 = total_wage1996 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=13(1)24 {
replace total_wage1997 = total_wage1997 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=25(1)36 {
replace total_wage1998 = total_wage1998 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=37(1)48 {
replace total_wage1999 = total_wage1999 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}



forvalues k=1(1)11 {
replace total_wage1996 = total_wage1996 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=12(1)23 {
replace total_wage1997 = total_wage1997 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=24(1)35 {
replace total_wage1998 = total_wage1998 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=36(1)47 {
replace total_wage1999 = total_wage1999 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}


forvalues k=1(1)10 {
replace total_wage1996 = total_wage1996 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=11(1)22 {
replace total_wage1997 = total_wage1997 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=23(1)34 {
replace total_wage1998 = total_wage1998 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=35(1)46 {
replace total_wage1999 = total_wage1999 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

replace hrlypayv11996 = total_wage1996/wage_count1996 
replace hrlypayv11997 = total_wage1997/wage_count1997
replace hrlypayv11998 = total_wage1998/wage_count1998 
replace hrlypayv11999 = total_wage1999/wage_count1999

sum hrlypay*
bysort rot: sum hrlypay*

drop total_wage* wage_count* wage_month*

/* Alternative if you don't work by the hour: get earnings/hours */
forvalues k=1(1)48 {
replace hours_job1_month`k' = 0 if hours_job1_month`k' < 0
replace hours_job2_month`k' = 0 if hours_job2_month`k' < 0
}

/* Need to get # of non-missing hours measures each year */
gen hours_count1996 = 0
gen hours_count1997 = 0
gen hours_count1998 = 0
gen hours_count1999 = 0

forvalues k=2(1)13 {
replace hours_count1996 = hours_count1996 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=14(1)25 {
replace hours_count1997 = hours_count1997 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=26(1)37 {
replace hours_count1998 = hours_count1998 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=38(1)48 {
replace hours_count1999 = hours_count1999 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=1(1)12 {
replace hours_count1996 = hours_count1996 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=13(1)24 {
replace hours_count1997 = hours_count1997 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=25(1)36 {
replace hours_count1998 = hours_count1998 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=37(1)48 {
replace hours_count1999 = hours_count1999 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}



forvalues k=1(1)11 {
replace hours_count1996 = hours_count1996 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=12(1)23 {
replace hours_count1997 = hours_count1997 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=24(1)35 {
replace hours_count1998 = hours_count1998 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=36(1)47 {
replace hours_count1999 = hours_count1999 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}


forvalues k=1(1)10 {
replace hours_count1996 = hours_count1996 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=11(1)22 {
replace hours_count1997 = hours_count1997 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=23(1)34 {
replace hours_count1998 = hours_count1998 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=35(1)46 {
replace hours_count1999 = hours_count1999 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}


gen total_hours1996 = 0
gen total_hours1997 = 0
gen total_hours1998 = 0
gen total_hours1999 = 0


forvalues k=2(1)13 {
replace total_hours1996 = total_hours1996 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=14(1)25 {
replace total_hours1997 = total_hours1997 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=26(1)37 {
replace total_hours1998 = total_hours1998 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=38(1)48 {
replace total_hours1999 = total_hours1999 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}


forvalues k=1(1)12 {
replace total_hours1996 = total_hours1996 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=13(1)24 {
replace total_hours1997 = total_hours1997 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=25(1)36 {
replace total_hours1998 = total_hours1998 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=37(1)48 {
replace total_hours1999 = total_hours1999 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}



forvalues k=1(1)11 {
replace total_hours1996 = total_hours1996 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=12(1)23 {
replace total_hours1997 = total_hours1997 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=24(1)35 {
replace total_hours1998 = total_hours1998 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=36(1)47 {
replace total_hours1999 = total_hours1999 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}


forvalues k=1(1)10 {
replace total_hours1996 = total_hours1996 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=11(1)22 {
replace total_hours1997 = total_hours1997 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=23(1)34 {
replace total_hours1998 = total_hours1998 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=35(1)46 {
replace total_hours1999 = total_hours1999 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}




replace hrlypayv21996 = earnings_annual1996 / total_hours1996
replace hrlypayv21997 = earnings_annual1997 / total_hours1997
replace hrlypayv21998 = earnings_annual1998 / total_hours1998
replace hrlypayv21999 = earnings_annual1999 / total_hours1999 


sum hrlypayv1* hrlypayv2*

sum hrlypay1997 if hrlypayv11997 > 0 & hrlypayv11997 != . & earnings_annual1997 > 500
sum hrlypay1997 if hrlypayv11997 == . & hrlypayv21997 > 0 & earnings_annual1997 > 500
sum earnings_annual1997 if hrlypayv11997 > 0 & hrlypayv11997 != . & earnings_annual1997 > 500
sum earnings_annual1997 if hrlypayv11997 == . & hrlypayv21997 > 0 & earnings_annual1997 > 500
sum total_hours1997 if hrlypayv11997 > 0 & hrlypayv11997 != . & earnings_annual1997 > 500
sum total_hours1997 if hrlypayv11997 == . & hrlypayv21997 > 0 & earnings_annual1997 > 500

forvalues k=1996(1)1999 {
replace hrlypay`k' = hrlypayv1`k'
replace hrlypay`k' = hrlypayv2`k' if hrlypay`k' == . | hrlypay`k' == 0
}



sum hrlypay*





sum age1996 age1997 age1998 age1999

sum black* hispanic*

sum hrlypay*, d






/* State and region */
/* I take the state from the first wave as the state for 1996 and the fourth wave for 1997, 7th for 1998, 10th for 1999 */
rename state5 state

gen west = 0
gen northeast = 0
gen midwest = 0
gen south = 0

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1996 = west
gen northeast1996 = northeast
gen midwest1996 = midwest
gen south1996 = south

rename state state_ba_degree 


/* state4 is the state from the 4th wave, which is in the second year */
rename state17 state

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1997 = west
gen northeast1997 = northeast
gen midwest1997 = midwest
gen south1997 = south

drop state


/* 1998 */
rename state29 state

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1998 = west
gen northeast1998 = northeast
gen midwest1998 = midwest
gen south1998 = south

drop state


/* 1999 */
rename state41 state

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1999 = west
gen northeast1999 = northeast
gen midwest1999 = midwest
gen south1999 = south


drop west south midwest northeast



/* Division of degree */
gen ba_newengland = 0
gen ba_midatlantic = 0
gen ba_eastnorthcentral = 0
gen ba_westnorthcentral = 0
gen ba_southatlantic = 0
gen ba_eastsouthcentral = 0
gen ba_westsouthcentral = 0
gen ba_mountain = 0
gen ba_pacific = 0


replace ba_newengland = 1 if state_ba_degree == 9 | state_ba_degree == 25 | state_ba_degree == 33  | state_ba_degree == 44 | state_ba_degree == 23 | state_ba_degree == 50 | state_ba_degree == 61
replace ba_midatlantic = 1 if state_ba_degree == 34 | state_ba_degree == 36 | state_ba_degree == 42
replace ba_eastnorthcentral = 1 if  state_ba_degree == 55 | state_ba_degree == 39 | state_ba_degree == 26 | state_ba_degree == 18 | state_ba_degree == 17
replace ba_westnorthcentral = 1 if state_ba_degree == 62 | state_ba_degree == 19 | state_ba_degree == 38 | state_ba_degree == 46 | state_ba_degree == 31| state_ba_degree == 20 | state_ba_degree == 29 | state_ba_degree == 27
replace ba_southatlantic = 1 if state_ba_degree == 10 | state_ba_degree == 11 | state_ba_degree == 24 | state_ba_degree == 54 | state_ba_degree == 51 | state_ba_degree == 37 | state_ba_degree == 45 | state_ba_degree == 12 | state_ba_degree == 13
replace ba_eastsouthcentral = 1 if state_ba_degree == 28 | state_ba_degree == 21 | state_ba_degree == 47 | state_ba_degree == 1
replace ba_westsouthcentral = 1 if state_ba_degree == 5 | state_ba_degree == 22 | state_ba_degree == 40 | state_ba_degree == 48
replace ba_mountain = 1 if state_ba_degree == 4 | state_ba_degree == 8 | state_ba_degree == 16 | state_ba_degree == 30 | state_ba_degree == 32 | state_ba_degree == 35 | state_ba_degree == 49 | state_ba_degree == 56
replace ba_pacific = 1 if state_ba_degree == 2 | state_ba_degree == 15 | state_ba_degree == 6 | state_ba_degree == 41 | state_ba_degree == 53





/* Survey weights */
/* I need to average the weights for each month over the year to get the annual weight */
forvalues k=1(1)48 {
replace weight`k' = 0 if weight`k' <= 0 | weight`k' == .
}

gen survey_weight1996 = .
gen survey_weight1997 = .
gen survey_weight1998 = .
gen survey_weight1999 = .

replace survey_weight1996 = (weight2+weight3+weight4+weight5+weight6+weight7+weight8+weight9+weight10+weight11+weight12+weight13)/months_seen1996 if rot == 1
replace survey_weight1996 = (weight1+weight2+weight3+weight4+weight5+weight6+weight7+weight8+weight9+weight10+weight11+weight12)/months_seen1996 if rot == 2
replace survey_weight1996 = (weight1+weight2+weight3+weight4+weight5+weight6+weight7+weight8+weight9+weight10+weight11)/months_seen1996 if rot == 3
replace survey_weight1996 = (weight1+weight2+weight3+weight4+weight5+weight6+weight7+weight8+weight9+weight10)/months_seen1996 if rot == 4

replace survey_weight1997 = (weight14+weight15+weight16+weight17+weight18+weight19+weight20+weight21+weight22+weight23+weight24+weight25)/months_seen1997 if rot == 1
replace survey_weight1997 = (weight13+weight14+weight15+weight16+weight17+weight18+weight19+weight20+weight21+weight22+weight23+weight24)/months_seen1997 if rot == 2
replace survey_weight1997 = (weight12+weight13+weight14+weight15+weight16+weight17+weight18+weight19+weight20+weight21+weight22+weight23)/months_seen1997 if rot == 3
replace survey_weight1997 = (weight11+weight12+weight13+weight14+weight15+weight16+weight17+weight18+weight19+weight20+weight21+weight22)/months_seen1997 if rot == 4

replace survey_weight1998 = (weight26+weight27+weight28+weight29+weight30+weight31+weight32+weight33+weight34+weight35+weight36+weight37)/months_seen1998 if rot == 1
replace survey_weight1998 = (weight25+weight26+weight27+weight28+weight29+weight30+weight31+weight32+weight33+weight34+weight35+weight36)/months_seen1998 if rot == 2
replace survey_weight1998 = (weight24+weight25+weight26+weight27+weight28+weight29+weight30+weight31+weight32+weight33+weight34+weight35)/months_seen1998 if rot == 3
replace survey_weight1998 = (weight23+weight24+weight25+weight26+weight27+weight28+weight29+weight30+weight31+weight32+weight33+weight34)/months_seen1998 if rot == 4

replace survey_weight1999 = (weight38+weight39+weight40+weight41+weight42+weight43+weight44+weight45+weight46+weight47+weight48)/months_seen1999 if rot == 1
replace survey_weight1999 = (weight37+weight38+weight39+weight40+weight41+weight42+weight43+weight44+weight45+weight46+weight47+weight48)/months_seen1999 if rot == 2
replace survey_weight1999 = (weight36+weight37+weight38+weight39+weight40+weight41+weight42+weight43+weight44+weight45+weight46+weight47)/months_seen1999 if rot == 3
replace survey_weight1999 = (weight35+weight36+weight37+weight38+weight39+weight40+weight41+weight42+weight43+weight44+weight45+weight46)/months_seen1999 if rot == 4

drop weight*


/* Are you employed? */
/* How should I do this? I have 12 observations per year */
/* For now, what I do (also for occupation and industry and full-time) is take the middle months of the person's year */

gen employed1996 = 0
gen employed1997 = 0
gen employed1998 = 0
gen employed1999 = 0


/* Group 1 */
forvalues k=2(1)13 {
replace employed1996 = employed1996 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 1
}

forvalues k=14(1)25 {
replace employed1997 = employed1997 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 1
}

forvalues k=26(1)37 {
replace employed1998 = employed1998 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 1
}

forvalues k=38(1)48 {
replace employed1999 = employed1999 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 1
}


/* Group 2 */
forvalues k=1(1)12 {
replace employed1996 = employed1996 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 2
}

forvalues k=13(1)24 {
replace employed1997 = employed1997 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 2
}

forvalues k=25(1)36 {
replace employed1998 = employed1998 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 2
}

forvalues k=37(1)48 {
replace employed1999 = employed1999 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 2
}


/* Group 3 */
forvalues k=1(1)11 {
replace employed1996 = employed1996 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 3
}

forvalues k=12(1)23 {
replace employed1997 = employed1997 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 3
}

forvalues k=24(1)35 {
replace employed1998 = employed1998 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 3
}

forvalues k=36(1)47 {
replace employed1999 = employed1999 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 3
}


/* Group 4 */
forvalues k=1(1)10 {
replace employed1996 = employed1996 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 4
}

forvalues k=11(1)22 {
replace employed1997 = employed1997 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 4
}

forvalues k=23(1)34 {
replace employed1998 = employed1998 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 4
}

forvalues k=35(1)46 {
replace employed1999 = employed1999 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 4
}


replace employed1996 = employed1996 / (months_seen1996 - months_enrolled1996)
replace employed1997 = employed1997 / (months_seen1997 - months_enrolled1997)
replace employed1998 = employed1998 / (months_seen1998 - months_enrolled1998)
replace employed1999 = employed1999 / (months_seen1999 - months_enrolled1999)

sum employed*

/* Are you full-time? */

gen fulltime1996 = 0
gen fulltime1997 = 0
gen fulltime1998 = 0
gen fulltime1999 = 0

/* Group 1 */
forvalues k=2(1)13 {
replace fulltime1996 = fulltime1996 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 1
}

forvalues k=14(1)25 {
replace fulltime1997 = fulltime1997 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 1
}

forvalues k=26(1)37 {
replace fulltime1998 = fulltime1998 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 1
}

forvalues k=38(1)48 {
replace fulltime1999 = fulltime1999 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 1
}


/* Group 2 */
forvalues k=1(1)12 {
replace fulltime1996 = fulltime1996 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 2
}

forvalues k=13(1)24 {
replace fulltime1997 = fulltime1997 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 2
}

forvalues k=25(1)36 {
replace fulltime1998 = fulltime1998 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 2
}

forvalues k=37(1)48 {
replace fulltime1999 = fulltime1999 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 2
}


/* Group 3 */
forvalues k=1(1)11 {
replace fulltime1996 = fulltime1996 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 3
}

forvalues k=12(1)23 {
replace fulltime1997 = fulltime1997 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 3
}

forvalues k=24(1)35 {
replace fulltime1998 = fulltime1998 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 3
}

forvalues k=36(1)47 {
replace fulltime1999 = fulltime1999 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 3
}


/* Group 4 */
forvalues k=1(1)10 {
replace fulltime1996 = fulltime1996 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 4
}

forvalues k=11(1)22 {
replace fulltime1997 = fulltime1997 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 4
}

forvalues k=23(1)34 {
replace fulltime1998 = fulltime1998 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 4
}

forvalues k=35(1)46 {
replace fulltime1999 = fulltime1999 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 4
}


replace fulltime1996 = fulltime1996 / (months_seen1996 - months_enrolled1996)
replace fulltime1997 = fulltime1997 / (months_seen1997 - months_enrolled1997)
replace fulltime1998 = fulltime1998 / (months_seen1998 - months_enrolled1998)
replace fulltime1999 = fulltime1999 / (months_seen1999 - months_enrolled1999)



sum fulltime*




/* OCCUPATION */

/* THESE ARE 1990 3-DIGIT CODES */
forvalues k=1(1)48 {
replace occ1_month`k' = . if occ1_month`k' == 0 | occ1_month`k' == 905 | occ1_month`k' < 0
}

forvalues k=1(1)12 {
gen occ`k'_1996 = .
gen occ`k'_1997 = .
gen occ`k'_1998 = .
gen occ`k'_1999 = .
}



forvalues k=2(1)13 {
local j = `k' - 1
replace occ`j'_1996 = occ1_month`k' if rot == 1
}

forvalues k=14(1)25 {
local j = `k' - 13
replace occ`j'_1997 = occ1_month`k' if rot == 1
}

forvalues k=26(1)37 {
local j = `k' - 25
replace occ`j'_1998 = occ1_month`k' if rot == 1
}

forvalues k=38(1)48 {
local j = `k' - 37
replace occ`j'_1999 = occ1_month`k' if rot == 1
}


forvalues k=1(1)12 {
local j = `k' - 0
replace occ`j'_1996 = occ1_month`k' if rot == 2
}

forvalues k=13(1)24 {
local j = `k' - 12
replace occ`j'_1997 = occ1_month`k' if rot == 2
}

forvalues k=25(1)36 {
local j = `k' - 24
replace occ`j'_1998 = occ1_month`k' if rot == 2
}

forvalues k=37(1)48 {
local j = `k' - 36
replace occ`j'_1999 = occ1_month`k' if rot == 2
}


forvalues k=1(1)11 {
local j = `k' + 1
replace occ`j'_1996 = occ1_month`k' if rot == 3
}

forvalues k=12(1)23 {
local j = `k' - 11
replace occ`j'_1997 = occ1_month`k' if rot == 3
}

forvalues k=24(1)35 {
local j = `k' - 23
replace occ`j'_1998 = occ1_month`k' if rot == 3
}

forvalues k=36(1)47 {
local j = `k' - 35
replace occ`j'_1999 = occ1_month`k' if rot == 3
}


forvalues k=1(1)10 {
local j = `k' + 2
replace occ`j'_1996 = occ1_month`k' if rot == 4
}

forvalues k=11(1)22 {
local j = `k' - 10
replace occ`j'_1997 = occ1_month`k' if rot == 4
}

forvalues k=23(1)34 {
local j = `k' - 22
replace occ`j'_1998 = occ1_month`k' if rot == 4
}

forvalues k=35(1)46 {
local j = `k' - 34
replace occ`j'_1999 = occ1_month`k' if rot == 4
}






/* INDUSTRY */
/* I use the 6th month industry as the industry. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1990 3-DIGIT CODES */
forvalues k=1(1)48 {
replace ind1_month`k' = . if ind1_month`k' == 0 | ind1_month`k' == 905 | ind1_month`k' < 0
}



forvalues k=1(1)12 {
gen ind`k'_1996 = .
gen ind`k'_1997 = .
gen ind`k'_1998 = .
gen ind`k'_1999 = .
}



forvalues k=2(1)13 {
local j = `k' - 1
replace ind`j'_1996 = ind1_month`k' if rot == 1
}

forvalues k=14(1)25 {
local j = `k' - 13
replace ind`j'_1997 = ind1_month`k' if rot == 1
}

forvalues k=26(1)37 {
local j = `k' - 25
replace ind`j'_1998 = ind1_month`k' if rot == 1
}

forvalues k=38(1)48 {
local j = `k' - 37
replace ind`j'_1999 = ind1_month`k' if rot == 1
}


forvalues k=1(1)12 {
local j = `k' - 0
replace ind`j'_1996 = ind1_month`k' if rot == 2
}

forvalues k=13(1)24 {
local j = `k' - 12
replace ind`j'_1997 = ind1_month`k' if rot == 2
}

forvalues k=25(1)36 {
local j = `k' - 24
replace ind`j'_1998 = ind1_month`k' if rot == 2
}

forvalues k=37(1)48 {
local j = `k' - 36
replace ind`j'_1999 = ind1_month`k' if rot == 2
}


forvalues k=1(1)11 {
local j = `k' + 1
replace ind`j'_1996 = ind1_month`k' if rot == 3
}

forvalues k=12(1)23 {
local j = `k' - 11
replace ind`j'_1997 = ind1_month`k' if rot == 3
}

forvalues k=24(1)35 {
local j = `k' - 23
replace ind`j'_1998 = ind1_month`k' if rot == 3
}

forvalues k=36(1)47 {
local j = `k' - 35
replace ind`j'_1999 = ind1_month`k' if rot == 3
}


forvalues k=1(1)10 {
local j = `k' + 2
replace ind`j'_1996 = ind1_month`k' if rot == 4
}

forvalues k=11(1)22 {
local j = `k' - 10
replace ind`j'_1997 = ind1_month`k' if rot == 4
}

forvalues k=23(1)34 {
local j = `k' - 22
replace ind`j'_1998 = ind1_month`k' if rot == 4
}

forvalues k=35(1)46 {
local j = `k' - 34
replace ind`j'_1999 = ind1_month`k' if rot == 4
}



drop *month*

bysort rot: sum ind* occ*



/* Identifying variables */
keep *1996 *1997 *1998 *1999 ssuid eentaid epppnum rot tbyear state_ba* ba_*

sort ssuid eentaid epppnum

compress
save Temp/sipp96_full_cleaned.dta, replace


*************************************************************************************

clear

use Temp/sipp96wave2.dta


/**** WAVE 2 DATASET ****/



/* Identifiers */
sum ssuid eentaid epppnum



/********** COLLEGE DEGREE INFORMATION *********/

/* 2 questions: highest degree and BA degree. Need to check both */

/* Need year of degree, age at degree, and field of degree. Also need highest degree completed */


gen col = 0
gen morcol = 0
gen hgc = .


replace hgc = 0    if eattain == 31
replace hgc = 2.5  if eattain == 32
replace hgc = 5.5  if eattain == 33
replace hgc = 7.5  if eattain == 34
replace hgc = 9    if eattain == 35
replace hgc = 10   if eattain == 36
replace hgc = 11   if eattain == 37
replace hgc = 11.5 if eattain == 38
replace hgc = 12   if eattain == 39
replace hgc = 13   if eattain == 40
replace hgc = 13.5 if eattain == 41
replace hgc = 14   if eattain == 42
replace hgc = 14   if eattain == 43
replace hgc = 16   if eattain == 44
replace hgc = 18   if eattain == 45
replace hgc = 19   if eattain == 46
replace hgc = 20   if eattain == 47

tab hgc, mi

replace col = 1 if hgc == 16
replace morcol = 1 if hgc > 16 & hgc != .

drop if hgc == .


tab col morcol


gen gradyear = .


replace gradyear = tbachyr if tbachyr > 0

tab gradyear




/* Field of bachelor's degree */

rename ebachfld major_field
replace major_field = . if major_field == -1

tab major_field if hgc == 16
tab major_field if hgc > 16 & hgc != .





keep hgc major_field gradyear col morcol ssuid eentaid epppnum


sort ssuid eentaid epppnum



merge ssuid eentaid epppnum using Temp/sipp96_full_cleaned.dta

tab _merge if hgc != .

drop if _merge == 2

drop _merge

gen age_grad = .

replace age_grad = gradyear - tbyear

tab age_grad


capture drop pid

egen pid=group(ssuid eentaid epppnum)
*bysort su_id pp_entry pp_pnum: gen pid = _n

drop ssuid eentaid epppnum

drop earnings_job* earnings_se* tbyear

capture drop *month*

reshape long total_hours survey_weight age male hispanic black earnings_annual hrlypay hrlypayv1 hrlypayv2 enrolled west northeast midwest south employed fulltime occ1_ occ2_ occ3_ occ4_ occ5_ occ6_ occ7_ occ8_ occ9_ occ10_ occ11_ occ12_ ind1_ ind2_ ind3_ ind4_ ind5_ ind6_ ind7_ ind8_ ind9_ ind10_ ind11_ ind12_, i(pid) j(year)

forvalues k=1(1)12 {
rename occ`k'_ occ`k'
rename ind`k'_ ind`k'
}


* keep if age >= 22

* keep if major_field != .
tab major_field, mi
tab major_field if hgc == 16
tab gradyear
gen potexp = year - gradyear
tab potexp

tab gradyear potexp if hgc == 16 & potexp <= 13

sum

gen panel = 1996
gen survey = 9697

sort pid


compress
save Temp/sipp96_ready.dta, replace


clear






/* Now 2001 */


use Temp/sipp01_core1.dta

forvalues k=1(1)9 {

use "Temp/sipp01_core`k'.dta"


gen refmonth = (swave-1)*4 + srefmon

tab refmonth


/* The goal is to rename variables to what they are for pre-1996 data, so I can use the same files I used for those */

rename tage age

gen male = (esex == 1)

gen hispanic = (eorigin >= 20 & eorigin <= 28)
gen black = (erace == 2 & hispanic != 1)


/* Earnings */
rename tpmsum1 earnings_job1_month
rename tpmsum2 earnings_job2_month

gen earnings_se1_month = 0
gen earnings_se2_month = 0



/* wages */
rename tpyrate1 wage_month


/* Usual hours per month */
rename ejbhrs1 hours_job1_month
rename ejbhrs2 hours_job2_month


/* Enrollment */
rename eenrlm enrl_m

replace enrl_m = 0 if enrl_m == -1 | enrl_m == 2



/* State of residence */
rename tfipsst state



/* Survey weight */
rename wpfinwgt weight

/* Will need to take avg of weights across the months in a year */


/* Employed */
rename rmwkwjb wksem_month

replace wksem_month = 0 if wksem_month < 0



/* Occupation and industry */
rename tjbocc1 occ1_month
rename ejbind1 ind1_month


rename srotaton rot



keep refmonth age male hispanic black earnings_job* wage_month hours_job* enrl_m state weight wksem_month occ1_month ind1_month ssuid eentaid epppnum rot tbyear

egen pid= group(ssuid eentaid epppnum)

reshape wide age male hispanic black earnings_job1_month earnings_job2_month hours_job1_month hours_job2_month wage_month enrl_m state weight wksem_month occ1_month ind1_month, i(pid) j(refmonth)

sort ssuid eentaid epppnum
compress
save "Temp/sipp01_core`k'_personrecord.dta", replace

clear

}


clear

use Temp/sipp01_core1_personrecord.dta


forvalues k=2(1)9 {
sort ssuid eentaid epppnum
merge ssuid eentaid epppnum using "Temp/sipp01_core`k'_personrecord.dta"

tab _merge
drop _merge

}


compress
save Temp/sipp01_full.dta, replace

* JA: Sometimes "hours_job1" = -8,
*  which means "hours vary" for now, just drop these obs
forvalues k=1(1)36 {
	foreach X in state`k' weight`k' age`k' enrl_m`k' wksem_month`k' earnings_job1_month`k' wage_month`k' ind1_month`k' occ1_month`k' hours_job2_month`k' earnings_job2_month`k' male`k' hispanic`k' black1 {
		qui replace `X'=. if hours_job1_month`k'==-8
	}
	qui replace hours_job1_month`k'=. if hours_job1_month`k'==-8

	qui replace earnings_job2_month`k'=. if hours_job2_month`k'==-8
	qui replace hours_job2_month`k'=.    if hours_job2_month`k'==-8
}


/* Age at survey */
gen age2001 = age3
gen age2002 = age15
gen age2003 = age27


/* Gender */
gen male2001 = male1
gen male2002 = male1
gen male2003 = male1


/* Race */
gen hispanic2001 = hispanic1
gen hispanic2002 = hispanic1
gen hispanic2003 = hispanic1

gen black2001 = black1
gen black2002 = black1
gen black2003 = black1


forvalues k=2(1)36 {
forvalues j=2001(1)2003 {
replace male`j' = male`k' if male`j' == .
replace black`j' = black`k' if black`j' == .
replace hispanic`j' = hispanic`k' if hispanic`j' == .
}
}


gen months_seen2001 = 0
gen months_seen2002 = 0
gen months_seen2003 = 0


/* Each wave asks about the past four months */

/*
/* We see everyone through all of 2001 */
replace months_seen2001 = 12 if rot == 2
replace months_seen2001 = 12 if rot == 3
replace months_seen2001 = 12 if rot == 4
replace months_seen2001 = 12 if rot == 1


/* We see everyone through all of 2002 */
replace months_seen2002 = 12 if rot == 2
replace months_seen2002 = 12 if rot == 3
replace months_seen2002 = 12 if rot == 4
replace months_seen2002 = 12 if rot == 1

/* We don't see everyone through all of 2003 */
replace months_seen2003 = 10 if rot == 2
replace months_seen2003 = 11 if rot == 3
replace months_seen2003 = 12 if rot == 4
replace months_seen2003 = 9 if rot == 1
*/


forvalues k=4(1)15 {
replace months_seen2001 = months_seen2001 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}

forvalues k=16(1)27 {
replace months_seen2002 = months_seen2002 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}

forvalues k=28(1)36 {
replace months_seen2003 = months_seen2003 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}




forvalues k=3(1)14 {
replace months_seen2001 = months_seen2001 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}

forvalues k=15(1)26 {
replace months_seen2002 = months_seen2002 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}

forvalues k=27(1)36 {
replace months_seen2003 = months_seen2003 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}





forvalues k=2(1)13 {
replace months_seen2001 = months_seen2001 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}

forvalues k=14(1)25 {
replace months_seen2002 = months_seen2002 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}

forvalues k=26(1)36 {
replace months_seen2003 = months_seen2003 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}




forvalues k=1(1)12 {
replace months_seen2001 = months_seen2001 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}

forvalues k=13(1)24 {
replace months_seen2002 = months_seen2002 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}

forvalues k=25(1)36 {
replace months_seen2003 = months_seen2003 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}




/* Enrollment */
/* Enrolled? */

/* I will code you as enrolled in the year if you are enrolled at least 2 months of the year */
gen months_enrolled2001 = 0
gen months_enrolled2002 = 0
gen months_enrolled2003 = 0



forvalues k=4(1)15 {
replace months_enrolled2001 = months_enrolled2001 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=16(1)27 {
replace months_enrolled2002 = months_enrolled2002 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=28(1)36 {
replace months_enrolled2003 = months_enrolled2003 + 1 if enrl_m`k' == 1 & rot == 1
}




forvalues k=3(1)14 {
replace months_enrolled2001 = months_enrolled2001 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=15(1)26 {
replace months_enrolled2002 = months_enrolled2002 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=27(1)36 {
replace months_enrolled2003 = months_enrolled2003 + 1 if enrl_m`k' == 1 & rot == 2
}





forvalues k=2(1)13 {
replace months_enrolled2001 = months_enrolled2001 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=14(1)25 {
replace months_enrolled2002 = months_enrolled2002 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=26(1)36 {
replace months_enrolled2003 = months_enrolled2003 + 1 if enrl_m`k' == 1 & rot == 3
}




forvalues k=1(1)12 {
replace months_enrolled2001 = months_enrolled2001 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=13(1)24 {
replace months_enrolled2002 = months_enrolled2002 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=25(1)36 {
replace months_enrolled2003 = months_enrolled2003 + 1 if enrl_m`k' == 1 & rot == 4
}





gen enrolled2001 = (months_enrolled2001/months_seen2001)
gen enrolled2002 = (months_enrolled2002/months_seen2002)
gen enrolled2003 = (months_enrolled2003/months_seen2003)

sum enrolled*
sum months_enrolled*










/**** ANNUAL EARNINGS ****/

/* Earnings are by month. Month #s to actual month mapping differs by rotation group */


forvalues k=1(1)36 {
replace earnings_job1_month`k' = 0 if earnings_job1_month`k' < 0 | earnings_job1_month`k' == .
replace earnings_job2_month`k' = 0 if earnings_job2_month`k' < 0 | earnings_job2_month`k' == .
gen earnings_se1_month`k' = 0
gen earnings_se2_month`k' = 0

}


gen earnings_job1_2001 = 0
gen earnings_job1_2002 = 0
gen earnings_job1_2003 = 0

gen earnings_job2_2001 = 0
gen earnings_job2_2002 = 0
gen earnings_job2_2003 = 0

gen earnings_se1_2001 = 0
gen earnings_se1_2002 = 0
gen earnings_se1_2003 = 0

gen earnings_se2_2001 = 0
gen earnings_se2_2002 = 0
gen earnings_se2_2003 = 0


gen earnings_annual2001 = 0
gen earnings_annual2002 = 0
gen earnings_annual2003 = 0




/* Rotation group 1: 2001 is months 2-13, 2002 is months 14-25, 2003 is 26-37, 2004 is 38-48 */
forvalues k=4(1)15 {
replace earnings_annual2001 = earnings_annual2001 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=16(1)27 {
replace earnings_annual2002 = earnings_annual2002 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=28(1)36 {
replace earnings_annual2003 = earnings_annual2003 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}




replace earnings_annual2001 = (earnings_annual2001/(months_seen2001-months_enrolled2001)) * 12  if rot == 1
replace earnings_annual2002 = (earnings_annual2002/(months_seen2002-months_enrolled2002)) * 12  if rot == 1
replace earnings_annual2003 = (earnings_annual2003/(months_seen2003-months_enrolled2003)) * 12  if rot == 1

replace earnings_annual2001 = 0 if months_enrolled2001 == months_seen2001 & rot == 1
replace earnings_annual2002 = 0 if months_enrolled2002 == months_seen2002 & rot == 1
replace earnings_annual2003 = 0 if months_enrolled2003 == months_seen2003 & rot == 1







/* Rotation group 2: 2001 is months 1-12, 2002 is months 13-24, 2003 is 25-36, 2004 is 37-48 */
forvalues k=3(1)14 {
replace earnings_annual2001 = earnings_annual2001 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=15(1)26 {
replace earnings_annual2002 = earnings_annual2002 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=27(1)36 {
replace earnings_annual2003 = earnings_annual2003 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}




replace earnings_annual2001 = (earnings_annual2001/(months_seen2001-months_enrolled2001)) * 12  if rot == 2
replace earnings_annual2002 = (earnings_annual2002/(months_seen2002-months_enrolled2002)) * 12  if rot == 2
replace earnings_annual2003 = (earnings_annual2003/(months_seen2003-months_enrolled2003)) * 12  if rot == 2

replace earnings_annual2001 = 0 if months_enrolled2001 == months_seen2001 & rot == 2
replace earnings_annual2002 = 0 if months_enrolled2002 == months_seen2002 & rot == 2
replace earnings_annual2003 = 0 if months_enrolled2003 == months_seen2003 & rot == 2







/* Rotation group 3: 2001 is months 1-11, 2002 is months 12-23, 2003 is 24-35, 2004 is 36-47 */
forvalues k=2(1)13 {
replace earnings_annual2001 = earnings_annual2001 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=14(1)25 {
replace earnings_annual2002 = earnings_annual2002 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=26(1)36 {
replace earnings_annual2003 = earnings_annual2003 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}



replace earnings_annual2001 = (earnings_annual2001/(months_seen2001-months_enrolled2001)) * 12  if rot == 3
replace earnings_annual2002 = (earnings_annual2002/(months_seen2002-months_enrolled2002)) * 12  if rot == 3
replace earnings_annual2003 = (earnings_annual2003/(months_seen2003-months_enrolled2003)) * 12  if rot == 3

replace earnings_annual2001 = 0 if months_enrolled2001 == months_seen2001 & rot == 3
replace earnings_annual2002 = 0 if months_enrolled2002 == months_seen2002 & rot == 3
replace earnings_annual2003 = 0 if months_enrolled2003 == months_seen2003 & rot == 3





/* Rotation group 4: 2001 is months 1-10, 2002 is months 11-22, 2003 is 22-34, 2004 is 35-46 */
forvalues k=1(1)12 {
replace earnings_annual2001 = earnings_annual2001 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=13(1)24 {
replace earnings_annual2002 = earnings_annual2002 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=25(1)36 {
replace earnings_annual2003 = earnings_annual2003 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}




replace earnings_annual2001 = (earnings_annual2001/(months_seen2001-months_enrolled2001)) * 12  if rot == 4
replace earnings_annual2002 = (earnings_annual2002/(months_seen2002-months_enrolled2002)) * 12  if rot == 4
replace earnings_annual2003 = (earnings_annual2003/(months_seen2003-months_enrolled2003)) * 12  if rot == 4

replace earnings_annual2001 = 0 if months_enrolled2001 == months_seen2001 & rot == 4
replace earnings_annual2002 = 0 if months_enrolled2002 == months_seen2002 & rot == 4
replace earnings_annual2003 = 0 if months_enrolled2003 == months_seen2003 & rot == 4


sum earnings_annual*

bysort rot: sum earnings_annual*






/**** WAGES ****/
/* For hourly workers, we actually have an hourly rate of pay variable */

/* Annual wage measure will be the average of the non-missing wage measures in the year (for job 1 only) */

/* Need to get # of non-missing wage measures each year */
gen wage_count2001 = 0
gen wage_count2002 = 0
gen wage_count2003 = 0

forvalues k=4(1)15 {
replace wage_count2001 = wage_count2001 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=16(1)27 {
replace wage_count2002 = wage_count2002 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=28(1)36 {
replace wage_count2003 = wage_count2003 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}



forvalues k=3(1)14 {
replace wage_count2001 = wage_count2001 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=15(1)26 {
replace wage_count2002 = wage_count2002 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=27(1)36 {
replace wage_count2003 = wage_count2003 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}





forvalues k=2(1)13 {
replace wage_count2001 = wage_count2001 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=14(1)25 {
replace wage_count2002 = wage_count2002 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=26(1)36 {
replace wage_count2003 = wage_count2003 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}




forvalues k=1(1)12 {
replace wage_count2001 = wage_count2001 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=13(1)24 {
replace wage_count2002 = wage_count2002 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=25(1)36 {
replace wage_count2003 = wage_count2003 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}





/* Now, we construct the annual wage measure */
gen hrlypay2001 = .
gen hrlypay2002 = .
gen hrlypay2003 = .

gen hrlypayv12001 = .
gen hrlypayv12002 = .
gen hrlypayv12003 = .

gen hrlypayv22001 = .
gen hrlypayv22002 = .
gen hrlypayv22003 = .



gen total_wage2001 = 0
gen total_wage2002 = 0
gen total_wage2003 = 0


forvalues k=4(1)15 {
replace total_wage2001 = total_wage2001 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=16(1)27 {
replace total_wage2002 = total_wage2002 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=26(1)36 {
replace total_wage2003 = total_wage2003 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}




forvalues k=3(1)14 {
replace total_wage2001 = total_wage2001 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=15(1)26 {
replace total_wage2002 = total_wage2002 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=27(1)36 {
replace total_wage2003 = total_wage2003 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}





forvalues k=2(1)13 {
replace total_wage2001 = total_wage2001 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=14(1)25 {
replace total_wage2002 = total_wage2002 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=26(1)36 {
replace total_wage2003 = total_wage2003 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}




forvalues k=1(1)12 {
replace total_wage2001 = total_wage2001 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=13(1)24 {
replace total_wage2002 = total_wage2002 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=25(1)36 {
replace total_wage2003 = total_wage2003 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}






replace hrlypayv12001 = total_wage2001/wage_count2001 
replace hrlypayv12002 = total_wage2002/wage_count2002
replace hrlypayv12003 = total_wage2003/wage_count2003 

sum hrlypay*

drop total_wage* wage_count* wage_month*





/* Alternative if you don't work by the hour: get earnings/hours */
forvalues k=1(1)36 {
replace hours_job1_month`k' = 0 if hours_job1_month`k' < 0
replace hours_job2_month`k' = 0 if hours_job2_month`k' < 0
}



/* Need to get # of non-missing hours measures each year */
gen hours_count2001 = 0
gen hours_count2002 = 0
gen hours_count2003 = 0

forvalues k=4(1)15 {
replace hours_count2001 = hours_count2001 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=16(1)27 {
replace hours_count2002 = hours_count2002 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=28(1)36 {
replace hours_count2003 = hours_count2003 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}




forvalues k=3(1)14 {
replace hours_count2001 = hours_count2001 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=15(1)26 {
replace hours_count2002 = hours_count2002 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=27(1)36 {
replace hours_count2003 = hours_count2003 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}





forvalues k=2(1)13 {
replace hours_count2001 = hours_count2001 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=14(1)25 {
replace hours_count2002 = hours_count2002 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=26(1)36 {
replace hours_count2003 = hours_count2003 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}



forvalues k=1(1)12 {
replace hours_count2001 = hours_count2001 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=13(1)24 {
replace hours_count2002 = hours_count2002 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=25(1)36 {
replace hours_count2003 = hours_count2003 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}




gen total_hours2001 = 0
gen total_hours2002 = 0
gen total_hours2003 = 0


forvalues k=4(1)15 {
replace total_hours2001 = total_hours2001 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=16(1)27 {
replace total_hours2002 = total_hours2002 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=28(1)36 {
replace total_hours2003 = total_hours2003 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}




forvalues k=3(1)14 {
replace total_hours2001 = total_hours2001 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=15(1)26 {
replace total_hours2002 = total_hours2002 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=27(1)36 {
replace total_hours2003 = total_hours2003 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}





forvalues k=2(1)13 {
replace total_hours2001 = total_hours2001 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=14(1)25 {
replace total_hours2002 = total_hours2002 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=26(1)36 {
replace total_hours2003 = total_hours2003 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}




forvalues k=1(1)12 {
replace total_hours2001 = total_hours2001 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=13(1)24 {
replace total_hours2002 = total_hours2002 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=25(1)36 {
replace total_hours2003 = total_hours2003 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}





replace hrlypayv22001 = earnings_annual2001 / total_hours2001
replace hrlypayv22002 = earnings_annual2002 / total_hours2002
replace hrlypayv22003 = earnings_annual2003 / total_hours2003

forvalues k=2001(1)2003 {
replace hrlypay`k' = hrlypayv1`k'
replace hrlypay`k' = hrlypayv2`k' if hrlypay`k' == . | hrlypay`k' == 0
}


sum hrlypay*





sum age2001 age2002 age2003

sum black* hispanic*

sum hrlypay*, d






/* State and region */
/* I take the state from the first wave as the state for 2001 and the fourth wave for 2002, 7th for 2003, 10th for 2004 */
rename state5 state

gen west = 0
gen northeast = 0
gen midwest = 0
gen south = 0

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west2001 = west
gen northeast2001 = northeast
gen midwest2001 = midwest
gen south2001 = south

rename state state_ba_degree 



/* state4 is the state from the 4th wave, which is in the second year */
rename state17 state

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west2002 = west
gen northeast2002 = northeast
gen midwest2002 = midwest
gen south2002 = south

drop state


/* 2003 */
rename state29 state

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west2003 = west
gen northeast2003 = northeast
gen midwest2003 = midwest
gen south2003 = south

drop state west northeast south


/* Division of degree */
gen ba_newengland = 0
gen ba_midatlantic = 0
gen ba_eastnorthcentral = 0
gen ba_westnorthcentral = 0
gen ba_southatlantic = 0
gen ba_eastsouthcentral = 0
gen ba_westsouthcentral = 0
gen ba_mountain = 0
gen ba_pacific = 0


replace ba_newengland = 1 if state_ba_degree == 9 | state_ba_degree == 25 | state_ba_degree == 33  | state_ba_degree == 44 | state_ba_degree == 23 | state_ba_degree == 50 | state_ba_degree == 61
replace ba_midatlantic = 1 if state_ba_degree == 34 | state_ba_degree == 36 | state_ba_degree == 42
replace ba_eastnorthcentral = 1 if  state_ba_degree == 55 | state_ba_degree == 39 | state_ba_degree == 26 | state_ba_degree == 18 | state_ba_degree == 17
replace ba_westnorthcentral = 1 if state_ba_degree == 62 | state_ba_degree == 19 | state_ba_degree == 38 | state_ba_degree == 46 | state_ba_degree == 31| state_ba_degree == 20 | state_ba_degree == 29 | state_ba_degree == 27
replace ba_southatlantic = 1 if state_ba_degree == 10 | state_ba_degree == 11 | state_ba_degree == 24 | state_ba_degree == 54 | state_ba_degree == 51 | state_ba_degree == 37 | state_ba_degree == 45 | state_ba_degree == 12 | state_ba_degree == 13
replace ba_eastsouthcentral = 1 if state_ba_degree == 28 | state_ba_degree == 21 | state_ba_degree == 47 | state_ba_degree == 1
replace ba_westsouthcentral = 1 if state_ba_degree == 5 | state_ba_degree == 22 | state_ba_degree == 40 | state_ba_degree == 48
replace ba_mountain = 1 if state_ba_degree == 4 | state_ba_degree == 8 | state_ba_degree == 16 | state_ba_degree == 30 | state_ba_degree == 32 | state_ba_degree == 35 | state_ba_degree == 49 | state_ba_degree == 56
replace ba_pacific = 1 if state_ba_degree == 2 | state_ba_degree == 15 | state_ba_degree == 6 | state_ba_degree == 41 | state_ba_degree == 53







/* Survey weights */
/* I need to average the weights for each month over the year to get the annual weight */
forvalues k=1(1)36 {
replace weight`k' = 0 if weight`k' <= 0 | weight`k' == .
}

gen survey_weight2001 = .
gen survey_weight2002 = .
gen survey_weight2003 = .

replace survey_weight2001 = (weight4+weight5+weight6+weight7+weight8+weight9+weight10+weight11+weight12+weight13+weight14+weight15)/months_seen2001 if rot == 1
replace survey_weight2001 = (weight3+weight4+weight5+weight6+weight7+weight8+weight9+weight10+weight11+weight12+weight13+weight14)/months_seen2001 if rot == 2
replace survey_weight2001 = (weight2+weight3+weight4+weight5+weight6+weight7+weight8+weight9+weight10+weight11+weight12+weight13)/months_seen2001 if rot == 3
replace survey_weight2001 = (weight1+weight2+weight3+weight4+weight5+weight6+weight7+weight8+weight9+weight10+weight11+weight12)/months_seen2001 if rot == 4

replace survey_weight2002 = (weight16+weight17+weight18+weight19+weight20+weight21+weight22+weight23+weight24+weight25+weight26+weight27)/months_seen2002 if rot == 1
replace survey_weight2002 = (weight15+weight16+weight17+weight18+weight19+weight20+weight21+weight22+weight23+weight24+weight25+weight26)/months_seen2002 if rot == 2
replace survey_weight2002 = (weight14+weight15+weight16+weight17+weight18+weight19+weight20+weight21+weight22+weight23+weight24+weight25)/months_seen2002 if rot == 3
replace survey_weight2002 = (weight13+weight14+weight15+weight16+weight17+weight18+weight19+weight20+weight21+weight22+weight23+weight24)/months_seen2002 if rot == 4

replace survey_weight2003 = (weight28+weight29+weight30+weight31+weight32+weight33+weight34+weight35+weight36)/months_seen2003 if rot == 1
replace survey_weight2003 = (weight27+weight28+weight29+weight30+weight31+weight32+weight33+weight34+weight35+weight36)/months_seen2003 if rot == 2
replace survey_weight2003 = (weight26+weight27+weight28+weight29+weight30+weight31+weight32+weight33+weight34+weight35+weight36)/months_seen2003 if rot == 3
replace survey_weight2003 = (weight25+weight26+weight27+weight28+weight29+weight30+weight31+weight32+weight33+weight34+weight35+weight36)/months_seen2003 if rot == 4


drop weight*


/* Are you employed? */
/* How should I do this? I have 12 observations per year */
/* For now, what I do (also for occupation and industry and full-time) is take the middle months of the person's year */

gen employed2001 = 0
gen employed2002 = 0
gen employed2003 = 0

/* Group 1 */
forvalues k=4(1)15 {
replace employed2001 = employed2001 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 1
}

forvalues k=16(1)27 {
replace employed2002 = employed2002 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 1
}

forvalues k=28(1)36 {
replace employed2003 = employed2003 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 1
}




/* Group 2 */
forvalues k=3(1)14 {
replace employed2001 = employed2001 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 2
}

forvalues k=15(1)26 {
replace employed2002 = employed2002 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 2
}

forvalues k=27(1)36 {
replace employed2003 = employed2003 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 2
}




/* Group 3 */
forvalues k=2(1)13 {
replace employed2001 = employed2001 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 3
}

forvalues k=14(1)25 {
replace employed2002 = employed2002 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 3
}

forvalues k=26(1)36 {
replace employed2003 = employed2003 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 3
}




/* Group 4 */
forvalues k=1(1)12 {
replace employed2001 = employed2001 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 4
}

forvalues k=13(1)24 {
replace employed2002 = employed2002 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 4
}

forvalues k=25(1)36 {
replace employed2003 = employed2003 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 4
}




replace employed2001 = employed2001 / (months_seen2001 - months_enrolled2001)
replace employed2002 = employed2002 / (months_seen2002 - months_enrolled2002)
replace employed2003 = employed2003 / (months_seen2003 - months_enrolled2003)



sum employed*



/* Are you full-time? */

gen fulltime2001 = 0
gen fulltime2002 = 0
gen fulltime2003 = 0

/* Group 1 */
forvalues k=4(1)15 {
replace fulltime2001 = fulltime2001 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=16(1)27 {
replace fulltime2002 = fulltime2002 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=28(1)36 {
replace fulltime2003 = fulltime2003 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}



/* Group 2 */
forvalues k=3(1)14 {
replace fulltime2001 = fulltime2001 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=15(1)26 {
replace fulltime2002 = fulltime2002 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=27(1)36 {
replace fulltime2003 = fulltime2003 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}




/* Group 3 */
forvalues k=2(1)13 {
replace fulltime2001 = fulltime2001 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=14(1)25 {
replace fulltime2002 = fulltime2002 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=26(1)36 {
replace fulltime2003 = fulltime2003 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}




/* Group 4 */
forvalues k=1(1)12 {
replace fulltime2001 = fulltime2001 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=13(1)24 {
replace fulltime2002 = fulltime2002 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=25(1)36 {
replace fulltime2003 = fulltime2003 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}




replace fulltime2001 = fulltime2001 / (months_seen2001 - months_enrolled2001)
replace fulltime2002 = fulltime2002 / (months_seen2002 - months_enrolled2002)
replace fulltime2003 = fulltime2003 / (months_seen2003 - months_enrolled2003)



sum fulltime*




/* OCCUPATION */

/* THESE ARE ??? 4-DIGIT CODES */
forvalues k=1(1)36 {
replace occ1_month`k' = . if occ1_month`k' == 0 | occ1_month`k' == 905 | occ1_month`k' < 0
}

forvalues k=1(1)12 {
gen occ`k'_2001 = .
gen occ`k'_2002 = .
gen occ`k'_2003 = .
}



forvalues k=4(1)15 {
local j = `k' - 3
replace occ`j'_2001 = occ1_month`k' if rot == 1
}

forvalues k=16(1)27 {
local j = `k' - 15
replace occ`j'_2002 = occ1_month`k' if rot == 1
}

forvalues k=28(1)36 {
local j = `k' - 27
replace occ`j'_2003 = occ1_month`k' if rot == 1
}




forvalues k=3(1)14 {
local j = `k' - 2
replace occ`j'_2001 = occ1_month`k' if rot == 2
}

forvalues k=15(1)26 {
local j = `k' - 14
replace occ`j'_2002 = occ1_month`k' if rot == 2
}

forvalues k=27(1)36 {
local j = `k' - 26
replace occ`j'_2003 = occ1_month`k' if rot == 2
}




forvalues k=2(1)13 {
local j = `k' - 1
replace occ`j'_2001 = occ1_month`k' if rot == 3
}

forvalues k=14(1)25 {
local j = `k' - 13
replace occ`j'_2002 = occ1_month`k' if rot == 3
}

forvalues k=26(1)36 {
local j = `k' - 25
replace occ`j'_2003 = occ1_month`k' if rot == 3
}




forvalues k=1(1)12 {
local j = `k' - 0
replace occ`j'_2001 = occ1_month`k' if rot == 4
}

forvalues k=13(1)24 {
local j = `k' - 12
replace occ`j'_2002 = occ1_month`k' if rot == 4
}

forvalues k=25(1)36 {
local j = `k' - 24
replace occ`j'_2003 = occ1_month`k' if rot == 4
}








/* INDUSTRY */
/* I use the 6th month industry as the industry. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE ??? 4-DIGIT CODES */
forvalues k=1(1)36 {
replace ind1_month`k' = . if ind1_month`k' == 0 | ind1_month`k' == 905 | ind1_month`k' < 0
}



forvalues k=1(1)12 {
gen ind`k'_2001 = .
gen ind`k'_2002 = .
gen ind`k'_2003 = .
}



forvalues k=4(1)15 {
local j = `k' - 3
replace ind`j'_2001 = ind1_month`k' if rot == 1
}

forvalues k=16(1)27 {
local j = `k' - 15
replace ind`j'_2002 = ind1_month`k' if rot == 1
}

forvalues k=28(1)36 {
local j = `k' - 27
replace ind`j'_2003 = ind1_month`k' if rot == 1
}




forvalues k=3(1)14 {
local j = `k' - 2
replace ind`j'_2001 = ind1_month`k' if rot == 2
}

forvalues k=15(1)26 {
local j = `k' - 14
replace ind`j'_2002 = ind1_month`k' if rot == 2
}

forvalues k=27(1)36 {
local j = `k' - 26
replace ind`j'_2003 = ind1_month`k' if rot == 2
}




forvalues k=2(1)13 {
local j = `k' - 1
replace ind`j'_2001 = ind1_month`k' if rot == 3
}

forvalues k=14(1)25 {
local j = `k' - 13
replace ind`j'_2002 = ind1_month`k' if rot == 3
}

forvalues k=26(1)36 {
local j = `k' - 25
replace ind`j'_2003 = ind1_month`k' if rot == 3
}




forvalues k=1(1)12 {
local j = `k' - 0
replace ind`j'_2001 = ind1_month`k' if rot == 4
}

forvalues k=13(1)24 {
local j = `k' - 12
replace ind`j'_2002 = ind1_month`k' if rot == 4
}

forvalues k=25(1)36 {
local j = `k' - 24
replace ind`j'_2003 = ind1_month`k' if rot == 4
}





drop *month*

bysort rot: sum ind* occ*



/* Identifying variables */
keep *2001 *2002 *2003 ssuid eentaid epppnum rot tbyear state_ba* ba_*

sort ssuid eentaid epppnum
compress
save Temp/sipp01_full_cleaned.dta, replace


*************************************************************************************

clear

use Temp/sipp01wave2.dta


/**** WAVE 2 DATASET ****/



/* Identifiers */
sum ssuid eentaid epppnum



/********** COLLEGE DEGREE INFORMATION *********/

/* 2 questions: highest degree and BA degree. Need to check both */

/* Need year of degree, age at degree, and field of degree. Also need highest degree completed */


gen col = 0
gen morcol = 0
gen hgc = .

replace hgc = 0    if eattain == 31
replace hgc = 2.5  if eattain == 32
replace hgc = 5.5  if eattain == 33
replace hgc = 7.5  if eattain == 34
replace hgc = 9    if eattain == 35
replace hgc = 10   if eattain == 36
replace hgc = 11   if eattain == 37
replace hgc = 11.5 if eattain == 38
replace hgc = 12   if eattain == 39
replace hgc = 13   if eattain == 40
replace hgc = 13.5 if eattain == 41
replace hgc = 14   if eattain == 42
replace hgc = 14   if eattain == 43
replace hgc = 16   if eattain == 44
replace hgc = 18   if eattain == 45
replace hgc = 19   if eattain == 46
replace hgc = 20   if eattain == 47

tab hgc, mi

replace col = 1 if hgc == 16
replace morcol = 1 if hgc > 16 & hgc != .

drop if hgc == .


tab col morcol


gen gradyear = .


replace gradyear = tbachyr if tbachyr > 0

tab gradyear




/* Field of bachelor's degree */

rename ebachfld major_field
replace major_field = . if major_field == -1

tab major_field if hgc == 16
tab major_field if hgc > 16 & hgc != .


tab hgc


keep hgc major_field gradyear col morcol ssuid eentaid epppnum


sort ssuid eentaid epppnum



merge ssuid eentaid epppnum using Temp/sipp01_full_cleaned.dta

tab _merge if hgc != .
drop if _merge == 2
drop _merge

gen age_grad = .

replace age_grad = gradyear - tbyear

tab age_grad


capture drop pid

egen pid=group(ssuid eentaid epppnum)
*bysort su_id pp_entry pp_pnum: gen pid = _n

drop ssuid eentaid epppnum

drop earnings_job* earnings_se* tbyear

capture drop *month*

reshape long total_hours survey_weight age male hispanic black earnings_annual hrlypay hrlypayv1 hrlypayv2 enrolled west northeast midwest south employed fulltime occ1_ occ2_ occ3_ occ4_ occ5_ occ6_ occ7_ occ8_ occ9_ occ10_ occ11_ occ12_ ind1_ ind2_ ind3_ ind4_ ind5_ ind6_ ind7_ ind8_ ind9_ ind10_ ind11_ ind12_, i(pid) j(year)

forvalues k=1(1)12 {
rename occ`k'_ occ`k'
rename ind`k'_ ind`k'
}


* keep if age >= 22

* keep if major_field != .
tab major_field, mi
tab major_field if hgc == 16
tab gradyear
gen potexp = year - gradyear
tab potexp

tab gradyear potexp if hgc == 16 & potexp <= 13

sum

gen panel = 2001
gen survey = 0102

sort pid
compress
save Temp/sipp01_ready.dta, replace






/* 2004 */



forvalues k=1(1)12 {

use "Temp/sipp04_core`k'.dta"


gen refmonth = (swave-1)*4 + srefmon

tab refmonth


/* The goal is to rename variables to what they are for pre-1996 data, so I can use the same files I used for those */

rename tage age

gen male = (esex == 1)

* gen hispanic = (eorigin >= 20 & eorigin <= 28)
gen hispanic = (eorigin==1)
gen black = (erace == 2 & hispanic != 1)


/* Earnings */
rename tpmsum1 earnings_job1_month
rename tpmsum2 earnings_job2_month

gen earnings_se1_month = 0
gen earnings_se2_month = 0



/* wages */
rename tpyrate1 wage_month


/* Usual hours per month */
rename ejbhrs1 hours_job1_month
rename ejbhrs2 hours_job2_month


/* Enrollment */
rename eenrlm enrl_m

replace enrl_m = 0 if enrl_m == -1 | enrl_m == 2



/* State of residence */
rename tfipsst state



/* Survey weight */
rename wpfinwgt weight

/* Will need to take avg of weights across the months in a year */


/* Employed */
rename rmwkwjb wksem_month

replace wksem_month = 0 if wksem_month < 0



/* Occupation and industry */
rename tjbocc1 occ1_month
rename ejbind1 ind1_month


rename srotaton rot



keep refmonth age male hispanic black earnings_job* wage_month hours_job* enrl_m state weight wksem_month occ1_month ind1_month ssuid eentaid epppnum rot tbyear

egen pid= group(ssuid eentaid epppnum)

reshape wide age male hispanic black earnings_job1_month earnings_job2_month hours_job1_month hours_job2_month wage_month enrl_m state weight wksem_month occ1_month ind1_month, i(pid) j(refmonth)

sort ssuid eentaid epppnum
compress
save "Temp/sipp04_core`k'_personrecord.dta", replace

clear

}


clear

use Temp/sipp04_core1_personrecord.dta


forvalues k=2(1)12 {
sort ssuid eentaid epppnum
merge ssuid eentaid epppnum using "Temp/sipp04_core`k'_personrecord.dta"

tab _merge

drop _merge

}


compress
save Temp/sipp04_full.dta, replace

* JA: Sometimes "hours_job1" = -8,
*  which means "hours vary" for now, just drop these obs
forvalues k=1(1)48 {
	foreach X in state`k' weight`k' age`k' enrl_m`k' wksem_month`k' earnings_job1_month`k' wage_month`k' ind1_month`k' occ1_month`k' hours_job2_month`k' earnings_job2_month`k' male`k' hispanic`k' black1 {
		qui replace `X'=. if hours_job1_month`k'==-8
	}
	qui replace hours_job1_month`k'=. if hours_job1_month`k'==-8

	qui replace earnings_job2_month`k'=. if hours_job2_month`k'==-8
	qui replace hours_job2_month`k'=.    if hours_job2_month`k'==-8
}


/* Age at survey */
gen age2004 = age3
gen age2005 = age15
gen age2006 = age27
gen age2007 = age39


/* Gender */
gen male2004 = male1
gen male2005 = male1
gen male2006 = male1
gen male2007 = male1


/* Race */
gen hispanic2004 = hispanic1
gen hispanic2005 = hispanic1
gen hispanic2006 = hispanic1
gen hispanic2007 = hispanic1

gen black2004 = black1
gen black2005 = black1
gen black2006 = black1
gen black2007 = black1


forvalues k=2(1)48 {
forvalues j=2004(1)2007 {
replace male`j' = male`k' if male`j' == .
replace black`j' = black`k' if black`j' == .
replace hispanic`j' = hispanic`k' if hispanic`j' == .
}
}



gen months_seen2004 = 0
gen months_seen2005 = 0
gen months_seen2006 = 0
gen months_seen2007 = 0


/* Each wave asks about the past four months */

/* The first survey is in April 2004, so we don't have obs for many people in 1995 */

/*
/* We see everyone through all of 2004 */
replace months_seen2004 = 12 if rot == 2
replace months_seen2004 = 12 if rot == 3
replace months_seen2004 = 12 if rot == 4
replace months_seen2004 = 12 if rot == 1


/* We see everyone through all of 2005 */
replace months_seen2005 = 12 if rot == 2
replace months_seen2005 = 12 if rot == 3
replace months_seen2005 = 12 if rot == 4
replace months_seen2005 = 12 if rot == 1

/* We see everyone through all of 2006 */
replace months_seen2006 = 12 if rot == 2
replace months_seen2006 = 12 if rot == 3
replace months_seen2006 = 12 if rot == 4
replace months_seen2006 = 12 if rot == 1

/* We don't see everyone through all of 2007 */
replace months_seen2007 = 10 if rot == 2
replace months_seen2007 = 11 if rot == 3
replace months_seen2007 = 12 if rot == 4
replace months_seen2007 = 9 if rot == 1
*/



forvalues k=4(1)15 {
replace months_seen2004 = months_seen2004 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}

forvalues k=16(1)27 {
replace months_seen2005 = months_seen2005 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}

forvalues k=28(1)39 {
replace months_seen2006 = months_seen2006 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}

forvalues k=40(1)48 {
replace months_seen2007 = months_seen2007 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}


forvalues k=3(1)14 {
replace months_seen2004 = months_seen2004 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}

forvalues k=15(1)26 {
replace months_seen2005 = months_seen2005 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}

forvalues k=27(1)38 {
replace months_seen2006 = months_seen2006 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}

forvalues k=39(1)48 {
replace months_seen2007 = months_seen2007 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}



forvalues k=2(1)13 {
replace months_seen2004 = months_seen2004 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}

forvalues k=14(1)25 {
replace months_seen2005 = months_seen2005 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}

forvalues k=26(1)37 {
replace months_seen2006 = months_seen2006 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}

forvalues k=38(1)48 {
replace months_seen2007 = months_seen2007 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}


forvalues k=1(1)12 {
replace months_seen2004 = months_seen2004 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}

forvalues k=13(1)24 {
replace months_seen2005 = months_seen2005 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}

forvalues k=25(1)36 {
replace months_seen2006 = months_seen2006 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}

forvalues k=37(1)48 {
replace months_seen2007 = months_seen2007 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}




/* Enrollment */
/* Enrolled? */

/* I will code you as enrolled in the year if you are enrolled at least 2 months of the year */
gen months_enrolled2004 = 0
gen months_enrolled2005 = 0
gen months_enrolled2006 = 0
gen months_enrolled2007 = 0



forvalues k=4(1)15 {
replace months_enrolled2004 = months_enrolled2004 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=16(1)27 {
replace months_enrolled2005 = months_enrolled2005 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=28(1)39 {
replace months_enrolled2006 = months_enrolled2006 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=40(1)48 {
replace months_enrolled2007 = months_enrolled2007 + 1 if enrl_m`k' == 1 & rot == 1
}


forvalues k=3(1)14 {
replace months_enrolled2004 = months_enrolled2004 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=15(1)26 {
replace months_enrolled2005 = months_enrolled2005 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=27(1)38 {
replace months_enrolled2006 = months_enrolled2006 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=39(1)48 {
replace months_enrolled2007 = months_enrolled2007 + 1 if enrl_m`k' == 1 & rot == 2
}



forvalues k=2(1)13 {
replace months_enrolled2004 = months_enrolled2004 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=14(1)25 {
replace months_enrolled2005 = months_enrolled2005 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=26(1)37 {
replace months_enrolled2006 = months_enrolled2006 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=38(1)48 {
replace months_enrolled2007 = months_enrolled2007 + 1 if enrl_m`k' == 1 & rot == 3
}


forvalues k=1(1)12 {
replace months_enrolled2004 = months_enrolled2004 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=13(1)24 {
replace months_enrolled2005 = months_enrolled2005 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=25(1)36 {
replace months_enrolled2006 = months_enrolled2006 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=37(1)48 {
replace months_enrolled2007 = months_enrolled2007 + 1 if enrl_m`k' == 1 & rot == 4
}



gen enrolled2004 = (months_enrolled2004/months_seen2004)
gen enrolled2005 = (months_enrolled2005/months_seen2005)
gen enrolled2006 = (months_enrolled2006/months_seen2006)
gen enrolled2007 = (months_enrolled2007/months_seen2007)

sum enrolled*
sum months_enrolled*










/**** ANNUAL EARNINGS ****/

/* Earnings are by month. Month #s to actual month mapping differs by rotation group */


forvalues k=1(1)48 {
replace earnings_job1_month`k' = 0 if earnings_job1_month`k' < 0 | earnings_job1_month`k' == .
replace earnings_job2_month`k' = 0 if earnings_job2_month`k' < 0 | earnings_job2_month`k' == .
gen earnings_se1_month`k' = 0
gen earnings_se2_month`k' = 0

}


gen earnings_job1_2004 = 0
gen earnings_job1_2005 = 0
gen earnings_job1_2006 = 0
gen earnings_job1_2007 = 0

gen earnings_job2_2004 = 0
gen earnings_job2_2005 = 0
gen earnings_job2_2006 = 0
gen earnings_job2_2007 = 0

gen earnings_se1_2004 = 0
gen earnings_se1_2005 = 0
gen earnings_se1_2006 = 0
gen earnings_se1_2007 = 0

gen earnings_se2_2004 = 0
gen earnings_se2_2005 = 0
gen earnings_se2_2006 = 0
gen earnings_se2_2007 = 0


gen earnings_annual2004 = 0
gen earnings_annual2005 = 0
gen earnings_annual2006 = 0
gen earnings_annual2007 = 0




/* Rotation group 1: 2004 is months 2-13, 2005 is months 14-25, 2006 is 26-37, 2007 is 38-48 */
forvalues k=4(1)15 {
replace earnings_annual2004 = earnings_annual2004 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=16(1)27 {
replace earnings_annual2005 = earnings_annual2005 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=28(1)39 {
replace earnings_annual2006 = earnings_annual2006 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=40(1)48 {
replace earnings_annual2007 = earnings_annual2007 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}


replace earnings_annual2004 = (earnings_annual2004/(months_seen2004-months_enrolled2004)) * 12  if rot == 1
replace earnings_annual2005 = (earnings_annual2005/(months_seen2005-months_enrolled2005)) * 12  if rot == 1
replace earnings_annual2006 = (earnings_annual2006/(months_seen2006-months_enrolled2006)) * 12  if rot == 1
replace earnings_annual2007 = (earnings_annual2007/(months_seen2007-months_enrolled2007)) * 12  if rot == 1

replace earnings_annual2004 = 0 if months_enrolled2004 == months_seen2004 & rot == 1
replace earnings_annual2005 = 0 if months_enrolled2005 == months_seen2005 & rot == 1
replace earnings_annual2006 = 0 if months_enrolled2006 == months_seen2006 & rot == 1
replace earnings_annual2007 = 0 if months_enrolled2007 == months_seen2007 & rot == 1







/* Rotation group 2: 2004 is months 1-12, 2005 is months 13-24, 2006 is 25-36, 2007 is 37-48 */
forvalues k=3(1)14 {
replace earnings_annual2004 = earnings_annual2004 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=15(1)26 {
replace earnings_annual2005 = earnings_annual2005 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=27(1)38 {
replace earnings_annual2006 = earnings_annual2006 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=39(1)48 {
replace earnings_annual2007 = earnings_annual2007 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}


replace earnings_annual2004 = (earnings_annual2004/(months_seen2004-months_enrolled2004)) * 12  if rot == 2
replace earnings_annual2005 = (earnings_annual2005/(months_seen2005-months_enrolled2005)) * 12  if rot == 2
replace earnings_annual2006 = (earnings_annual2006/(months_seen2006-months_enrolled2006)) * 12  if rot == 2
replace earnings_annual2007 = (earnings_annual2007/(months_seen2007-months_enrolled2007)) * 12  if rot == 2

replace earnings_annual2004 = 0 if months_enrolled2004 == months_seen2004 & rot == 2
replace earnings_annual2005 = 0 if months_enrolled2005 == months_seen2005 & rot == 2
replace earnings_annual2006 = 0 if months_enrolled2006 == months_seen2006 & rot == 2
replace earnings_annual2007 = 0 if months_enrolled2007 == months_seen2007 & rot == 2







/* Rotation group 3: 2004 is months 1-11, 2005 is months 12-23, 2006 is 24-35, 2007 is 36-47 */
forvalues k=2(1)13 {
replace earnings_annual2004 = earnings_annual2004 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=14(1)25 {
replace earnings_annual2005 = earnings_annual2005 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=26(1)37 {
replace earnings_annual2006 = earnings_annual2006 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=38(1)48 {
replace earnings_annual2007 = earnings_annual2007 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}


replace earnings_annual2004 = (earnings_annual2004/(months_seen2004-months_enrolled2004)) * 12  if rot == 3
replace earnings_annual2005 = (earnings_annual2005/(months_seen2005-months_enrolled2005)) * 12  if rot == 3
replace earnings_annual2006 = (earnings_annual2006/(months_seen2006-months_enrolled2006)) * 12  if rot == 3
replace earnings_annual2007 = (earnings_annual2007/(months_seen2007-months_enrolled2007)) * 12  if rot == 3

replace earnings_annual2004 = 0 if months_enrolled2004 == months_seen2004 & rot == 3
replace earnings_annual2005 = 0 if months_enrolled2005 == months_seen2005 & rot == 3
replace earnings_annual2006 = 0 if months_enrolled2006 == months_seen2006 & rot == 3
replace earnings_annual2007 = 0 if months_enrolled2007 == months_seen2007 & rot == 3





/* Rotation group 4: 2004 is months 1-10, 2005 is months 11-22, 2006 is 22-34, 2007 is 35-46 */
forvalues k=1(1)12 {
replace earnings_annual2004 = earnings_annual2004 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=13(1)24 {
replace earnings_annual2005 = earnings_annual2005 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=25(1)36 {
replace earnings_annual2006 = earnings_annual2006 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=37(1)48 {
replace earnings_annual2007 = earnings_annual2007 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}


replace earnings_annual2004 = (earnings_annual2004/(months_seen2004-months_enrolled2004)) * 12  if rot == 4
replace earnings_annual2005 = (earnings_annual2005/(months_seen2005-months_enrolled2005)) * 12  if rot == 4
replace earnings_annual2006 = (earnings_annual2006/(months_seen2006-months_enrolled2006)) * 12  if rot == 4
replace earnings_annual2007 = (earnings_annual2007/(months_seen2007-months_enrolled2007)) * 12  if rot == 4

replace earnings_annual2004 = 0 if months_enrolled2004 == months_seen2004 & rot == 4
replace earnings_annual2005 = 0 if months_enrolled2005 == months_seen2005 & rot == 4
replace earnings_annual2006 = 0 if months_enrolled2006 == months_seen2006 & rot == 4
replace earnings_annual2007 = 0 if months_enrolled2007 == months_seen2007 & rot == 4


sum earnings_annual*

bysort rot: sum earnings_annual*






/**** WAGES ****/
/* For hourly workers, we actually have an hourly rate of pay variable */

/* Annual wage measure will be the average of the non-missing wage measures in the year (for job 1 only) */

/* Need to get # of non-missing wage measures each year */
gen wage_count2004 = 0
gen wage_count2005 = 0
gen wage_count2006 = 0
gen wage_count2007 = 0

forvalues k=4(1)15 {
replace wage_count2004 = wage_count2004 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=16(1)27 {
replace wage_count2005 = wage_count2005 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=28(1)39 {
replace wage_count2006 = wage_count2006 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=40(1)48 {
replace wage_count2007 = wage_count2007 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}


forvalues k=3(1)14 {
replace wage_count2004 = wage_count2004 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=15(1)26 {
replace wage_count2005 = wage_count2005 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=27(1)38 {
replace wage_count2006 = wage_count2006 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=39(1)48 {
replace wage_count2007 = wage_count2007 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}



forvalues k=2(1)13 {
replace wage_count2004 = wage_count2004 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=14(1)25 {
replace wage_count2005 = wage_count2005 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=26(1)37 {
replace wage_count2006 = wage_count2006 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=38(1)48 {
replace wage_count2007 = wage_count2007 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}


forvalues k=1(1)12 {
replace wage_count2004 = wage_count2004 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=13(1)24 {
replace wage_count2005 = wage_count2005 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=25(1)36 {
replace wage_count2006 = wage_count2006 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=37(1)48 {
replace wage_count2007 = wage_count2007 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}



/* Now, we construct the annual wage measure */
gen hrlypay2004 = .
gen hrlypay2005 = .
gen hrlypay2006 = .
gen hrlypay2007 = .

gen hrlypayv12004 = .
gen hrlypayv12005 = .
gen hrlypayv12006 = .
gen hrlypayv12007 = .

gen hrlypayv22004 = .
gen hrlypayv22005 = .
gen hrlypayv22006 = .
gen hrlypayv22007 = .

gen total_wage2004 = 0
gen total_wage2005 = 0
gen total_wage2006 = 0
gen total_wage2007 = 0


forvalues k=4(1)15 {
replace total_wage2004 = total_wage2004 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=16(1)27 {
replace total_wage2005 = total_wage2005 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=28(1)39 {
replace total_wage2006 = total_wage2006 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=40(1)48 {
replace total_wage2007 = total_wage2007 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}


forvalues k=3(1)14 {
replace total_wage2004 = total_wage2004 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=15(1)26 {
replace total_wage2005 = total_wage2005 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=27(1)38 {
replace total_wage2006 = total_wage2006 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=39(1)48 {
replace total_wage2007 = total_wage2007 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}



forvalues k=2(1)13 {
replace total_wage2004 = total_wage2004 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=14(1)25 {
replace total_wage2005 = total_wage2005 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=26(1)37 {
replace total_wage2006 = total_wage2006 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=38(1)48 {
replace total_wage2007 = total_wage2007 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}


forvalues k=1(1)12 {
replace total_wage2004 = total_wage2004 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=13(1)24 {
replace total_wage2005 = total_wage2005 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=25(1)36 {
replace total_wage2006 = total_wage2006 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=37(1)48 {
replace total_wage2007 = total_wage2007 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}




replace hrlypayv12004 = total_wage2004/wage_count2004 
replace hrlypayv12005 = total_wage2005/wage_count2005
replace hrlypayv12006 = total_wage2006/wage_count2006 
replace hrlypayv12007 = total_wage2007/wage_count2007

sum hrlypay*

drop total_wage* wage_count* wage_month*





/* Alternative if you don't work by the hour: get earnings/hours */
forvalues k=1(1)48 {
replace hours_job1_month`k' = 0 if hours_job1_month`k' < 0
replace hours_job2_month`k' = 0 if hours_job2_month`k' < 0
}



/* Need to get # of non-missing hours measures each year */
gen hours_count2004 = 0
gen hours_count2005 = 0
gen hours_count2006 = 0
gen hours_count2007 = 0

forvalues k=4(1)15 {
replace hours_count2004 = hours_count2004 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=16(1)27 {
replace hours_count2005 = hours_count2005 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=28(1)39 {
replace hours_count2006 = hours_count2006 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=40(1)48 {
replace hours_count2007 = hours_count2007 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=3(1)14 {
replace hours_count2004 = hours_count2004 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=15(1)26 {
replace hours_count2005 = hours_count2005 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=27(1)38 {
replace hours_count2006 = hours_count2006 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=39(1)48 {
replace hours_count2007 = hours_count2007 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}



forvalues k=2(1)13 {
replace hours_count2004 = hours_count2004 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=14(1)25 {
replace hours_count2005 = hours_count2005 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=26(1)37 {
replace hours_count2006 = hours_count2006 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=38(1)48 {
replace hours_count2007 = hours_count2007 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}


forvalues k=1(1)12 {
replace hours_count2004 = hours_count2004 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=13(1)24 {
replace hours_count2005 = hours_count2005 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=25(1)36 {
replace hours_count2006 = hours_count2006 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=37(1)48 {
replace hours_count2007 = hours_count2007 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}


gen total_hours2004 = 0
gen total_hours2005 = 0
gen total_hours2006 = 0
gen total_hours2007 = 0


forvalues k=4(1)15 {
replace total_hours2004 = total_hours2004 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=16(1)27 {
replace total_hours2005 = total_hours2005 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=28(1)39 {
replace total_hours2006 = total_hours2006 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=40(1)48 {
replace total_hours2007 = total_hours2007 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}


forvalues k=3(1)14 {
replace total_hours2004 = total_hours2004 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=15(1)26 {
replace total_hours2005 = total_hours2005 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=27(1)38 {
replace total_hours2006 = total_hours2006 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=39(1)48 {
replace total_hours2007 = total_hours2007 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}



forvalues k=2(1)13 {
replace total_hours2004 = total_hours2004 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=14(1)25 {
replace total_hours2005 = total_hours2005 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=26(1)37 {
replace total_hours2006 = total_hours2006 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=38(1)48 {
replace total_hours2007 = total_hours2007 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}


forvalues k=1(1)12 {
replace total_hours2004 = total_hours2004 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=13(1)24 {
replace total_hours2005 = total_hours2005 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=25(1)36 {
replace total_hours2006 = total_hours2006 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=37(1)48 {
replace total_hours2007 = total_hours2007 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}




replace hrlypayv22004 = earnings_annual2004 / total_hours2004
replace hrlypayv22005 = earnings_annual2005 / total_hours2005
replace hrlypayv22006 = earnings_annual2006 / total_hours2006
replace hrlypayv22007 = earnings_annual2007 / total_hours2007


forvalues k=2004(1)2007 {
replace hrlypay`k' = hrlypayv1`k'
replace hrlypay`k' = hrlypayv2`k' if hrlypay`k' == . | hrlypay`k' == 0
}


sum hrlypay*





sum age2004 age2005 age2006 age2007

sum black* hispanic*

sum hrlypay*, d






/* State and region */
/* I take the state from the first wave as the state for 2004 and the fourth wave for 2005, 7th for 2006, 10th for 2007 */
rename state5 state

gen west = 0
gen northeast = 0
gen midwest = 0
gen south = 0

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west2004 = west
gen northeast2004 = northeast
gen midwest2004 = midwest
gen south2004 = south

rename state state_ba_degree 


/* state4 is the state from the 4th wave, which is in the second year */
rename state17 state

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west2005 = west
gen northeast2005 = northeast
gen midwest2005 = midwest
gen south2005 = south

drop state


/* 2006 */
rename state29 state

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west2006 = west
gen northeast2006 = northeast
gen midwest2006 = midwest
gen south2006 = south

drop state


/* 2007 */
rename state41 state

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west2007 = west
gen northeast2007 = northeast
gen midwest2007 = midwest
gen south2007 = south


drop west south midwest northeast 



/* Division of degree */
gen ba_newengland = 0
gen ba_midatlantic = 0
gen ba_eastnorthcentral = 0
gen ba_westnorthcentral = 0
gen ba_southatlantic = 0
gen ba_eastsouthcentral = 0
gen ba_westsouthcentral = 0
gen ba_mountain = 0
gen ba_pacific = 0


replace ba_newengland = 1 if state_ba_degree == 9 | state_ba_degree == 25 | state_ba_degree == 33  | state_ba_degree == 44 | state_ba_degree == 23 | state_ba_degree == 50 | state_ba_degree == 61
replace ba_midatlantic = 1 if state_ba_degree == 34 | state_ba_degree == 36 | state_ba_degree == 42
replace ba_eastnorthcentral = 1 if  state_ba_degree == 55 | state_ba_degree == 39 | state_ba_degree == 26 | state_ba_degree == 18 | state_ba_degree == 17
replace ba_westnorthcentral = 1 if state_ba_degree == 62 | state_ba_degree == 19 | state_ba_degree == 38 | state_ba_degree == 46 | state_ba_degree == 31| state_ba_degree == 20 | state_ba_degree == 29 | state_ba_degree == 27
replace ba_southatlantic = 1 if state_ba_degree == 10 | state_ba_degree == 11 | state_ba_degree == 24 | state_ba_degree == 54 | state_ba_degree == 51 | state_ba_degree == 37 | state_ba_degree == 45 | state_ba_degree == 12 | state_ba_degree == 13
replace ba_eastsouthcentral = 1 if state_ba_degree == 28 | state_ba_degree == 21 | state_ba_degree == 47 | state_ba_degree == 1
replace ba_westsouthcentral = 1 if state_ba_degree == 5 | state_ba_degree == 22 | state_ba_degree == 40 | state_ba_degree == 48
replace ba_mountain = 1 if state_ba_degree == 4 | state_ba_degree == 8 | state_ba_degree == 16 | state_ba_degree == 30 | state_ba_degree == 32 | state_ba_degree == 35 | state_ba_degree == 49 | state_ba_degree == 56
replace ba_pacific = 1 if state_ba_degree == 2 | state_ba_degree == 15 | state_ba_degree == 6 | state_ba_degree == 41 | state_ba_degree == 53






/* Survey weights */
/* I need to average the weights for each month over the year to get the annual weight */
forvalues k=1(1)48 {
replace weight`k' = 0 if weight`k' <= 0 | weight`k' == .
}

gen survey_weight2004 = .
gen survey_weight2005 = .
gen survey_weight2006 = .
gen survey_weight2007 = .

replace survey_weight2004 = (weight2+weight3+weight4+weight5+weight6+weight7+weight8+weight9+weight10+weight11+weight12+weight13)/months_seen2004 if rot == 1
replace survey_weight2004 = (weight1+weight2+weight3+weight4+weight5+weight6+weight7+weight8+weight9+weight10+weight11+weight12)/months_seen2004 if rot == 2
replace survey_weight2004 = (weight1+weight2+weight3+weight4+weight5+weight6+weight7+weight8+weight9+weight10+weight11)/11 if rot == 3
replace survey_weight2004 = (weight1+weight2+weight3+weight4+weight5+weight6+weight7+weight8+weight9+weight10)/10 if rot == 4

replace survey_weight2005 = (weight14+weight15+weight16+weight17+weight18+weight19+weight20+weight21+weight22+weight23+weight24+weight25)/months_seen2005 if rot == 1
replace survey_weight2005 = (weight13+weight14+weight15+weight16+weight17+weight18+weight19+weight20+weight21+weight22+weight23+weight24)/months_seen2005 if rot == 2
replace survey_weight2005 = (weight12+weight13+weight14+weight15+weight16+weight17+weight18+weight19+weight20+weight21+weight22+weight23)/months_seen2005 if rot == 3
replace survey_weight2005 = (weight11+weight12+weight13+weight14+weight15+weight16+weight17+weight18+weight19+weight20+weight21+weight22)/months_seen2005 if rot == 4

replace survey_weight2006 = (weight26+weight27+weight28+weight29+weight30+weight31+weight32+weight33+weight34+weight35+weight36+weight37)/months_seen2006 if rot == 1
replace survey_weight2006 = (weight25+weight26+weight27+weight28+weight29+weight30+weight31+weight32+weight33+weight34+weight35+weight36)/months_seen2006 if rot == 2
replace survey_weight2006 = (weight24+weight25+weight26+weight27+weight28+weight29+weight30+weight31+weight32+weight33+weight34+weight35)/months_seen2006 if rot == 3
replace survey_weight2006 = (weight23+weight24+weight25+weight26+weight27+weight28+weight29+weight30+weight31+weight32+weight33+weight34)/months_seen2006 if rot == 4

replace survey_weight2007 = (weight38+weight39+weight40+weight41+weight42+weight43+weight44+weight45+weight46+weight47+weight48)/11 if rot == 1
replace survey_weight2007 = (weight37+weight38+weight39+weight40+weight41+weight42+weight43+weight44+weight45+weight46+weight47+weight48)/months_seen2007 if rot == 2
replace survey_weight2007 = (weight36+weight37+weight38+weight39+weight40+weight41+weight42+weight43+weight44+weight45+weight46+weight47)/months_seen2007 if rot == 3
replace survey_weight2007 = (weight35+weight36+weight37+weight38+weight39+weight40+weight41+weight42+weight43+weight44+weight45+weight46)/months_seen2007 if rot == 4

drop weight*


/* Are you employed? */
/* How should I do this? I have 12 observations per year */
/* For now, what I do (also for occupation and industry and full-time) is take the middle months of the person's year */

gen employed2004 = 0
gen employed2005 = 0
gen employed2006 = 0
gen employed2007 = 0

/* Group 1 */
forvalues k=4(1)15 {
replace employed2004 = employed2004 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 1
}

forvalues k=16(1)27 {
replace employed2005 = employed2005 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 1
}

forvalues k=28(1)39 {
replace employed2006 = employed2006 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 1
}

forvalues k=40(1)48 {
replace employed2007 = employed2007 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 1
}


/* Group 2 */
forvalues k=3(1)14 {
replace employed2004 = employed2004 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 2
}

forvalues k=15(1)26 {
replace employed2005 = employed2005 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 2
}

forvalues k=27(1)38 {
replace employed2006 = employed2006 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 2
}

forvalues k=39(1)48 {
replace employed2007 = employed2007 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 2
}


/* Group 3 */
forvalues k=2(1)13 {
replace employed2004 = employed2004 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 3
}

forvalues k=14(1)25 {
replace employed2005 = employed2005 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 3
}

forvalues k=26(1)37 {
replace employed2006 = employed2006 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 3
}

forvalues k=38(1)48 {
replace employed2007 = employed2007 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 3
}


/* Group 4 */
forvalues k=1(1)12 {
replace employed2004 = employed2004 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 4
}

forvalues k=13(1)24 {
replace employed2005 = employed2005 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 4
}

forvalues k=25(1)36 {
replace employed2006 = employed2006 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 4
}

forvalues k=37(1)48 {
replace employed2007 = employed2007 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 4
}


replace employed2004 = employed2004 / (months_seen2004 - months_enrolled2004)
replace employed2005 = employed2005 / (months_seen2005 - months_enrolled2005)
replace employed2006 = employed2006 / (months_seen2006 - months_enrolled2006)
replace employed2007 = employed2007 / (months_seen2007 - months_enrolled2007)



sum employed*



/* Are you full-time? */

gen fulltime2004 = 0
gen fulltime2005 = 0
gen fulltime2006 = 0
gen fulltime2007 = 0

/* Group 1 */
forvalues k=4(1)15 {
replace fulltime2004 = fulltime2004 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=16(1)27 {
replace fulltime2005 = fulltime2005 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=28(1)39 {
replace fulltime2006 = fulltime2006 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=40(1)48 {
replace fulltime2007 = fulltime2007 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}


/* Group 2 */
forvalues k=3(1)14 {
replace fulltime2004 = fulltime2004 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=15(1)26 {
replace fulltime2005 = fulltime2005 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=27(1)38 {
replace fulltime2006 = fulltime2006 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=39(1)48 {
replace fulltime2007 = fulltime2007 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}


/* Group 3 */
forvalues k=2(1)13 {
replace fulltime2004 = fulltime2004 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=14(1)25 {
replace fulltime2005 = fulltime2005 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=26(1)37 {
replace fulltime2006 = fulltime2006 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=38(1)48 {
replace fulltime2007 = fulltime2007 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}


/* Group 4 */
forvalues k=1(1)12 {
replace fulltime2004 = fulltime2004 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=13(1)24 {
replace fulltime2005 = fulltime2005 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=25(1)36 {
replace fulltime2006 = fulltime2006 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=37(1)48 {
replace fulltime2007 = fulltime2007 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}


replace fulltime2004 = fulltime2004 / (months_seen2004 - months_enrolled2004)
replace fulltime2005 = fulltime2005 / (months_seen2005 - months_enrolled2005)
replace fulltime2006 = fulltime2006 / (months_seen2006 - months_enrolled2006)
replace fulltime2007 = fulltime2007 / (months_seen2007 - months_enrolled2007)



sum fulltime*




/* OCCUPATION */

/* THESE ARE ??? 4-DIGIT CODES */
forvalues k=1(1)48 {
replace occ1_month`k' = . if occ1_month`k' == 0 | occ1_month`k' == 905 | occ1_month`k' < 0
}

forvalues k=1(1)12 {
gen occ`k'_2004 = .
gen occ`k'_2005 = .
gen occ`k'_2006 = .
gen occ`k'_2007 = .
}



forvalues k=4(1)15 {
local j = `k' - 3
replace occ`j'_2004 = occ1_month`k' if rot == 1
}

forvalues k=16(1)27 {
local j = `k' - 15
replace occ`j'_2005 = occ1_month`k' if rot == 1
}

forvalues k=28(1)39 {
local j = `k' - 27
replace occ`j'_2006 = occ1_month`k' if rot == 1
}

forvalues k=40(1)48 {
local j = `k' - 39
replace occ`j'_2007 = occ1_month`k' if rot == 1
}


forvalues k=3(1)14 {
local j = `k' - 2
replace occ`j'_2004 = occ1_month`k' if rot == 2
}

forvalues k=15(1)26 {
local j = `k' - 14
replace occ`j'_2005 = occ1_month`k' if rot == 2
}

forvalues k=27(1)38 {
local j = `k' - 26
replace occ`j'_2006 = occ1_month`k' if rot == 2
}

forvalues k=39(1)48 {
local j = `k' - 38
replace occ`j'_2007 = occ1_month`k' if rot == 2
}


forvalues k=2(1)13 {
local j = `k' - 1
replace occ`j'_2004 = occ1_month`k' if rot == 3
}

forvalues k=14(1)25 {
local j = `k' - 13
replace occ`j'_2005 = occ1_month`k' if rot == 3
}

forvalues k=26(1)37 {
local j = `k' - 25
replace occ`j'_2006 = occ1_month`k' if rot == 3
}

forvalues k=38(1)48 {
local j = `k' - 37
replace occ`j'_2007 = occ1_month`k' if rot == 3
}


forvalues k=1(1)12 {
local j = `k' 
replace occ`j'_2004 = occ1_month`k' if rot == 4
}

forvalues k=13(1)24 {
local j = `k' - 12
replace occ`j'_2005 = occ1_month`k' if rot == 4
}

forvalues k=25(1)36 {
local j = `k' - 24
replace occ`j'_2006 = occ1_month`k' if rot == 4
}

forvalues k=37(1)48 {
local j = `k' - 36
replace occ`j'_2007 = occ1_month`k' if rot == 4
}






/* INDUSTRY */
/* I use the 6th month industry as the industry. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE ??? 4-DIGIT CODES */
forvalues k=1(1)48 {
replace ind1_month`k' = . if ind1_month`k' == 0 | ind1_month`k' == 905 | ind1_month`k' < 0
}



forvalues k=1(1)12 {
gen ind`k'_2004 = .
gen ind`k'_2005 = .
gen ind`k'_2006 = .
gen ind`k'_2007 = .
}



forvalues k=4(1)15 {
local j = `k' - 3
replace ind`j'_2004 = ind1_month`k' if rot == 1
}

forvalues k=16(1)27 {
local j = `k' - 15
replace ind`j'_2005 = ind1_month`k' if rot == 1
}

forvalues k=28(1)39 {
local j = `k' - 27
replace ind`j'_2006 = ind1_month`k' if rot == 1
}

forvalues k=40(1)48 {
local j = `k' - 39
replace ind`j'_2007 = ind1_month`k' if rot == 1
}


forvalues k=3(1)14 {
local j = `k' - 2
replace ind`j'_2004 = ind1_month`k' if rot == 2
}

forvalues k=15(1)26 {
local j = `k' - 14
replace ind`j'_2005 = ind1_month`k' if rot == 2
}

forvalues k=27(1)38 {
local j = `k' - 26
replace ind`j'_2006 = ind1_month`k' if rot == 2
}

forvalues k=39(1)48 {
local j = `k' - 38
replace ind`j'_2007 = ind1_month`k' if rot == 2
}


forvalues k=2(1)13 {
local j = `k' - 1
replace ind`j'_2004 = ind1_month`k' if rot == 3
}

forvalues k=14(1)25 {
local j = `k' - 13
replace ind`j'_2005 = ind1_month`k' if rot == 3
}

forvalues k=26(1)37 {
local j = `k' - 25
replace ind`j'_2006 = ind1_month`k' if rot == 3
}

forvalues k=38(1)48 {
local j = `k' - 37
replace ind`j'_2007 = ind1_month`k' if rot == 3
}


forvalues k=1(1)12 {
local j = `k' 
replace ind`j'_2004 = ind1_month`k' if rot == 4
}

forvalues k=13(1)24 {
local j = `k' - 12
replace ind`j'_2005 = ind1_month`k' if rot == 4
}

forvalues k=25(1)36 {
local j = `k' - 24
replace ind`j'_2006 = ind1_month`k' if rot == 4
}

forvalues k=37(1)48 {
local j = `k' - 36
replace ind`j'_2007 = ind1_month`k' if rot == 4
}



drop *month*

bysort rot: sum ind* occ*



/* Identifying variables */
keep *2004 *2005 *2006 *2007 ssuid eentaid epppnum rot tbyear state_ba* ba_*

sort ssuid eentaid epppnum
compress
save Temp/sipp04_full_cleaned.dta, replace


*************************************************************************************

clear

use Temp/sipp04wave2.dta


/**** WAVE 2 DATASET ****/



/* Identifiers */
sum ssuid eentaid epppnum



/********** COLLEGE DEGREE INFORMATION *********/

/* 2 questions: highest degree and BA degree. Need to check both */

/* Need year of degree, age at degree, and field of degree. Also need highest degree completed */


gen col = 0
gen morcol = 0
gen hgc = .


replace hgc = 0    if eeducate == 31
replace hgc = 2.5  if eeducate == 32
replace hgc = 5.5  if eeducate == 33
replace hgc = 7.5  if eeducate == 34
replace hgc = 9    if eeducate == 35
replace hgc = 10   if eeducate == 36
replace hgc = 11   if eeducate == 37
replace hgc = 11.5 if eeducate == 38
replace hgc = 12   if eeducate == 39
replace hgc = 13   if eeducate == 40
replace hgc = 13.5 if eeducate == 41
replace hgc = 14   if eeducate == 42
replace hgc = 14   if eeducate == 43
replace hgc = 16   if eeducate == 44
replace hgc = 18   if eeducate == 45
replace hgc = 19   if eeducate == 46
replace hgc = 20   if eeducate == 47

tab hgc, mi

replace col = 1 if hgc == 16
replace morcol = 1 if hgc > 16 & hgc != .

drop if hgc == .


tab col morcol


gen gradyear = .


replace gradyear = tbachyr if tbachyr > 0

tab gradyear




/* Field of bachelor's degree */

rename ebachfld major_field
replace major_field = . if major_field == -1

tab major_field if hgc == 16
tab major_field if hgc > 16 & hgc != .


tab hgc


keep hgc major_field gradyear col morcol ssuid eentaid epppnum


sort ssuid eentaid epppnum



merge ssuid eentaid epppnum using Temp/sipp04_full_cleaned.dta

tab _merge if hgc != .
drop if _merge == 2
drop _merge

gen age_grad = .

replace age_grad = gradyear - tbyear

tab age_grad


capture drop pid

egen pid=group(ssuid eentaid epppnum)
*bysort su_id pp_entry pp_pnum: gen pid = _n

drop ssuid eentaid epppnum

drop earnings_job* earnings_se* tbyear

capture drop *month*

reshape long total_hours survey_weight age male hispanic black earnings_annual hrlypay hrlypayv1 hrlypayv2 enrolled west northeast midwest south employed fulltime occ1_ occ2_ occ3_ occ4_ occ5_ occ6_ occ7_ occ8_ occ9_ occ10_ occ11_ occ12_ ind1_ ind2_ ind3_ ind4_ ind5_ ind6_ ind7_ ind8_ ind9_ ind10_ ind11_ ind12_, i(pid) j(year)

forvalues k=1(1)12 {
rename occ`k'_ occ`k'
rename ind`k'_ ind`k'
}


* keep if age >= 22

* keep if major_field != .
tab major_field, mi
tab major_field if hgc == 16
tab gradyear
gen potexp = year - gradyear
tab potexp

tab gradyear potexp if hgc == 16 & potexp <= 13

sum

gen panel = 2004
gen survey = 0405

sort pid
compress
save Temp/sipp04_ready.dta, replace

clear



/* 2008 */



forvalues k=1(1)16 {

use "Temp/sipp08_core`k'.dta"


gen refmonth = (swave-1)*4 + srefmon

tab refmonth


/* The goal is to rename variables to what they are for pre-1996 data, so I can use the same files I used for those */

rename tage age

gen male = (esex == 1)

* gen hispanic = (eorigin >= 20 & eorigin <= 28)
gen hispanic = (eorigin==1)
gen black = (erace == 2 & hispanic != 1)


/* Earnings */
rename tpmsum1 earnings_job1_month
rename tpmsum2 earnings_job2_month

gen earnings_se1_month = 0
gen earnings_se2_month = 0



/* wages */
rename tpyrate1 wage_month


/* Usual hours per month */
rename ejbhrs1 hours_job1_month
rename ejbhrs2 hours_job2_month


/* Enrollment */
rename eenrlm enrl_m

replace enrl_m = 0 if enrl_m == -1 | enrl_m == 2



/* State of residence */
rename tfipsst state



/* Survey weight */
rename wpfinwgt weight

/* Will need to take avg of weights across the months in a year */


/* Employed */
rename rmwkwjb wksem_month

replace wksem_month = 0 if wksem_month < 0



/* Occupation and industry */
rename tjbocc1 occ1_month
rename ejbind1 ind1_month


rename srotaton rot



keep refmonth age male hispanic black earnings_job* wage_month hours_job* enrl_m state weight wksem_month occ1_month ind1_month ssuid eentaid epppnum rot tbyear

egen pid= group(ssuid eentaid epppnum)

reshape wide age male hispanic black earnings_job1_month earnings_job2_month hours_job1_month hours_job2_month wage_month enrl_m state weight wksem_month occ1_month ind1_month, i(pid) j(refmonth)

sort ssuid eentaid epppnum
compress
save "Temp/sipp08_core`k'_personrecord.dta", replace

clear

}


clear

use Temp/sipp08_core1_personrecord.dta


forvalues k=2(1)16 {
sort ssuid eentaid epppnum
merge ssuid eentaid epppnum using "Temp/sipp08_core`k'_personrecord.dta"

tab _merge

drop _merge

}


compress
save Temp/sipp08_full.dta, replace

* JA: Sometimes "hours_job1" = -8,
*  which means "hours vary" for now, just drop these obs
forvalues k=1(1)64 {
	foreach X in state`k' weight`k' age`k' enrl_m`k' wksem_month`k' earnings_job1_month`k' wage_month`k' ind1_month`k' occ1_month`k' hours_job2_month`k' earnings_job2_month`k' male`k' hispanic`k' black1 {
		qui replace `X'=. if hours_job1_month`k'==-8
	}
	qui replace hours_job1_month`k'=. if hours_job1_month`k'==-8

	qui replace earnings_job2_month`k'=. if hours_job2_month`k'==-8
	qui replace hours_job2_month`k'=.    if hours_job2_month`k'==-8
}


/* Age at survey */
gen age2008 = age3
gen age2009 = age15
gen age2010 = age27
gen age2011 = age39
gen age2012 = age51
gen age2013 = age63


/* Gender */
gen male2008 = male1
gen male2009 = male1
gen male2010 = male1
gen male2011 = male1
gen male2012 = male1
gen male2013 = male1


/* Race */
gen hispanic2008 = hispanic1
gen hispanic2009 = hispanic1
gen hispanic2010 = hispanic1
gen hispanic2011 = hispanic1
gen hispanic2012 = hispanic1
gen hispanic2013 = hispanic1

gen black2008 = black1
gen black2009 = black1
gen black2010 = black1
gen black2011 = black1
gen black2012 = black1
gen black2013 = black1

d male*
forvalues k=2(1)64 {
forvalues j=2008(1)2013 {
replace male`j' = male`k' if male`j' == .
replace black`j' = black`k' if black`j' == .
replace hispanic`j' = hispanic`k' if hispanic`j' == .
}
}



gen months_seen2008 = 0
gen months_seen2009 = 0
gen months_seen2010 = 0
gen months_seen2011 = 0
gen months_seen2012 = 0
gen months_seen2013 = 0


/* Each wave asks about the past four months */

/* The first survey is in April 2008, so we don't have obs for many people in 1995 */

/*
/* We don't see everyone through all of 2008 */
replace months_seen2008 = 7 if rot == 2
replace months_seen2008 = 6 if rot == 3
replace months_seen2008 = 5 if rot == 4
replace months_seen2008 = 8 if rot == 1

/* We see everyone through all of 2009 */
replace months_seen2009 = 12 if rot == 2
replace months_seen2009 = 12 if rot == 3
replace months_seen2009 = 12 if rot == 4
replace months_seen2009 = 12 if rot == 1

/* We see everyone through all of 2010 */
replace months_seen2010 = 12 if rot == 2
replace months_seen2010 = 12 if rot == 3
replace months_seen2010 = 12 if rot == 4
replace months_seen2010 = 12 if rot == 1

/* We see everyone through all of 2011 */
replace months_seen2011 = 12 if rot == 2
replace months_seen2011 = 12 if rot == 3
replace months_seen2011 = 12 if rot == 4
replace months_seen2011 = 12 if rot == 1

/* We see everyone through all of 2012 */
replace months_seen2012 = 12 if rot == 2
replace months_seen2012 = 12 if rot == 3
replace months_seen2012 = 12 if rot == 4
replace months_seen2012 = 12 if rot == 1

/* We don't see everyone through all of 2013   */
/* Also, rot==2 was not interviewed in Wave 16 */
/* due to the government shutdown of 2013      */
replace months_seen2013 = 5  if rot == 2
replace months_seen2013 = 10 if rot == 3
replace months_seen2013 = 11 if rot == 4
replace months_seen2013 = 8  if rot == 1
*/



forvalues k=1(1)8 {
replace months_seen2008 = months_seen2008 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}

forvalues k=9(1)20 {
replace months_seen2009 = months_seen2009 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}

forvalues k=21(1)32 {
replace months_seen2010 = months_seen2010 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}

forvalues k=33(1)44 {
replace months_seen2011 = months_seen2011 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}

forvalues k=45(1)56 {
replace months_seen2012 = months_seen2012 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}

forvalues k=57(1)64 {
replace months_seen2013 = months_seen2013 + 1 if (male`k' != . | weight`k' != .) & rot == 1
}


forvalues k=1(1)7 {
replace months_seen2008 = months_seen2008 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}

forvalues k=8(1)19 {
replace months_seen2009 = months_seen2009 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}

forvalues k=20(1)31 {
replace months_seen2010 = months_seen2010 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}

forvalues k=32(1)43 {
replace months_seen2011 = months_seen2011 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}

forvalues k=44(1)55 {
replace months_seen2012 = months_seen2012 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}

forvalues k=56(1)63 {
replace months_seen2013 = months_seen2013 + 1 if (male`k' != . | weight`k' != .) & rot == 2
}



forvalues k=1(1)6 {
replace months_seen2008 = months_seen2008 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}

forvalues k=7(1)18 {
replace months_seen2009 = months_seen2009 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}

forvalues k=19(1)30 {
replace months_seen2010 = months_seen2010 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}

forvalues k=31(1)42 {
replace months_seen2011 = months_seen2011 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}

forvalues k=43(1)54 {
replace months_seen2012 = months_seen2012 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}

forvalues k=55(1)62 {
replace months_seen2013 = months_seen2013 + 1 if (male`k' != . | weight`k' != .) & rot == 3
}


forvalues k=1(1)5 {
replace months_seen2008 = months_seen2008 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}

forvalues k=6(1)17 {
replace months_seen2009 = months_seen2009 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}

forvalues k=18(1)29 {
replace months_seen2010 = months_seen2010 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}

forvalues k=30(1)41 {
replace months_seen2011 = months_seen2011 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}

forvalues k=42(1)53 {
replace months_seen2012 = months_seen2012 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}

forvalues k=54(1)61 {
replace months_seen2013 = months_seen2013 + 1 if (male`k' != . | weight`k' != .) & rot == 4
}





/* Enrollment */
/* Enrolled? */

/* I will code you as enrolled in the year if you are enrolled at least 2 months of the year */
gen months_enrolled2008 = 0
gen months_enrolled2009 = 0
gen months_enrolled2010 = 0
gen months_enrolled2011 = 0
gen months_enrolled2012 = 0
gen months_enrolled2013 = 0



forvalues k=1(1)8 {
replace months_enrolled2008 = months_enrolled2008 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=9(1)20 {
replace months_enrolled2009 = months_enrolled2009 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=21(1)32 {
replace months_enrolled2010 = months_enrolled2010 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=33(1)44 {
replace months_enrolled2011 = months_enrolled2011 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=45(1)56 {
replace months_enrolled2012 = months_enrolled2012 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=57(1)64 {
replace months_enrolled2013 = months_enrolled2013 + 1 if enrl_m`k' == 1 & rot == 1
}


forvalues k=1(1)7 {
replace months_enrolled2008 = months_enrolled2008 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=8(1)19 {
replace months_enrolled2009 = months_enrolled2009 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=20(1)31 {
replace months_enrolled2010 = months_enrolled2010 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=32(1)43 {
replace months_enrolled2011 = months_enrolled2011 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=44(1)55 {
replace months_enrolled2012 = months_enrolled2012 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=56(1)63 {
replace months_enrolled2013 = months_enrolled2013 + 1 if enrl_m`k' == 1 & rot == 2
}



forvalues k=1(1)6 {
replace months_enrolled2008 = months_enrolled2008 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=7(1)18 {
replace months_enrolled2009 = months_enrolled2009 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=19(1)30 {
replace months_enrolled2010 = months_enrolled2010 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=31(1)42 {
replace months_enrolled2011 = months_enrolled2011 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=43(1)54 {
replace months_enrolled2012 = months_enrolled2012 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=55(1)62 {
replace months_enrolled2013 = months_enrolled2013 + 1 if enrl_m`k' == 1 & rot == 3
}


forvalues k=1(1)5 {
replace months_enrolled2008 = months_enrolled2008 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=6(1)17 {
replace months_enrolled2009 = months_enrolled2009 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=18(1)29 {
replace months_enrolled2010 = months_enrolled2010 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=30(1)41 {
replace months_enrolled2011 = months_enrolled2011 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=42(1)53 {
replace months_enrolled2012 = months_enrolled2012 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=54(1)61 {
replace months_enrolled2013 = months_enrolled2013 + 1 if enrl_m`k' == 1 & rot == 4
}



gen enrolled2008 = (months_enrolled2008/months_seen2008)
gen enrolled2009 = (months_enrolled2009/months_seen2009)
gen enrolled2010 = (months_enrolled2010/months_seen2010)
gen enrolled2011 = (months_enrolled2011/months_seen2011)
gen enrolled2012 = (months_enrolled2012/months_seen2012)
gen enrolled2013 = (months_enrolled2013/months_seen2013)

sum enrolled*
sum months_enrolled*










/**** ANNUAL EARNINGS ****/

/* Earnings are by month. Month #s to actual month mapping differs by rotation group */


forvalues k=1(1)64 {
replace earnings_job1_month`k' = 0 if earnings_job1_month`k' < 0 | earnings_job1_month`k' == .
replace earnings_job2_month`k' = 0 if earnings_job2_month`k' < 0 | earnings_job2_month`k' == .
gen earnings_se1_month`k' = 0
gen earnings_se2_month`k' = 0

}


gen earnings_job1_2008 = 0
gen earnings_job1_2009 = 0
gen earnings_job1_2010 = 0
gen earnings_job1_2011 = 0
gen earnings_job1_2012 = 0
gen earnings_job1_2013 = 0

gen earnings_job2_2008 = 0
gen earnings_job2_2009 = 0
gen earnings_job2_2010 = 0
gen earnings_job2_2011 = 0
gen earnings_job2_2012 = 0
gen earnings_job2_2013 = 0

gen earnings_se1_2008 = 0
gen earnings_se1_2009 = 0
gen earnings_se1_2010 = 0
gen earnings_se1_2011 = 0
gen earnings_se1_2012 = 0
gen earnings_se1_2013 = 0

gen earnings_se2_2008 = 0
gen earnings_se2_2009 = 0
gen earnings_se2_2010 = 0
gen earnings_se2_2011 = 0
gen earnings_se2_2012 = 0
gen earnings_se2_2013 = 0


gen earnings_annual2008 = 0
gen earnings_annual2009 = 0
gen earnings_annual2010 = 0
gen earnings_annual2011 = 0
gen earnings_annual2012 = 0
gen earnings_annual2013 = 0




/* Rotation group 1: 2008 is months 2-13, 2009 is months 14-25, 2010 is 26-37, 2011 is 38-48 */
forvalues k=1(1)8 {
replace earnings_annual2008 = earnings_annual2008 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=9(1)20 {
replace earnings_annual2009 = earnings_annual2009 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=21(1)32 {
replace earnings_annual2010 = earnings_annual2010 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=33(1)44 {
replace earnings_annual2011 = earnings_annual2011 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=45(1)56 {
replace earnings_annual2012 = earnings_annual2012 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=57(1)64 {
replace earnings_annual2013 = earnings_annual2013 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1
}


replace earnings_annual2008 = (earnings_annual2008/(months_seen2008-months_enrolled2008)) * 12  if rot == 1
replace earnings_annual2009 = (earnings_annual2009/(months_seen2009-months_enrolled2009)) * 12  if rot == 1
replace earnings_annual2010 = (earnings_annual2010/(months_seen2010-months_enrolled2010)) * 12  if rot == 1
replace earnings_annual2011 = (earnings_annual2011/(months_seen2011-months_enrolled2011)) * 12  if rot == 1
replace earnings_annual2012 = (earnings_annual2012/(months_seen2012-months_enrolled2012)) * 12  if rot == 1
replace earnings_annual2013 = (earnings_annual2013/(months_seen2013-months_enrolled2013)) * 12  if rot == 1

replace earnings_annual2008 = 0 if months_enrolled2008 == months_seen2008 & rot == 1
replace earnings_annual2009 = 0 if months_enrolled2009 == months_seen2009 & rot == 1
replace earnings_annual2010 = 0 if months_enrolled2010 == months_seen2010 & rot == 1
replace earnings_annual2011 = 0 if months_enrolled2011 == months_seen2011 & rot == 1
replace earnings_annual2012 = 0 if months_enrolled2012 == months_seen2012 & rot == 1
replace earnings_annual2013 = 0 if months_enrolled2013 == months_seen2013 & rot == 1







/* Rotation group 2: 2008 is months 1-12, 2009 is months 13-24, 2010 is 25-36, 2011 is 37-48 */
forvalues k=1(1)7 {
replace earnings_annual2008 = earnings_annual2008 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=8(1)19 {
replace earnings_annual2009 = earnings_annual2009 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=20(1)31 {
replace earnings_annual2010 = earnings_annual2010 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=32(1)43 {
replace earnings_annual2011 = earnings_annual2011 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=44(1)55 {
replace earnings_annual2012 = earnings_annual2012 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=56(1)63 {
replace earnings_annual2013 = earnings_annual2013 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 2
}


replace earnings_annual2008 = (earnings_annual2008/(months_seen2008-months_enrolled2008)) * 12  if rot == 2
replace earnings_annual2009 = (earnings_annual2009/(months_seen2009-months_enrolled2009)) * 12  if rot == 2
replace earnings_annual2010 = (earnings_annual2010/(months_seen2010-months_enrolled2010)) * 12  if rot == 2
replace earnings_annual2011 = (earnings_annual2011/(months_seen2011-months_enrolled2011)) * 12  if rot == 2
replace earnings_annual2012 = (earnings_annual2012/(months_seen2012-months_enrolled2012)) * 12  if rot == 2
replace earnings_annual2013 = (earnings_annual2013/(months_seen2013-months_enrolled2013)) * 12  if rot == 2

replace earnings_annual2008 = 0 if months_enrolled2008 == months_seen2008 & rot == 2
replace earnings_annual2009 = 0 if months_enrolled2009 == months_seen2009 & rot == 2
replace earnings_annual2010 = 0 if months_enrolled2010 == months_seen2010 & rot == 2
replace earnings_annual2011 = 0 if months_enrolled2011 == months_seen2011 & rot == 2
replace earnings_annual2012 = 0 if months_enrolled2012 == months_seen2012 & rot == 2
replace earnings_annual2013 = 0 if months_enrolled2013 == months_seen2013 & rot == 2







/* Rotation group 3: 2008 is months 1-11, 2009 is months 12-23, 2010 is 24-35, 2011 is 36-47 */
forvalues k=1(1)6 {
replace earnings_annual2008 = earnings_annual2008 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=7(1)18 {
replace earnings_annual2009 = earnings_annual2009 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=19(1)30 {
replace earnings_annual2010 = earnings_annual2010 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=31(1)42 {
replace earnings_annual2011 = earnings_annual2011 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=43(1)54 {
replace earnings_annual2012 = earnings_annual2012 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=55(1)62 {
replace earnings_annual2013 = earnings_annual2013 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 3
}


replace earnings_annual2008 = (earnings_annual2008/(months_seen2008-months_enrolled2008)) * 12  if rot == 3
replace earnings_annual2009 = (earnings_annual2009/(months_seen2009-months_enrolled2009)) * 12  if rot == 3
replace earnings_annual2010 = (earnings_annual2010/(months_seen2010-months_enrolled2010)) * 12  if rot == 3
replace earnings_annual2011 = (earnings_annual2011/(months_seen2011-months_enrolled2011)) * 12  if rot == 3
replace earnings_annual2012 = (earnings_annual2012/(months_seen2012-months_enrolled2012)) * 12  if rot == 3
replace earnings_annual2013 = (earnings_annual2013/(months_seen2013-months_enrolled2013)) * 12  if rot == 3

replace earnings_annual2008 = 0 if months_enrolled2008 == months_seen2008 & rot == 3
replace earnings_annual2009 = 0 if months_enrolled2009 == months_seen2009 & rot == 3
replace earnings_annual2010 = 0 if months_enrolled2010 == months_seen2010 & rot == 3
replace earnings_annual2011 = 0 if months_enrolled2011 == months_seen2011 & rot == 3
replace earnings_annual2012 = 0 if months_enrolled2012 == months_seen2012 & rot == 3
replace earnings_annual2013 = 0 if months_enrolled2013 == months_seen2013 & rot == 3





/* Rotation group 4: 2008 is months 1-10, 2009 is months 11-22, 2010 is 22-34, 2011 is 35-46 */
forvalues k=1(1)5 {
replace earnings_annual2008 = earnings_annual2008 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=6(1)17 {
replace earnings_annual2009 = earnings_annual2009 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=18(1)29 {
replace earnings_annual2010 = earnings_annual2010 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=30(1)41 {
replace earnings_annual2011 = earnings_annual2011 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=42(1)53 {
replace earnings_annual2012 = earnings_annual2012 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=54(1)61 {
replace earnings_annual2013 = earnings_annual2013 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 4
}


replace earnings_annual2008 = (earnings_annual2008/(months_seen2008-months_enrolled2008)) * 12  if rot == 4
replace earnings_annual2009 = (earnings_annual2009/(months_seen2009-months_enrolled2009)) * 12  if rot == 4
replace earnings_annual2010 = (earnings_annual2010/(months_seen2010-months_enrolled2010)) * 12  if rot == 4
replace earnings_annual2011 = (earnings_annual2011/(months_seen2011-months_enrolled2011)) * 12  if rot == 4
replace earnings_annual2012 = (earnings_annual2012/(months_seen2012-months_enrolled2012)) * 12  if rot == 4
replace earnings_annual2013 = (earnings_annual2013/(months_seen2013-months_enrolled2013)) * 12  if rot == 4

replace earnings_annual2008 = 0 if months_enrolled2008 == months_seen2008 & rot == 4
replace earnings_annual2009 = 0 if months_enrolled2009 == months_seen2009 & rot == 4
replace earnings_annual2010 = 0 if months_enrolled2010 == months_seen2010 & rot == 4
replace earnings_annual2011 = 0 if months_enrolled2011 == months_seen2011 & rot == 4
replace earnings_annual2012 = 0 if months_enrolled2012 == months_seen2012 & rot == 4
replace earnings_annual2013 = 0 if months_enrolled2013 == months_seen2013 & rot == 4


sum earnings_annual*

bysort rot: sum earnings_annual*






/**** WAGES ****/
/* For hourly workers, we actually have an hourly rate of pay variable */

/* Annual wage measure will be the average of the non-missing wage measures in the year (for job 1 only) */

/* Need to get # of non-missing wage measures each year */
gen wage_count2008 = 0
gen wage_count2009 = 0
gen wage_count2010 = 0
gen wage_count2011 = 0
gen wage_count2012 = 0
gen wage_count2013 = 0

forvalues k=1(1)8 {
replace wage_count2008 = wage_count2008 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=9(1)20 {
replace wage_count2009 = wage_count2009 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=21(1)32 {
replace wage_count2010 = wage_count2010 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=33(1)44 {
replace wage_count2011 = wage_count2011 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=45(1)56 {
replace wage_count2012 = wage_count2012 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=57(1)64 {
replace wage_count2013 = wage_count2013 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}


forvalues k=1(1)7 {
replace wage_count2008 = wage_count2008 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=8(1)19 {
replace wage_count2009 = wage_count2009 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=20(1)31 {
replace wage_count2010 = wage_count2010 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=32(1)43 {
replace wage_count2011 = wage_count2011 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=44(1)55 {
replace wage_count2012 = wage_count2012 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=56(1)63 {
replace wage_count2013 = wage_count2013 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}



forvalues k=1(1)6 {
replace wage_count2008 = wage_count2008 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=7(1)18 {
replace wage_count2009 = wage_count2009 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=19(1)30 {
replace wage_count2010 = wage_count2010 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=31(1)42 {
replace wage_count2011 = wage_count2011 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=43(1)54 {
replace wage_count2012 = wage_count2012 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=55(1)62 {
replace wage_count2013 = wage_count2013 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}


forvalues k=1(1)5 {
replace wage_count2008 = wage_count2008 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=6(1)17 {
replace wage_count2009 = wage_count2009 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=18(1)29 {
replace wage_count2010 = wage_count2010 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=30(1)41 {
replace wage_count2011 = wage_count2011 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=42(1)53 {
replace wage_count2012 = wage_count2012 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=54(1)61 {
replace wage_count2013 = wage_count2013 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}



/* Now, we construct the annual wage measure */
gen hrlypay2008 = .
gen hrlypay2009 = .
gen hrlypay2010 = .
gen hrlypay2011 = .
gen hrlypay2012 = .
gen hrlypay2013 = .

gen hrlypayv12008 = .
gen hrlypayv12009 = .
gen hrlypayv12010 = .
gen hrlypayv12011 = .
gen hrlypayv12012 = .
gen hrlypayv12013 = .

gen hrlypayv22008 = .
gen hrlypayv22009 = .
gen hrlypayv22010 = .
gen hrlypayv22011 = .
gen hrlypayv22012 = .
gen hrlypayv22013 = .

gen total_wage2008 = 0
gen total_wage2009 = 0
gen total_wage2010 = 0
gen total_wage2011 = 0
gen total_wage2012 = 0
gen total_wage2013 = 0


forvalues k=1(1)8 {
replace total_wage2008 = total_wage2008 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=9(1)20 {
replace total_wage2009 = total_wage2009 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=21(1)32 {
replace total_wage2010 = total_wage2010 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=33(1)44 {
replace total_wage2011 = total_wage2011 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=45(1)56 {
replace total_wage2012 = total_wage2012 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=57(1)64 {
replace total_wage2013 = total_wage2013 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}


forvalues k=1(1)7 {
replace total_wage2008 = total_wage2008 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=8(1)19 {
replace total_wage2009 = total_wage2009 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=20(1)31 {
replace total_wage2010 = total_wage2010 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=32(1)43 {
replace total_wage2011 = total_wage2011 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=44(1)55 {
replace total_wage2012 = total_wage2012 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=56(1)63 {
replace total_wage2013 = total_wage2013 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}



forvalues k=1(1)6 {
replace total_wage2008 = total_wage2008 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=7(1)18 {
replace total_wage2009 = total_wage2009 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=19(1)30 {
replace total_wage2010 = total_wage2010 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=31(1)42 {
replace total_wage2011 = total_wage2011 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=43(1)54 {
replace total_wage2012 = total_wage2012 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=55(1)62 {
replace total_wage2013 = total_wage2013 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}


forvalues k=1(1)5 {
replace total_wage2008 = total_wage2008 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=6(1)17 {
replace total_wage2009 = total_wage2009 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=18(1)29 {
replace total_wage2010 = total_wage2010 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=30(1)41 {
replace total_wage2011 = total_wage2011 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=42(1)53 {
replace total_wage2012 = total_wage2012 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=54(1)61 {
replace total_wage2013 = total_wage2013 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}




replace hrlypayv12008 = total_wage2008/wage_count2008 
replace hrlypayv12009 = total_wage2009/wage_count2009
replace hrlypayv12010 = total_wage2010/wage_count2010 
replace hrlypayv12011 = total_wage2011/wage_count2011
replace hrlypayv12012 = total_wage2012/wage_count2012
replace hrlypayv12013 = total_wage2013/wage_count2013

sum hrlypay*

drop total_wage* wage_count* wage_month*





/* Alternative if you don't work by the hour: get earnings/hours */
forvalues k=1(1)64 {
replace hours_job1_month`k' = 0 if hours_job1_month`k' < 0
replace hours_job2_month`k' = 0 if hours_job2_month`k' < 0
}



/* Need to get # of non-missing hours measures each year */
gen hours_count2008 = 0
gen hours_count2009 = 0
gen hours_count2010 = 0
gen hours_count2011 = 0
gen hours_count2012 = 0
gen hours_count2013 = 0

forvalues k=1(1)8 {
replace hours_count2008 = hours_count2008 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=9(1)20 {
replace hours_count2009 = hours_count2009 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=21(1)32 {
replace hours_count2010 = hours_count2010 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=33(1)44 {
replace hours_count2011 = hours_count2011 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=45(1)56 {
replace hours_count2012 = hours_count2012 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=57(1)64 {
replace hours_count2013 = hours_count2013 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=1(1)7 {
replace hours_count2008 = hours_count2008 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=8(1)19 {
replace hours_count2009 = hours_count2009 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=20(1)31 {
replace hours_count2010 = hours_count2010 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=32(1)43 {
replace hours_count2011 = hours_count2011 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=44(1)55 {
replace hours_count2012 = hours_count2012 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=56(1)63 {
replace hours_count2013 = hours_count2013 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}



forvalues k=1(1)6 {
replace hours_count2008 = hours_count2008 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=7(1)18 {
replace hours_count2009 = hours_count2009 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=19(1)30 {
replace hours_count2010 = hours_count2010 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=31(1)42 {
replace hours_count2011 = hours_count2011 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=43(1)54 {
replace hours_count2012 = hours_count2012 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=55(1)62 {
replace hours_count2013 = hours_count2013 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}


forvalues k=1(1)5 {
replace hours_count2008 = hours_count2008 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=6(1)17 {
replace hours_count2009 = hours_count2009 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=18(1)29 {
replace hours_count2010 = hours_count2010 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=30(1)41 {
replace hours_count2011 = hours_count2011 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=42(1)53 {
replace hours_count2012 = hours_count2012 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=54(1)61 {
replace hours_count2013 = hours_count2013 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}


gen total_hours2008 = 0
gen total_hours2009 = 0
gen total_hours2010 = 0
gen total_hours2011 = 0
gen total_hours2012 = 0
gen total_hours2013 = 0


forvalues k=1(1)8 {
replace total_hours2008 = total_hours2008 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=9(1)20 {
replace total_hours2009 = total_hours2009 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=21(1)32 {
replace total_hours2010 = total_hours2010 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=33(1)44 {
replace total_hours2011 = total_hours2011 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=45(1)56 {
replace total_hours2012 = total_hours2012 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=57(1)64 {
replace total_hours2013 = total_hours2013 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 1
}


forvalues k=1(1)7 {
replace total_hours2008 = total_hours2008 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=8(1)19 {
replace total_hours2009 = total_hours2009 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=20(1)31 {
replace total_hours2010 = total_hours2010 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=32(1)43 {
replace total_hours2011 = total_hours2011 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=44(1)55 {
replace total_hours2012 = total_hours2012 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=56(1)63 {
replace total_hours2013 = total_hours2013 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 2
}



forvalues k=1(1)6 {
replace total_hours2008 = total_hours2008 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=7(1)18 {
replace total_hours2009 = total_hours2009 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=19(1)30 {
replace total_hours2010 = total_hours2010 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=31(1)42 {
replace total_hours2011 = total_hours2011 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=43(1)54 {
replace total_hours2012 = total_hours2012 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=55(1)62 {
replace total_hours2013 = total_hours2013 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 3
}


forvalues k=1(1)5 {
replace total_hours2008 = total_hours2008 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=6(1)17 {
replace total_hours2009 = total_hours2009 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=18(1)29 {
replace total_hours2010 = total_hours2010 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=30(1)41 {
replace total_hours2011 = total_hours2011 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=42(1)53 {
replace total_hours2012 = total_hours2012 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=54(1)61 {
replace total_hours2013 = total_hours2013 + (hours_job1_month`k' + hours_job2_month`k')*wksem_month`k' if enrl_m`k' == 0 & rot == 4
}




replace hrlypayv22008 = earnings_annual2008 / total_hours2008
replace hrlypayv22009 = earnings_annual2009 / total_hours2009
replace hrlypayv22010 = earnings_annual2010 / total_hours2010
replace hrlypayv22011 = earnings_annual2011 / total_hours2011
replace hrlypayv22012 = earnings_annual2012 / total_hours2012
replace hrlypayv22013 = earnings_annual2013 / total_hours2013

forvalues k=2008(1)2013 {
replace hrlypay`k' = hrlypayv1`k'
replace hrlypay`k' = hrlypayv2`k' if hrlypay`k' == . | hrlypay`k' == 0
}


sum hrlypay*





sum age2008 age2009 age2010 age2011 age2012 age2013

sum black* hispanic*

sum hrlypay*, d






/* State and region */
/* I take the state from the first wave as the state for 2008 and the fourth wave for 2009, 7th for 2010, 10th for 2011 */
rename state5 state

gen west = 0
gen northeast = 0
gen midwest = 0
gen south = 0

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west2008 = west
gen northeast2008 = northeast
gen midwest2008 = midwest
gen south2008 = south

rename state state_ba_degree 


/* state4 is the state from the 4th wave, which is in the second year */
rename state17 state

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west2009 = west
gen northeast2009 = northeast
gen midwest2009 = midwest
gen south2009 = south

drop state


/* 2010 */
rename state29 state

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west2010 = west
gen northeast2010 = northeast
gen midwest2010 = midwest
gen south2010 = south

drop state


/* 2011 */
rename state41 state

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west2011 = west
gen northeast2011 = northeast
gen midwest2011 = midwest
gen south2011 = south

drop state


/* 2012 */
rename state53 state

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west2012 = west
gen northeast2012 = northeast
gen midwest2012 = midwest
gen south2012 = south

drop state


/* 2013 */
rename state61 state

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west2013 = west
gen northeast2013 = northeast
gen midwest2013 = midwest
gen south2013 = south


drop west south midwest northeast 



/* Division of degree */
gen ba_newengland = 0
gen ba_midatlantic = 0
gen ba_eastnorthcentral = 0
gen ba_westnorthcentral = 0
gen ba_southatlantic = 0
gen ba_eastsouthcentral = 0
gen ba_westsouthcentral = 0
gen ba_mountain = 0
gen ba_pacific = 0


replace ba_newengland = 1 if state_ba_degree == 9 | state_ba_degree == 25 | state_ba_degree == 33  | state_ba_degree == 44 | state_ba_degree == 23 | state_ba_degree == 50 | state_ba_degree == 61
replace ba_midatlantic = 1 if state_ba_degree == 34 | state_ba_degree == 36 | state_ba_degree == 42
replace ba_eastnorthcentral = 1 if  state_ba_degree == 55 | state_ba_degree == 39 | state_ba_degree == 26 | state_ba_degree == 18 | state_ba_degree == 17
replace ba_westnorthcentral = 1 if state_ba_degree == 62 | state_ba_degree == 19 | state_ba_degree == 38 | state_ba_degree == 46 | state_ba_degree == 31| state_ba_degree == 20 | state_ba_degree == 29 | state_ba_degree == 27
replace ba_southatlantic = 1 if state_ba_degree == 10 | state_ba_degree == 11 | state_ba_degree == 24 | state_ba_degree == 54 | state_ba_degree == 51 | state_ba_degree == 37 | state_ba_degree == 45 | state_ba_degree == 12 | state_ba_degree == 13
replace ba_eastsouthcentral = 1 if state_ba_degree == 28 | state_ba_degree == 21 | state_ba_degree == 47 | state_ba_degree == 1
replace ba_westsouthcentral = 1 if state_ba_degree == 5 | state_ba_degree == 22 | state_ba_degree == 40 | state_ba_degree == 48
replace ba_mountain = 1 if state_ba_degree == 4 | state_ba_degree == 8 | state_ba_degree == 16 | state_ba_degree == 30 | state_ba_degree == 32 | state_ba_degree == 35 | state_ba_degree == 49 | state_ba_degree == 56
replace ba_pacific = 1 if state_ba_degree == 2 | state_ba_degree == 15 | state_ba_degree == 6 | state_ba_degree == 41 | state_ba_degree == 53






/* Survey weights */
/* I need to average the weights for each month over the year to get the annual weight */
forvalues k=1(1)44 {
replace weight`k' = 0 if weight`k' <= 0 | weight`k' == .
}

gen survey_weight2008 = .
gen survey_weight2009 = .
gen survey_weight2010 = .
gen survey_weight2011 = .
gen survey_weight2012 = .
gen survey_weight2013 = .

replace survey_weight2008 = (weight1+weight2+weight3+weight4+weight5+weight6+weight7+weight8)/months_seen2008 if rot == 1
replace survey_weight2008 = (weight1+weight2+weight3+weight4+weight5+weight6+weight7)/months_seen2008 if rot == 2
replace survey_weight2008 = (weight1+weight2+weight3+weight4+weight5+weight6)/months_seen2008 if rot == 3
replace survey_weight2008 = (weight1+weight2+weight3+weight4+weight5)/months_seen2008 if rot == 4

replace survey_weight2009 = (weight9+weight10+weight11+weight12+weight13+weight14+weight15+weight16+weight17+weight18+weight19+weight20)/months_seen2009 if rot == 1
replace survey_weight2009 = (weight8+weight9+weight10+weight11+weight12+weight13+weight14+weight15+weight16+weight17+weight18+weight19)/months_seen2009 if rot == 2
replace survey_weight2009 = (weight7+weight8+weight9+weight10+weight11+weight12+weight13+weight14+weight15+weight16+weight17+weight18)/months_seen2009 if rot == 3
replace survey_weight2009 = (weight6+weight7+weight8+weight9+weight10+weight11+weight12+weight13+weight14+weight15+weight16+weight17)/months_seen2009 if rot == 4

replace survey_weight2010 = (weight21+weight22+weight23+weight24+weight25+weight26+weight27+weight28+weight29+weight30+weight31+weight32)/months_seen2010 if rot == 1
replace survey_weight2010 = (weight20+weight21+weight22+weight23+weight24+weight25+weight26+weight27+weight28+weight29+weight30+weight31)/months_seen2010 if rot == 2
replace survey_weight2010 = (weight19+weight20+weight21+weight22+weight23+weight24+weight25+weight26+weight27+weight28+weight29+weight30)/months_seen2010 if rot == 3
replace survey_weight2010 = (weight18+weight19+weight20+weight21+weight22+weight23+weight24+weight25+weight26+weight27+weight28+weight29)/months_seen2010 if rot == 4

replace survey_weight2011 = (weight33+weight34+weight35+weight36+weight37+weight38+weight39+weight40+weight41+weight42+weight43+weight44)/months_seen2011 if rot == 1
replace survey_weight2011 = (weight32+weight33+weight34+weight35+weight36+weight37+weight38+weight39+weight40+weight41+weight42+weight43)/months_seen2011 if rot == 2
replace survey_weight2011 = (weight31+weight32+weight33+weight34+weight35+weight36+weight37+weight38+weight39+weight40+weight41+weight42)/months_seen2011 if rot == 3
replace survey_weight2011 = (weight30+weight31+weight32+weight33+weight34+weight35+weight36+weight37+weight38+weight39+weight40+weight41)/months_seen2011 if rot == 4

replace survey_weight2012 = (weight45+weight46+weight47+weight48+weight49+weight50+weight51+weight52+weight53+weight54+weight55+weight56)/months_seen2012 if rot == 1
replace survey_weight2012 = (weight44+weight45+weight46+weight47+weight48+weight49+weight50+weight51+weight52+weight53+weight54+weight55)/months_seen2012 if rot == 2
replace survey_weight2012 = (weight43+weight44+weight45+weight46+weight47+weight48+weight49+weight50+weight51+weight52+weight53+weight54)/months_seen2012 if rot == 3
replace survey_weight2012 = (weight42+weight43+weight44+weight45+weight46+weight47+weight48+weight49+weight50+weight51+weight52+weight53)/months_seen2012 if rot == 4

replace survey_weight2013 = (weight57+weight58+weight59+weight60+weight61+weight62+weight63+weight64)/months_seen2013 if rot == 1
replace survey_weight2013 = (weight56+weight57+weight58+weight59+weight60+weight61+weight62+weight63)/months_seen2013 if rot == 2
replace survey_weight2013 = (weight55+weight56+weight57+weight58+weight59+weight60+weight61+weight62)/months_seen2013 if rot == 3
replace survey_weight2013 = (weight54+weight55+weight56+weight57+weight58+weight59+weight60+weight61)/months_seen2013 if rot == 4

drop weight*


/* Are you employed? */
/* How should I do this? I have 12 observations per year */
/* For now, what I do (also for occupation and industry and full-time) is take the middle months of the person's year */

gen employed2008 = 0
gen employed2009 = 0
gen employed2010 = 0
gen employed2011 = 0
gen employed2012 = 0
gen employed2013 = 0

/* Group 1 */
forvalues k=1(1)8 {
replace employed2008 = employed2008 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 1
}

forvalues k=9(1)20 {
replace employed2009 = employed2009 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 1
}

forvalues k=21(1)32 {
replace employed2010 = employed2010 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 1
}

forvalues k=33(1)44 {
replace employed2011 = employed2011 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 1
}

forvalues k=45(1)56 {
replace employed2012 = employed2012 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 1
}

forvalues k=57(1)64 {
replace employed2013 = employed2013 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 1
}


/* Group 2 */
forvalues k=1(1)7 {
replace employed2008 = employed2008 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 2
}

forvalues k=8(1)19 {
replace employed2009 = employed2009 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 2
}

forvalues k=20(1)31 {
replace employed2010 = employed2010 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 2
}

forvalues k=32(1)43 {
replace employed2011 = employed2011 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 2
}

forvalues k=44(1)55 {
replace employed2012 = employed2012 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 2
}

forvalues k=56(1)63 {
replace employed2013 = employed2013 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 2
}


/* Group 3 */
forvalues k=1(1)6 {
replace employed2008 = employed2008 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 3
}

forvalues k=7(1)18 {
replace employed2009 = employed2009 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 3
}

forvalues k=19(1)30 {
replace employed2010 = employed2010 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 3
}

forvalues k=31(1)42 {
replace employed2011 = employed2011 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 3
}

forvalues k=43(1)54 {
replace employed2012 = employed2012 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 3
}

forvalues k=55(1)62 {
replace employed2013 = employed2013 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 3
}


/* Group 4 */
forvalues k=1(1)5 {
replace employed2008 = employed2008 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 4
}

forvalues k=6(1)17 {
replace employed2009 = employed2009 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 4
}

forvalues k=18(1)29 {
replace employed2010 = employed2010 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 4
}

forvalues k=30(1)41 {
replace employed2011 = employed2011 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 4
}

forvalues k=42(1)53 {
replace employed2012 = employed2012 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 4
}

forvalues k=54(1)61 {
replace employed2013 = employed2013 + 1 if wksem_month`k' >= 1 & enrl_m`k' == 0 & rot == 4
}


replace employed2008 = employed2008 / (months_seen2008 - months_enrolled2008)
replace employed2009 = employed2009 / (months_seen2009 - months_enrolled2009)
replace employed2010 = employed2010 / (months_seen2010 - months_enrolled2010)
replace employed2011 = employed2011 / (months_seen2011 - months_enrolled2011)
replace employed2012 = employed2012 / (months_seen2012 - months_enrolled2012)
replace employed2013 = employed2013 / (months_seen2013 - months_enrolled2013)



sum employed*



/* Are you full-time? */

gen fulltime2008 = 0
gen fulltime2009 = 0
gen fulltime2010 = 0
gen fulltime2011 = 0
gen fulltime2012 = 0
gen fulltime2013 = 0

/* Group 1 */
forvalues k=1(1)8 {
replace fulltime2008 = fulltime2008 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=9(1)20 {
replace fulltime2009 = fulltime2009 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=21(1)32 {
replace fulltime2010 = fulltime2010 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=33(1)44 {
replace fulltime2011 = fulltime2011 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=45(1)56 {
replace fulltime2012 = fulltime2012 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=57(1)64 {
replace fulltime2013 = fulltime2013 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}


/* Group 2 */
forvalues k=1(1)7 {
replace fulltime2008 = fulltime2008 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=8(1)19 {
replace fulltime2009 = fulltime2009 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=20(1)31 {
replace fulltime2010 = fulltime2010 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=32(1)43 {
replace fulltime2011 = fulltime2011 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=44(1)55 {
replace fulltime2012 = fulltime2012 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=56(1)63 {
replace fulltime2013 = fulltime2013 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}


/* Group 3 */
forvalues k=1(1)6 {
replace fulltime2008 = fulltime2008 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=7(1)18 {
replace fulltime2009 = fulltime2009 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=19(1)30 {
replace fulltime2010 = fulltime2010 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=31(1)42 {
replace fulltime2011 = fulltime2011 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=43(1)54 {
replace fulltime2012 = fulltime2012 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=55(1)62 {
replace fulltime2013 = fulltime2013 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}


/* Group 4 */
forvalues k=1(1)5 {
replace fulltime2008 = fulltime2008 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=6(1)17 {
replace fulltime2009 = fulltime2009 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=18(1)29 {
replace fulltime2010 = fulltime2010 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=30(1)41 {
replace fulltime2011 = fulltime2011 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=42(1)53 {
replace fulltime2012 = fulltime2012 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=54(1)61 {
replace fulltime2013 = fulltime2013 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}


replace fulltime2008 = fulltime2008 / (months_seen2008 - months_enrolled2008)
replace fulltime2009 = fulltime2009 / (months_seen2009 - months_enrolled2009)
replace fulltime2010 = fulltime2010 / (months_seen2010 - months_enrolled2010)
replace fulltime2011 = fulltime2011 / (months_seen2011 - months_enrolled2011)
replace fulltime2012 = fulltime2012 / (months_seen2012 - months_enrolled2012)
replace fulltime2013 = fulltime2013 / (months_seen2013 - months_enrolled2013)



sum fulltime*




/* OCCUPATION */

/* THESE ARE ??? 4-DIGIT CODES */
forvalues k=1(1)64 {
replace occ1_month`k' = . if occ1_month`k' == 0 | occ1_month`k' == 905 | occ1_month`k' < 0
}

forvalues k=1(1)12 {
gen occ`k'_2008 = .
gen occ`k'_2009 = .
gen occ`k'_2010 = .
gen occ`k'_2011 = .
gen occ`k'_2012 = .
gen occ`k'_2013 = .
}



forvalues k=1(1)8 {
local j = `k' + 4
replace occ`j'_2008 = occ1_month`k' if rot == 1
}

forvalues k=9(1)20 {
local j = `k' - 8
replace occ`j'_2009 = occ1_month`k' if rot == 1
}

forvalues k=21(1)32 {
local j = `k' - 20
replace occ`j'_2010 = occ1_month`k' if rot == 1
}

forvalues k=33(1)44 {
local j = `k' - 32
replace occ`j'_2011 = occ1_month`k' if rot == 1
}

forvalues k=45(1)56 {
local j = `k' - 44
replace occ`j'_2012 = occ1_month`k' if rot == 1
}

forvalues k=57(1)64 {
local j = `k' - 56
replace occ`j'_2013 = occ1_month`k' if rot == 1
}


forvalues k=1(1)7 {
local j = `k' + 5
replace occ`j'_2008 = occ1_month`k' if rot == 2
}

forvalues k=8(1)19 {
local j = `k' - 7
replace occ`j'_2009 = occ1_month`k' if rot == 2
}

forvalues k=20(1)31 {
local j = `k' - 19
replace occ`j'_2010 = occ1_month`k' if rot == 2
}

forvalues k=32(1)43 {
local j = `k' - 31
replace occ`j'_2011 = occ1_month`k' if rot == 2
}

forvalues k=44(1)55 {
local j = `k' - 43
replace occ`j'_2012 = occ1_month`k' if rot == 2
}

forvalues k=56(1)63 {
local j = `k' - 55
replace occ`j'_2013 = occ1_month`k' if rot == 2
}


forvalues k=1(1)6 {
local j = `k' + 6
replace occ`j'_2008 = occ1_month`k' if rot == 3
}

forvalues k=7(1)18 {
local j = `k' - 6
replace occ`j'_2009 = occ1_month`k' if rot == 3
}

forvalues k=19(1)30 {
local j = `k' - 18
replace occ`j'_2010 = occ1_month`k' if rot == 3
}

forvalues k=31(1)42 {
local j = `k' - 30
replace occ`j'_2011 = occ1_month`k' if rot == 3
}

forvalues k=43(1)54 {
local j = `k' - 42
replace occ`j'_2012 = occ1_month`k' if rot == 3
}

forvalues k=55(1)62 {
local j = `k' - 54
replace occ`j'_2013 = occ1_month`k' if rot == 3
}


forvalues k=1(1)5 {
local j = `k' + 7
replace occ`j'_2008 = occ1_month`k' if rot == 4
}

forvalues k=6(1)17 {
local j = `k' - 5
replace occ`j'_2009 = occ1_month`k' if rot == 4
}

forvalues k=18(1)29 {
local j = `k' - 17
replace occ`j'_2010 = occ1_month`k' if rot == 4
}

forvalues k=30(1)41 {
local j = `k' - 29
replace occ`j'_2011 = occ1_month`k' if rot == 4
}

forvalues k=42(1)53 {
local j = `k' - 41
replace occ`j'_2012 = occ1_month`k' if rot == 4
}

forvalues k=54(1)61 {
local j = `k' - 53
replace occ`j'_2013 = occ1_month`k' if rot == 4
}






/* INDUSTRY */
/* I use the 6th month industry as the industry. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE ??? 4-DIGIT CODES */
forvalues k=1(1)64 {
replace ind1_month`k' = . if ind1_month`k' == 0 | ind1_month`k' == 905 | ind1_month`k' < 0
}



forvalues k=1(1)12 {
gen ind`k'_2008 = .
gen ind`k'_2009 = .
gen ind`k'_2010 = .
gen ind`k'_2011 = .
gen ind`k'_2012 = .
gen ind`k'_2013 = .
}



forvalues k=1(1)8 {
local j = `k' + 4
replace ind`j'_2008 = ind1_month`k' if rot == 1
}

forvalues k=9(1)20 {
local j = `k' - 8
replace ind`j'_2009 = ind1_month`k' if rot == 1
}

forvalues k=21(1)32 {
local j = `k' - 20
replace ind`j'_2010 = ind1_month`k' if rot == 1
}

forvalues k=33(1)44 {
local j = `k' - 32
replace ind`j'_2011 = ind1_month`k' if rot == 1
}

forvalues k=45(1)56 {
local j = `k' - 44
replace ind`j'_2012 = ind1_month`k' if rot == 1
}

forvalues k=57(1)64 {
local j = `k' - 56
replace ind`j'_2013 = ind1_month`k' if rot == 1
}


forvalues k=1(1)7 {
local j = `k' + 5
replace ind`j'_2008 = ind1_month`k' if rot == 2
}

forvalues k=8(1)19 {
local j = `k' - 7
replace ind`j'_2009 = ind1_month`k' if rot == 2
}

forvalues k=20(1)31 {
local j = `k' - 19
replace ind`j'_2010 = ind1_month`k' if rot == 2
}

forvalues k=32(1)43 {
local j = `k' - 31
replace ind`j'_2011 = ind1_month`k' if rot == 2
}

forvalues k=44(1)55 {
local j = `k' - 43
replace ind`j'_2012 = ind1_month`k' if rot == 2
}

forvalues k=56(1)63 {
local j = `k' - 55
replace ind`j'_2013 = ind1_month`k' if rot == 2
}


forvalues k=1(1)6 {
local j = `k' + 6
replace ind`j'_2008 = ind1_month`k' if rot == 3
}

forvalues k=7(1)18 {
local j = `k' - 6
replace ind`j'_2009 = ind1_month`k' if rot == 3
}

forvalues k=19(1)30 {
local j = `k' - 18
replace ind`j'_2010 = ind1_month`k' if rot == 3
}

forvalues k=31(1)42 {
local j = `k' - 30
replace ind`j'_2011 = ind1_month`k' if rot == 3
}

forvalues k=43(1)54 {
local j = `k' - 42
replace ind`j'_2012 = ind1_month`k' if rot == 3
}

forvalues k=55(1)62 {
local j = `k' - 54
replace ind`j'_2013 = ind1_month`k' if rot == 3
}


forvalues k=1(1)5 {
local j = `k' + 7
replace ind`j'_2008 = ind1_month`k' if rot == 4
}

forvalues k=6(1)17 {
local j = `k' - 5
replace ind`j'_2009 = ind1_month`k' if rot == 4
}

forvalues k=18(1)29 {
local j = `k' - 17
replace ind`j'_2010 = ind1_month`k' if rot == 4
}

forvalues k=30(1)41 {
local j = `k' - 29
replace ind`j'_2011 = ind1_month`k' if rot == 4
}

forvalues k=42(1)53 {
local j = `k' - 41
replace ind`j'_2012 = ind1_month`k' if rot == 4
}

forvalues k=54(1)61 {
local j = `k' - 53
replace ind`j'_2013 = ind1_month`k' if rot == 4
}


drop *month*

bysort rot: sum ind* occ*



/* Identifying variables */
keep *2008 *2009 *2010 *2011 *2012 *2013 ssuid eentaid epppnum rot tbyear state_ba* ba_*

sort ssuid eentaid epppnum
compress
save Temp/sipp08_full_cleaned.dta, replace


*************************************************************************************

clear

use Temp/sipp08wave2.dta


/**** WAVE 2 DATASET ****/



/* Identifiers */
sum ssuid eentaid epppnum



/********** COLLEGE DEGREE INFORMATION *********/

/* 2 questions: highest degree and BA degree. Need to check both */

/* Need year of degree, age at degree, and field of degree. Also need highest degree completed */


gen col = 0
gen morcol = 0
gen hgc = .



replace hgc = 0    if eeducate == 31
replace hgc = 2.5  if eeducate == 32
replace hgc = 5.5  if eeducate == 33
replace hgc = 7.5  if eeducate == 34
replace hgc = 9    if eeducate == 35
replace hgc = 10   if eeducate == 36
replace hgc = 11   if eeducate == 37
replace hgc = 11.5 if eeducate == 38
replace hgc = 12   if eeducate == 39
replace hgc = 13   if eeducate == 40
replace hgc = 13.5 if eeducate == 41
replace hgc = 14   if eeducate == 42
replace hgc = 14   if eeducate == 43
replace hgc = 16   if eeducate == 44
replace hgc = 18   if eeducate == 45
replace hgc = 19   if eeducate == 46
replace hgc = 20   if eeducate == 47

tab hgc, mi

replace col = 1 if hgc == 16
replace morcol = 1 if hgc > 16 & hgc != .

drop if hgc == .


tab col morcol


gen gradyear = .


replace gradyear = tbachyr if tbachyr > 0

tab gradyear




/* Field of bachelor's degree */

rename ebachfld major_field
replace major_field = . if major_field == -1

tab major_field if hgc == 16
tab major_field if hgc > 16 & hgc != .


tab hgc


keep hgc major_field gradyear col morcol ssuid eentaid epppnum


sort ssuid eentaid epppnum



merge ssuid eentaid epppnum using Temp/sipp08_full_cleaned.dta

tab _merge if hgc != .
drop if _merge == 2
drop _merge

gen age_grad = .

replace age_grad = gradyear - tbyear

tab age_grad


capture drop pid

egen pid=group(ssuid eentaid epppnum)
*bysort su_id pp_entry pp_pnum: gen pid = _n

drop ssuid eentaid epppnum

drop earnings_job* earnings_se* tbyear

capture drop *month*

reshape long total_hours survey_weight age male hispanic black earnings_annual hrlypay hrlypayv1 hrlypayv2 enrolled west northeast midwest south employed fulltime occ1_ occ2_ occ3_ occ4_ occ5_ occ6_ occ7_ occ8_ occ9_ occ10_ occ11_ occ12_ ind1_ ind2_ ind3_ ind4_ ind5_ ind6_ ind7_ ind8_ ind9_ ind10_ ind11_ ind12_, i(pid) j(year)

forvalues k=1(1)12 {
rename occ`k'_ occ`k'
rename ind`k'_ ind`k'
}


* keep if age >= 22

* keep if major_field != .
tab major_field, mi
tab major_field if hgc == 16
tab gradyear
gen potexp = year - gradyear
tab potexp

tab gradyear potexp if hgc == 16 & potexp <= 13

sum

gen panel = 2008
gen survey = 08091011

sort pid
compress
save Temp/sipp08_ready.dta, replace


clear





/* Now I combine the years */




use Temp/sipp96_ready.dta

sum enrolled if potexp >= 1 & potexp <= 13
sum employed if potexp >= 1 & potexp <= 13

append using Temp/sipp01_ready.dta

sum enrolled if potexp >= 1 & potexp <= 13
sum employed if potexp >= 1 & potexp <= 13

append using Temp/sipp04_ready.dta

sum enrolled if potexp >= 1 & potexp <= 13
sum employed if potexp >= 1 & potexp <= 13

append using Temp/sipp08_ready.dta

sum enrolled if potexp >= 1 & potexp <= 13
sum employed if potexp >= 1 & potexp <= 13



tab gradyear potexp

tab gradyear potexp if earnings_annual > 500

tab survey

tab year



/* 1996 and 2001 occupations are already in 1990 form. 2004 and 2008 is 4-digit 2000+ codes.  */
forvalues k=1(1)12 {
gen occ2005= occ`k'
replace occ2005 = . if panel == 1996 | panel == 2001

rename occ`k' occ90
rename occ2005 occ`k'

rename occ`k' occ
sort occ

merge m:1 occ using Crosswalks/occ2005_to_occ1990.dta
tab _merge
drop _merge

drop occ
gen occ`k' = .
replace occ`k' = occ1990 if panel > 2001
replace occ`k' = occ90 if panel <= 2001
drop occ1990 occ90

replace occ`k' = . if occ`k' >= 9800

bysort panel: sum occ`k'
}



forvalues k=1(1)12 {
gen ind2005= ind`k'
replace ind2005 = . if panel == 1996 | panel == 2001

rename ind`k' ind90
rename ind2005 ind`k'

rename ind`k' ind
sort ind

merge m:1 ind using Crosswalks/ind2005_to_ind1990.dta
tab _merge
drop _merge

drop ind
gen ind`k' = .
replace ind`k' = ind1990 if panel > 2001
replace ind`k' = ind90 if panel <= 2001
drop ind1990 ind90

replace ind`k' = . if ind`k' >= 9800

bysort panel: sum ind`k'
}




/* Deflating to 1982-84 dollars */
replace earnings_annual = earnings_annual / 1.569 if year == 1996
replace earnings_annual = earnings_annual / 1.605 if year == 1997
replace earnings_annual = earnings_annual / 1.630 if year == 1998
replace earnings_annual = earnings_annual / 1.666 if year == 1999
replace earnings_annual = earnings_annual / 1.722 if year == 2000
replace earnings_annual = earnings_annual / 1.771 if year == 2001
replace earnings_annual = earnings_annual / 1.799 if year == 2002
replace earnings_annual = earnings_annual / 1.840 if year == 2003
replace earnings_annual = earnings_annual / 1.889 if year == 2004
replace earnings_annual = earnings_annual / 1.953 if year == 2005
replace earnings_annual = earnings_annual / 2.016 if year == 2006
replace earnings_annual = earnings_annual / 2.073 if year == 2007
replace earnings_annual = earnings_annual / 2.153 if year == 2008
replace earnings_annual = earnings_annual / 2.145 if year == 2009
replace earnings_annual = earnings_annual / 2.181 if year == 2010
replace earnings_annual = earnings_annual / 2.249 if year == 2011
replace earnings_annual = earnings_annual / 2.296 if year == 2012
replace earnings_annual = earnings_annual / 2.330 if year == 2013


replace hrlypay = hrlypay / 1.569 if year == 1996
replace hrlypay = hrlypay / 1.605 if year == 1997
replace hrlypay = hrlypay / 1.630 if year == 1998
replace hrlypay = hrlypay / 1.666 if year == 1999
replace hrlypay = hrlypay / 1.722 if year == 2000
replace hrlypay = hrlypay / 1.771 if year == 2001
replace hrlypay = hrlypay / 1.799 if year == 2002
replace hrlypay = hrlypay / 1.840 if year == 2003
replace hrlypay = hrlypay / 1.889 if year == 2004
replace hrlypay = hrlypay / 1.953 if year == 2005
replace hrlypay = hrlypay / 2.016 if year == 2006
replace hrlypay = hrlypay / 2.073 if year == 2007
replace hrlypay = hrlypay / 2.153 if year == 2008
replace hrlypay = hrlypay / 2.145 if year == 2009
replace hrlypay = hrlypay / 2.181 if year == 2010
replace hrlypay = hrlypay / 2.249 if year == 2011
replace hrlypay = hrlypay / 2.296 if year == 2012
replace hrlypay = hrlypay / 2.330 if year == 2013

replace hrlypayv1 = hrlypayv1 / 1.569 if year == 1996
replace hrlypayv1 = hrlypayv1 / 1.605 if year == 1997
replace hrlypayv1 = hrlypayv1 / 1.630 if year == 1998
replace hrlypayv1 = hrlypayv1 / 1.666 if year == 1999
replace hrlypayv1 = hrlypayv1 / 1.722 if year == 2000
replace hrlypayv1 = hrlypayv1 / 1.771 if year == 2001
replace hrlypayv1 = hrlypayv1 / 1.799 if year == 2002
replace hrlypayv1 = hrlypayv1 / 1.840 if year == 2003
replace hrlypayv1 = hrlypayv1 / 1.889 if year == 2004
replace hrlypayv1 = hrlypayv1 / 1.953 if year == 2005
replace hrlypayv1 = hrlypayv1 / 2.016 if year == 2006
replace hrlypayv1 = hrlypayv1 / 2.073 if year == 2007
replace hrlypayv1 = hrlypayv1 / 2.153 if year == 2008
replace hrlypayv1 = hrlypayv1 / 2.145 if year == 2009
replace hrlypayv1 = hrlypayv1 / 2.181 if year == 2010
replace hrlypayv1 = hrlypayv1 / 2.249 if year == 2011
replace hrlypayv1 = hrlypayv1 / 2.296 if year == 2012
replace hrlypayv1 = hrlypayv1 / 2.330 if year == 2013

replace hrlypayv2 = hrlypayv2 / 1.569 if year == 1996
replace hrlypayv2 = hrlypayv2 / 1.605 if year == 1997
replace hrlypayv2 = hrlypayv2 / 1.630 if year == 1998
replace hrlypayv2 = hrlypayv2 / 1.666 if year == 1999
replace hrlypayv2 = hrlypayv2 / 1.722 if year == 2000
replace hrlypayv2 = hrlypayv2 / 1.771 if year == 2001
replace hrlypayv2 = hrlypayv2 / 1.799 if year == 2002
replace hrlypayv2 = hrlypayv2 / 1.840 if year == 2003
replace hrlypayv2 = hrlypayv2 / 1.889 if year == 2004
replace hrlypayv2 = hrlypayv2 / 1.953 if year == 2005
replace hrlypayv2 = hrlypayv2 / 2.016 if year == 2006
replace hrlypayv2 = hrlypayv2 / 2.073 if year == 2007
replace hrlypayv2 = hrlypayv2 / 2.153 if year == 2008
replace hrlypayv2 = hrlypayv2 / 2.145 if year == 2009
replace hrlypayv2 = hrlypayv2 / 2.181 if year == 2010
replace hrlypayv2 = hrlypayv2 / 2.249 if year == 2011
replace hrlypayv2 = hrlypayv2 / 2.296 if year == 2012
replace hrlypayv2 = hrlypayv2 / 2.330 if year == 2013



/* Merging in occbeta */

forvalues k=1(1)12 {
rename occ`k' occ1990
sort occ1990

merge m:1 occ1990 using Crosswalks/occupation_betas_and_scores.dta

rename occbeta occbeta`k'
tab _merge
drop _merge

rename occ1990 occ`k'
}

sum occbeta*



/* Getting an occbeta measure for the entire year */

/* First, I need the # of non-missing occbeta observations we have for each year */
gen occ_count = 0
forvalues k=1(1)12 {
replace occ_count = occ_count + 1 if occbeta`k' != .
}

gen total_occbeta = 0
forvalues k=1(1)12 {
replace total_occbeta = total_occbeta + occbeta`k' if occbeta`k' != .
}

gen occbeta = total_occbeta / occ_count

tab occ_count

drop occ_count total_occbeta occbeta1* occbeta2 occbeta3 occbeta4 occbeta5 occbeta6 occbeta7 occbeta8 occbeta9

sum occbeta






gen lnearnings = ln(earnings_annual)
gen lnpay = ln(hrlypay)
gen lnpay1 = ln(hrlypayv1)
gen lnpay2 = ln(hrlypayv2)

gen potexp2 = potexp^2

rename year bob
rename gradyear year
sort year

/*
tab hgc, mi
merge m:1 year using Crosswalks/unemployment_rates_national.dta
drop if _merge != 3
tab hgc, mi
*/

* rename urate_natl urate_grad
rename year gradyear
rename bob year

rename major_field major_field_96to08

keep *earnings* ba_* occ1 occ2 occ3 occ4 occ5 occ6 occ7 occ8 occ9 occ10 occ11 occ12 age_grad survey_weight state_ba_degree total_hours *pay* pid year major_field_96to08 col morcol hgc gradyear age male black hispanic potexp* enrolled employed occbeta fulltime northeast south midwest west survey panel

compress
save Temp/sipp96to08_ready.dta, replace
!gzip -f Temp/sipp96to08_ready.dta

tab hgc, mi

log close


******************
