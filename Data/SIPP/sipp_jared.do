version 14.1
clear all
set more off
capture log close
log using sipp_jared.log, replace

/* This file follows sipp_96to08_master_readin.do */
/* This file combines the SIPP files and transforms them into person-record format so we can use them, then combines all the years */
/* Some notes:
SIPP notes:

For 1996, it looks like there are 12 files, with each file having a trimester of the year, ie months 1-4, 5-8 or 9-12
In each month, we have info on wksem (across all jobs), wage1 (called wage; wage2 was ignored for some reason), hoursjob1, earnjob1, hoursjob2, earnjob2, and demographics

It appears that anyone who was enrolled was not allowed to have earnings
`replace earnings_annual1996 = earnings_annual1996 + earnings_job1_month`k' + earnings_job2_month`k' if enrl_m`k' == 0 & rot == 1`
`replace earnings_annual1996 = (earnings_annual1996/(months_seen1996-months_enrolled1996)) * 12  if rot == 1`
`replace earnings_annual1996 = 0 if months_enrolled1996 == months_seen1996 & rot == 1`


Some pid's may not be uniquely identifying obs
*/

/* Interview date Roadmap: 
1996: k - 1-12
2001: k - 1-9
2004: k - 1-12
2008: k - 1-16

* Rotation group 1: 1996 is months 2-13, 1997 is months 14-25, 1998 is 26-37, 1999 is 38-48 
* Rotation group 2: 1996 is months 1-12, 1997 is months 13-24, 1998 is 25-36, 1999 is 37-48 
* Rotation group 3: 1996 is months 1-11, 1997 is months 12-23, 1998 is 24-35, 1999 is 36-47 
* Rotation group 4: 1996 is months 1-10, 1997 is months 11-22, 1998 is 22-34, 1999 is 35-46 
* Rotation group 1: 2001 is months 2-13, 2002 is months 14-25, 2003 is 26-37, 2004 is 38-48 
* Rotation group 2: 2001 is months 1-12, 2002 is months 13-24, 2003 is 25-36, 2004 is 37-48 
* Rotation group 3: 2001 is months 1-11, 2002 is months 12-23, 2003 is 24-35, 2004 is 36-47 
* Rotation group 4: 2001 is months 1-10, 2002 is months 11-22, 2003 is 22-34, 2004 is 35-46 
* Rotation group 1: 2004 is months 2-13, 2005 is months 14-25, 2006 is 26-37, 2007 is 38-48 
* Rotation group 2: 2004 is months 1-12, 2005 is months 13-24, 2006 is 25-36, 2007 is 37-48 
* Rotation group 3: 2004 is months 1-11, 2005 is months 12-23, 2006 is 24-35, 2007 is 36-47 
* Rotation group 4: 2004 is months 1-10, 2005 is months 11-22, 2006 is 22-34, 2007 is 35-46 
* Rotation group 1: 2008 is months 2-13, 2009 is months 14-25, 2010 is 26-37, 2011 is 38-48 
* Rotation group 2: 2008 is months 1-12, 2009 is months 13-24, 2010 is 25-36, 2011 is 37-48 
* Rotation group 3: 2008 is months 1-11, 2009 is months 12-23, 2010 is 24-35, 2011 is 36-47 
* Rotation group 4: 2008 is months 1-10, 2009 is months 11-22, 2010 is 22-34, 2011 is 35-46 

* I belive the above is slightly off; best ot try to convert values into months;

From what I can tell from the user's guide, the 96 went like this:
Rot 1: Dec. 95-Nov. 99 (48 months)
Rot 2: Jan. 96-Dec. 99 (48 months)
Rot 3: Feb. 96-Jan. 00 (48 months)
Rot 4: Mar. 96-Feb. 00 (48 months)
  ------10 months skipped
2001 went like this:
Rot 1: Oct. 00-Sep. 03 (36 months)
Rot 2: Nov. 00-Oct. 03 (36 months)
Rot 3: Dec. 00-Nov. 03 (36 months)
Rot 4: Jan. 01-Dec. 03 (36 months)

2004 went like this:
Rot 1: Oct. 03-Sep. 07 (48 months)
Rot 2: Nov. 03-Oct. 07 (48 months)
Rot 3: Dec. 03-Nov. 07 (48 months)
Rot 4: Jan. 04-Dec. 07 (48 months)

2008 went like this (we may have more data then the online file refers to)
Rot 1: May. 08-Aug. 12 (52 months) 64?
Rot 2: Jun. 08-Sep. 12 (52 months)
Rot 3: Jul. 08-Oct. 12 (52 months)
Rot 4: Aug. 08-Nov. 12 (52 months)

https://www2.census.gov/programs-surveys/sipp/guidance/SIPP_2008_USERS_Guide_Chapter2.pdf, Tables 2.2-5

*/

