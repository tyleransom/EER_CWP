version 13.0
clear all
set more off
capture log close
log using sipp_attrition.log, replace

local NUMPIECES 2
forvalues X = 1/`NUMPIECES' {
	local EY = int(10000*uniform()) // NO seed; needs to be random
	!gunzip -fc  ../../Data/SIPP/Cleaned/sipp_full_master_pt`X'.dta.gz > tmp`EY'.dta
	append using tmp`EY'.dta
	!rm          tmp`EY'.dta
}

* Generate attrition behavior using -fillin-
drop if mi(pid)
isid panel pid year

* Need to figure out how to identify observations which missed the interview, since the way we've created the data forces a balanced panel

