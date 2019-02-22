/* This file combines the SIPP 84 to 93 and SIPP 96 to 08, and calculates majorbetas */

/* Output: sipp_full_readyforregs.dta, the "final" SIPP file */

version 14.1
clear all
set more off

capture log close

log using sipp_combining_master.log, replace

local EY = int(10000*uniform()) // NO seed; needs to be random
!gunzip -fc Temp/sipp84to93_ready.dta.gz > Temp/tmp`EY'.dta
use Temp/tmp`EY'.dta
!rm Temp/tmp`EY'.dta

tab hgc, mi

local EY = int(10000*uniform()) // NO seed; needs to be random
!gunzip -fc Temp/sipp96to08_ready.dta.gz > Temp/tmp`EY'.dta
append using Temp/tmp`EY'.dta
!rm Temp/tmp`EY'.dta

tab hgc, mi

replace lnearnings = ln(earnings_annual)
replace lnpay = ln(hrlypay)

sum earnings_annual if earnings_annual > 500 & potexp >= 1 & potexp <= 13

tab hgc
tab hgc if age >= 22 & age<= 35

/* Region */
capture drop ba_west ba_northeast ba_midwest
foreach x in west northeast south midwest {
gen ba_`x' = 0
}

replace ba_west = 1 if ba_pacific == 1 | ba_mountain == 1
replace ba_northeast = 1 if ba_newengland == 1 | ba_midatlantic == 1
replace ba_south = 1 if ba_southatlantic == 1 | ba_eastsouthcentral == 1 | ba_westsouthcentral == 1
replace ba_midwest = 1 if ba_eastnorthcentral == 1 | ba_westnorthcentral == 1

/* STILL NEED TO COMBINE MAJOR FIELDS */
gen sipp_major = .
replace sipp_major = major_field_96to08 if panel >= 1996

replace sipp_major = 1 if major_field_84to93 == 1
replace sipp_major = 13 if major_field_84to93 == 2
replace sipp_major = 3 if major_field_84to93 == 3
replace sipp_major = 3 if major_field_84to93 == 4
replace sipp_major = 6 if major_field_84to93 == 5
replace sipp_major = 7 if major_field_84to93 == 6
replace sipp_major = 8 if major_field_84to93 == 7
replace sipp_major = 18 if major_field_84to93 == 8
replace sipp_major = 15 if major_field_84to93 == 9
replace sipp_major = 11 if major_field_84to93 == 10
replace sipp_major = 12 if major_field_84to93 == 11
replace sipp_major = 15 if major_field_84to93 == 12
replace sipp_major = 10 if major_field_84to93 == 13
replace sipp_major = 13 if major_field_84to93 == 14
replace sipp_major = 17 if major_field_84to93 == 15
replace sipp_major = 16 if major_field_84to93 == 16
replace sipp_major = 14 if major_field_84to93 == 17
replace sipp_major = 17 if major_field_84to93 == 18
replace sipp_major = 18 if major_field_84to93 == 19
replace sipp_major = 18 if major_field_84to93 == 20

sort year
* merge m:1 year using Crosswalks/unemployment_rates_national.dta
* drop if _merge != 3
* drop _merge

* rename urate_natl urate_natl_cur

* rename urate_grad urate_natl_grad
* JA: This file is un-needed
* compress
* save Temp/sipp_full_ready.dta, replace
* !gzip -f Temp/sipp_full_ready.dta

/* Estimating majorbeta */
quietly tab major_field_84to93, gen(earlymajdum)
quietly tab major_field_96to08, gen(latemajdum)

/* Early majorbeta */

/* List of early majors:
          Agriculture or Forestry |        718        1.49        1.49
                          Biology |      1,403        2.92        4.41
           Business or Management |     10,663       22.18       26.59
                        Economics |      1,196        2.49       29.08
                        Education |      6,601       13.73       42.81
 Engineering (including computers |      4,629        9.63       52.44
            English or Journalism |      2,068        4.30       56.74
                   Home Economics |        501        1.04       57.78
                              Law |        218        0.45       58.23
       Liberal Arts or Humanities |      4,561        9.49       67.72
        Mathematics or Statistics |        961        2.00       69.72
            Medicine or Dentistry |        235        0.49       70.21
     Nursing, Pharmacy, or Health |      2,975        6.19       76.39
       Physical or Earth Sciences |      1,195        2.49       78.88
Police Science or Law Enforcement |        664        1.38       80.26
                       Psychology |      1,729        3.60       83.86
             Religion or Theology |        318        0.66       84.52
        Social Sciences (history, |      3,528        7.34       91.86
   Vocational - Technical Studies |        381        0.79       92.65
                            Other |      3,534        7.35      100.00
*/
reg lnearnings i.year male black hispanic west northeast midwest potexp potexp2 earlymajdum2-earlymajdum20 if fulltime > 0.75 & employed > 0.75 & enrolled < 0.25 & potexp > 13 & age <= 60 & panel < 1996
gen earlymajorbeta=0 if earlymajdum1==1
for num 2/20: replace earlymajorbeta = _b[earlymajdumX] if earlymajdumX==1

/* Late majorbeta */
/* List of late majors
      Agriculture/Forestry |      2,216        1.18        1.18
              Art/Architecture |      5,216        2.79        3.97
           Business/Management |     35,725       19.10       23.07
                Communications |      5,507        2.94       26.01
      Computer and Information |      6,184        3.31       29.32
                     Education |     23,377       12.50       41.82
                   Engineering |     13,438        7.18       49.00
            English/Literature |      5,277        2.82       51.82
             Foreign Languages |      1,440        0.77       52.59
               Health Sciences |     10,319        5.52       58.11
       Liberal Arts/Humanities |     10,338        5.53       63.63
               Math/Statistics |      3,465        1.85       65.48
Nature Sciences(Biological and |     11,534        6.17       71.65
  Philosophy/Religion/Theology |      2,013        1.08       72.73
              Pre-Professional |      1,720        0.92       73.64
                    Psychology |      8,511        4.55       78.19
       Social Sciences/History |      9,505        5.08       83.28
                         Other |     31,287       16.72      100.00
*/

reg lnearnings i.year male black hispanic west northeast midwest potexp potexp2 latemajdum2-latemajdum18 if fulltime > 0.75 & employed > 0.75 & enrolled < 0.25 & potexp > 13 & age <= 60 & panel >= 1996
gen latemajorbeta=0 if latemajdum1==1
for num 2/18: replace latemajorbeta = _b[latemajdumX] if latemajdumX==1


capture drop sipp_major

gen sipp_major = .
replace sipp_major = major_field_96to08 if panel >= 1996

replace sipp_major = 1 if major_field_84to93 == 1
replace sipp_major = 13 if major_field_84to93 == 2
replace sipp_major = 3 if major_field_84to93 == 3
replace sipp_major = 3 if major_field_84to93 == 4
replace sipp_major = 6 if major_field_84to93 == 5
replace sipp_major = 7 if major_field_84to93 == 6
replace sipp_major = 8 if major_field_84to93 == 7
replace sipp_major = 18 if major_field_84to93 == 8
replace sipp_major = 15 if major_field_84to93 == 9
replace sipp_major = 11 if major_field_84to93 == 10
replace sipp_major = 12 if major_field_84to93 == 11
replace sipp_major = 15 if major_field_84to93 == 12
replace sipp_major = 10 if major_field_84to93 == 13
replace sipp_major = 13 if major_field_84to93 == 14
replace sipp_major = 17 if major_field_84to93 == 15
replace sipp_major = 16 if major_field_84to93 == 16
replace sipp_major = 14 if major_field_84to93 == 17
replace sipp_major = 17 if major_field_84to93 == 18
replace sipp_major = 18 if major_field_84to93 == 19
replace sipp_major = 18 if major_field_84to93 == 20

tab sipp_major

/* Combined majorbeta */
quietly tab sipp_major, gen(totalmajdum)

reg lnearnings i.year male black hispanic west northeast midwest potexp potexp2 totalmajdum2-totalmajdum18 if fulltime > 0.75 & employed > 0.75 & enrolled < 0.25 & potexp > 13 & age <= 60 & panel >= 1996
gen totalmajorbeta=0 if totalmajdum1==1
for num 2/18: replace totalmajorbeta = _b[totalmajdumX] if totalmajdumX==1

gen late = (panel >= 1996)
replace earlymajorbeta = . if late == 1
replace latemajorbeta = . if late != 1 

/* Now we test the majorbeta */
/* Standardizing majorbeta */

/* Need to standardize for the age-restricted sample only */
replace earlymajorbeta = . if age > 35 | age < 22
replace latemajorbeta = . if age > 35 | age < 22

drop totalmajorbeta
gen majorbeta = .
replace majorbeta = earlymajorbeta if late == 0
replace majorbeta = latemajorbeta if late == 1

* gen majorbeta_x_urate_natl_grad = majorbeta*urate_natl_grad
capture drop majorbeta_x_potexp
gen majorbeta_x_potexp = majorbeta*potexp
* gen urate_natl_grad_x_pe = urate_natl_grad * potexp
* gen urate_natl_grad_x_pe2 = urate_natl_grad * potexp2

egen clustvar = group(sipp_major gradyear)

* capture drop urate_natl_cur
* sort year
* merge m:1 year using Crosswalks/nat_unemp.dta
* drop if _merge != 3
* drop _merge

* rename unemp urate_natl_cur


/* Q: How are earnings constructed ? 
Take avg monthly earnings in months you weren't enrolled. Then multiply that by 12 (this is unnecessary, I know)

Q: How is hourly pay constructed?
For workers who work hourly, take their hourly pay, averaged over months they weren't enrolled AND had a positive wage
For other workers, we take their earnings measure and divide by hours, for non-enrolled months

Q: What is the enrollment restriction? 
Enrolled is defined as the % of months in the year you were enrolled. Enrolled < 0.25 would keep everyone enrolled 2 or fewer months in the year 

Q: How did I construct occbeta?
Average occbeta of all months you have a valid occupation

Q: What are the employment and FT measures?
% of months you are employed/FT (35+ hrs/week) among months you are not enrolled in school. they vary from 0 to 1.

*/

drop early* latemajorbeta latemajdum* 
replace lnpay = lnpay2
drop lnpay1 lnpay2

capture drop time time2
drop clustvar late *majdum* 

drop survey

gen survey = .
replace survey = 8493 if panel >= 1984 & panel <= 1993
replace survey = 9608 if panel >= 1996 & panel <= 2008


* Create variables that will be useful for our project
gen gradHS = hgc>=12
gen grad4yr = hgc>=16
gen birthYr = year-age
gen empFT = inrange(fulltime,0.75,1)
gen empPT = inrange(employed,0.25,1) & inrange(fulltime,0.25,0.75) & ~empFT
tab hgc, mi
sum gradHS grad4yr
tab empFT
tab empPT
tab hgc, sum(empFT) mi
tab hgc, sum(empPT) mi

compress
* save Cleaned/sipp_full_master.dta, replace
* !gzip -f Cleaned/sipp_full_master.dta

preserve
keep if _n<=_N/2
save Cleaned/sipp_full_master_pt1.dta, replace
!gzip -f Cleaned/sipp_full_master_pt1.dta
restore

preserve
keep if _n>_N/2
save Cleaned/sipp_full_master_pt2.dta, replace
!gzip -f Cleaned/sipp_full_master_pt2.dta
restore

log close