foreach X in 96 01 04 08 {
	use Temp/sipp`X'_full, clear
	* For whatever reason, pid is garbage
	drop pid
	isid ssuid eentaid epppnum
	egen pid = group(ssuid eentaid epppnum)
	* Ideally we could create a var from ssuid eentaid eppnum
	gen  pidsvy = pid*100+`X'
	set seed 101
	* Sampler: comment out for full code
	sample 10
	
	reshape long state weight age enrl_m wksem_month hours_job1_month earnings_job1_month wage_month ind1_month occ1_month hours_job2_month earnings_job2_month male hispanic black, i(ssuid rot eentaid epppnum tbyear pid pidsvy) j(sippmonth)
	gen svy = `X'

	tempfile holder`X'
	save `holder`X''
}
clear
foreach X in 96 01 04 08 {
	append using `holder`X''
}
isid pid svy sippmonth
isid pidsvy sippmonth

* Convert sippmonth into year-month; 
gen     date0 = .
format  date0 %td

replace date0 = mdy(11,1,1995) if rot==1 & svy==96
replace date0 = mdy(12,1,1995) if rot==2 & svy==96
replace date0 = mdy( 1,1,1996) if rot==3 & svy==96
replace date0 = mdy( 2,1,1996) if rot==4 & svy==96

replace date0 = mdy( 9,1,2000) if rot==1 & svy==01
replace date0 = mdy(10,1,2000) if rot==2 & svy==01
replace date0 = mdy(11,1,2000) if rot==3 & svy==01
replace date0 = mdy(12,1,2000) if rot==4 & svy==01

replace date0 = mdy( 9,1,2003) if rot==1 & svy==04
replace date0 = mdy(10,1,2003) if rot==2 & svy==04
replace date0 = mdy(11,1,2003) if rot==3 & svy==04
replace date0 = mdy(12,1,2003) if rot==4 & svy==04

replace date0 = mdy( 4,1,2008) if rot==1 & svy==08
replace date0 = mdy( 5,1,2008) if rot==2 & svy==08
replace date0 = mdy( 6,1,2008) if rot==3 & svy==08
replace date0 = mdy( 7,1,2008) if rot==4 & svy==08
assert ~mi(date0)

gen     month0Stata = mofd(date0)
gen     monthStata = month0Stata+sippmonth
gen     month = month(dofm(monthStata))
gen     year  = year(dofm(monthStata))
format  month0Stata monthStata %tm
l pid svy sippmonth date0-year if mod(pid,20000)==0 & mod(sippmonth,12)==0, sepby(pid)

drop date0 month0Stata monthStata

* And now we can reshape it back, or just create annual vars using 'by' and then keep _n==1
* So, we need to create variables that do not vary within year

* Missing data comes from the reshape, nothing more,
* Drop all missing obs
drop if mi(weight)

* Some obs have "hours vary"; drop for now (see below)
drop if hours_job1_month==-8

* Note: the SIPP is internally consistent with whether there are
*  4 or 5 weeks in a month (ie, 5 weeks in Dec 2004; 4 weeks in Dec 2005)
*  Thus, use that var to ID num weeks in a given month
bys year month: egen wks_month = max(wksem_month)

