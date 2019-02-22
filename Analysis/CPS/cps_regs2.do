version 13.0
clear all
set more off
capture log close
log using cps_regs2.log, replace

set seed 124513 // Need to set the seed as everytime Stats starts it sets the seed to 123456789
local NUMPIECES 3
forvalues X = 1/`NUMPIECES' {
	local EY = int(10000*uniform()) // NO seed; needs to be random
	!gunzip -fc  ../../Data/CPS/CPS_data_pt`X'.dta.gz > tmp`EY'.dta
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

*---------------------------------------------
* Generate variables
*---------------------------------------------
* undo shortyr
gen year = shortyr + 1978

* Top-code at 100 (1983$) ??
* Notes: 1) top code everything at 100 instead of 40 (consistent with NLSY)
*        2) currently, simply drop all inlist(realwage,2,100)
*           since the cpi calcs ensures no values exactly equal to 2 | 100
replace realwage = 100 if inrange(realwage,100,.)
replace realwage =   2 if inrange(realwage,  .,2)
drop if ~inrange(realwage,2,100)
drop if inlist(realwage,2,100)  // Comment this line to topcode v drop
gen lnwage       = log(realwage)

* keep if age>=16 & inrange(year,1979,2010) // conform to NLSY sample (we don't need to conform here)

* background variables
cap drop race
generat race = .
replace race = 1 if white
replace race = 2 if black
replace race = 3 if hispanic
replace race = 4 if other
lab def vlrace     1 "White" 2 "Black" 3 "Hispanic" 4 "Other"
lab val race       vlrace

* gradHS, grad4yr are good
* hgc created in CPS_import.do
* gen potExp
gen potExp = age-hgc-6

* female is indicator for female
* year is calendar year; we'll use age and year to get birthyr
generat birthyr = year - age - 1 if inrange(month,1,6)
replace birthyr = year - age     if inrange(month,7,12)

gen someCol  = hgc>12 & hgc<16 & grad4yr==0
gen gradGrad = inrange(hgc,17,.)

postfile tester birthyr female age1 age2 empFT str20(controls) HSWP SCWP CWP GWP HSWPse SCWPse CWPse GWPse N R2a using cps_regs2, replace
forvalues BYR = 1945/1986 {
	disp "`BYR'"
	foreach FEM in 0 1 {
		foreach AGES in 1828 2534 2630 3039 3544 4554 {
			local AGE1 = floor(`AGES'/100)
			local AGE2 = `AGES' - `AGE1'*100
			foreach FT in 1 {
                qui count if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
                local counter = `r(N)'
                di "Count=`counter' BirthYear=`BYR' Female=`FEM' AgeLo=`AGE1' AgeHi=`AGE2' EmpFT=`FT'"
                if `=1*`counter''>0 {
					qui  reg lnwage gradHS someCol grad4yr gradGrad  [aw=earnwt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
			    	post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("RawGradExact") (_b[gradHS]) (_b[someCol]) (_b[grad4yr]) (_b[gradGrad]) (_se[gradHS]) (_se[someCol]) (_se[grad4yr]) (_se[gradGrad]) (e(N)) (e(r2_a))
				}
			}
		}
	}
}
postclose tester

log close
