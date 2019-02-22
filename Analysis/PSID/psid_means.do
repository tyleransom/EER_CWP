version 13.0
clear all
set more off
capture log close
log using psid_means.log, replace

use ../../Data/PSID/psid_master, clear

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
* background variables
cap drop race
generat race = .
replace race = 1 if white
replace race = 2 if black
replace race = 3 if other
lab def vlrace     1 "White" 2 "Black" 3 "Hispanic" 4 "Other"
lab val race       vlrace

* gen gradGrad
* gen gradGrad = hgc>=17

* gen potExp
gen potExp = age-hgc-6

* gen female
cap drop female
gen female = male==0

* rename wave --> year
ren wave year

postfile tester birthyr female age1 age2 empFT str20(controls) mean semean N R2a using psid_means, replace
forvalues BYR = 1945/1986 {
    disp "`BYR'"
	foreach FEM in 0 1 {
		foreach AGES in 1828 2534 2630 3039 3544 4554 {
			local AGE1 = floor(`AGES'/100)
			local AGE2 = `AGES' - `AGE1'*100
			foreach FT in 0 1 {
                qui count if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
                local counter = `r(N)'
                di "Count=`counter' BirthYear=`BYR' Female=`FEM' AgeLo=`AGE1' AgeHi=`AGE2' EmpFT=`FT'"
                if `=1*`counter''>19 {
					qui  reg hgc      [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("HGC") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg white    [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("White") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg other    [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("Other") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg black    [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("Black") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg gradHS   [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("GradHS") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg grad4yr  [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("Grad4yr") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))
					
					qui  reg grad4yr  [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2')
					post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (99) ("Grad4yr") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))
					
					qui  reg gradGrad [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("GradGrad") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))
					
					qui  reg gradGrad [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2')
					post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (99) ("GradGrad") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))
					
					qui  reg empFT    [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2')
					post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (99) ("FTvAll") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg empFT    [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & (empFT==1 | empPT==1)
					post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (99) ("FTvFTPT") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg female   [aw=svywgt] if birthyr==`BYR' &                 inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`BYR') (99) (`AGE1') (`AGE2') (`FT') ("Female") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))
				}
			}
		}
	}
}
postclose tester

log close