bys pidsvy year (month): egen wks_annual_obs = total(wks_month)
bys pidsvy year (month): gen firstObs = _n==1
bys pidsvy year (month): gen numObs = _N

corr numObs wks_annual_obs

ren tbyear birthyr
* We do have age in each month if we want it
ren age ageinterview
gen age = year-birthyr

corr age ageinterview

*****************************************************************************
* Employment Status/Hours
*****************************************************************************
* data has inconsistencies between wksem and hours/earnings/wage_job?_month
*  in a very small number of instances, wksem==0, but there is job1 info
*  in a larger number of case (10%?), earnings==NA, but wksem>0
* replace employed1996 = employed1996 + 1 if wksem_month`k' >= 1 & wksem_month`k' != . & enrl_m`k' == 0 & rot == 1

* How many weeks worked; 	
bys pidsvy year (month): egen wksem_annual = total(wksem_month)
gen pct_wksem = wksem_annual/(wks_annual_obs)

* Hours worked/week (potentially use last obs of this?)
*  In later years, there is a flag for "hours vary"
*  Impute? Drop? Assume normal?
*  For now: if   obs has ANY valid hours flags for the year, use those
*           else 
label define ejbhrs1l -8 "Hours vary", add
label define ejbhrs2l -8 "Hours vary", add
* If hours vary, currently they are getting 0 hours
*  as such, they will NOT be available for FT employment in that month
* NOTE: This is a fairly large part of employees in the 2003-2013 surveys
* Solutions:
*  1-Take them out of the data
*  2-Impute hours from overall data
*  3-Inpute hours from other months 
*  For now: 1), just drop them (do this above to get the correct numObs)
* drop if hours_job1_month==-8

gen     weekly_hours = (0)*(hours_job1_month<0) + (hours_job1_month)*inrange(hours_job1_month,0,.)+ (hours_job2_month)*inrange(hours_job2_month,0,.)

* Average hours worked/week IF employed
bys pidsvy year (month): egen average_weekly_hours     = mean(weekly_hours) if inrange(wksem_month,1,5)
bys pidsvy year (month): egen average_weekly_hours_max = max(average_weekly_hours)
replace               average_weekly_hours     = max(0,average_weekly_hours_max)

* empFT IF: worked 40+ weeks (>75%) AND worked 35+ hours average in those weeks (too strong?)
gen empFT = inrange(pct_wksem,0.75,.) & inrange(average_weekly_hours,35,.)
gen empFT2= inrange(pct_wksem,0.75,.) & inrange(average_weekly_hours,30,.)
gen empFT3= inrange(pct_wksem,0.60,.) & inrange(average_weekly_hours,35,.)

tab birthyr age if inrange(age,30,34) & firstObs &  male, sum(empFT) 
tab birthyr age if inrange(age,30,34) & firstObs & ~male, sum(empFT) 

tab birthyr age if inrange(age,25,29) & firstObs &  male, sum(empFT) 
tab birthyr age if inrange(age,25,29) & firstObs & ~male, sum(empFT) 

*****************************************************************************
* Wages/earnings
*****************************************************************************
/* Earnings are by month.  */
gen earnings_monthly = (0)*(earnings_job1_month<0) + (earnings_job1_month)*inrange(earnings_job1_month,0,.)+ (earnings_job2_month)*inrange(earnings_job2_month,0,.)
bys pidsvy year (month): egen earnings_annual = total(earnings_monthly)

gen    earnings_average_hourly = earnings_annual/(wksem_annual*average_weekly_hours)
recode earnings_average_hourly (.=0)

* This generates lots of missing values, but also some zero values which are concerning (above)

* wage_month is average hourly wage in a given month IF employed
bys pidsvy year (month): egen wage_average     = mean(wage_month) if inrange(wage_month,0.01,.)
bys pidsvy year (month): egen wage_average_max = max(wage_average)
replace                       wage_average     = max(0,wage_average_max)

drop wage_average_max

gen wage = 

save sipp_jared.dta, replace

log close
exit

*************************************************************************************

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

log close


******************
