version 13.0
clear all
set more off
capture log close
log using nlsy_means.log, replace

local EY = int(10000*uniform()) // NO seed; needs to be random
!gunzip -fc ../../Data/NLSY/yCombinedAnalysis.dta.gz > tmp`EY'.dta
use tmp`EY'.dta
!rm tmp`EY'.dta
* keep if empFT | empPT

*****************************************************************************
* Calculate mean values of variables for various subpopulations (or not)
* 
* Variables
*   hgc
*   female (on all gender)
*   race
*   grad4yr/HS
*   empFT (on all Emp)
*****************************************************************************

replace gradGrad = inrange(hgc,17,.) if birthyr<1980 & !mi(gradGrad)

postfile tester birthyr female age1 age2 empFT str20(controls) mean semean N R2a using nlsy_means, replace
foreach BYR in 1957 1958 1959 1960 1961 1962 1963 1964 1980 1981 1982 1983 1984 {
    disp "`BYR'"
	foreach FEM in 0 1 {
		foreach AGES in 1828 2534 2630 3039 3544 4554 {
			local AGE1 = floor(`AGES'/100)
			local AGE2 = `AGES' - `AGE1'*100
			foreach FT in 0 1 {
                qui count if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
                local counter = `r(N)'
                di "Count=`counter' BirthYear=`BYR' Female=`FEM' AgeLo=`AGE1' AgeHi=`AGE2' EmpFT=`FT'"
                if `=1*`counter''>0 {
					qui  reg hgc      [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("HGC") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg white    [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("White") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

					qui  reg hispanic [aw=svywgt] if birthyr==`BYR' & female==`FEM' & inrange(age,`AGE1',`AGE2') & empFT==`FT'
					post tester (`BYR') (`FEM') (`AGE1') (`AGE2') (`FT') ("Hispanic") (_b[_cons]) (_se[_cons]) (e(N)) (e(r2_a))

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
