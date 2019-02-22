version 13.0
clear all
set more off
capture log close
log using compare_premia_smooth2.log, replace

* Compare the wage premia of the different datasets/birth cohorts
local DATALIST ACS CPS NLSY PSID SIPP

gen dataset=""
foreach DATA in `DATALIST' {
    disp "`DATA'"
    local data = lower("`DATA'")
    append using `DATA'/`data'_regs2.dta, gen(`DATA')
    replace dataset="`DATA'" if `DATA'==1
}
drop   `DATALIST'

replace GWP = . if dataset=="PSID"

local minyear 1950
local maxyear 1988
local obscut  400

drop if dataset=="SIPP" & birthyr>=1983
drop if birthyr<`minyear'

* Will create smooth hi/lo below
* gen CWPhi = CWP+1.96*CWPse
* gen CWPlo = CWP-1.96*CWPse
* gen HSWPhi = HSWP+1.96*HSWPse
* gen HSWPlo = HSWP-1.96*HSWPse

foreach X in HSWP CWP GWP {
    if "`X'"=="GWP"  local ymax .3
    if "`X'"=="GWP"  local ymin -.1
    if "`X'"=="CWP"  local ymax .6
    if "`X'"=="CWP"  local ymin  0
    if "`X'"=="HSWP" local ymax .4
    if "`X'"=="HSWP" local ymin -.1

	foreach FEM in 0 1 {
		if `FEM'==1 local PRE="fe"
		else local PRE=""

		foreach Y in RawGradExact {
			foreach A in 18 25 26 30 35 45 {
				preserve // Preserve is important so that we don't have to drop our smoothed vars each time
				lowess `X' birthyr if female==`FEM' & empFT & age1==`A' & N>=`obscut' & controls=="`Y'" & dataset=="NLSY" & birthyr<=1964, gen(`X'smooth64) bwidth(.7)
				lowess `X' birthyr if female==`FEM' & empFT & age1==`A' & N>=`obscut' & controls=="`Y'" & dataset=="NLSY" & birthyr>=1980, gen(`X'smooth80) bwidth(.9)
				
				gen `X'hiSmooth64 = `X'smooth64+1.96*`X'se
				gen `X'loSmooth64 = `X'smooth64-1.96*`X'se
				
				gen `X'hiSmooth80 = `X'smooth80+1.96*`X'se
				gen `X'loSmooth80 = `X'smooth80-1.96*`X'se
				
				if `A'==18 drop if !inlist(birthyr,1958,1959,1968,1969,1978,1979) & !inrange(birthyr,1980,1988) & dataset=="ACS" // keep 21-22 year olds
				if `A'==25 drop if !inlist(birthyr,1950,1951,1960,1961,1970,1971) & !inrange(birthyr,1972,1988) & dataset=="ACS" // keep 29-30 year olds
				if `A'==26 drop if !inlist(birthyr,1952,     1962,     1972     ) & !inrange(birthyr,1973,1988) & dataset=="ACS" // keep 28    year olds
				if `A'==30 drop if !inlist(birthyr,1945,1946,1955,1956,1965,1966) & !inrange(birthyr,1967,1988) & dataset=="ACS" // keep 34-35 year olds
                if `A'==35 drop if ~inlist(birthyr,1940,1941,1950,1951,1960,1961) & ~inrange(birthyr,1962,1988) & dataset=="ACS" // keep 39-40 year olds
                if `A'==45 drop if ~inlist(birthyr,1935,1936,1945,1946,1955,1956) & ~inrange(birthyr,1957,1988) & dataset=="ACS" // keep 44-45 year olds
				if `A'==18 local A2 28
				if `A'==25 local A2 34
				if `A'==26 local A2 30
				if `A'==30 local A2 39
				if `A'==35 local A2 44
				if `A'==45 local A2 54
				twoway ( rarea   `X'hiSmooth64 `X'loSmooth64 birthyr if female==`FEM' & empFT & age1==`A' & N>=`obscut' & controls=="`Y'" & dataset=="NLSY" & birthyr<=1964 , color(gs14)) ///
					   ( rarea   `X'hiSmooth80 `X'loSmooth80 birthyr if female==`FEM' & empFT & age1==`A' & N>=`obscut' & controls=="`Y'" & dataset=="NLSY" & birthyr>=1980 , color(gs14)) ///
				       ( lowess  `X'                         birthyr if female==`FEM' & empFT & age1==`A' & N>=`obscut' & controls=="`Y'" & dataset=="NLSY" & birthyr<=1964 , bwidth(.7) lwidth(medthick) lcolor(black) lpattern(solid)) ///
					   ( lowess  `X'                         birthyr if female==`FEM' & empFT & age1==`A' & N>=`obscut' & controls=="`Y'" & dataset=="CPS"                  , bwidth(.2) lwidth(medthick) lcolor(black) lpattern(dash)) ///
					   ( lowess  `X'                         birthyr if female==`FEM' & empFT & age1==`A' & N>=`obscut' & controls=="`Y'" & dataset=="ACS"                  , bwidth(.2) lwidth(medthick) lcolor(black) lpattern(dot)) ///
					   ( lowess  `X'                         birthyr if female==`FEM' & empFT & age1==`A' & N>=`obscut' & controls=="`Y'" & dataset=="PSID" & birthyr<=1966 , bwidth(.3) lwidth(medthick) lcolor(black) lpattern(shortdash_dot)) ///
					   ( lowess  `X'                         birthyr if female==`FEM' & empFT & age1==`A' & N>=`obscut' & controls=="`Y'" & dataset=="SIPP" & birthyr<=1984 , bwidth(.2) lwidth(medthick) lcolor(black) lpattern(longdash_dot)) ///
					   ( lowess  `X'                         birthyr if female==`FEM' & empFT & age1==`A' & N>=`obscut' & controls=="`Y'" & dataset=="NLSY" & birthyr>=1980 , bwidth(.9) lwidth(medthick) lcolor(black) lpattern(solid)) ///
					   ( lowess  `X'                         birthyr if female==`FEM' & empFT & age1==`A' & N>=`obscut' & controls=="`Y'" & dataset=="PSID" & birthyr>=1978 , bwidth(.3) lwidth(medthick) lcolor(black) lpattern(shortdash_dot)) ///
				, legend(order(3 4 5 6 7) label(3 "NLSY") label(4 "CPS") label(5 "ACS") label(6 "PSID") label(7 "SIPP") cols(2) symxsize(10) keygap(1) ) ///
				xscale(range(`minyear' `maxyear')) xlabel(`minyear'(4)`maxyear') yscale(range(`=`ymin'-.05' `=`ymax'+.05')) ylabel(`ymin'(.2)`ymax') xtitle(Birth Year) ytitle(Wage Premium) graphregion(color(white))
				*xscale(range(`minyear' `maxyear')) xlabel(`minyear'(4)`maxyear') yscale(range(-.2 .8)) ylabel(-.2(.2).6) xtitle(Birth Year) ytitle(Wage Premium) graphregion(color(white))
				graph export PDFs/lowess_`PRE'male_FT_`A'`A2'_`X'_`Y'.pdf, replace
				graph export  PSs/lowess_`PRE'male_FT_`A'`A2'_`X'_`Y'.eps, replace
				restore
			}
		}
    }
}

log close
