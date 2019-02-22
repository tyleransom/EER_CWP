version 13.0
clear all
set more off
capture log close
log using nlsy_regs2.log, replace

set seed 235230 // Need to set the seed as everytime Stats starts it sets the seed to 123456789
local EY = int(10000*uniform()) 
!gunzip -fc ../../Data/NLSY/yCombinedAnalysis.dta.gz > tmp`EY'.dta
use tmp`EY'.dta
!rm tmp`EY'.dta

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
*   +Back - add background vars such as parents ed, afqt, etc
*****************************************************************************

drop if inlist(wagereal,2,100)  // Comment this line to topcode v drop

gen     someCol  = hgc>12 & hgc<16 & grad4yr==0
replace gradGrad = inrange(hgc,17,.) if birthyr<1980 & !mi(gradGrad)

postfile tester birthyr female age1 age2 empFT str20(controls) HSWP SCWP CWP GWP HSWPse SCWPse CWPse GWPse N R2a using nlsy_regs2, replace
foreach BYR in 1957 1958 1959 1960 1961 1962 1963 1964 1980 1981 1982 1983 1984 {
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
					qui  reg lnwage gradHS someCol grad4yr gradGrad  [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
			    	post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("RawGradExact") (_b[gradHS]) (_b[someCol]) (_b[grad4yr]) (_b[gradGrad]) (_se[gradHS]) (_se[someCol]) (_se[grad4yr]) (_se[gradGrad]) (e(N)) (e(r2_a))
				}
			}
		}
	}
}
postclose tester

log close
