version 13.0
clear all
set more off
capture log close
log using GoldinKatzReplication.log, replace

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



postfile tester calyear female age1 age2 empFT str20(controls) HSWP CWP HSWPse CWPse N R2a using cps_GK_regs, replace
forvalues CYR = 1979/2015 {
	disp "`CYR'"
	foreach FEM in 0 1 {
		foreach AGES in 2554 {
			local AGE1 = floor(`AGES'/100)
			local AGE2 = `AGES' - `AGE1'*100
			foreach FT in 1 {
                qui count if year==`CYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
                local counter = `r(N)'
                di "Count=`counter' CalendarYear=`CYR' Female=`FEM' AgeLo=`AGE1' AgeHi=`AGE2' EmpFT=`FT'"
                if `=1*`counter''>0 {
					qui  reg lnwage gradHS grad4yr [aw=earnwt] if year==`CYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT' & !inrange(hgc,13,15) & hgc<=16
					post tester (`CYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("RawExact") (_b[gradHS]) (_b[grad4yr]) (_se[gradHS]) (_se[grad4yr]) (e(N)) (e(r2_a))
				}
			}
		}
	}
}
postclose tester

postfile tester calyear female age1 age2 empFT str20(controls) mean semean N R2a using cps_GK_means, replace
forvalues CYR = 1945/1986 {
    disp "`CYR'"
	foreach FEM in 0 1 {
		foreach AGES in 2554 {
			local AGE1 = floor(`AGES'/100)
			local AGE2 = `AGES' - `AGE1'*100
			foreach FT in 0 1 {
                qui count if year==`CYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
                local counter = `r(N)'
                di "Count=`counter' BirthYear=`CYR' Female=`FEM' AgeLo=`AGE1' AgeHi=`AGE2' EmpFT=`FT'"
                if `=1*`counter''>0 {
					qui  reg hgc      [aw=weight] if year==`CYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`CYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("HGC") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg white    [aw=weight] if year==`CYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`CYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("White") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg hispanic [aw=weight] if year==`CYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`CYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("Hispanic") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg black    [aw=weight] if year==`CYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`CYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("Black") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg gradHS   [aw=weight] if year==`CYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`CYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("GradHS") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg grad4yr  [aw=weight] if year==`CYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`CYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("Grad4yr") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))
					
					qui  reg grad4yr  [aw=weight] if year==`CYR' & female==`FEM' & inrange(age,`AGE1',`AGE2')
					post tester (`CYR') (`FEM') (`AGE1') (`AGE2') (99) ("Grad4yr") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))
					
					qui  reg empFT    [aw=weight] if year==`CYR' & female==`FEM' & inrange(age,`AGE1',`AGE2')
					post tester (`CYR') (`FEM') (`AGE1') (`AGE2') (99) ("FTvAll") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg empFT    [aw=weight] if year==`CYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & (empFT==1 | empPT==1)
					post tester (`CYR') (`FEM') (`AGE1') (`AGE2') (99) ("FTvFTPT") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg female   [aw=weight] if year==`CYR' &                 inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`CYR') (99) (`AGE1') (`AGE2') (`FT') ("Female") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))
				}
			}
		}
	}
}
postclose tester

use cps_GK_regs, clear
plot CWP calyear if female==0

log close

