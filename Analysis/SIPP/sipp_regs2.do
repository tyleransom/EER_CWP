version 13.0
clear all
set more off
capture log close
log using sipp_regs2.log, replace

set seed 153542 // Need to set the seed as everytime Stats starts it sets the seed to 123456789
local NUMPIECES 2
forvalues X = 1/`NUMPIECES' {
	local EY = int(10000*uniform()) // NO seed; needs to be random
	!gunzip -fc  ../../Data/SIPP/Cleaned/sipp_full_master_pt`X'.dta.gz > tmp`EY'.dta
	append using tmp`EY'.dta
	!rm          tmp`EY'.dta
}

*****************************************************************************
* Run various log-wage specifications of the college wage premium and create
*  a dataset of CWP (HSWP?) estimates by birth year, age at wage, gender, 
*  specification
* 
* Specifications:
*   Raw - no controls
*   Mincer - potExp^2, hgc
*   HLT - potExp^3, hgc, potExp*hgc, race/ethnicity
*   +Exper - replace potExp with exper
*     !!! - Don't have actually exper!
*   +Back - add background vars such as parents ed, afqt, etc
*     !!! - Currently there are no addtnl background vars in CPS_data3
*****************************************************************************
tab grad4yr
tab gradHS
count
count if !mi(hgc)
drop if mi(hgc)

*---------------------------------------------
* Generate variables
*---------------------------------------------
generate earnings = exp(lnearnings)
generate pay = exp(lnpay)

* Top-code at 100 (1983$) ??
* Notes: 1) top code everything at 100 instead of 40 (consistent with NLSY)
*        2) currently, simply drop all inlist(realwage,2,100)
*           since the cpi calcs ensures no values exactly equal to 2 | 100
replace earnings = 200000 if inrange(earnings,200000,.)
replace earnings =    500 if inrange(earnings,.,500)
drop if ~inrange(earnings,500,200000)
gen lnearn   = ln(earnings)

drop if inlist(earnings,500,200000) // Comment this line to topcode v drop

replace pay = 100 if inrange(pay,100,.)
replace pay =   2 if inrange(pay,.,2)
drop if ~inrange(pay,2,100)
gen lnwage   = ln(pay)

drop if inlist(pay,2,100) // Comment this line to topcode v drop

* background variables
cap drop race
generat race = .
replace race = 1 if !black & !hispanic
replace race = 2 if black
replace race = 3 if hispanic
lab def vlrace     1 "White" 2 "Black" 3 "Hispanic" 4 "Other"
lab val race       vlrace

* gen potExp
gen potExp = age-hgc-6

* gen female
gen female = male==0

* year is calendar year; we'll use age and year to get birthyr
generate birthyr = year - age

gen someCol  = hgc>12 & hgc<16 & grad4yr==0
gen gradGrad = inrange(hgc,17,.)

postfile tester birthyr female age1 age2 empFT str20(controls) HSWP SCWP CWP GWP HSWPse SCWPse CWPse GWPse N R2a using sipp_regs2, replace
forvalues BYR = 1945/1986 {
    disp "`BYR'"
    foreach FEM in 0 1 {
        foreach AGES in 1828 2534 2630 3039 3544 4554 {
            local AGE1 = floor(`AGES'/100)
            local AGE2 = `AGES' - `AGE1'*100
            foreach FT in 1 {
                qui count if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT' & ~mi(survey_weight)
                local counter = `r(N)'
                qui count if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT' & ~mi(survey_weight) & survey==9608
                local counter2 = `r(N)'
                di "Count=`counter' BirthYear=`BYR' Female=`FEM' AgeLo=`AGE1' AgeHi=`AGE2' EmpFT=`FT'"
                if `=1*`counter''>0 {
                    qui  reg lnwage gradHS someCol grad4yr gradGrad  [aw=survey_weight] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
			    	post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("RawGradExact") (_b[gradHS]) (_b[someCol]) (_b[grad4yr]) (_b[gradGrad]) (_se[gradHS]) (_se[someCol]) (_se[grad4yr]) (_se[gradGrad]) (e(N)) (e(r2_a))
                }
			}
		}
	}
}
postclose tester

log close
