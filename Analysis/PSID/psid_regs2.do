version 13.0
clear all
set more off
capture log close
log using psid_regs2.log, replace

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
replace wage = 100 if inrange(wage,100,.)
replace wage =   2 if inrange(wage,.,2)
drop if ~inrange(wage,2,100)
gen lnwage   = ln(wage)

drop if inlist(wage,2,100) // Comment this line to topcode v drop

* background variables
cap drop race
generat race = .
replace race = 1 if white
replace race = 2 if black
replace race = 3 if other
lab def vlrace     1 "White" 2 "Black" 3 "Hispanic" 4 "Other"
lab val race       vlrace

* gen potExp
gen potExp = age-hgc-6

* gen female
cap drop female
gen female = male==0

* rename wave --> year
ren wave year

gen someCol  = hgc>12 & hgc<16 & grad4yr==0
*gen gradGrad = inrange(hgc,17,.)

postfile tester birthyr female age1 age2 empFT str20(controls) HSWP SCWP CWP GWP HSWPse SCWPse CWPse GWPse N R2a using psid_regs2, replace
forvalues BYR = 1945/1986 {
    disp "`BYR'"
    foreach FEM in 0 1 {
        foreach AGES in 1828 2534 2630 3039 3544 4554 {
            local AGE1 = floor(`AGES'/100)
            local AGE2 = `AGES' - `AGE1'*100
            foreach FT in 1 {
                qui count if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT' & ~mi(svywgt)
                local counter = `r(N)'
                di "Count=`counter' BirthYear=`BYR' Female=`FEM' AgeLo=`AGE1' AgeHi=`AGE2' EmpFT=`FT'"
                if `=1*`counter''>19 {
                    qui  reg lnwage gradHS someCol grad4yr gradGrad  [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
			    	post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("RawGradExact") (_b[gradHS]) (_b[someCol]) (_b[grad4yr]) (_b[gradGrad]) (_se[gradHS]) (_se[someCol]) (_se[grad4yr]) (_se[gradGrad]) (e(N)) (e(r2_a))
                }
			}
		}
	}
}
postclose tester

log close
