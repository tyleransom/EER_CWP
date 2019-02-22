version 14.1
clear all

capture log close
log using sipp_84to93_master.log, replace


/* This file takes the SIPP data, which I downloaded from the NBER website, and turns it into usable form */
/* The file sipp_84to93_master_readin.do reads the data in and creates usable files */
/* This do file picks up after that one */
/* I do this wave by wave, starting with the 1984 and going forward to 1993 */

* One change to the file:
*  1: change hour requirement from 35 to 30; this will help with all years
*     - global find and replace of: 
*       'hours_job1_month`k' >= 35' to 'hours_job1_month`k' >= 30'
*       'hours_job2_month`k' >= 35' to 'hours_job2_month`k' >= 30'



/* 1984 */
use Temp/sipp84_full.dta


/* Age at survey */
gen year1984 = 1984
gen year1985 = 1985

gen age1984 = 1984 - u_brthyr
gen age1985 = 1985 - u_brthyr



/* Gender */
gen male1984 = (sex == 1)
gen male1985 = (sex == 1)


/* Race */
gen hispanic1984 = (ethnicty >= 14 & ethnicty <= 20)
gen hispanic1985 = (ethnicty >= 14 & ethnicty <= 20)

gen black1984 = (race == 2 & hispanic1984 != 1)
gen black1985 = (race == 2 & hispanic1985 != 1)

forvalues k=1(1)9 {
rename pp_mis0`k' pp_mis`k'
}



gen months_seen1984 = 0
gen months_seen1985 = 0



forvalues k=8(1)19 {
replace months_seen1984 = months_seen1984 + 1 if pp_mis`k' == 1 & rot == 1
}

forvalues k=20(1)31 {
replace months_seen1985 = months_seen1985 + 1 if pp_mis`k' == 1 & rot == 1
}


forvalues k=7(1)18 {
replace months_seen1984 = months_seen1984 + 1 if pp_mis`k' == 1 & rot == 2
}

forvalues k=19(1)30 {
replace months_seen1985 = months_seen1985 + 1 if pp_mis`k' == 1 & rot == 2
}


forvalues k=6(1)17 {
replace months_seen1984 = months_seen1984 + 1 if pp_mis`k' == 1 & rot == 3
}

forvalues k=18(1)29 {
replace months_seen1985 = months_seen1985 + 1 if pp_mis`k' == 1 & rot == 3
}


forvalues k=5(1)16 {
replace months_seen1984 = months_seen1984 + 1 if pp_mis`k' == 1 & rot == 4
}

forvalues k=17(1)28 {
replace months_seen1985 = months_seen1985 + 1 if pp_mis`k' == 1 & rot == 4
}

sum months_seen*


/* Each wave asks about the past four months */
/*
/* The first survey is in Oct 1983, so we don't have obs for many people in 1983 */
replace months_seen1983 = 6 if rot == 2
replace months_seen1983 = 5 if rot == 3
replace months_seen1983 = 4 if rot == 4
replace months_seen1983 = 7 if rot == 1


/* We see everyone through all of 1984 */
replace months_seen1984 = 12 if rot == 2
replace months_seen1984 = 12 if rot == 3
replace months_seen1984 = 12 if rot == 4
replace months_seen1984 = 12 if rot == 1


/* We see everyone through all of 1985 */
replace months_seen1985 = 12 if rot == 2
replace months_seen1985 = 12 if rot == 3
replace months_seen1985 = 12 if rot == 4
replace months_seen1985 = 12 if rot == 1
*/

/* We only see a bit of 1986 */




/**** ANNUAL EARNINGS ****/

/* Earnings are by month. Month #s to actual month mapping differs by rotation group */
forvalues k=1(1)9 {
rename ws1_am0`k' earnings_job1_month`k' 
rename ws2_am0`k' earnings_job2_month`k' 
rename se1_am0`k' earnings_se1_month`k' 
rename se2_am0`k' earnings_se2_month`k' 
}

forvalues k=10(1)32 {
rename ws1_am`k' earnings_job1_month`k' 
rename ws2_am`k' earnings_job2_month`k' 
rename se1_am`k' earnings_se1_month`k' 
rename se2_am`k' earnings_se2_month`k' 
}


forvalues k=1(1)32 {
replace earnings_job1_month`k' = 0 if earnings_job1_month`k' < 0 | earnings_job1_month`k' == .
replace earnings_job2_month`k' = 0 if earnings_job2_month`k' < 0 | earnings_job2_month`k' == .
replace earnings_se1_month`k' = 0 if earnings_se1_month`k' < 0 | earnings_se1_month`k' == .
replace earnings_se2_month`k' = 0 if earnings_se2_month`k' < 0 | earnings_se2_month`k' == .
}



gen earnings_job1_1984 = .
gen earnings_job1_1985 = .
gen earnings_job2_1984 = .
gen earnings_job2_1985 = .
gen earnings_se1_1984 = .
gen earnings_se1_1985 = .
gen earnings_se2_1984 = .
gen earnings_se2_1985 = .

gen earnings_annual1984 = .
gen earnings_annual1985 = .


/* Rotation group 1: 1984 is months 8-19, 1985 is months 20-31 */
replace earnings_job1_1984 = earnings_job1_month8 + earnings_job1_month9 + earnings_job1_month10 + earnings_job1_month11 + earnings_job1_month12 + earnings_job1_month13 + earnings_job1_month14 + earnings_job1_month15 + earnings_job1_month16 + earnings_job1_month17 + earnings_job1_month18 + earnings_job1_month19  if rot == 1 
replace earnings_job1_1985 = earnings_job1_month20 + earnings_job1_month21 + earnings_job1_month22 + earnings_job1_month23 + earnings_job1_month24 + earnings_job1_month25 + earnings_job1_month26 + earnings_job1_month27 + earnings_job1_month28 + earnings_job1_month29 + earnings_job1_month30 + earnings_job1_month31 if rot == 1

replace earnings_job2_1984 = earnings_job2_month8 + earnings_job2_month9 + earnings_job2_month10 + earnings_job2_month11 + earnings_job2_month12 + earnings_job2_month13 + earnings_job2_month14 + earnings_job2_month15 + earnings_job2_month16 + earnings_job2_month17 + earnings_job2_month18 + earnings_job2_month19  if rot == 1 
replace earnings_job2_1985 = earnings_job2_month20 + earnings_job2_month21 + earnings_job2_month22 + earnings_job2_month23 + earnings_job2_month24 + earnings_job2_month25 + earnings_job2_month26 + earnings_job2_month27 + earnings_job2_month28 + earnings_job2_month29 + earnings_job2_month30 + earnings_job2_month31 if rot == 1

replace earnings_se1_1984 = earnings_se1_month8 + earnings_se1_month9 + earnings_se1_month10 + earnings_se1_month11 + earnings_se1_month12 + earnings_se1_month13 + earnings_se1_month14 + earnings_se1_month15 + earnings_se1_month16 + earnings_se1_month17 + earnings_se1_month18 + earnings_se1_month19  if rot == 1 
replace earnings_se1_1985 = earnings_se1_month20 + earnings_se1_month21 + earnings_se1_month22 + earnings_se1_month23 + earnings_se1_month24 + earnings_se1_month25 + earnings_se1_month26 + earnings_se1_month27 + earnings_se1_month28 + earnings_se1_month29 + earnings_se1_month30 + earnings_se1_month31 if rot == 1

replace earnings_se2_1984 = earnings_se2_month8 + earnings_se2_month9 + earnings_se2_month10 + earnings_se2_month11 + earnings_se2_month12 + earnings_se2_month13 + earnings_se2_month14 + earnings_se2_month15 + earnings_se2_month16 + earnings_se2_month17 + earnings_se2_month18 + earnings_se2_month19  if rot == 1 
replace earnings_se2_1985 = earnings_se2_month20 + earnings_se2_month21 + earnings_se2_month22 + earnings_se2_month23 + earnings_se2_month24 + earnings_se2_month25 + earnings_se2_month26 + earnings_se2_month27 + earnings_se2_month28 + earnings_se2_month29 + earnings_se2_month30 + earnings_se2_month31 if rot == 1

replace earnings_annual1984 = earnings_job1_1984 + earnings_job2_1984 if rot == 1
replace earnings_annual1985 = earnings_job1_1985 + earnings_job2_1985 if rot == 1



/* Rotation group 2: 1984 is months 7-18, 1985 is months 19-30 */
replace earnings_job1_1984 = earnings_job1_month7 if rot == 2
replace earnings_job2_1984 = earnings_job2_month7 if rot == 2
replace earnings_se1_1984 = earnings_se1_month7 if rot == 2
replace earnings_se2_1984 = earnings_se2_month7 if rot == 2

forvalues k=8(1)18 {
replace earnings_job1_1984 = earnings_job1_1984 + earnings_job1_month`k' if rot == 2
replace earnings_job2_1984 = earnings_job2_1984 + earnings_job2_month`k' if rot == 2
replace earnings_se1_1984 = earnings_se1_1984 + earnings_se1_month`k' if rot == 2
replace earnings_se2_1984 = earnings_se2_1984 + earnings_se2_month`k' if rot == 2
}

replace earnings_job1_1985 = earnings_job1_month19 if rot == 2
replace earnings_job2_1985 = earnings_job2_month19 if rot == 2
replace earnings_se1_1985 = earnings_se1_month19 if rot == 2
replace earnings_se2_1985 = earnings_se2_month19 if rot == 2

forvalues k=20(1)30 {
replace earnings_job1_1985 = earnings_job1_1985 + earnings_job1_month`k' if rot == 2
replace earnings_job2_1985 = earnings_job2_1985 + earnings_job2_month`k' if rot == 2
replace earnings_se1_1985 = earnings_se1_1985 + earnings_se1_month`k' if rot == 2
replace earnings_se2_1985 = earnings_se2_1985 + earnings_se2_month`k' if rot == 2
}


replace earnings_annual1984 = earnings_job1_1984 + earnings_job2_1984 if rot == 2
replace earnings_annual1985 = earnings_job1_1985 + earnings_job2_1985 if rot == 2




/* Rotation group 3: 1984 is months 6-17, 1985 is months 18-29 */
replace earnings_job1_1984 = earnings_job1_month6 if rot == 3
replace earnings_job2_1984 = earnings_job2_month6 if rot == 3
replace earnings_se1_1984 = earnings_se1_month6 if rot == 3
replace earnings_se2_1984 = earnings_se2_month6 if rot == 3

forvalues k=7(1)17 {
replace earnings_job1_1984 = earnings_job1_1984 + earnings_job1_month`k' if rot == 3
replace earnings_job2_1984 = earnings_job2_1984 + earnings_job2_month`k' if rot == 3
replace earnings_se1_1984 = earnings_se1_1984 + earnings_se1_month`k' if rot == 3
replace earnings_se2_1984 = earnings_se2_1984 + earnings_se2_month`k' if rot == 3
}

replace earnings_job1_1985 = earnings_job1_month18 if rot == 3
replace earnings_job2_1985 = earnings_job2_month18 if rot == 3
replace earnings_se1_1985 = earnings_se1_month18 if rot == 3
replace earnings_se2_1985 = earnings_se2_month18 if rot == 3

forvalues k=19(1)29 {
replace earnings_job1_1985 = earnings_job1_1985 + earnings_job1_month`k' if rot == 3
replace earnings_job2_1985 = earnings_job2_1985 + earnings_job2_month`k' if rot == 3
replace earnings_se1_1985 = earnings_se1_1985 + earnings_se1_month`k' if rot == 3
replace earnings_se2_1985 = earnings_se2_1985 + earnings_se2_month`k' if rot == 3
}


replace earnings_annual1984 = earnings_job1_1984 + earnings_job2_1984 if rot == 3
replace earnings_annual1985 = earnings_job1_1985 + earnings_job2_1985 if rot == 3





/* Rotation group 4: 1984 is months 5-16, 1985 is months 17-28 */
replace earnings_job1_1984 = earnings_job1_month5 if rot == 4
replace earnings_job2_1984 = earnings_job2_month5 if rot == 4
replace earnings_se1_1984 = earnings_se1_month5 if rot == 4
replace earnings_se2_1984 = earnings_se2_month5 if rot == 4

forvalues k=6(1)16 {
replace earnings_job1_1984 = earnings_job1_1984 + earnings_job1_month`k' if rot == 4
replace earnings_job2_1984 = earnings_job2_1984 + earnings_job2_month`k' if rot == 4
replace earnings_se1_1984 = earnings_se1_1984 + earnings_se1_month`k' if rot == 4
replace earnings_se2_1984 = earnings_se2_1984 + earnings_se2_month`k' if rot == 4
}

replace earnings_job1_1985 = earnings_job1_month17 if rot == 4
replace earnings_job2_1985 = earnings_job2_month17 if rot == 4
replace earnings_se1_1985 = earnings_se1_month17 if rot == 4
replace earnings_se2_1985 = earnings_se2_month17 if rot == 4

forvalues k=18(1)28 {
replace earnings_job1_1985 = earnings_job1_1985 + earnings_job1_month`k' if rot == 4
replace earnings_job2_1985 = earnings_job2_1985 + earnings_job2_month`k' if rot == 4
replace earnings_se1_1985 = earnings_se1_1985 + earnings_se1_month`k' if rot == 4
replace earnings_se2_1985 = earnings_se2_1985 + earnings_se2_month`k' if rot == 4
}


replace earnings_annual1984 = earnings_job1_1984 + earnings_job2_1984 if rot == 4
replace earnings_annual1985 = earnings_job1_1985 + earnings_job2_1985 if rot == 4







/**** WAGES ****/
/* For hourly workers, we actually have an hourly rate of pay variable */
forvalues k=1(1)9 {
rename w2028_0`k' wage_month`k'
}

forvalues k=10(1)32 {
rename w2028_`k' wage_month`k'
}

forvalues k=1(1)32 {
replace wage_month`k' = . if pp_mis`k' != 1
}


/* Annual wage measure will be the average of the non-missing wage measures in the year (for job 1 only) */

/* Need to get # of non-missing wage measures each year */
gen wage_count1984 = 0
gen wage_count1985 = 0

forvalues k=8(1)19 {
replace wage_count1984 = wage_count1984 + 1 if wage_month`k' > 0 & wage_month`k' != . & rot == 1
}

forvalues k=20(1)31 {
replace wage_count1985 = wage_count1985 + 1 if wage_month`k' > 0 & wage_month`k' != . & rot == 1
}


forvalues k=7(1)18 {
replace wage_count1984 = wage_count1984 + 1 if wage_month`k' > 0 & wage_month`k' != . & rot == 2
}

forvalues k=19(1)30 {
replace wage_count1985 = wage_count1985 + 1 if wage_month`k' > 0 & wage_month`k' != . & rot == 2
}


forvalues k=6(1)17 {
replace wage_count1984 = wage_count1984 + 1 if wage_month`k' > 0 & wage_month`k' != . & rot == 3
}

forvalues k=18(1)29 {
replace wage_count1985 = wage_count1985 + 1 if wage_month`k' > 0 & wage_month`k' != . & rot == 3
}


forvalues k=5(1)16 {
replace wage_count1984 = wage_count1984 + 1 if wage_month`k' > 0 & wage_month`k' != . & rot == 4
}

forvalues k=17(1)28 {
replace wage_count1985 = wage_count1985 + 1 if wage_month`k' > 0 & wage_month`k' != . & rot == 4
}



/* Now, we construct the annual wage measure */
gen hrlypay1984 = .
gen hrlypay1985 = .

gen hrlypayv11984 = .
gen hrlypayv11985 = .

gen hrlypayv21984 = .
gen hrlypayv21985 = .

gen total_wage1984 = 0
gen total_wage1985 = 0


forvalues k=8(1)19 {
replace total_wage1984 = total_wage1984 + wage_month`k' if wage_month`k' != . & rot == 1
}

forvalues k=20(1)31 {
replace total_wage1985 = total_wage1985 + wage_month`k' if wage_month`k' != . & rot == 1
}


forvalues k=7(1)18 {
replace total_wage1984 = total_wage1984 + wage_month`k' if wage_month`k' != . & rot == 2
}

forvalues k=19(1)30 {
replace total_wage1985 = total_wage1985 + wage_month`k' if wage_month`k' != . & rot == 2
}


forvalues k=6(1)17 {
replace total_wage1984 = total_wage1984 + wage_month`k' if wage_month`k' != . & rot == 3
}

forvalues k=18(1)29 {
replace total_wage1985 = total_wage1985 + wage_month`k' if wage_month`k' != . & rot == 3
}


forvalues k=5(1)16 {
replace total_wage1984 = total_wage1984 + wage_month`k' if wage_month`k' != . & rot == 4
}

forvalues k=17(1)28 {
replace total_wage1985 = total_wage1985 + wage_month`k' if wage_month`k' != . & rot == 4
}


replace hrlypayv11984 = total_wage1984/wage_count1984 
replace hrlypayv11985 = total_wage1985/wage_count1985


sum hrlypay*
bysort rot: sum hrlypay*

drop total_wage* wage_count* wage_month*



/* Alternative if you don't work by the hour: get earnings/hours */
forvalues k=1(1)9 {
replace w2024_0`k' = 0 if w2024_0`k' < 0
rename w2024_0`k' hours_job1_month`k'

replace w2124_0`k' = 0 if w2124_0`k' < 0
rename w2124_0`k' hours_job2_month`k'
}

forvalues k=10(1)32 {
replace w2024_`k' = 0 if w2024_`k' < 0
rename w2024_`k' hours_job1_month`k'
rename w2124_`k' hours_job2_month`k'

}

forvalues k=1(1)32 {
replace hours_job1_month`k' = . if pp_mis`k' != 1
replace hours_job2_month`k' = . if pp_mis`k' != 1
}


forvalues k=1(1)9 {
rename ws1_wk0`k' ws1_wk`k'
rename ws2_wk0`k' ws2_wk`k'
}

forvalues k=1(1)32 {
replace ws1_wk`k' = . if pp_mis`k' != 1
replace ws2_wk`k' = . if pp_mis`k' != 1
}




/* Need to get # of non-missing hours measures each year */
gen hours_count1984 = 0
gen hours_count1985 = 0


forvalues k=8(1)19 {
replace hours_count1984 = hours_count1984 + 1 if ((hours_job1_month`k' > 0 & hours_job1_month`k' != .) | (hours_job2_month`k' > 0 & hours_job2_month`k' != .)) & rot == 1
}

forvalues k=20(1)31 {
replace hours_count1985 = hours_count1985 + 1 if ((hours_job1_month`k' > 0 & hours_job1_month`k' != .) | (hours_job2_month`k' > 0 & hours_job2_month`k' != .)) & rot == 1
}


forvalues k=7(1)18 {
replace hours_count1984 = hours_count1984 + 1 if ((hours_job1_month`k' > 0 & hours_job1_month`k' != .) | (hours_job2_month`k' > 0 & hours_job2_month`k' != .)) & rot == 2
}

forvalues k=19(1)30 {
replace hours_count1985 = hours_count1985 + 1 if ((hours_job1_month`k' > 0 & hours_job1_month`k' != .) | (hours_job2_month`k' > 0 & hours_job2_month`k' != .)) & rot == 2
}


forvalues k=6(1)17 {
replace hours_count1984 = hours_count1984 + 1 if ((hours_job1_month`k' > 0 & hours_job1_month`k' != .) | (hours_job2_month`k' > 0 & hours_job2_month`k' != .)) & rot == 3
}

forvalues k=18(1)29 {
replace hours_count1985 = hours_count1985 + 1 if ((hours_job1_month`k' > 0 & hours_job1_month`k' != .) | (hours_job2_month`k' > 0 & hours_job2_month`k' != .)) & rot == 3
}


forvalues k=5(1)16 {
replace hours_count1984 = hours_count1984 + 1 if ((hours_job1_month`k' > 0 & hours_job1_month`k' != .) | (hours_job2_month`k' > 0 & hours_job2_month`k' != .)) & rot == 4
}

forvalues k=17(1)28 {
replace hours_count1985 = hours_count1985 + 1 if ((hours_job1_month`k' > 0 & hours_job1_month`k' != .) | (hours_job2_month`k' > 0 & hours_job2_month`k' != .)) & rot == 4
}



gen total_hours1984 = 0
gen total_hours1985 = 0

forvalues k=1(1)32 {
replace hours_job1_month`k' = 0 if hours_job1_month`k' == .
replace hours_job2_month`k' = 0 if hours_job2_month`k' == .
}

forvalues k=8(1)19 {
replace total_hours1984 = total_hours1984 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if rot == 1
}

forvalues k=20(1)31 {
replace total_hours1985 = total_hours1985 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if rot == 1
}


forvalues k=7(1)18 {
replace total_hours1984 = total_hours1984 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if rot == 2
}

forvalues k=19(1)30 {
replace total_hours1985 = total_hours1985 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if rot == 2
}


forvalues k=6(1)17 {
replace total_hours1984 = total_hours1984 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if rot == 3
}

forvalues k=18(1)29 {
replace total_hours1985 = total_hours1985 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if rot == 3
}


forvalues k=5(1)16 {
replace total_hours1984 = total_hours1984 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if rot == 4
}

forvalues k=17(1)28 {
replace total_hours1985 = total_hours1985 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if rot == 4
}



replace hrlypayv21984 = earnings_annual1984 / total_hours1984
replace hrlypayv21985 = earnings_annual1985 / total_hours1985


forvalues k=1984(1)1985 {
replace hrlypay`k' = hrlypayv1`k'
replace hrlypay`k' = hrlypayv2`k' if hrlypay`k' == . | hrlypay`k' == 0
}

sum hrlypay*





/*
/* Enrolled? */

/* I will code you as enrolled in the year if you are enrolled at least 2 months of the year */
gen months_enrolled1984 = 0
gen months_enrolled1985 = 0

forvalues k=1(1)9 {
rename enrl_m0`k' enrl_m`k'
}


forvalues k=8(1)19 {
replace months_enrolled1984 = months_enrolled1984 + 1 if enrl_m`k' & rot == 1
}

forvalues k=20(1)31 {
replace months_enrolled1985 = months_enrolled1985 + 1 if enrl_m`k' & rot == 1
}



forvalues k=7(1)18 {
replace months_enrolled1984 = months_enrolled1984 + 1 if enrl_m`k' & rot == 2
}

forvalues k=19(1)30 {
replace months_enrolled1985 = months_enrolled1985 + 1 if enrl_m`k' & rot == 2
}



forvalues k=6(1)17 {
replace months_enrolled1984 = months_enrolled1984 + 1 if enrl_m`k' & rot == 3
}

forvalues k=18(1)29 {
replace months_enrolled1985 = months_enrolled1985 + 1 if enrl_m`k' & rot == 3
}



forvalues k=5(1)16 {
replace months_enrolled1984 = months_enrolled1984 + 1 if enrl_m`k' & rot == 4
}

forvalues k=17(1)28 {
replace months_enrolled1985 = months_enrolled1985 + 1 if enrl_m`k' & rot == 4
}


drop enrl*

gen enrolled1984 = (months_enrolled1984 >= 2)
gen enrolled1985 = (months_enrolled1985 >= 2)
*/

gen enrolled1984 = .
gen enrolled1985 = .

tab enrolled*
*sum months_enrolled*

sum age1984 age1985

sum black* hispanic*

sum hrlypay*, d



/* State and region */
/* I take the state from the second wave as the state for 1984 and the fourth wave for 1985 */
rename state_2 state

replace state = state_3 if state == 0 | state == .
replace state = state_4 if state == 0 | state == .


gen west = 0
gen northeast = 0
gen midwest = 0
gen south = 0

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1984 = west
gen northeast1984 = northeast
gen midwest1984 = midwest
gen south1984 = south

rename state state_ba_degree


/* State_5 is the state from the 4th wave, which is in the second year */
rename state_5 state

replace state = state_6 if state == 0 | state == .
replace state = state_7 if state == 0 | state == .


replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1985 = west
gen northeast1985 = northeast
gen midwest1985 = midwest
gen south1985 = south


drop west south midwest northeast 



/* Division of degree */
gen ba_newengland = 0
gen ba_midatlantic = 0
gen ba_eastnorthcentral = 0
gen ba_westnorthcentral = 0
gen ba_southatlantic = 0
gen ba_eastsouthcentral = 0
gen ba_westsouthcentral = 0
gen ba_mountain = 0
gen ba_pacific = 0


replace ba_newengland = 1 if state_ba_degree == 9 | state_ba_degree == 25 | state_ba_degree == 33  | state_ba_degree == 44 | state_ba_degree == 23 | state_ba_degree == 50
replace ba_midatlantic = 1 if state_ba_degree == 34 | state_ba_degree == 36 | state_ba_degree == 42
replace ba_eastnorthcentral = 1 if  state_ba_degree == 55 | state_ba_degree == 39 | state_ba_degree == 26 | state_ba_degree == 18 | state_ba_degree == 17
replace ba_westnorthcentral = 1 if state_ba_degree == 19 | state_ba_degree == 38 | state_ba_degree == 46 | state_ba_degree == 31| state_ba_degree == 20 | state_ba_degree == 29 | state_ba_degree == 27
replace ba_southatlantic = 1 if state_ba_degree == 10 | state_ba_degree == 11 | state_ba_degree == 24 | state_ba_degree == 54 | state_ba_degree == 51 | state_ba_degree == 37 | state_ba_degree == 45 | state_ba_degree == 12 | state_ba_degree == 13
replace ba_eastsouthcentral = 1 if state_ba_degree == 28 | state_ba_degree == 21 | state_ba_degree == 47 | state_ba_degree == 1
replace ba_westsouthcentral = 1 if state_ba_degree == 5 | state_ba_degree == 22 | state_ba_degree == 40 | state_ba_degree == 48
replace ba_mountain = 1 if state_ba_degree == 4 | state_ba_degree == 8 | state_ba_degree == 16 | state_ba_degree == 30 | state_ba_degree == 32 | state_ba_degree == 35 | state_ba_degree == 49 | state_ba_degree == 56
replace ba_pacific = 1 if state_ba_degree == 2 | state_ba_degree == 15 | state_ba_degree == 6 | state_ba_degree == 41 | state_ba_degree == 53

/* There are a few aggregated state variables for the early years that we can't tell which division they are in (e.g., "Mississippi and West Virginia"); these are small numbers of people */




/* Survey weights */
rename fnlwgt84 survey_weight1984
rename fnlwgt85 survey_weight1985


/* Are you employed? */
/* How should I do this? I have 12 observations per year */
/* For now, what I do (also for occupation and industry and full-time) is take the middle months of the person's year */

gen employed1984 = 0
gen employed1985 = 0

forvalues k=8(1)19 {
replace employed1984 = employed1984 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) |  (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & rot == 1
}

forvalues k=20(1)31 {
replace employed1985 = employed1985 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) |  (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & rot == 1
}


forvalues k=7(1)18 {
replace employed1984 = employed1984 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) |  (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & rot == 2
}

forvalues k=19(1)30 {
replace employed1985 = employed1985 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) |  (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & rot == 2
}


forvalues k=6(1)17 {
replace employed1984 = employed1984 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) |  (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & rot == 3
}

forvalues k=18(1)29 {
replace employed1985 = employed1985 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) |  (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & rot == 3
}


forvalues k=5(1)16 {
replace employed1984 = employed1984 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) |  (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & rot == 4
}

forvalues k=17(1)28 {
replace employed1985 = employed1985 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) |  (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & rot == 4
}


replace employed1984 = employed1984 / months_seen1984
replace employed1985 = employed1985 / months_seen1985




sum employed*


/* Are you full-time? */

gen fulltime1984 = 0
gen fulltime1985 = 0


forvalues k=8(1)19 {
replace fulltime1984 = fulltime1984 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & rot == 1
}

forvalues k=20(1)31 {
replace fulltime1985 = fulltime1985 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & rot == 1
}


forvalues k=7(1)18 {
replace fulltime1984 = fulltime1984 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & rot == 2
}

forvalues k=19(1)30 {
replace fulltime1985 = fulltime1985 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & rot == 2
}


forvalues k=6(1)17 {
replace fulltime1984 = fulltime1984 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & rot == 3
}

forvalues k=18(1)29 {
replace fulltime1985 = fulltime1985 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & rot == 3
}


forvalues k=5(1)16 {
replace fulltime1984 = fulltime1984 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & rot == 4
}

forvalues k=17(1)28 {
replace fulltime1985 = fulltime1985 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & rot == 4
}


replace fulltime1984 = fulltime1984 / months_seen1984
replace fulltime1985 = fulltime1985 / months_seen1985




/* OCCUPATION */
/* I use the 6th month occupation as the occupation. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace ws1_oc0`k' = . if ws1_oc0`k' == 0 | ws1_oc0`k' == 905
rename ws1_oc0`k' ws1_oc`k'
}

forvalues k=10(1)32 {
replace ws1_oc`k' = . if ws1_oc`k' == 0 | ws1_oc`k' == 905
}


forvalues k=1(1)12 {
gen occ`k'_1984 = .
gen occ`k'_1985 = .
}

forvalues k=8(1)19 {
local j = `k' - 7
replace occ`j'_1984 = ws1_oc`k' if rot == 1
}


forvalues k=20(1)31 {
local j = `k' - 19
replace occ`j'_1985 = ws1_oc`k' if rot == 1
}


forvalues k=7(1)18 {
local j = `k' - 6
replace occ`j'_1984 = ws1_oc`k' if rot == 2
}

forvalues k=19(1)30 {
local j = `k' - 18
replace occ`j'_1985 = ws1_oc`k' if rot == 2
}


forvalues k=6(1)17 {
local j = `k' - 5
replace occ`j'_1984 = ws1_oc`k' if rot == 3
}

forvalues k=18(1)29 {
local j = `k' - 17
replace occ`j'_1985 = ws1_oc`k' if rot == 3
}


forvalues k=5(1)16 {
local j = `k' - 4
replace occ`j'_1984 = ws1_oc`k' if rot == 4
}

forvalues k=17(1)28 {
local j = `k' - 16
replace occ`j'_1985 = ws1_oc`k' if rot == 4
}



/* INDUSTRY */
/* I use the 6th month industry as the industry. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace ws1_in0`k' = . if ws1_in0`k' == 0 | ws1_in0`k' == 905
rename ws1_in0`k' ws1_in`k'
}

forvalues k=10(1)32 {
replace ws1_in`k' = . if ws1_in`k' == 0 | ws1_in`k' == 905
}


forvalues k=1(1)12 {
gen ind`k'_1984 = .
gen ind`k'_1985 = .
}

forvalues k=8(1)19 {
local j = `k' - 7
replace ind`j'_1984 = ws1_in`k' if rot == 1
}


forvalues k=20(1)31 {
local j = `k' - 19
replace ind`j'_1985 = ws1_in`k' if rot == 1
}


forvalues k=7(1)18 {
local j = `k' - 6
replace ind`j'_1984 = ws1_in`k' if rot == 2
}

forvalues k=19(1)30 {
local j = `k' - 18
replace ind`j'_1985 = ws1_in`k' if rot == 2
}


forvalues k=6(1)17 {
local j = `k' - 5
replace ind`j'_1984 = ws1_in`k' if rot == 3
}

forvalues k=18(1)29 {
local j = `k' - 17
replace ind`j'_1985 = ws1_in`k' if rot == 3
}


forvalues k=5(1)16 {
local j = `k' - 4
replace ind`j'_1984 = ws1_in`k' if rot == 4
}

forvalues k=17(1)28 {
local j = `k' - 16
replace ind`j'_1985 = ws1_in`k' if rot == 4
}

drop *month*

bysort rot: sum ind* occ*



/* Identifying variables */
keep *1984 *1985 rot su_id pp_entry pp_pnum state_ba_degree ba_*


sort su_id pp_entry pp_pnum
compress
save Temp/sipp84_full_cleaned.dta, replace




*************************************************************

clear

use Temp/sipp84wave3.dta


/**** WAVE 2 DATASET ****/



/* Identifiers */
sum su_id pp_entry pp_pnum



* D TM8022 1 24 5424
 * Check item T3
 * Was ...'s highest grade attended at
 * least one year of college
* U Persons 16 years old or older who
 * attended at least four years of high
 * school
* V 0 .Not in universe
* V 1 .Yes - skip to TM8026
* V 2 .No 


* D TM8024 1 25 5425
 * Has ... received a high school
 * diploma
* U Persons 16 years old or older who
 * attended less than 1 year of college
* V 0 .Not in universe
* V 1 .Yes - skip to TM8042
* V 2 .No - skip to TM8042 


/********** COLLEGE DEGREE INFORMATION *********/

/* 2 questions: highest degree and BA degree. Need to check both */

/* Need year of degree, age at degree, and field of degree. Also need highest degree completed */


gen col = 0
gen morcol = 0
gen hgc = .

replace hgc = 12 if tm8028 == 0 | tm8028 == -1 | tm8028 == 7
replace hgc = 14 if tm8028 == 6 | tm8028 == 5
replace hgc = 16 if tm8028 == 4
replace hgc = 18 if tm8028 == 3
replace hgc = 19 if tm8028 == 2
replace hgc = 20 if tm8028 == 1
replace hgc = 10 if tm8024 == 2 // 8024 is indicator for high school diploma

tab hgc, mi

replace col = 1 if hgc == 16
replace morcol = 1 if hgc > 16

tab col morcol


gen gradyear = .

replace tm8030 = . if tm8030 <= 0

replace gradyear = tm8030 if hgc == 16

replace gradyear = tm8036 if gradyear == .

tab gradyear

gen age_grad = .

replace age_grad = gradyear - u_brthyr

tab age_grad



/* Field of bachelor's degree */

rename tm8032 major_field
replace major_field = . if major_field == 0

tab major_field, mi





keep hgc major_field age_grad gradyear col morcol su_id pp_entry pp_pnum


sort su_id pp_entry pp_pnum



merge su_id pp_entry pp_pnum using Temp/sipp84_full_cleaned.dta

tab _merge
drop _merge

egen pid=group(su_id pp_entry pp_pnum)
*bysort su_id pp_entry pp_pnum: gen pid = _n

drop su_id pp_entry pp_pnum

drop earnings_job* earnings_se* 

drop year1984 year1985


reshape long total_hours survey_weight age male hispanic black earnings_annual hrlypay hrlypayv1 hrlypayv2 enrolled west northeast midwest south employed fulltime occ1_ occ2_ occ3_ occ4_ occ5_ occ6_ occ7_ occ8_ occ9_ occ10_ occ11_ occ12_ ind1_ ind2_ ind3_ ind4_ ind5_ ind6_ ind7_ ind8_ ind9_ ind10_ ind11_ ind12_, i(pid) j(year)

forvalues k=1(1)12 {
rename occ`k'_ occ`k'
rename ind`k'_ ind`k'
}

* keep if age >= 22

tab major_field, mi
tab major_field if hgc == 16
tab gradyear
gen potexp = year - gradyear
tab potexp

tab gradyear potexp if hgc == 16 & potexp <= 13

sum


gen panel = 1984
gen survey = 8485

sort pid
compress
save Temp/sipp84_ready.dta, replace


clear



/* 1986 */






use Temp/sipp86_full.dta


/* Age at survey */
gen year1986 = 1986
gen year1987 = 1987

gen age1986 = 1986 - brthyr
gen age1987 = 1987 - brthyr



/* Gender */
gen male1986 = (sex == 1)
gen male1987 = (sex == 1)


/* Race */
gen hispanic1986 = (ethnicty >= 14 & ethnicty <= 20)
gen hispanic1987 = (ethnicty >= 14 & ethnicty <= 20)

gen black1986 = (race == 2 & hispanic1986 != 1)
gen black1987 = (race == 2 & hispanic1987 != 1)





gen months_seen1986 = 0
gen months_seen1987 = 0

/* Each wave asks about the past four months */



forvalues k=1(1)9 {
rename enrl_m0`k' enrl_m`k'
rename pp_mis0`k' pp_mis`k'
}



forvalues k=1(1)12 {
replace months_seen1986 = months_seen1986 + 1 if pp_mis`k' == 1 & rot == 1
}

forvalues k=13(1)24 {
replace months_seen1987 = months_seen1987 + 1 if pp_mis`k' == 1 & rot == 1
}



forvalues k=4(1)15 {
replace months_seen1986 = months_seen1986 + 1 if pp_mis`k' == 1 & rot == 2
}

forvalues k=16(1)27 {
replace months_seen1987 = months_seen1987 + 1 if pp_mis`k' == 1 & rot == 2
}



forvalues k=3(1)14 {
replace months_seen1986 = months_seen1986 + 1 if pp_mis`k' == 1 & rot == 3
}

forvalues k=15(1)26 {
replace months_seen1987 = months_seen1987 + 1 if pp_mis`k' == 1 & rot == 3
}



forvalues k=2(1)13 {
replace months_seen1986 = months_seen1986 + 1 if pp_mis`k' == 1 & rot == 4
}

forvalues k=14(1)25 {
replace months_seen1987 = months_seen1987 + 1 if pp_mis`k' == 1 & rot == 4
}

sum months_seen*




/* I need to set all my variables to missing if pp_mis`k' != 1 */


/*
/* The first survey is in Feb 1986, so we don't have obs for many people in 1985 */
replace months_seen1985 = 3 if rot == 2
replace months_seen1985 = 2 if rot == 3
replace months_seen1985 = 1 if rot == 4
replace months_seen1985 = 0 if rot == 1


/* We see everyone through all of 1986 */
replace months_seen1986 = 12 if rot == 2
replace months_seen1986 = 12 if rot == 3
replace months_seen1986 = 12 if rot == 4
replace months_seen1986 = 12 if rot == 1


/* We see everyone through all of 1987 */
replace months_seen1987 = 12 if rot == 2
replace months_seen1987 = 12 if rot == 3
replace months_seen1987 = 12 if rot == 4
replace months_seen1987 = 12 if rot == 1


/* We only see a bit of 1988 */
replace months_seen1988 = 1 if rot == 2
replace months_seen1988 = 2 if rot == 3
replace months_seen1988 = 3 if rot == 4
replace months_seen1988 = 0 if rot == 1
*/


forvalues k=1(1)32 {
replace enrl_m`k' = . if pp_mis`k' != 1
}



/* Enrolled? */


/* I will code you as enrolled in the year if you are enrolled at least 2 months of the year */
gen months_enrolled1986 = 0
gen months_enrolled1987 = 0




forvalues k=1(1)12 {
replace months_enrolled1986 = months_enrolled1986 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=13(1)24 {
replace months_enrolled1987 = months_enrolled1987 + 1 if enrl_m`k' == 1 & rot == 1
}



forvalues k=4(1)15 {
replace months_enrolled1986 = months_enrolled1986 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=16(1)27 {
replace months_enrolled1987 = months_enrolled1987 + 1 if enrl_m`k' == 1 & rot == 2
}



forvalues k=3(1)14 {
replace months_enrolled1986 = months_enrolled1986 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=15(1)26 {
replace months_enrolled1987 = months_enrolled1987 + 1 if enrl_m`k' == 1 & rot == 3
}



forvalues k=2(1)13 {
replace months_enrolled1986 = months_enrolled1986 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=14(1)25 {
replace months_enrolled1987 = months_enrolled1987 + 1 if enrl_m`k' == 1 & rot == 4
}

sum months_enrolled*
tab months_enrolled1986
tab months_enrolled1987



gen enrolled1986 = months_enrolled1986 / months_seen1986
gen enrolled1987 = months_enrolled1987 / months_seen1987

sum enrolled*




/**** ANNUAL EARNINGS ****/

/* Earnings are by month. Month #s to actual month mapping differs by rotation group */


forvalues k=1(1)9 {
rename ws1_am0`k' earnings_job1_month`k' 
rename ws2_am0`k' earnings_job2_month`k' 
rename se1_am0`k' earnings_se1_month`k' 
rename se2_am0`k' earnings_se2_month`k' 
}

forvalues k=10(1)32 {
rename ws1_am`k' earnings_job1_month`k' 
rename ws2_am`k' earnings_job2_month`k' 
rename se1_am`k' earnings_se1_month`k' 
rename se2_am`k' earnings_se2_month`k' 
}


forvalues k=1(1)32 {
replace earnings_job1_month`k' = 0 if earnings_job1_month`k' < 0 | earnings_job1_month`k' == .
replace earnings_job2_month`k' = 0 if earnings_job2_month`k' < 0 | earnings_job2_month`k' == .
replace earnings_se1_month`k' = 0 if earnings_se1_month`k' < 0 | earnings_se1_month`k' == .
replace earnings_se2_month`k' = 0 if earnings_se2_month`k' < 0 | earnings_se2_month`k' == .
}

forvalues k=1(1)32 {
replace earnings_job1_month`k' = . if pp_mis`k' != 1
replace earnings_job2_month`k' = . if pp_mis`k' != 1
replace earnings_se1_month`k' = . if pp_mis`k' != 1
replace earnings_se2_month`k' = . if pp_mis`k' != 1
}



gen earnings_job1_1986 = 0
gen earnings_job1_1987 = 0
gen earnings_job2_1986 = 0
gen earnings_job2_1987 = 0
gen earnings_se1_1986 = 0
gen earnings_se1_1987 = 0
gen earnings_se2_1986 = 0
gen earnings_se2_1987 = 0

gen earnings_annual1986 = 0
gen earnings_annual1987 = 0


/* Rotation group 1: 1986 is months 1-12, 1987 is months 13-24 */
forvalues k=1(1)12 {
replace earnings_annual1986 = earnings_annual1986 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}

forvalues k=13(1)24 {
replace earnings_annual1987 = earnings_annual1987 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}


replace earnings_annual1986 = (earnings_annual1986/(months_seen1986-months_enrolled1986)) * 12  if rot == 1
replace earnings_annual1987 = (earnings_annual1987/(months_seen1987-months_enrolled1987)) * 12  if rot == 1

replace earnings_annual1986 = 0 if months_enrolled1986 == 12 & rot == 1
replace earnings_annual1987 = 0 if months_enrolled1987 == 12 & rot == 1

sum earnings_annual* if rot == 1






/* Rotation group 2: 1986 is months 4-15, 1987 is months 16-27 */
forvalues k=4(1)15 {
replace earnings_annual1986 = earnings_annual1986 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}

forvalues k=16(1)27 {
replace earnings_annual1987 = earnings_annual1987 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}


replace earnings_annual1986 = (earnings_annual1986/(months_seen1986-months_enrolled1986)) * 12  if rot == 2
replace earnings_annual1987 = (earnings_annual1987/(months_seen1987-months_enrolled1987)) * 12  if rot == 2

replace earnings_annual1986 = 0 if months_enrolled1986 == 12 & rot == 2
replace earnings_annual1987 = 0 if months_enrolled1987 == 12 & rot == 2

sum earnings_annual* if rot == 2








/* Rotation group 3: 1986 is months 3-14, 1987 is months 15-26 */
forvalues k=3(1)14 {
replace earnings_annual1986 = earnings_annual1986 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}

forvalues k=15(1)26 {
replace earnings_annual1987 = earnings_annual1987 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}


replace earnings_annual1986 = (earnings_annual1986/(months_seen1986-months_enrolled1986)) * 12  if rot == 3
replace earnings_annual1987 = (earnings_annual1987/(months_seen1987-months_enrolled1987)) * 12  if rot == 3

replace earnings_annual1986 = 0 if months_enrolled1986 == 12 & rot == 3
replace earnings_annual1987 = 0 if months_enrolled1987 == 12 & rot == 3

sum earnings_annual* if rot == 3






/* Rotation group 4: 1986 is months 2-13, 1987 is months 14-25 */
forvalues k=2(1)13 {
replace earnings_annual1986 = earnings_annual1986 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}

forvalues k=14(1)25 {
replace earnings_annual1987 = earnings_annual1987 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}


replace earnings_annual1986 = (earnings_annual1986/(months_seen1986-months_enrolled1986)) * 12  if rot == 4
replace earnings_annual1987 = (earnings_annual1987/(months_seen1987-months_enrolled1987)) * 12  if rot == 4

replace earnings_annual1986 = 0 if months_enrolled1986 == 12 & rot == 4
replace earnings_annual1987 = 0 if months_enrolled1987 == 12 & rot == 4

sum earnings_annual* if rot == 4

bysort rot: sum earnings_annual1986 if earnings_annual1986 > 300
bysort rot: sum earnings_annual1987 if earnings_annual1987 > 300




/**** WAGES ****/
/* For hourly workers, we actually have an hourly rate of pay variable */
forvalues k=1(1)9 {
rename w2028_0`k' wage_month`k'
}

forvalues k=10(1)32 {
rename w2028_`k' wage_month`k'
}

forvalues k=1(1)32 {
replace wage_month`k' = . if pp_mis`k' != 1
}


/* Annual wage measure will be the average of the non-missing wage measures in the year (for job 1 only) for non-enrolled months */

/* Need to get # of non-missing wage measures each year */
gen wage_count1986 = 0
gen wage_count1987 = 0

forvalues k=1(1)12 {
replace wage_count1986 = wage_count1986 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace wage_count1987 = wage_count1987 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace wage_count1986 = wage_count1986 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace wage_count1987 = wage_count1987 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace wage_count1986 = wage_count1986 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace wage_count1987 = wage_count1987 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace wage_count1986 = wage_count1986 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace wage_count1987 = wage_count1987 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}



/* Now, we construct the annual wage measure */
gen hrlypay1986 = .
gen hrlypay1987 = .

gen hrlypayv11986 = .
gen hrlypayv11987 = .

gen hrlypayv21986 = .
gen hrlypayv21987 = .

gen total_wage1986 = 0
gen total_wage1987 = 0


forvalues k=1(1)12 {
replace total_wage1986 = total_wage1986 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace total_wage1987 = total_wage1987 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace total_wage1986 = total_wage1986 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace total_wage1987 = total_wage1987 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace total_wage1986 = total_wage1986 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace total_wage1987 = total_wage1987 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace total_wage1986 = total_wage1986 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace total_wage1987 = total_wage1987 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}


replace hrlypayv11986 = total_wage1986/wage_count1986 
replace hrlypayv11987 = total_wage1987/wage_count1987


sum hrlypay*

drop total_wage* wage_count* wage_month*



/* Alternative if you don't work by the hour: get earnings/hours */
forvalues k=1(1)9 {
replace w2024_0`k' = 0 if w2024_0`k' < 0
rename w2024_0`k' hours_job1_month`k'

replace w2124_0`k' = 0 if w2124_0`k' < 0
rename w2124_0`k' hours_job2_month`k'
}

forvalues k=10(1)32 {
replace w2024_`k' = 0 if w2024_`k' < 0
rename w2024_`k' hours_job1_month`k'
rename w2124_`k' hours_job2_month`k'

}

forvalues k=1(1)32 {
replace hours_job1_month`k' = . if pp_mis`k' != 1
replace hours_job2_month`k' = . if pp_mis`k' != 1
}


/* Need to get # of non-missing hours measures each year */
gen hours_count1986 = 0
gen hours_count1987 = 0

forvalues k=1(1)12 {
replace hours_count1986 = hours_count1986 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace hours_count1987 = hours_count1987 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace hours_count1986 = hours_count1986 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace hours_count1987 = hours_count1987 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace hours_count1986 = hours_count1986 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace hours_count1987 = hours_count1987 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace hours_count1986 = hours_count1986 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace hours_count1987 = hours_count1987 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}


gen total_hours1986 = 0
gen total_hours1987 = 0


forvalues k=1(1)9 {
rename ws1_wk0`k' ws1_wk`k'
rename ws2_wk0`k' ws2_wk`k'
}

forvalues k=1(1)32 {
replace ws1_wk`k' = . if pp_mis`k' != 1
replace ws2_wk`k' = . if pp_mis`k' != 1
}



forvalues k=1(1)12 {
replace total_hours1986 = total_hours1986 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace total_hours1987 = total_hours1987 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace total_hours1986 = total_hours1986 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace total_hours1987 = total_hours1987 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace total_hours1986 = total_hours1986 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace total_hours1987 = total_hours1987 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace total_hours1986 = total_hours1986 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace total_hours1987 = total_hours1987 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}


replace hrlypayv21986 = earnings_annual1986 / total_hours1986
replace hrlypayv21987 = earnings_annual1987 / total_hours1987

forvalues k=1986(1)1987 {
replace hrlypay`k' = hrlypayv1`k'
replace hrlypay`k' = hrlypayv2`k' if hrlypay`k' == . | hrlypay`k' == 0
}


sum hrlypay*

bysort rot: sum hrlypay1986 if hrlypay1986 > 1






sum age1986 age1987

sum black* hispanic*

sum hrlypay*, d





/* State and region */
/* I take the state from the first wave as the state for 1986 and the fourth wave for 1987 */
rename state_1 state

replace state = state_2 if state == 0 | state == .
replace state = state_3 if state == 0 | state == .


gen west = 0
gen northeast = 0
gen midwest = 0
gen south = 0

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1986 = west
gen northeast1986 = northeast
gen midwest1986 = midwest
gen south1986 = south

rename state state_ba_degree 

/* State_4 is the state from the 4th wave, which is in the second year */
rename state_4 state

replace state = state_5 if state == 0 | state == .
replace state = state_6 if state == 0 | state == .


replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1987 = west
gen northeast1987 = northeast
gen midwest1987 = midwest
gen south1987 = south


drop west south midwest northeast 



/* Division of degree */
gen ba_newengland = 0
gen ba_midatlantic = 0
gen ba_eastnorthcentral = 0
gen ba_westnorthcentral = 0
gen ba_southatlantic = 0
gen ba_eastsouthcentral = 0
gen ba_westsouthcentral = 0
gen ba_mountain = 0
gen ba_pacific = 0


replace ba_newengland = 1 if state_ba_degree == 9 | state_ba_degree == 25 | state_ba_degree == 33  | state_ba_degree == 44 | state_ba_degree == 23 | state_ba_degree == 50 | state_ba_degree == 61
replace ba_midatlantic = 1 if state_ba_degree == 34 | state_ba_degree == 36 | state_ba_degree == 42
replace ba_eastnorthcentral = 1 if  state_ba_degree == 55 | state_ba_degree == 39 | state_ba_degree == 26 | state_ba_degree == 18 | state_ba_degree == 17
replace ba_westnorthcentral = 1 if state_ba_degree == 62 | state_ba_degree == 19 | state_ba_degree == 38 | state_ba_degree == 46 | state_ba_degree == 31| state_ba_degree == 20 | state_ba_degree == 29 | state_ba_degree == 27
replace ba_southatlantic = 1 if state_ba_degree == 10 | state_ba_degree == 11 | state_ba_degree == 24 | state_ba_degree == 54 | state_ba_degree == 51 | state_ba_degree == 37 | state_ba_degree == 45 | state_ba_degree == 12 | state_ba_degree == 13
replace ba_eastsouthcentral = 1 if state_ba_degree == 28 | state_ba_degree == 21 | state_ba_degree == 47 | state_ba_degree == 1
replace ba_westsouthcentral = 1 if state_ba_degree == 5 | state_ba_degree == 22 | state_ba_degree == 40 | state_ba_degree == 48
replace ba_mountain = 1 if state_ba_degree == 4 | state_ba_degree == 8 | state_ba_degree == 16 | state_ba_degree == 30 | state_ba_degree == 32 | state_ba_degree == 35 | state_ba_degree == 49 | state_ba_degree == 56
replace ba_pacific = 1 if state_ba_degree == 2 | state_ba_degree == 15 | state_ba_degree == 6 | state_ba_degree == 41 | state_ba_degree == 53

/* There are a few aggregated state variables for the early years that we can't tell which division they are in (e.g., "Mississippi and West Virginia"); these are small numbers of people */




/* Survey weights */
rename fnlwgt86 survey_weight1986
rename fnlwgt87 survey_weight1987





/* Are you employed? */
/* How should I do this? I have 12 observations per year */
/* For now, employed will not be a dummy. It will be the proportion of months you are employed at least one week */


gen employed1986 = 0
gen employed1987 = 0


forvalues k=1(1)12 {
replace employed1986 = employed1986 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace employed1987 = employed1987 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace employed1986 = employed1986 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace employed1987 = employed1987 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace employed1986 = employed1986 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace employed1987 = employed1987 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace employed1986 = employed1986 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace employed1987 = employed1987 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 4
}

sum employed*

replace employed1986 = employed1986 / (months_seen1986-months_enrolled1986)
replace employed1987 = employed1987 / (months_seen1987-months_enrolled1987)

sum employed*, d




/* Are you full-time? */

gen fulltime1986 = 0
gen fulltime1987 = 0

forvalues k=1(1)12 {
replace fulltime1986 = fulltime1986 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace fulltime1987 = fulltime1987 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace fulltime1986 = fulltime1986 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace fulltime1987 = fulltime1987 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace fulltime1986 = fulltime1986 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace fulltime1987 = fulltime1987 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace fulltime1986 = fulltime1986 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace fulltime1987 = fulltime1987 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

sum fulltime*

replace fulltime1986 = fulltime1986 / (months_seen1986-months_enrolled1986)
replace fulltime1987 = fulltime1987 / (months_seen1987-months_enrolled1987)

sum employed*, d
sum fulltime*, d




/* OCCUPATION */
/* I use the 6th month occupation as the occupation. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace ws1_oc0`k' = . if ws1_oc0`k' == 0 | ws1_oc0`k' == 905
rename ws1_oc0`k' ws1_oc`k'
}

forvalues k=10(1)32 {
replace ws1_oc`k' = . if ws1_oc`k' == 0 | ws1_oc`k' == 905
}


forvalues k=1(1)12 {
gen occ`k'_1986 = .
gen occ`k'_1987 = .
}

forvalues k=1(1)12 {
local j = `k'
replace occ`j'_1986 = ws1_oc`k' if rot == 1
}


forvalues k=13(1)24 {
local j = `k' - 12
replace occ`j'_1987 = ws1_oc`k' if rot == 1
}


forvalues k=4(1)15 {
local j = `k' - 3
replace occ`j'_1986 = ws1_oc`k' if rot == 2
}

forvalues k=16(1)27 {
local j = `k' - 15
replace occ`j'_1987 = ws1_oc`k' if rot == 2
}


forvalues k=3(1)14 {
local j = `k' - 2
replace occ`j'_1986 = ws1_oc`k' if rot == 3
}

forvalues k=15(1)26 {
local j = `k' - 14
replace occ`j'_1987 = ws1_oc`k' if rot == 3
}


forvalues k=2(1)13 {
local j = `k' - 1
replace occ`j'_1986 = ws1_oc`k' if rot == 4
}

forvalues k=14(1)25 {
local j = `k' - 13
replace occ`j'_1987 = ws1_oc`k' if rot == 4
}





/* INDUSTRY */
/* I use the 6th month industry as the industry. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace ws1_in0`k' = . if ws1_in0`k' == 0 | ws1_in0`k' == 905
rename ws1_in0`k' ws1_in`k'
}

forvalues k=10(1)32 {
replace ws1_in`k' = . if ws1_in`k' == 0 | ws1_in`k' == 905
}


forvalues k=1(1)12 {
gen ind`k'_1986 = .
gen ind`k'_1987 = .
}

forvalues k=1(1)12 {
local j = `k'
replace ind`j'_1986 = ws1_in`k' if rot == 1
}


forvalues k=13(1)24 {
local j = `k' - 12
replace ind`j'_1987 = ws1_in`k' if rot == 1
}


forvalues k=4(1)15 {
local j = `k' - 3
replace ind`j'_1986 = ws1_in`k' if rot == 2
}

forvalues k=16(1)27 {
local j = `k' - 15
replace ind`j'_1987 = ws1_in`k' if rot == 2
}


forvalues k=3(1)14 {
local j = `k' - 2
replace ind`j'_1986 = ws1_in`k' if rot == 3
}

forvalues k=15(1)26 {
local j = `k' - 14
replace ind`j'_1987 = ws1_in`k' if rot == 3
}


forvalues k=2(1)13 {
local j = `k' - 1
replace ind`j'_1986 = ws1_in`k' if rot == 4
}

forvalues k=14(1)25 {
local j = `k' - 13
replace ind`j'_1987 = ws1_in`k' if rot == 4
}

drop *month*

bysort rot: sum ind* occ*



/* Identifying variables */
keep *1986 *1987 rot su_id pp_entry pp_pnum state_ba* ba_*


sort su_id pp_entry pp_pnum
compress
save Temp/sipp86_full_cleaned.dta, replace


**************************************************************


clear

use Temp/sipp86wave2.dta


/**** WAVE 2 DATASET ****/



/* Identifiers */
sum su_id pp_entry pp_pnum




* D TM8408 1 6532
 * Has...received a high school diploma?
 * (include GED's.)
* U All persons with highest grade attended
 * grade 12 or less and not currently
 * attending elementary or high school
* V 0 .Not applicable
* V 1 .Yes
* V 2 .No - Skip to TM8444 





/********** COLLEGE DEGREE INFORMATION *********/

/* 2 questions: highest degree and BA degree. Need to check both */

/* Need year of degree, age at degree, and field of degree. Also need highest degree completed */


gen col = 0
gen morcol = 0
gen hgc = .

replace hgc = 12 if tm8422 == 0 | tm8422 == -1 | tm8422 == 7
replace hgc = 14 if tm8422 == 6 | tm8422 == 5
replace hgc = 16 if tm8422 == 4
replace hgc = 18 if tm8422 == 3
replace hgc = 19 if tm8422 == 2
replace hgc = 20 if tm8422 == 1
replace hgc = 10 if tm8408 == 2 // 2 means did not grad HS in 86 SIPP 

tab hgc, mi

replace col = 1 if hgc == 16
replace morcol = 1 if hgc > 16

tab col morcol


gen gradyear = .

replace tm8426 = . if tm8426 <= 0
replace tm8434 = . if tm8434 <= 0

replace gradyear = tm8426 if hgc == 16

replace gradyear = tm8434 if gradyear == .

tab gradyear


gen age_grad = .

replace age_grad = gradyear - brthyr

tab age_grad



/* Field of bachelor's degree */

rename tm8428 major_field
replace major_field = . if major_field == 0

tab major_field, mi





keep hgc major_field age_grad gradyear col morcol su_id pp_entry pp_pnum


sort su_id pp_entry pp_pnum



merge su_id pp_entry pp_pnum using Temp/sipp86_full_cleaned.dta

tab _merge
drop _merge


egen pid=group(su_id pp_entry pp_pnum)
*bysort su_id pp_entry pp_pnum: gen pid = _n

drop su_id pp_entry pp_pnum

drop earnings_job* earnings_se* 

drop year1986 year1987


reshape long total_hours survey_weight age male hispanic black earnings_annual hrlypay hrlypayv1 hrlypayv2 enrolled west northeast midwest south employed fulltime occ1_ occ2_ occ3_ occ4_ occ5_ occ6_ occ7_ occ8_ occ9_ occ10_ occ11_ occ12_ ind1_ ind2_ ind3_ ind4_ ind5_ ind6_ ind7_ ind8_ ind9_ ind10_ ind11_ ind12_, i(pid) j(year)


forvalues k=1(1)12 {
rename occ`k'_ occ`k'
rename ind`k'_ ind`k'
}


* keep if age >= 22

* keep if major_field != .
tab major_field, mi
tab major_field if hgc == 16
tab gradyear
gen potexp = year - gradyear
tab potexp

tab gradyear potexp if hgc == 16 & potexp <= 13

sum

gen panel = 1986
gen survey = 8687

sort pid
compress
save Temp/sipp86_ready.dta, replace

clear



/* 1987 */








use Temp/sipp87_full.dta


/* Age at survey */
gen year1987 = 1987
gen year1988 = 1988

gen age1987 = 1987 - brthyr
gen age1988 = 1988 - brthyr



/* Gender */
gen male1987 = (sex == 1)
gen male1988 = (sex == 1)


/* Race */
gen hispanic1987 = (ethnicty >= 14 & ethnicty <= 20)
gen hispanic1988 = (ethnicty >= 14 & ethnicty <= 20)

gen black1987 = (race == 2 & hispanic1987 != 1)
gen black1988 = (race == 2 & hispanic1988 != 1)



forvalues k=1(1)9 {
rename enrl_m0`k' enrl_m`k'
rename pp_mis0`k' pp_mis`k'
}

forvalues k=1(1)32 {
replace enrl_m`k' = . if pp_mis`k' != 1
}




gen months_seen1987 = 0
gen months_seen1988 = 0

/* Each wave asks about the past four months */


forvalues k=1(1)12 {
replace months_seen1987 = months_seen1987 + 1 if pp_mis`k' == 1 & rot == 1
}

forvalues k=13(1)24 {
replace months_seen1988 = months_seen1988 + 1 if pp_mis`k' == 1 & rot == 1
}



forvalues k=4(1)15 {
replace months_seen1987 = months_seen1987 + 1 if pp_mis`k' == 1 & rot == 2
}

forvalues k=16(1)27 {
replace months_seen1988 = months_seen1988 + 1 if pp_mis`k' == 1 & rot == 2
}



forvalues k=3(1)14 {
replace months_seen1987 = months_seen1987 + 1 if pp_mis`k' == 1 & rot == 3
}

forvalues k=15(1)26 {
replace months_seen1988 = months_seen1988 + 1 if pp_mis`k' == 1 & rot == 3
}



forvalues k=2(1)13 {
replace months_seen1987 = months_seen1987 + 1 if pp_mis`k' == 1 & rot == 4
}

forvalues k=14(1)25 {
replace months_seen1988 = months_seen1988 + 1 if pp_mis`k' == 1 & rot == 4
}



/*
/* The first survey is in Feb 1987, so we don't have obs for many people in 1985 */
replace months_seen1986 = 3 if rot == 2
replace months_seen1986 = 2 if rot == 3
replace months_seen1986 = 1 if rot == 4
replace months_seen1986 = 0 if rot == 1


/* We see everyone through all of 1987 */
replace months_seen1987 = 12 if rot == 2
replace months_seen1987 = 12 if rot == 3
replace months_seen1987 = 12 if rot == 4
replace months_seen1987 = 12 if rot == 1


/* We see everyone through all of 1988 */
replace months_seen1988 = 12 if rot == 2
replace months_seen1988 = 12 if rot == 3
replace months_seen1988 = 12 if rot == 4
replace months_seen1988 = 12 if rot == 1


/* We only see a bit of 1989 */
replace months_seen1989 = 1 if rot == 2
replace months_seen1989 = 2 if rot == 3
replace months_seen1989 = 3 if rot == 4
replace months_seen1989 = 4 if rot == 1
*/





/* Enrolled? */

/* I will code you as enrolled in the year if you are enrolled at least 2 months of the year */
gen months_enrolled1987 = 0
gen months_enrolled1988 = 0




forvalues k=1(1)12 {
replace months_enrolled1987 = months_enrolled1987 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=13(1)24 {
replace months_enrolled1988 = months_enrolled1988 + 1 if enrl_m`k' == 1 & rot == 1
}



forvalues k=4(1)15 {
replace months_enrolled1987 = months_enrolled1987 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=16(1)27 {
replace months_enrolled1988 = months_enrolled1988 + 1 if enrl_m`k' == 1 & rot == 2
}



forvalues k=3(1)14 {
replace months_enrolled1987 = months_enrolled1987 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=15(1)26 {
replace months_enrolled1988 = months_enrolled1988 + 1 if enrl_m`k' == 1 & rot == 3
}



forvalues k=2(1)13 {
replace months_enrolled1987 = months_enrolled1987 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=14(1)25 {
replace months_enrolled1988 = months_enrolled1988 + 1 if enrl_m`k' == 1 & rot == 4
}

sum months_enrolled*




gen enrolled1988 = months_enrolled1988 / months_seen1988
gen enrolled1987 = months_enrolled1987 / months_seen1987







/**** ANNUAL EARNINGS ****/

/* Earnings are by month. Month #s to actual month mapping differs by rotation group */
forvalues k=1(1)9 {
rename ws1_am0`k' earnings_job1_month`k' 
rename ws2_am0`k' earnings_job2_month`k' 
rename se1_am0`k' earnings_se1_month`k' 
rename se2_am0`k' earnings_se2_month`k' 
}

forvalues k=10(1)32 {
rename ws1_am`k' earnings_job1_month`k' 
rename ws2_am`k' earnings_job2_month`k' 
rename se1_am`k' earnings_se1_month`k' 
rename se2_am`k' earnings_se2_month`k' 
}


forvalues k=1(1)32 {
replace earnings_job1_month`k' = 0 if earnings_job1_month`k' < 0 | earnings_job1_month`k' == .
replace earnings_job2_month`k' = 0 if earnings_job2_month`k' < 0 | earnings_job2_month`k' == .
replace earnings_se1_month`k' = 0 if earnings_se1_month`k' < 0 | earnings_se1_month`k' == .
replace earnings_se2_month`k' = 0 if earnings_se2_month`k' < 0 | earnings_se2_month`k' == .
}

forvalues k=1(1)32 {
replace earnings_job1_month`k' = . if pp_mis`k' != 1
replace earnings_job2_month`k' = . if pp_mis`k' != 1
replace earnings_se1_month`k' = . if pp_mis`k' != 1
replace earnings_se2_month`k' = . if pp_mis`k' != 1
}



gen earnings_job1_1987 = 0
gen earnings_job1_1988 = 0
gen earnings_job2_1987 = 0
gen earnings_job2_1988 = 0
gen earnings_se1_1987 = 0
gen earnings_se1_1988 = 0
gen earnings_se2_1987 = 0
gen earnings_se2_1988 = 0

gen earnings_annual1987 = 0
gen earnings_annual1988 = 0


/* Rotation group 1: 1987 is months 1-12, 1988 is months 13-24 */
forvalues k=1(1)12 {
replace earnings_annual1987 = earnings_annual1987 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}

forvalues k=13(1)24 {
replace earnings_annual1988 = earnings_annual1988 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}


replace earnings_annual1987 = (earnings_annual1987/(months_seen1987-months_enrolled1987)) * 12  if rot == 1
replace earnings_annual1988 = (earnings_annual1988/(months_seen1988-months_enrolled1988)) * 12  if rot == 1

replace earnings_annual1987 = 0 if months_enrolled1987 == 12 & rot == 1
replace earnings_annual1988 = 0 if months_enrolled1988 == 12 & rot == 1

sum earnings_annual* if rot == 1






/* Rotation group 2: 1987 is months 4-15, 1988 is months 16-27 */
forvalues k=4(1)15 {
replace earnings_annual1987 = earnings_annual1987 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}

forvalues k=16(1)27 {
replace earnings_annual1988 = earnings_annual1988 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}


replace earnings_annual1987 = (earnings_annual1987/(months_seen1987-months_enrolled1987)) * 12  if rot == 2
replace earnings_annual1988 = (earnings_annual1988/(months_seen1988-months_enrolled1988)) * 12  if rot == 2

replace earnings_annual1987 = 0 if months_enrolled1987 == 12 & rot == 2
replace earnings_annual1988 = 0 if months_enrolled1988 == 12 & rot == 2

sum earnings_annual* if rot == 2








/* Rotation group 3: 1987 is months 3-14, 1988 is months 15-26 */
forvalues k=3(1)14 {
replace earnings_annual1987 = earnings_annual1987 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}

forvalues k=15(1)26 {
replace earnings_annual1988 = earnings_annual1988 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}


replace earnings_annual1987 = (earnings_annual1987/(months_seen1987-months_enrolled1987)) * 12  if rot == 3
replace earnings_annual1988 = (earnings_annual1988/(months_seen1988-months_enrolled1988)) * 12  if rot == 3

replace earnings_annual1987 = 0 if months_enrolled1987 == 12 & rot == 3
replace earnings_annual1988 = 0 if months_enrolled1988 == 12 & rot == 3

sum earnings_annual* if rot == 3






/* Rotation group 4: 1987 is months 2-13, 1988 is months 14-25 */
forvalues k=2(1)13 {
replace earnings_annual1987 = earnings_annual1987 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}

forvalues k=14(1)25 {
replace earnings_annual1988 = earnings_annual1988 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}


replace earnings_annual1987 = (earnings_annual1987/(months_seen1987-months_enrolled1987)) * 12  if rot == 4
replace earnings_annual1988 = (earnings_annual1988/(months_seen1988-months_enrolled1988)) * 12  if rot == 4

replace earnings_annual1987 = 0 if months_enrolled1987 == 12 & rot == 4
replace earnings_annual1988 = 0 if months_enrolled1988 == 12 & rot == 4

sum earnings_annual* if rot == 4

bysort rot: sum earnings_annual1987 if earnings_annual1987 > 300
bysort rot: sum earnings_annual1988 if earnings_annual1988 > 300




/**** WAGES ****/
/* For hourly workers, we actually have an hourly rate of pay variable */
forvalues k=1(1)9 {
rename w2028_0`k' wage_month`k'
replace wage_month`k' = . if pp_mis`k' != 1
}

forvalues k=10(1)32 {
rename w2028_`k' wage_month`k'
replace wage_month`k' = . if pp_mis`k' != 1

}


/* Annual wage measure will be the average of the non-missing wage measures in the year (for job 1 only) for non-enrolled months */

/* Need to get # of non-missing wage measures each year */
gen wage_count1987 = 0
gen wage_count1988 = 0

forvalues k=1(1)12 {
replace wage_count1987 = wage_count1987 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace wage_count1988 = wage_count1988 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace wage_count1987 = wage_count1987 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace wage_count1988 = wage_count1988 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace wage_count1987 = wage_count1987 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace wage_count1988 = wage_count1988 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace wage_count1987 = wage_count1987 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace wage_count1988 = wage_count1988 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}



/* Now, we construct the annual wage measure */
gen hrlypay1987 = .
gen hrlypay1988 = .

gen hrlypayv11987 = .
gen hrlypayv11988 = .

gen hrlypayv21987 = .
gen hrlypayv21988 = .

gen total_wage1987 = 0
gen total_wage1988 = 0


forvalues k=1(1)12 {
replace total_wage1987 = total_wage1987 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace total_wage1988 = total_wage1988 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace total_wage1987 = total_wage1987 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace total_wage1988 = total_wage1988 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace total_wage1987 = total_wage1987 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace total_wage1988 = total_wage1988 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace total_wage1987 = total_wage1987 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace total_wage1988 = total_wage1988 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}


replace hrlypayv11987 = total_wage1987/wage_count1987 
replace hrlypayv11988 = total_wage1988/wage_count1988


sum hrlypay*
bysort rot: sum hrlypay*

drop total_wage* wage_count* wage_month*



/* Alternative if you don't work by the hour: get earnings/hours */
forvalues k=1(1)9 {
replace w2024_0`k' = 0 if w2024_0`k' < 0
rename w2024_0`k' hours_job1_month`k'

replace w2124_0`k' = 0 if w2124_0`k' < 0
rename w2124_0`k' hours_job2_month`k'
}

forvalues k=10(1)32 {
replace w2024_`k' = 0 if w2024_`k' < 0
rename w2024_`k' hours_job1_month`k'
rename w2124_`k' hours_job2_month`k'

}

forvalues k=1(1)32 {
replace hours_job1_month`k' = . if pp_mis`k' != 1
replace hours_job2_month`k' = . if pp_mis`k' != 1
}


/* Need to get # of non-missing hours measures each year */
gen hours_count1987 = 0
gen hours_count1988 = 0

forvalues k=1(1)12 {
replace hours_count1987 = hours_count1987 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace hours_count1988 = hours_count1988 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace hours_count1987 = hours_count1987 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace hours_count1988 = hours_count1988 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace hours_count1987 = hours_count1987 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace hours_count1988 = hours_count1988 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace hours_count1987 = hours_count1987 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace hours_count1988 = hours_count1988 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}


gen total_hours1987 = 0
gen total_hours1988 = 0


forvalues k=1(1)9 {
rename ws1_wk0`k' ws1_wk`k'
rename ws2_wk0`k' ws2_wk`k'
}


forvalues k=1(1)32 {
replace ws1_wk`k' = . if pp_mis`k' != 1
replace ws2_wk`k' = . if pp_mis`k' != 1
}



forvalues k=1(1)12 {
replace total_hours1987 = total_hours1987 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace total_hours1988 = total_hours1988 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace total_hours1987 = total_hours1987 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace total_hours1988 = total_hours1988 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace total_hours1987 = total_hours1987 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace total_hours1988 = total_hours1988 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace total_hours1987 = total_hours1987 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace total_hours1988 = total_hours1988 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}


replace hrlypayv21987 = earnings_annual1987 / total_hours1987 
replace hrlypayv21988 = earnings_annual1988 / total_hours1988

forvalues k=1987(1)1988 {
replace hrlypay`k' = hrlypayv1`k'
replace hrlypay`k' = hrlypayv2`k' if hrlypay`k' == . | hrlypay`k' == 0
}


sum hrlypay*

bysort rot: sum hrlypay1987 if hrlypay1987 > 1






sum age1987 age1988

sum black* hispanic*

sum hrlypay*, d





/* State and region */
/* I take the state from the first wave as the state for 1987 and the fourth wave for 1988 */
rename state_1 state

replace state = state_2 if state == 0 | state == .
replace state = state_3 if state == 0 | state == .


gen west = 0
gen northeast = 0
gen midwest = 0
gen south = 0

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1987 = west
gen northeast1987 = northeast
gen midwest1987 = midwest
gen south1987 = south

rename state state_ba_degree 

/* State_4 is the state from the 4th wave, which is in the second year */
rename state_4 state

replace state = state_5 if state == 0 | state == .
replace state = state_6 if state == 0 | state == .


replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1988 = west
gen northeast1988 = northeast
gen midwest1988 = midwest
gen south1988 = south


drop west south midwest northeast



/* Division of degree */
gen ba_newengland = 0
gen ba_midatlantic = 0
gen ba_eastnorthcentral = 0
gen ba_westnorthcentral = 0
gen ba_southatlantic = 0
gen ba_eastsouthcentral = 0
gen ba_westsouthcentral = 0
gen ba_mountain = 0
gen ba_pacific = 0


replace ba_newengland = 1 if state_ba_degree == 9 | state_ba_degree == 25 | state_ba_degree == 33  | state_ba_degree == 44 | state_ba_degree == 23 | state_ba_degree == 50 | state_ba_degree == 61
replace ba_midatlantic = 1 if state_ba_degree == 34 | state_ba_degree == 36 | state_ba_degree == 42
replace ba_eastnorthcentral = 1 if  state_ba_degree == 55 | state_ba_degree == 39 | state_ba_degree == 26 | state_ba_degree == 18 | state_ba_degree == 17
replace ba_westnorthcentral = 1 if state_ba_degree == 62 | state_ba_degree == 19 | state_ba_degree == 38 | state_ba_degree == 46 | state_ba_degree == 31| state_ba_degree == 20 | state_ba_degree == 29 | state_ba_degree == 27
replace ba_southatlantic = 1 if state_ba_degree == 10 | state_ba_degree == 11 | state_ba_degree == 24 | state_ba_degree == 54 | state_ba_degree == 51 | state_ba_degree == 37 | state_ba_degree == 45 | state_ba_degree == 12 | state_ba_degree == 13
replace ba_eastsouthcentral = 1 if state_ba_degree == 28 | state_ba_degree == 21 | state_ba_degree == 47 | state_ba_degree == 1
replace ba_westsouthcentral = 1 if state_ba_degree == 5 | state_ba_degree == 22 | state_ba_degree == 40 | state_ba_degree == 48
replace ba_mountain = 1 if state_ba_degree == 4 | state_ba_degree == 8 | state_ba_degree == 16 | state_ba_degree == 30 | state_ba_degree == 32 | state_ba_degree == 35 | state_ba_degree == 49 | state_ba_degree == 56
replace ba_pacific = 1 if state_ba_degree == 2 | state_ba_degree == 15 | state_ba_degree == 6 | state_ba_degree == 41 | state_ba_degree == 53

/* There are a few aggregated state variables for the early years that we can't tell which division they are in (e.g., "Mississippi and West Virginia"); these are small numbers of people */




/* Survey weights */
rename fnlwgt87 survey_weight1987
rename fnlwgt88 survey_weight1988





/* Are you employed? */
/* How should I do this? I have 12 observations per year */
/* For now, employed will not be a dummy. It will be the proportion of months you are employed at least one week */


gen employed1987 = 0
gen employed1988 = 0


forvalues k=1(1)12 {
replace employed1987 = employed1987 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace employed1988 = employed1988 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace employed1987 = employed1987 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace employed1988 = employed1988 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace employed1987 = employed1987 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace employed1988 = employed1988 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace employed1987 = employed1987 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace employed1988 = employed1988 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 4
}

sum employed*

replace employed1987 = employed1987 / (months_seen1987-months_enrolled1987)
replace employed1988 = employed1988 / (months_seen1988-months_enrolled1988)

sum employed*, d




/* Are you full-time? */

gen fulltime1987 = 0
gen fulltime1988 = 0

forvalues k=1(1)12 {
replace fulltime1987 = fulltime1987 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace fulltime1988 = fulltime1988 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace fulltime1987 = fulltime1987 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace fulltime1988 = fulltime1988 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace fulltime1987 = fulltime1987 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace fulltime1988 = fulltime1988 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace fulltime1987 = fulltime1987 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace fulltime1988 = fulltime1988 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

sum fulltime*

replace fulltime1987 = fulltime1987 / (months_seen1987-months_enrolled1987)
replace fulltime1988 = fulltime1988 / (months_seen1988-months_enrolled1988)

sum employed*, d
sum fulltime*, d




/* OCCUPATION */
/* I use the 6th month occupation as the occupation. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace ws1_oc0`k' = . if ws1_oc0`k' == 0 | ws1_oc0`k' == 905
rename ws1_oc0`k' ws1_oc`k'
}

forvalues k=10(1)32 {
replace ws1_oc`k' = . if ws1_oc`k' == 0 | ws1_oc`k' == 905
}


forvalues k=1(1)12 {
gen occ`k'_1987 = .
gen occ`k'_1988 = .
}

forvalues k=1(1)12 {
local j = `k'
replace occ`j'_1987 = ws1_oc`k' if rot == 1
}


forvalues k=13(1)24 {
local j = `k' - 12
replace occ`j'_1988 = ws1_oc`k' if rot == 1
}


forvalues k=4(1)15 {
local j = `k' - 3
replace occ`j'_1987 = ws1_oc`k' if rot == 2
}

forvalues k=16(1)27 {
local j = `k' - 15
replace occ`j'_1988 = ws1_oc`k' if rot == 2
}


forvalues k=3(1)14 {
local j = `k' - 2
replace occ`j'_1987 = ws1_oc`k' if rot == 3
}

forvalues k=15(1)26 {
local j = `k' - 14
replace occ`j'_1988 = ws1_oc`k' if rot == 3
}


forvalues k=2(1)13 {
local j = `k' - 1
replace occ`j'_1987 = ws1_oc`k' if rot == 4
}

forvalues k=14(1)25 {
local j = `k' - 13
replace occ`j'_1988 = ws1_oc`k' if rot == 4
}





/* INDUSTRY */
/* I use the 6th month industry as the industry. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace ws1_in0`k' = . if ws1_in0`k' == 0 | ws1_in0`k' == 905
rename ws1_in0`k' ws1_in`k'
}

forvalues k=10(1)32 {
replace ws1_in`k' = . if ws1_in`k' == 0 | ws1_in`k' == 905
}


forvalues k=1(1)12 {
gen ind`k'_1987 = .
gen ind`k'_1988 = .
}

forvalues k=1(1)12 {
local j = `k'
replace ind`j'_1987 = ws1_in`k' if rot == 1
}


forvalues k=13(1)24 {
local j = `k' - 12
replace ind`j'_1988 = ws1_in`k' if rot == 1
}


forvalues k=4(1)15 {
local j = `k' - 3
replace ind`j'_1987 = ws1_in`k' if rot == 2
}

forvalues k=16(1)27 {
local j = `k' - 15
replace ind`j'_1988 = ws1_in`k' if rot == 2
}


forvalues k=3(1)14 {
local j = `k' - 2
replace ind`j'_1987 = ws1_in`k' if rot == 3
}

forvalues k=15(1)26 {
local j = `k' - 14
replace ind`j'_1988 = ws1_in`k' if rot == 3
}


forvalues k=2(1)13 {
local j = `k' - 1
replace ind`j'_1987 = ws1_in`k' if rot == 4
}

forvalues k=14(1)25 {
local j = `k' - 13
replace ind`j'_1988 = ws1_in`k' if rot == 4
}

drop *month*

bysort rot: sum ind* occ*



/* Identifying variables */
keep *1987 *1988 rot su_id pp_entry pp_pnum state_ba_degree ba_*


sort su_id pp_entry pp_pnum
compress
save Temp/sipp87_full_cleaned.dta, replace


**************************************************************


clear

use Temp/sipp87wave2.dta


/**** WAVE 2 DATASET ****/



/* Identifiers */
sum su_id pp_entry pp_pnum



/********** COLLEGE DEGREE INFORMATION *********/

/* 2 questions: highest degree and BA degree. Need to check both */

/* Need year of degree, age at degree, and field of degree. Also need highest degree completed */


gen col = 0
gen morcol = 0
gen hgc = .

replace hgc = 12 if tm8422 == 0 | tm8422 == -1 | tm8422 == 7
replace hgc = 14 if tm8422 == 6 | tm8422 == 5
replace hgc = 16 if tm8422 == 4
replace hgc = 18 if tm8422 == 3
replace hgc = 19 if tm8422 == 2
replace hgc = 20 if tm8422 == 1
replace hgc = 10 if tm8408 == 2 // 2 means did not grad HS in 87 SIPP 

replace col = 1 if hgc == 16
replace morcol = 1 if hgc > 16

tab hgc, mi

tab col morcol


gen gradyear = .

replace tm8426 = . if tm8426 <= 0
replace tm8434 = . if tm8434 <= 0

replace gradyear = tm8426 if hgc == 16

replace gradyear = tm8434 if gradyear == .

tab gradyear


gen age_grad = .

replace age_grad = gradyear - brthyr

tab age_grad



/* Field of bachelor's degree */

rename tm8428 major_field
replace major_field = . if major_field == 0

tab major_field, mi





keep hgc major_field age_grad gradyear col morcol su_id pp_entry pp_pnum


sort su_id pp_entry pp_pnum



merge su_id pp_entry pp_pnum using Temp/sipp87_full_cleaned.dta

tab _merge
drop _merge


egen pid=group(su_id pp_entry pp_pnum)
*bysort su_id pp_entry pp_pnum: gen pid = _n

drop su_id pp_entry pp_pnum

drop earnings_job* earnings_se* 

drop year1987 year1988


reshape long total_hours survey_weight age male hispanic black earnings_annual hrlypay hrlypayv1 hrlypayv2 enrolled west northeast midwest south employed fulltime occ1_ occ2_ occ3_ occ4_ occ5_ occ6_ occ7_ occ8_ occ9_ occ10_ occ11_ occ12_ ind1_ ind2_ ind3_ ind4_ ind5_ ind6_ ind7_ ind8_ ind9_ ind10_ ind11_ ind12_, i(pid) j(year)



forvalues k=1(1)12 {
rename occ`k'_ occ`k'
rename ind`k'_ ind`k'
}


* keep if age >= 22

* keep if major_field != .
tab major_field, mi
tab major_field if hgc == 16
tab gradyear
gen potexp = year - gradyear
tab potexp

tab gradyear potexp if hgc == 16 & potexp <= 13

sum

gen panel = 1987
gen survey = 8687

sort pid
compress
save Temp/sipp87_ready.dta, replace

clear




/* 1988 */






use Temp/sipp88_full.dta


/* Age at survey */
gen year1988 = 1988
gen year1989 = 1989

gen age1988 = 1988 - u_brthyr
gen age1989 = 1989 - u_brthyr



/* Gender */
gen male1988 = (sex == 1)
gen male1989 = (sex == 1)


/* Race */
gen hispanic1988 = (ethnicty >= 14 & ethnicty <= 20)
gen hispanic1989 = (ethnicty >= 14 & ethnicty <= 20)

gen black1988 = (race == 2 & hispanic1988 != 1)
gen black1989 = (race == 2 & hispanic1989 != 1)



forvalues k=1(1)9 {
rename enrl_m0`k' enrl_m`k'
rename pp_mis0`k' pp_mis`k'
}

forvalues k=1(1)32 {
replace enrl_m`k' = . if pp_mis`k' != 1 
}

gen months_seen1988 = 0
gen months_seen1989 = 0

/* Each wave asks about the past four months */


forvalues k=1(1)12 {
replace months_seen1988 = months_seen1988 + 1 if pp_mis`k' == 1 & rot == 1
}

forvalues k=13(1)24 {
replace months_seen1989 = months_seen1989 + 1 if pp_mis`k' == 1 & rot == 1
}



forvalues k=4(1)15 {
replace months_seen1988 = months_seen1988 + 1 if pp_mis`k' == 1 & rot == 2
}

forvalues k=16(1)24 {
replace months_seen1989 = months_seen1989 + 1 if pp_mis`k' == 1 & rot == 2
}



forvalues k=3(1)14 {
replace months_seen1988 = months_seen1988 + 1 if pp_mis`k' == 1 & rot == 3
}

forvalues k=15(1)24 {
replace months_seen1989 = months_seen1989 + 1 if pp_mis`k' == 1 & rot == 3
}



forvalues k=2(1)13 {
replace months_seen1988 = months_seen1988 + 1 if pp_mis`k' == 1 & rot == 4
}

forvalues k=14(1)24 {
replace months_seen1989 = months_seen1989 + 1 if pp_mis`k' == 1 & rot == 4
}

/*
/* The first survey is in Feb 1988, so we don't have obs for many people in 1987 */
replace months_seen1987 = 3 if rot == 2
replace months_seen1987 = 2 if rot == 3
replace months_seen1987 = 1 if rot == 4
replace months_seen1987 = 0 if rot == 1


/* We see everyone through all of 1988 */
replace months_seen1988 = 12 if rot == 2
replace months_seen1988 = 12 if rot == 3
replace months_seen1988 = 12 if rot == 4
replace months_seen1988 = 12 if rot == 1


/* We don't see everyone through all of 1989 */
replace months_seen1989 = 9 if rot == 2
replace months_seen1989 = 10 if rot == 3
replace months_seen1989 = 11 if rot == 4
replace months_seen1989 = 12 if rot == 1

*/



/* Enrolled? */



/* I will code you as enrolled in the year if you are enrolled at least 2 months of the year */
gen months_enrolled1988 = 0
gen months_enrolled1989 = 0




forvalues k=1(1)12 {
replace months_enrolled1988 = months_enrolled1988 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=13(1)24 {
replace months_enrolled1989 = months_enrolled1989 + 1 if enrl_m`k' == 1 & rot == 1
}



forvalues k=4(1)15 {
replace months_enrolled1988 = months_enrolled1988 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=16(1)24 {
replace months_enrolled1989 = months_enrolled1989 + 1 if enrl_m`k' == 1 & rot == 2
}



forvalues k=3(1)14 {
replace months_enrolled1988 = months_enrolled1988 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=15(1)24 {
replace months_enrolled1989 = months_enrolled1989 + 1 if enrl_m`k' == 1 & rot == 3
}



forvalues k=2(1)13 {
replace months_enrolled1988 = months_enrolled1988 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=14(1)24 {
replace months_enrolled1989 = months_enrolled1989 + 1 if enrl_m`k' == 1 & rot == 4
}

sum months_enrolled*


gen enrolled1988 = months_enrolled1988 / months_seen1988
gen enrolled1989 = months_enrolled1989 / months_seen1989





/**** ANNUAL EARNINGS ****/

/* Earnings are by month. Month #s to actual month mapping differs by rotation group */
forvalues k=1(1)9 {
rename ernam10`k' earnings_job1_month`k' 
rename ernam20`k' earnings_job2_month`k' 
gen earnings_se1_month`k' = 0
gen earnings_se2_month`k' = 0
}

forvalues k=10(1)32 {
rename ernam1`k' earnings_job1_month`k' 
rename ernam2`k' earnings_job2_month`k' 
gen earnings_se1_month`k' = 0
gen earnings_se2_month`k' = 0
}



forvalues k=1(1)32 {
replace earnings_job1_month`k' = 0 if earnings_job1_month`k' < 0 | earnings_job1_month`k' == .
replace earnings_job2_month`k' = 0 if earnings_job2_month`k' < 0 | earnings_job2_month`k' == .
replace earnings_se1_month`k' = 0 if earnings_se1_month`k' < 0 | earnings_se1_month`k' == .
replace earnings_se2_month`k' = 0 if earnings_se2_month`k' < 0 | earnings_se2_month`k' == .
}

forvalues k=1(1)32 {
replace earnings_job1_month`k' = . if pp_mis`k' != 1
replace earnings_job2_month`k' = . if pp_mis`k' != 1
}


gen earnings_job1_1988 = 0
gen earnings_job1_1989 = 0
gen earnings_job2_1988 = 0
gen earnings_job2_1989 = 0
gen earnings_se1_1988 = 0
gen earnings_se1_1989 = 0
gen earnings_se2_1988 = 0
gen earnings_se2_1989 = 0

gen earnings_annual1988 = 0
gen earnings_annual1989 = 0


/* Rotation group 1: 1988 is months 1-12, 1989 is months 13-24 */
forvalues k=1(1)12 {
replace earnings_annual1988 = earnings_annual1988 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}

forvalues k=13(1)24 {
replace earnings_annual1989 = earnings_annual1989 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}


replace earnings_annual1988 = (earnings_annual1988/(months_seen1988-months_enrolled1988)) * 12  if rot == 1
replace earnings_annual1989 = (earnings_annual1989/(months_seen1989-months_enrolled1989)) * 12  if rot == 1

replace earnings_annual1988 = 0 if months_enrolled1988 == 12 & rot == 1
replace earnings_annual1989 = 0 if months_enrolled1989 == 12 & rot == 1

sum earnings_annual* if rot == 1






/* Rotation group 2: 1988 is months 4-15, 1989 is months 16-27 */
forvalues k=4(1)15 {
replace earnings_annual1988 = earnings_annual1988 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}

forvalues k=16(1)24 {
replace earnings_annual1989 = earnings_annual1989 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}


replace earnings_annual1988 = (earnings_annual1988/(months_seen1988-months_enrolled1988)) * 12  if rot == 2
replace earnings_annual1989 = (earnings_annual1989/(months_seen1989-months_enrolled1989)) * 12  if rot == 2

replace earnings_annual1988 = 0 if months_enrolled1988 == 12 & rot == 2
replace earnings_annual1989 = 0 if months_enrolled1989 == 12 & rot == 2

sum earnings_annual* if rot == 2








/* Rotation group 3: 1988 is months 3-14, 1989 is months 15-26 */
forvalues k=3(1)14 {
replace earnings_annual1988 = earnings_annual1988 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}

forvalues k=15(1)24 {
replace earnings_annual1989 = earnings_annual1989 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}


replace earnings_annual1988 = (earnings_annual1988/(months_seen1988-months_enrolled1988)) * 12  if rot == 3
replace earnings_annual1989 = (earnings_annual1989/(months_seen1989-months_enrolled1989)) * 12  if rot == 3

replace earnings_annual1988 = 0 if months_enrolled1988 == 12 & rot == 3
replace earnings_annual1989 = 0 if months_enrolled1989 == 12 & rot == 3

sum earnings_annual* if rot == 3






/* Rotation group 4: 1988 is months 2-13, 1989 is months 14-25 */
forvalues k=2(1)13 {
replace earnings_annual1988 = earnings_annual1988 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}

forvalues k=14(1)24 {
replace earnings_annual1989 = earnings_annual1989 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}


replace earnings_annual1988 = (earnings_annual1988/(months_seen1988-months_enrolled1988)) * 12  if rot == 4
replace earnings_annual1989 = (earnings_annual1989/(months_seen1989-months_enrolled1989)) * 12  if rot == 4

replace earnings_annual1988 = 0 if months_enrolled1988 == 12 & rot == 4
replace earnings_annual1989 = 0 if months_enrolled1989 == 12 & rot == 4

sum earnings_annual* if rot == 4

bysort rot: sum earnings_annual1988 if earnings_annual1988 > 300
bysort rot: sum earnings_annual1989 if earnings_annual1989 > 300




/**** WAGES ****/
/* For hourly workers, we actually have an hourly rate of pay variable */
forvalues k=1(1)9 {
rename hrrat10`k' wage_month`k'
replace wage_month`k' = . if pp_mis`k' != 1
}

forvalues k=10(1)32 {
rename hrrat1`k' wage_month`k'
replace wage_month`k' = . if pp_mis`k' != 1

}


/* Annual wage measure will be the average of the non-missing wage measures in the year (for job 1 only) */

/* Need to get # of non-missing wage measures each year */
gen wage_count1988 = 0
gen wage_count1989 = 0

forvalues k=1(1)12 {
replace wage_count1988 = wage_count1988 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace wage_count1989 = wage_count1989 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace wage_count1988 = wage_count1988 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)24 {
replace wage_count1989 = wage_count1989 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace wage_count1988 = wage_count1988 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)24 {
replace wage_count1989 = wage_count1989 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace wage_count1988 = wage_count1988 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)24 {
replace wage_count1989 = wage_count1989 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}



/* Now, we construct the annual wage measure */
gen hrlypay1988 = .
gen hrlypay1989 = .

gen hrlypayv11988 = .
gen hrlypayv11989 = .

gen hrlypayv21988 = .
gen hrlypayv21989 = .

gen total_wage1988 = 0
gen total_wage1989 = 0


forvalues k=1(1)12 {
replace total_wage1988 = total_wage1988 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace total_wage1989 = total_wage1989 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace total_wage1988 = total_wage1988 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)24 {
replace total_wage1989 = total_wage1989 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace total_wage1988 = total_wage1988 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)24 {
replace total_wage1989 = total_wage1989 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace total_wage1988 = total_wage1988 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)24 {
replace total_wage1989 = total_wage1989 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}


replace hrlypayv11988 = total_wage1988/wage_count1988 
replace hrlypayv11989 = total_wage1989/wage_count1989


sum hrlypay*
bysort rot: sum hrlypay*

drop total_wage* wage_count* wage_month*




/* Alternative if you don't work by the hour: get earnings/hours */
forvalues k=1(1)9 {
replace wshrs10`k' = 0 if wshrs10`k' < 0
rename wshrs10`k' hours_job1_month`k'

replace wshrs20`k' = 0 if wshrs20`k' < 0
rename wshrs20`k' hours_job2_month`k'
}

forvalues k=10(1)32 {
replace wshrs1`k' = 0 if wshrs1`k' < 0
rename wshrs1`k' hours_job1_month`k'
rename wshrs2`k' hours_job2_month`k'

}


forvalues k=1(1)32 {
replace hours_job1_month`k' = . if pp_mis`k' != 1
replace hours_job2_month`k' = . if pp_mis`k' != 1
}


/* Need to get # of non-missing hours measures each year */
gen hours_count1988 = 0
gen hours_count1989 = 0

forvalues k=1(1)12 {
replace hours_count1988 = hours_count1988 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace hours_count1989 = hours_count1989 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace hours_count1988 = hours_count1988 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)24 {
replace hours_count1989 = hours_count1989 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace hours_count1988 = hours_count1988 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)24 {
replace hours_count1989 = hours_count1989 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace hours_count1988 = hours_count1988 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)24 {
replace hours_count1989 = hours_count1989 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}




gen total_hours1988 = 0
gen total_hours1989 = 0


forvalues k=1(1)9 {
rename wksem10`k' ws1_wk`k'
rename wksem20`k' ws2_wk`k'
}

forvalues k=10(1)32 {
rename wksem1`k' ws1_wk`k'
rename wksem2`k' ws2_wk`k'
}

forvalues k=1(1)32 {
replace ws1_wk`k' = . if pp_mis`k' != 1
replace ws2_wk`k' = . if pp_mis`k' != 1
}



forvalues k=1(1)12 {
replace total_hours1988 = total_hours1988 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace total_hours1989 = total_hours1989 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace total_hours1988 = total_hours1988 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)24 {
replace total_hours1989 = total_hours1989 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace total_hours1988 = total_hours1988 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)24 {
replace total_hours1989 = total_hours1989 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace total_hours1988 = total_hours1988 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)24 {
replace total_hours1989 = total_hours1989 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}


replace hrlypayv21988 = earnings_annual1988 / total_hours1988
replace hrlypayv21989 = earnings_annual1989 / total_hours1989

forvalues k=1988(1)1989 {
replace hrlypay`k' = hrlypayv1`k'
replace hrlypay`k' = hrlypayv2`k' if hrlypay`k' == . | hrlypay`k' == 0
}


sum hrlypay*

bysort rot: sum hrlypay1988 if hrlypay1988 > 1




sum age1988 age1989

sum black* hispanic*

sum hrlypay*, d




/* State and region */
/* I take the state from the first wave as the state for 1988 and the fourth wave for 1989 */
rename geo_ste1 state

replace state = geo_ste2 if state == 0 | state == .
replace state = geo_ste3 if state == 0 | state == .

gen west = 0
gen northeast = 0
gen midwest = 0
gen south = 0

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1988 = west
gen northeast1988 = northeast
gen midwest1988 = midwest
gen south1988 = south

rename state state_ba_degree 


/* geo_ste4 is the state from the 4th wave, which is in the second year */
rename geo_ste4 state

replace state = geo_ste5 if state == 0 | state == .
replace state = geo_ste6 if state == 0 | state == .

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1989 = west
gen northeast1989 = northeast
gen midwest1989 = midwest
gen south1989 = south


drop west south midwest northeast 



/* Division of degree */
gen ba_newengland = 0
gen ba_midatlantic = 0
gen ba_eastnorthcentral = 0
gen ba_westnorthcentral = 0
gen ba_southatlantic = 0
gen ba_eastsouthcentral = 0
gen ba_westsouthcentral = 0
gen ba_mountain = 0
gen ba_pacific = 0


replace ba_newengland = 1 if state_ba_degree == 9 | state_ba_degree == 25 | state_ba_degree == 33  | state_ba_degree == 44 | state_ba_degree == 23 | state_ba_degree == 50 | state_ba_degree == 61
replace ba_midatlantic = 1 if state_ba_degree == 34 | state_ba_degree == 36 | state_ba_degree == 42
replace ba_eastnorthcentral = 1 if  state_ba_degree == 55 | state_ba_degree == 39 | state_ba_degree == 26 | state_ba_degree == 18 | state_ba_degree == 17
replace ba_westnorthcentral = 1 if state_ba_degree == 62 | state_ba_degree == 19 | state_ba_degree == 38 | state_ba_degree == 46 | state_ba_degree == 31| state_ba_degree == 20 | state_ba_degree == 29 | state_ba_degree == 27
replace ba_southatlantic = 1 if state_ba_degree == 10 | state_ba_degree == 11 | state_ba_degree == 24 | state_ba_degree == 54 | state_ba_degree == 51 | state_ba_degree == 37 | state_ba_degree == 45 | state_ba_degree == 12 | state_ba_degree == 13
replace ba_eastsouthcentral = 1 if state_ba_degree == 28 | state_ba_degree == 21 | state_ba_degree == 47 | state_ba_degree == 1
replace ba_westsouthcentral = 1 if state_ba_degree == 5 | state_ba_degree == 22 | state_ba_degree == 40 | state_ba_degree == 48
replace ba_mountain = 1 if state_ba_degree == 4 | state_ba_degree == 8 | state_ba_degree == 16 | state_ba_degree == 30 | state_ba_degree == 32 | state_ba_degree == 35 | state_ba_degree == 49 | state_ba_degree == 56
replace ba_pacific = 1 if state_ba_degree == 2 | state_ba_degree == 15 | state_ba_degree == 6 | state_ba_degree == 41 | state_ba_degree == 53

/* There are a few aggregated state variables for the early years that we can't tell which division they are in (e.g., "Mississippi and West Virginia"); these are small numbers of people */









/* Survey weights */
rename fnlwgt88 survey_weight1988
rename fnlwgt89 survey_weight1989


/* Are you employed? */
/* How should I do this? I have 12 observations per year */
/* For now, what I do (also for occupation and industry and full-time) is take the middle months of the person's year */


/* Are you employed? */
/* How should I do this? I have 12 observations per year */
/* For now, employed will not be a dummy. It will be the proportion of months you are employed at least one week */


gen employed1988 = 0
gen employed1989 = 0


forvalues k=1(1)12 {
replace employed1988 = employed1988 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace employed1989 = employed1989 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace employed1988 = employed1988 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)24 {
replace employed1989 = employed1989 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace employed1988 = employed1988 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)24 {
replace employed1989 = employed1989 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace employed1988 = employed1988 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)24 {
replace employed1989 = employed1989 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 4
}

sum employed*

replace employed1988 = employed1988 / (months_seen1988-months_enrolled1988)
replace employed1989 = employed1989 / (months_seen1989-months_enrolled1989)

sum employed*, d




/* Are you full-time? */

gen fulltime1988 = 0
gen fulltime1989 = 0

forvalues k=1(1)12 {
replace fulltime1988 = fulltime1988 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace fulltime1989 = fulltime1989 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace fulltime1988 = fulltime1988 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)24 {
replace fulltime1989 = fulltime1989 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace fulltime1988 = fulltime1988 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)24 {
replace fulltime1989 = fulltime1989 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace fulltime1988 = fulltime1988 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)24 {
replace fulltime1989 = fulltime1989 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

sum fulltime*

replace fulltime1988 = fulltime1988 / (months_seen1988-months_enrolled1988)
replace fulltime1989 = fulltime1989 / (months_seen1989-months_enrolled1989)

sum employed*, d
sum fulltime*, d







/* OCCUPATION */
/* I use the 6th month occupation as the occupation. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace occ1_0`k' = . if occ1_0`k' == 0 | occ1_0`k' == 905
rename occ1_0`k' ws1_oc`k'
}

forvalues k=10(1)32 {
replace occ1_`k' = . if occ1_`k' == 0 | occ1_`k' == 905
rename occ1_`k' ws1_oc`k'

}

forvalues k=1(1)12 {
gen occ`k'_1988 = .
gen occ`k'_1989 = .
}

forvalues k=1(1)12 {
local j = `k'
replace occ`j'_1988 = ws1_oc`k' if rot == 1
}


forvalues k=13(1)24 {
local j = `k' - 12
replace occ`j'_1989 = ws1_oc`k' if rot == 1
}


forvalues k=4(1)15 {
local j = `k' - 3
replace occ`j'_1988 = ws1_oc`k' if rot == 2
}

forvalues k=16(1)24 {
local j = `k' - 15
replace occ`j'_1989 = ws1_oc`k' if rot == 2
}


forvalues k=3(1)14 {
local j = `k' - 2
replace occ`j'_1988 = ws1_oc`k' if rot == 3
}

forvalues k=15(1)24 {
local j = `k' - 14
replace occ`j'_1989 = ws1_oc`k' if rot == 3
}


forvalues k=2(1)13 {
local j = `k' - 1
replace occ`j'_1988 = ws1_oc`k' if rot == 4
}

forvalues k=14(1)24 {
local j = `k' - 13
replace occ`j'_1989 = ws1_oc`k' if rot == 4
}



/* INDUSTRY */
/* I use the 6th month industry as the industry. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace ind1_0`k' = . if ind1_0`k' == 0 | ind1_0`k' == 991
rename ind1_0`k' ws1_in`k'
}

forvalues k=10(1)32 {
replace ind1_`k' = . if ind1_`k' == 0 | ind1_`k' == 991
rename ind1_`k' ws1_in`k'
}


forvalues k=1(1)12 {
gen ind`k'_1988 = .
gen ind`k'_1989 = .
}

forvalues k=1(1)12 {
local j = `k'
replace ind`j'_1988 = ws1_in`k' if rot == 1
}


forvalues k=13(1)24 {
local j = `k' - 12
replace ind`j'_1989 = ws1_in`k' if rot == 1
}


forvalues k=4(1)15 {
local j = `k' - 3
replace ind`j'_1988 = ws1_in`k' if rot == 2
}

forvalues k=16(1)24 {
local j = `k' - 15
replace ind`j'_1989 = ws1_in`k' if rot == 2
}


forvalues k=3(1)14 {
local j = `k' - 2
replace ind`j'_1988 = ws1_in`k' if rot == 3
}

forvalues k=15(1)24 {
local j = `k' - 14
replace ind`j'_1989 = ws1_in`k' if rot == 3
}


forvalues k=2(1)13 {
local j = `k' - 1
replace ind`j'_1988 = ws1_in`k' if rot == 4
}

forvalues k=14(1)24 {
local j = `k' - 13
replace ind`j'_1989 = ws1_in`k' if rot == 4
}


drop *month*

bysort rot: sum ind* occ*



/* Identifying variables */
keep *1988 *1989 rot pp_id pp_entry pp_pnum state_ba* ba_*

rename pp_id su_id
sort su_id pp_entry pp_pnum
compress
save Temp/sipp88_full_cleaned.dta, replace


*************************************************************************************

clear

use Temp/sipp88wave2.dta


/**** WAVE 2 DATASET ****/



/* Identifiers */
sum su_id pp_entry pp_pnum



/********** COLLEGE DEGREE INFORMATION *********/

/* 2 questions: highest degree and BA degree. Need to check both */

/* Need year of degree, age at degree, and field of degree. Also need highest degree completed */


gen col = 0
gen morcol = 0
gen hgc = .

replace hgc = 12 if tm8422 == 0 | tm8422 == -1 | tm8422 == 7
replace hgc = 14 if tm8422 == 6 | tm8422 == 5
replace hgc = 16 if tm8422 == 4
replace hgc = 18 if tm8422 == 3
replace hgc = 19 if tm8422 == 2
replace hgc = 20 if tm8422 == 1
replace hgc = 10 if tm8408 == 2 // 2 means did not grad HS in 88 SIPP 

tab hgc, mi

replace col = 1 if hgc == 16
replace morcol = 1 if hgc > 16

tab col morcol


gen gradyear = .

replace tm8426 = . if tm8426 <= 0
replace tm8434 = . if tm8434 <= 0

replace gradyear = tm8426 if hgc == 16

replace gradyear = tm8434 if gradyear == .

tab gradyear


gen age_grad = .

replace age_grad = gradyear - brthyr

tab age_grad



/* Field of bachelor's degree */

rename tm8428 major_field
replace major_field = . if major_field == 0

tab major_field, mi





keep hgc major_field age_grad gradyear col morcol su_id pp_entry pp_pnum


sort su_id pp_entry pp_pnum



merge su_id pp_entry pp_pnum using Temp/sipp88_full_cleaned.dta

tab _merge
drop _merge


egen pid=group(su_id pp_entry pp_pnum)
*bysort su_id pp_entry pp_pnum: gen pid = _n

drop su_id pp_entry pp_pnum

drop earnings_job* earnings_se* 

drop year1988 year1989


reshape long total_hours survey_weight age male hispanic black earnings_annual hrlypay hrlypayv1 hrlypayv2 enrolled west northeast midwest south employed fulltime occ1_ occ2_ occ3_ occ4_ occ5_ occ6_ occ7_ occ8_ occ9_ occ10_ occ11_ occ12_ ind1_ ind2_ ind3_ ind4_ ind5_ ind6_ ind7_ ind8_ ind9_ ind10_ ind11_ ind12_, i(pid) j(year)


forvalues k=1(1)12 {
rename occ`k'_ occ`k'
rename ind`k'_ ind`k'
}

* keep if age >= 22

* keep if major_field != .
tab major_field, mi
tab major_field if hgc == 16
tab gradyear
gen potexp = year - gradyear
tab potexp

tab gradyear potexp if hgc == 16 & potexp <= 13

sum

gen panel = 1988
gen survey = 8889

sort pid
compress
save Temp/sipp88_ready.dta, replace


clear






/* 1990 */






use Temp/sipp90_full.dta


/* Age at survey */
gen year1990 = 1990
gen year1991 = 1991

gen age1990 = 1990 - u_brthyr
gen age1991 = 1991 - u_brthyr



/* Gender */
gen male1990 = (sex == 1)
gen male1991 = (sex == 1)


/* Race */
gen hispanic1990 = (ethnicty >= 14 & ethnicty <= 20)
gen hispanic1991 = (ethnicty >= 14 & ethnicty <= 20)

gen black1990 = (race == 2 & hispanic1990 != 1)
gen black1991 = (race == 2 & hispanic1991 != 1)


forvalues k=1(1)9 {
rename enrl_m0`k' enrl_m`k'
rename pp_mis0`k' pp_mis`k'
}

forvalues k=1(1)32 {
replace enrl_m`k' = . if pp_mis`k' != 1
}

gen months_seen1990 = 0
gen months_seen1991 = 0

/* Each wave asks about the past four months */

forvalues k=1(1)12 {
replace months_seen1990 = months_seen1990 + 1 if pp_mis`k' == 1 & rot == 1
}

forvalues k=13(1)24 {
replace months_seen1991 = months_seen1991 + 1 if pp_mis`k' == 1 & rot == 1
}



forvalues k=4(1)15 {
replace months_seen1990 = months_seen1990 + 1 if pp_mis`k' == 1 & rot == 2
}

forvalues k=16(1)27 {
replace months_seen1991 = months_seen1991 + 1 if pp_mis`k' == 1 & rot == 2
}



forvalues k=3(1)14 {
replace months_seen1990 = months_seen1990 + 1 if pp_mis`k' == 1 & rot == 3
}

forvalues k=15(1)26 {
replace months_seen1991 = months_seen1991 + 1 if pp_mis`k' == 1 & rot == 3
}



forvalues k=2(1)13 {
replace months_seen1990 = months_seen1990 + 1 if pp_mis`k' == 1 & rot == 4
}

forvalues k=14(1)25 {
replace months_seen1991 = months_seen1991 + 1 if pp_mis`k' == 1 & rot == 4
}

sum months_seen*


/*
/* The first survey is in Feb 1990, so we don't have obs for many people in 1989 */
replace months_seen1989 = 3 if rot == 2
replace months_seen1989 = 2 if rot == 3
replace months_seen1989 = 1 if rot == 4
replace months_seen1989 = 0 if rot == 1


/* We see everyone through all of 1990 */
replace months_seen1990 = 12 if rot == 2
replace months_seen1990 = 12 if rot == 3
replace months_seen1990 = 12 if rot == 4
replace months_seen1990 = 12 if rot == 1


/* We see everyone through all of 1991 */
replace months_seen1991 = 12 if rot == 2
replace months_seen1991 = 12 if rot == 3
replace months_seen1991 = 12 if rot == 4
replace months_seen1991 = 12 if rot == 1

*/
/* We see some in 1992, but I'm not using that for now */




/* Enrolled? */



/* I will code you as enrolled in the year if you are enrolled at least 2 months of the year */
gen months_enrolled1990 = 0
gen months_enrolled1991 = 0




forvalues k=1(1)12 {
replace months_enrolled1990 = months_enrolled1990 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=13(1)24 {
replace months_enrolled1991 = months_enrolled1991 + 1 if enrl_m`k' == 1 & rot == 1
}



forvalues k=4(1)15 {
replace months_enrolled1990 = months_enrolled1990 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=16(1)27 {
replace months_enrolled1991 = months_enrolled1991 + 1 if enrl_m`k' == 1 & rot == 2
}



forvalues k=3(1)14 {
replace months_enrolled1990 = months_enrolled1990 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=15(1)26 {
replace months_enrolled1991 = months_enrolled1991 + 1 if enrl_m`k' == 1 & rot == 3
}



forvalues k=2(1)13 {
replace months_enrolled1990 = months_enrolled1990 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=14(1)25 {
replace months_enrolled1991 = months_enrolled1991 + 1 if enrl_m`k' == 1 & rot == 4
}

sum months_enrolled*



gen enrolled1990 = months_enrolled1990 / months_seen1990
gen enrolled1991 = months_enrolled1991 / months_seen1991






/**** ANNUAL EARNINGS ****/

/* Earnings are by month. Month #s to actual month mapping differs by rotation group */
forvalues k=1(1)9 {
rename ernam10`k' earnings_job1_month`k' 
rename ernam20`k' earnings_job2_month`k' 
gen earnings_se1_month`k' = 0
gen earnings_se2_month`k' = 0
}

forvalues k=10(1)32 {
rename ernam1`k' earnings_job1_month`k' 
rename ernam2`k' earnings_job2_month`k' 
gen earnings_se1_month`k' = 0
gen earnings_se2_month`k' = 0
}


forvalues k=1(1)32 {
replace earnings_job1_month`k' = 0 if earnings_job1_month`k' < 0 | earnings_job1_month`k' == .
replace earnings_job2_month`k' = 0 if earnings_job2_month`k' < 0 | earnings_job2_month`k' == .
replace earnings_se1_month`k' = 0 if earnings_se1_month`k' < 0 | earnings_se1_month`k' == .
replace earnings_se2_month`k' = 0 if earnings_se2_month`k' < 0 | earnings_se2_month`k' == .
}

forvalues k=1(1)32 {
replace earnings_job1_month`k' = . if pp_mis`k' != 1
replace earnings_job2_month`k' = . if pp_mis`k' != 1
replace earnings_se1_month`k' = . if pp_mis`k' != 1
replace earnings_se2_month`k' = . if pp_mis`k' != 1
}


gen earnings_job1_1990 = 0
gen earnings_job1_1991 = 0
gen earnings_job2_1990 = 0
gen earnings_job2_1991 = 0
gen earnings_se1_1990 = 0
gen earnings_se1_1991 = 0
gen earnings_se2_1990 = 0
gen earnings_se2_1991 = 0

gen earnings_annual1990 = 0
gen earnings_annual1991 = 0


/* Rotation group 1: 1990 is months 1-12, 1991 is months 13-24 */
forvalues k=1(1)12 {
replace earnings_annual1990 = earnings_annual1990 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}

forvalues k=13(1)24 {
replace earnings_annual1991 = earnings_annual1991 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}


replace earnings_annual1990 = (earnings_annual1990/(months_seen1990-months_enrolled1990)) * 12  if rot == 1
replace earnings_annual1991 = (earnings_annual1991/(months_seen1991-months_enrolled1991)) * 12  if rot == 1

replace earnings_annual1990 = 0 if months_enrolled1990 == 12 & rot == 1
replace earnings_annual1991 = 0 if months_enrolled1991 == 12 & rot == 1

sum earnings_annual* if rot == 1






/* Rotation group 2: 1990 is months 4-15, 1991 is months 16-27 */
forvalues k=4(1)15 {
replace earnings_annual1990 = earnings_annual1990 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}

forvalues k=16(1)27 {
replace earnings_annual1991 = earnings_annual1991 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}


replace earnings_annual1990 = (earnings_annual1990/(months_seen1990-months_enrolled1990)) * 12  if rot == 2
replace earnings_annual1991 = (earnings_annual1991/(months_seen1991-months_enrolled1991)) * 12  if rot == 2

replace earnings_annual1990 = 0 if months_enrolled1990 == 12 & rot == 2
replace earnings_annual1991 = 0 if months_enrolled1991 == 12 & rot == 2

sum earnings_annual* if rot == 2








/* Rotation group 3: 1990 is months 3-14, 1991 is months 15-26 */
forvalues k=3(1)14 {
replace earnings_annual1990 = earnings_annual1990 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}

forvalues k=15(1)26 {
replace earnings_annual1991 = earnings_annual1991 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}


replace earnings_annual1990 = (earnings_annual1990/(months_seen1990-months_enrolled1990)) * 12  if rot == 3
replace earnings_annual1991 = (earnings_annual1991/(months_seen1991-months_enrolled1991)) * 12  if rot == 3

replace earnings_annual1990 = 0 if months_enrolled1990 == 12 & rot == 3
replace earnings_annual1991 = 0 if months_enrolled1991 == 12 & rot == 3

sum earnings_annual* if rot == 3






/* Rotation group 4: 1990 is months 2-13, 1991 is months 14-25 */
forvalues k=2(1)13 {
replace earnings_annual1990 = earnings_annual1990 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}

forvalues k=14(1)25 {
replace earnings_annual1991 = earnings_annual1991 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}


replace earnings_annual1990 = (earnings_annual1990/(months_seen1990-months_enrolled1990)) * 12  if rot == 4
replace earnings_annual1991 = (earnings_annual1991/(months_seen1991-months_enrolled1991)) * 12  if rot == 4

replace earnings_annual1990 = 0 if months_enrolled1990 == 12 & rot == 4
replace earnings_annual1991 = 0 if months_enrolled1991 == 12 & rot == 4

sum earnings_annual* if rot == 4

bysort rot: sum earnings_annual1990 if earnings_annual1990 > 300
bysort rot: sum earnings_annual1991 if earnings_annual1991 > 300






/**** WAGES ****/
/* For hourly workers, we actually have an hourly rate of pay variable */
forvalues k=1(1)9 {
rename hrrat10`k' wage_month`k'
}

forvalues k=10(1)32 {
rename hrrat1`k' wage_month`k'
}


forvalues k=1(1)32 {
replace wage_month`k' = . if pp_mis`k' != 1
}


/* Annual wage measure will be the average of the non-missing wage measures in the year (for job 1 only) */

/* Need to get # of non-missing wage measures each year */
gen wage_count1990 = 0
gen wage_count1991 = 0

forvalues k=1(1)12 {
replace wage_count1990 = wage_count1990 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace wage_count1991 = wage_count1991 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace wage_count1990 = wage_count1990 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace wage_count1991 = wage_count1991 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace wage_count1990 = wage_count1990 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace wage_count1991 = wage_count1991 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace wage_count1990 = wage_count1990 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace wage_count1991 = wage_count1991 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}



/* Now, we construct the annual wage measure */
gen hrlypay1990 = .
gen hrlypay1991 = .

gen hrlypayv11990 = .
gen hrlypayv11991 = .

gen hrlypayv21990 = .
gen hrlypayv21991 = .

gen total_wage1990 = 0
gen total_wage1991 = 0


forvalues k=1(1)12 {
replace total_wage1990 = total_wage1990 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace total_wage1991 = total_wage1991 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace total_wage1990 = total_wage1990 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace total_wage1991 = total_wage1991 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace total_wage1990 = total_wage1990 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace total_wage1991 = total_wage1991 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace total_wage1990 = total_wage1990 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace total_wage1991 = total_wage1991 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}


replace hrlypayv11990 = total_wage1990/wage_count1990 
replace hrlypayv11991 = total_wage1991/wage_count1991

sum hrlypay*

drop total_wage* wage_count* wage_month*



/* Alternative if you don't work by the hour: get earnings/hours */
forvalues k=1(1)9 {
replace wshrs10`k' = 0 if wshrs10`k' < 0
rename wshrs10`k' hours_job1_month`k'

replace wshrs20`k' = 0 if wshrs20`k' < 0
rename wshrs20`k' hours_job2_month`k'
}

forvalues k=10(1)32 {
replace wshrs1`k' = 0 if wshrs1`k' < 0
rename wshrs1`k' hours_job1_month`k'
rename wshrs2`k' hours_job2_month`k'

}


forvalues k=1(1)32 {
replace hours_job1_month`k' = . if pp_mis`k' != 1
replace hours_job2_month`k' = . if pp_mis`k' != 1

}


/* Need to get # of non-missing hours measures each year */
gen hours_count1990 = 0
gen hours_count1991 = 0

forvalues k=1(1)12 {
replace hours_count1990 = hours_count1990 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace hours_count1991 = hours_count1991 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace hours_count1990 = hours_count1990 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace hours_count1991 = hours_count1991 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace hours_count1990 = hours_count1990 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace hours_count1991 = hours_count1991 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace hours_count1990 = hours_count1990 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace hours_count1991 = hours_count1991 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}


gen total_hours1990 = 0
gen total_hours1991 = 0


forvalues k=1(1)9 {
rename wksem10`k' ws1_wk`k'
rename wksem20`k' ws2_wk`k'
}

forvalues k=10(1)32 {
rename wksem1`k' ws1_wk`k'
rename wksem2`k' ws2_wk`k'
}

forvalues k=1(1)32 {
replace ws1_wk`k' = . if pp_mis`k' != 1
replace ws2_wk`k' = . if pp_mis`k' != 1

}





forvalues k=1(1)12 {
replace total_hours1990 = total_hours1990 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace total_hours1991 = total_hours1991 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace total_hours1990 = total_hours1990 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace total_hours1991 = total_hours1991 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace total_hours1990 = total_hours1990 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace total_hours1991 = total_hours1991 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace total_hours1990 = total_hours1990 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace total_hours1991 = total_hours1991 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}


replace hrlypayv21990 = earnings_annual1990 / total_hours1990
replace hrlypayv21991 = earnings_annual1991 / total_hours1991

forvalues k=1990(1)1991 {
replace hrlypay`k' = hrlypayv1`k'
replace hrlypay`k' = hrlypayv2`k' if hrlypay`k' == . | hrlypay`k' == 0
}


sum hrlypay*

bysort rot: sum hrlypay1990 if hrlypay1990 > 1






sum age1990 age1991

sum black* hispanic*

sum hrlypay*, d



/* State and region */
/* I take the state from the first wave as the state for 1990 and the fourth wave for 1991 */
rename geo_ste1 state

replace state = geo_ste2 if state == 0 | state == .
replace state = geo_ste3 if state == 0 | state == .


gen west = 0
gen northeast = 0
gen midwest = 0
gen south = 0

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1990 = west
gen northeast1990 = northeast
gen midwest1990 = midwest
gen south1990 = south

rename state state_ba_degree 


/* geo_ste4 is the state from the 4th wave, which is in the second year */
rename geo_ste4 state

replace state = geo_ste5 if state == 0 | state == .
replace state = geo_ste6 if state == 0 | state == .


replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1991 = west
gen northeast1991 = northeast
gen midwest1991 = midwest
gen south1991 = south


drop west south midwest northeast 


/* Division of degree */
gen ba_newengland = 0
gen ba_midatlantic = 0
gen ba_eastnorthcentral = 0
gen ba_westnorthcentral = 0
gen ba_southatlantic = 0
gen ba_eastsouthcentral = 0
gen ba_westsouthcentral = 0
gen ba_mountain = 0
gen ba_pacific = 0


replace ba_newengland = 1 if state_ba_degree == 9 | state_ba_degree == 25 | state_ba_degree == 33  | state_ba_degree == 44 | state_ba_degree == 23 | state_ba_degree == 50 | state_ba_degree == 61
replace ba_midatlantic = 1 if state_ba_degree == 34 | state_ba_degree == 36 | state_ba_degree == 42
replace ba_eastnorthcentral = 1 if  state_ba_degree == 55 | state_ba_degree == 39 | state_ba_degree == 26 | state_ba_degree == 18 | state_ba_degree == 17
replace ba_westnorthcentral = 1 if state_ba_degree == 62 | state_ba_degree == 19 | state_ba_degree == 38 | state_ba_degree == 46 | state_ba_degree == 31| state_ba_degree == 20 | state_ba_degree == 29 | state_ba_degree == 27
replace ba_southatlantic = 1 if state_ba_degree == 10 | state_ba_degree == 11 | state_ba_degree == 24 | state_ba_degree == 54 | state_ba_degree == 51 | state_ba_degree == 37 | state_ba_degree == 45 | state_ba_degree == 12 | state_ba_degree == 13
replace ba_eastsouthcentral = 1 if state_ba_degree == 28 | state_ba_degree == 21 | state_ba_degree == 47 | state_ba_degree == 1
replace ba_westsouthcentral = 1 if state_ba_degree == 5 | state_ba_degree == 22 | state_ba_degree == 40 | state_ba_degree == 48
replace ba_mountain = 1 if state_ba_degree == 4 | state_ba_degree == 8 | state_ba_degree == 16 | state_ba_degree == 30 | state_ba_degree == 32 | state_ba_degree == 35 | state_ba_degree == 49 | state_ba_degree == 56
replace ba_pacific = 1 if state_ba_degree == 2 | state_ba_degree == 15 | state_ba_degree == 6 | state_ba_degree == 41 | state_ba_degree == 53

/* There are a few aggregated state variables for the early years that we can't tell which division they are in (e.g., "Mississippi and West Virginia"); these are small numbers of people */




/* Survey weights */
rename fnlwgt90 survey_weight1990
rename fnlwgt91 survey_weight1991





/* Are you employed? */
/* How should I do this? I have 12 observations per year */
/* For now, what I do (also for occupation and industry and full-time) is take the middle months of the person's year */

gen employed1990 = 0
gen employed1991 = 0


forvalues k=1(1)12 {
replace employed1990 = employed1990 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace employed1991 = employed1991 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace employed1990 = employed1990 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace employed1991 = employed1991 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace employed1990 = employed1990 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace employed1991 = employed1991 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace employed1990 = employed1990 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace employed1991 = employed1991 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 4
}

sum employed*

replace employed1990 = employed1990 / (months_seen1990-months_enrolled1990)
replace employed1991 = employed1991 / (months_seen1991-months_enrolled1991)

sum employed*, d




/* Are you full-time? */

gen fulltime1990 = 0
gen fulltime1991 = 0

forvalues k=1(1)12 {
replace fulltime1990 = fulltime1990 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace fulltime1991 = fulltime1991 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace fulltime1990 = fulltime1990 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace fulltime1991 = fulltime1991 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace fulltime1990 = fulltime1990 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace fulltime1991 = fulltime1991 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace fulltime1990 = fulltime1990 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace fulltime1991 = fulltime1991 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

sum fulltime*

replace fulltime1990 = fulltime1990 / (months_seen1990-months_enrolled1990)
replace fulltime1991 = fulltime1991 / (months_seen1991-months_enrolled1991)

sum employed*, d
sum fulltime*, d



/* OCCUPATION */
/* I use the 6th month occupation as the occupation. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace occ1_0`k' = . if occ1_0`k' == 0 | occ1_0`k' == 905
rename occ1_0`k' ws1_oc`k'
}

forvalues k=10(1)32 {
replace occ1_`k' = . if occ1_`k' == 0 | occ1_`k' == 905
rename occ1_`k' ws1_oc`k'

}


forvalues k=1(1)12 {
gen occ`k'_1990 = .
gen occ`k'_1991 = .
}

forvalues k=1(1)12 {
local j = `k'
replace occ`j'_1990 = ws1_oc`k' if rot == 1
}


forvalues k=13(1)24 {
local j = `k' - 12
replace occ`j'_1991 = ws1_oc`k' if rot == 1
}


forvalues k=4(1)15 {
local j = `k' - 3
replace occ`j'_1990 = ws1_oc`k' if rot == 2
}

forvalues k=16(1)27 {
local j = `k' - 15
replace occ`j'_1991 = ws1_oc`k' if rot == 2
}


forvalues k=3(1)14 {
local j = `k' - 2
replace occ`j'_1990 = ws1_oc`k' if rot == 3
}

forvalues k=15(1)26 {
local j = `k' - 14
replace occ`j'_1991 = ws1_oc`k' if rot == 3
}


forvalues k=2(1)13 {
local j = `k' - 1
replace occ`j'_1990 = ws1_oc`k' if rot == 4
}

forvalues k=14(1)25 {
local j = `k' - 13
replace occ`j'_1991 = ws1_oc`k' if rot == 4
}


/* INDUSTRY */
/* I use the 6th month industry as the industry. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace ind1_0`k' = . if ind1_0`k' == 0 | ind1_0`k' == 991
rename ind1_0`k' ws1_in`k'
}

forvalues k=10(1)32 {
replace ind1_`k' = . if ind1_`k' == 0 | ind1_`k' == 991
rename ind1_`k' ws1_in`k'
}


forvalues k=1(1)12 {
gen ind`k'_1990 = .
gen ind`k'_1991 = .
}

forvalues k=1(1)12 {
local j = `k'
replace ind`j'_1990 = ws1_in`k' if rot == 1
}


forvalues k=13(1)24 {
local j = `k' - 12
replace ind`j'_1991 = ws1_in`k' if rot == 1
}


forvalues k=4(1)15 {
local j = `k' - 3
replace ind`j'_1990 = ws1_in`k' if rot == 2
}

forvalues k=16(1)27 {
local j = `k' - 15
replace ind`j'_1991 = ws1_in`k' if rot == 2
}


forvalues k=3(1)14 {
local j = `k' - 2
replace ind`j'_1990 = ws1_in`k' if rot == 3
}

forvalues k=15(1)26 {
local j = `k' - 14
replace ind`j'_1991 = ws1_in`k' if rot == 3
}


forvalues k=2(1)13 {
local j = `k' - 1
replace ind`j'_1990 = ws1_in`k' if rot == 4
}

forvalues k=14(1)25 {
local j = `k' - 13
replace ind`j'_1991 = ws1_in`k' if rot == 4
}


drop *month*

bysort rot: sum ind* occ*



/* Identifying variables */
keep *1990 *1991 rot pp_id pp_entry pp_pnum u_brthyr state_ba* ba_*

rename pp_id su_id
sort su_id pp_entry pp_pnum
compress
save Temp/sipp90_full_cleaned.dta, replace


*************************************************************************************8

clear

use Temp/sipp90wave2.dta


/**** WAVE 2 DATASET ****/



/* Identifiers */
rename id su_id
rename entry pp_entry 
rename pnum pp_pnum 

sum su_id pp_entry pp_pnum



/********** COLLEGE DEGREE INFORMATION *********/

/* 2 questions: highest degree and BA degree. Need to check both */

/* Need year of degree, age at degree, and field of degree. Also need highest degree completed */


gen col = 0
gen morcol = 0
gen hgc = .

replace hgc = 12 if tm8422 == 0 | tm8422 == -1 | tm8422 == 7
replace hgc = 14 if tm8422 == 6 | tm8422 == 5
replace hgc = 16 if tm8422 == 4
replace hgc = 18 if tm8422 == 3
replace hgc = 19 if tm8422 == 2
replace hgc = 20 if tm8422 == 1
replace hgc = 10 if tm8408 == 2 // 2 means did not grad HS in 90 SIPP 

tab hgc, mi

replace col = 1 if hgc == 16
replace morcol = 1 if hgc > 16

tab col morcol


gen gradyear = .

replace tm8426 = . if tm8426 <= 0
replace tm8434 = . if tm8434 <= 0

replace gradyear = tm8426 if hgc == 16

replace gradyear = tm8434 if gradyear == .

tab gradyear


/* Field of bachelor's degree */

rename tm8428 major_field
replace major_field = . if major_field == 0

tab major_field, mi





keep hgc major_field gradyear col morcol su_id pp_entry pp_pnum


sort su_id pp_entry pp_pnum



merge su_id pp_entry pp_pnum using Temp/sipp90_full_cleaned.dta

tab _merge
drop _merge


gen age_grad = .

replace age_grad = gradyear - u_brthyr

tab age_grad


egen pid=group(su_id pp_entry pp_pnum)
*bysort su_id pp_entry pp_pnum: gen pid = _n

drop su_id pp_entry pp_pnum

drop earnings_job* earnings_se* 

drop year1990 year1991


reshape long total_hours survey_weight age male hispanic black earnings_annual hrlypay hrlypayv1 hrlypayv2 enrolled west northeast midwest south employed fulltime occ1_ occ2_ occ3_ occ4_ occ5_ occ6_ occ7_ occ8_ occ9_ occ10_ occ11_ occ12_ ind1_ ind2_ ind3_ ind4_ ind5_ ind6_ ind7_ ind8_ ind9_ ind10_ ind11_ ind12_, i(pid) j(year)

forvalues k=1(1)12 {
rename occ`k'_ occ`k'
rename ind`k'_ ind`k'
}

* keep if age >= 22

* keep if major_field != .
tab major_field, mi
tab major_field if hgc == 16
tab gradyear
gen potexp = year - gradyear
tab potexp

tab gradyear potexp if hgc == 16 & potexp <= 13

sum

gen panel = 1990
gen survey = 9091

sort pid
compress
save Temp/sipp90_ready.dta, replace


clear





/* 1991 */





use Temp/sipp91_full.dta


/* Age at survey */
gen year1991 = 1991
gen year1992 = 1992

gen age1991 = 1991 - u_brthyr
gen age1992 = 1992 - u_brthyr



/* Gender */
gen male1991 = (sex == 1)
gen male1992 = (sex == 1)


/* Race */
gen hispanic1991 = (ethnicty >= 14 & ethnicty <= 20)
gen hispanic1992 = (ethnicty >= 14 & ethnicty <= 20)

gen black1991 = (race == 2 & hispanic1991 != 1)
gen black1992 = (race == 2 & hispanic1992 != 1)


forvalues k=1(1)9 {
rename enrl_m0`k' enrl_m`k'
rename pp_mis0`k' pp_mis`k'
}

forvalues k=1(1)32 {
replace enrl_m`k' = . if pp_mis`k' != 1
}






gen months_seen1991 = 0
gen months_seen1992 = 0

/* Each wave asks about the past four months */

forvalues k=1(1)12 {
replace months_seen1991 = months_seen1991 + 1 if pp_mis`k' == 1 & rot == 1
}

forvalues k=13(1)24 {
replace months_seen1992 = months_seen1992 + 1 if pp_mis`k' == 1 & rot == 1
}



forvalues k=4(1)15 {
replace months_seen1991 = months_seen1991 + 1 if pp_mis`k' == 1 & rot == 2
}

forvalues k=16(1)27 {
replace months_seen1992 = months_seen1992 + 1 if pp_mis`k' == 1 & rot == 2
}



forvalues k=3(1)14 {
replace months_seen1991 = months_seen1991 + 1 if pp_mis`k' == 1 & rot == 3
}

forvalues k=15(1)26 {
replace months_seen1992 = months_seen1992 + 1 if pp_mis`k' == 1 & rot == 3
}



forvalues k=2(1)13 {
replace months_seen1991 = months_seen1991 + 1 if pp_mis`k' == 1 & rot == 4
}

forvalues k=14(1)25 {
replace months_seen1992 = months_seen1992 + 1 if pp_mis`k' == 1 & rot == 4
}

sum months_seen*

/*
/* The first survey is in Feb 1991, so we don't have obs for many people in 1990 */
replace months_seen1990 = 3 if rot == 2
replace months_seen1990 = 2 if rot == 3
replace months_seen1990 = 1 if rot == 4
replace months_seen1990 = 0 if rot == 1


/* We see everyone through all of 1991 */
replace months_seen1991 = 12 if rot == 2
replace months_seen1991 = 12 if rot == 3
replace months_seen1991 = 12 if rot == 4
replace months_seen1991 = 12 if rot == 1


/* We see everyone through all of 1992 */
replace months_seen1992 = 12 if rot == 2
replace months_seen1992 = 12 if rot == 3
replace months_seen1992 = 12 if rot == 4
replace months_seen1992 = 12 if rot == 1
*/

/* We see some in 1992, but I'm not using that for now */




/* Enrolled? */


/* I will code you as enrolled in the year if you are enrolled at least 2 months of the year */
gen months_enrolled1991 = 0
gen months_enrolled1992 = 0




forvalues k=1(1)12 {
replace months_enrolled1991 = months_enrolled1991 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=13(1)24 {
replace months_enrolled1992 = months_enrolled1992 + 1 if enrl_m`k' == 1 & rot == 1
}



forvalues k=4(1)15 {
replace months_enrolled1991 = months_enrolled1991 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=16(1)27 {
replace months_enrolled1992 = months_enrolled1992 + 1 if enrl_m`k' == 1 & rot == 2
}



forvalues k=3(1)14 {
replace months_enrolled1991 = months_enrolled1991 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=15(1)26 {
replace months_enrolled1992 = months_enrolled1992 + 1 if enrl_m`k' == 1 & rot == 3
}



forvalues k=2(1)13 {
replace months_enrolled1991 = months_enrolled1991 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=14(1)25 {
replace months_enrolled1992 = months_enrolled1992 + 1 if enrl_m`k' == 1 & rot == 4
}

sum months_enrolled*



gen enrolled1991 = months_enrolled1991 / months_seen1991
gen enrolled1992 = months_enrolled1992 / months_seen1992






/**** ANNUAL EARNINGS ****/

/* Earnings are by month. Month #s to actual month mapping differs by rotation group */
forvalues k=1(1)9 {
rename ernam10`k' earnings_job1_month`k' 
rename ernam20`k' earnings_job2_month`k' 
gen earnings_se1_month`k' = 0
gen earnings_se2_month`k' = 0
}

forvalues k=10(1)32 {
rename ernam1`k' earnings_job1_month`k' 
rename ernam2`k' earnings_job2_month`k' 
gen earnings_se1_month`k' = 0
gen earnings_se2_month`k' = 0
}


forvalues k=1(1)32 {
replace earnings_job1_month`k' = 0 if earnings_job1_month`k' < 0 | earnings_job1_month`k' == .
replace earnings_job2_month`k' = 0 if earnings_job2_month`k' < 0 | earnings_job2_month`k' == .
replace earnings_se1_month`k' = 0 if earnings_se1_month`k' < 0 | earnings_se1_month`k' == .
replace earnings_se2_month`k' = 0 if earnings_se2_month`k' < 0 | earnings_se2_month`k' == .
}

forvalues k=1(1)32 {
replace earnings_job1_month`k' = . if pp_mis`k' != 1
replace earnings_job2_month`k' = . if pp_mis`k' != 1
replace earnings_se1_month`k' = . if pp_mis`k' != 1
replace earnings_se2_month`k' = . if pp_mis`k' != 1
}


gen earnings_job1_1991 = 0
gen earnings_job1_1992 = 0
gen earnings_job2_1991 = 0
gen earnings_job2_1992 = 0
gen earnings_se1_1991 = 0
gen earnings_se1_1992 = 0
gen earnings_se2_1991 = 0
gen earnings_se2_1992 = 0

gen earnings_annual1991 = 0
gen earnings_annual1992 = 0


/* Rotation group 1: 1991 is months 1-12, 1992 is months 13-24 */
forvalues k=1(1)12 {
replace earnings_annual1991 = earnings_annual1991 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}

forvalues k=13(1)24 {
replace earnings_annual1992 = earnings_annual1992 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}


replace earnings_annual1991 = (earnings_annual1991/(months_seen1991-months_enrolled1991)) * 12  if rot == 1
replace earnings_annual1992 = (earnings_annual1992/(months_seen1992-months_enrolled1992)) * 12  if rot == 1

replace earnings_annual1991 = 0 if months_enrolled1991 == 12 & rot == 1
replace earnings_annual1992 = 0 if months_enrolled1992 == 12 & rot == 1

sum earnings_annual* if rot == 1






/* Rotation group 2: 1991 is months 4-15, 1992 is months 16-27 */
forvalues k=4(1)15 {
replace earnings_annual1991 = earnings_annual1991 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}

forvalues k=16(1)27 {
replace earnings_annual1992 = earnings_annual1992 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}


replace earnings_annual1991 = (earnings_annual1991/(months_seen1991-months_enrolled1991)) * 12  if rot == 2
replace earnings_annual1992 = (earnings_annual1992/(months_seen1992-months_enrolled1992)) * 12  if rot == 2

replace earnings_annual1991 = 0 if months_enrolled1991 == 12 & rot == 2
replace earnings_annual1992 = 0 if months_enrolled1992 == 12 & rot == 2

sum earnings_annual* if rot == 2








/* Rotation group 3: 1991 is months 3-14, 1992 is months 15-26 */
forvalues k=3(1)14 {
replace earnings_annual1991 = earnings_annual1991 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}

forvalues k=15(1)26 {
replace earnings_annual1992 = earnings_annual1992 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}


replace earnings_annual1991 = (earnings_annual1991/(months_seen1991-months_enrolled1991)) * 12  if rot == 3
replace earnings_annual1992 = (earnings_annual1992/(months_seen1992-months_enrolled1992)) * 12  if rot == 3

replace earnings_annual1991 = 0 if months_enrolled1991 == 12 & rot == 3
replace earnings_annual1992 = 0 if months_enrolled1992 == 12 & rot == 3

sum earnings_annual* if rot == 3






/* Rotation group 4: 1991 is months 2-13, 1992 is months 14-25 */
forvalues k=2(1)13 {
replace earnings_annual1991 = earnings_annual1991 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}

forvalues k=14(1)25 {
replace earnings_annual1992 = earnings_annual1992 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}


replace earnings_annual1991 = (earnings_annual1991/(months_seen1991-months_enrolled1991)) * 12  if rot == 4
replace earnings_annual1992 = (earnings_annual1992/(months_seen1992-months_enrolled1992)) * 12  if rot == 4

replace earnings_annual1991 = 0 if months_enrolled1991 == 12 & rot == 4
replace earnings_annual1992 = 0 if months_enrolled1992 == 12 & rot == 4

sum earnings_annual* if rot == 4

bysort rot: sum earnings_annual1991 if earnings_annual1991 > 300
bysort rot: sum earnings_annual1992 if earnings_annual1992 > 300






/**** WAGES ****/
/* For hourly workers, we actually have an hourly rate of pay variable */
forvalues k=1(1)9 {
rename hrrat10`k' wage_month`k'
}

forvalues k=10(1)32 {
rename hrrat1`k' wage_month`k'
}

forvalues k=1(1)32 {
replace wage_month`k' = . if pp_mis`k' != 1
}


/* Annual wage measure will be the average of the non-missing wage measures in the year (for job 1 only) */

/* Need to get # of non-missing wage measures each year */
gen wage_count1991 = 0
gen wage_count1992 = 0

forvalues k=1(1)12 {
replace wage_count1991 = wage_count1991 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace wage_count1992 = wage_count1992 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace wage_count1991 = wage_count1991 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace wage_count1992 = wage_count1992 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace wage_count1991 = wage_count1991 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace wage_count1992 = wage_count1992 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace wage_count1991 = wage_count1991 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace wage_count1992 = wage_count1992 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}



/* Now, we construct the annual wage measure */
gen hrlypay1991 = .
gen hrlypay1992 = .

gen hrlypayv11991 = .
gen hrlypayv11992 = .

gen hrlypayv21991 = .
gen hrlypayv21992 = .

gen total_wage1991 = 0
gen total_wage1992 = 0


forvalues k=1(1)12 {
replace total_wage1991 = total_wage1991 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace total_wage1992 = total_wage1992 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace total_wage1991 = total_wage1991 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace total_wage1992 = total_wage1992 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace total_wage1991 = total_wage1991 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace total_wage1992 = total_wage1992 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace total_wage1991 = total_wage1991 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace total_wage1992 = total_wage1992 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}


replace hrlypayv11991 = total_wage1991/wage_count1991 
replace hrlypayv11992 = total_wage1992/wage_count1992

sum hrlypay*

drop total_wage* wage_count* wage_month*



/* Alternative if you don't work by the hour: get earnings/hours */
forvalues k=1(1)9 {
replace wshrs10`k' = 0 if wshrs10`k' < 0
rename wshrs10`k' hours_job1_month`k'

replace wshrs20`k' = 0 if wshrs20`k' < 0
rename wshrs20`k' hours_job2_month`k'
}

forvalues k=10(1)32 {
replace wshrs1`k' = 0 if wshrs1`k' < 0
rename wshrs1`k' hours_job1_month`k'
rename wshrs2`k' hours_job2_month`k'
}

forvalues k=1(1)32 {
replace hours_job1_month`k' = . if pp_mis`k' != 1
replace hours_job2_month`k' = . if pp_mis`k' != 1

}


/* Need to get # of non-missing hours measures each year */
gen hours_count1991 = 0
gen hours_count1992 = 0

forvalues k=1(1)12 {
replace hours_count1991 = hours_count1991 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace hours_count1992 = hours_count1992 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace hours_count1991 = hours_count1991 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace hours_count1992 = hours_count1992 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace hours_count1991 = hours_count1991 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace hours_count1992 = hours_count1992 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace hours_count1991 = hours_count1991 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace hours_count1992 = hours_count1992 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}


gen total_hours1991 = 0
gen total_hours1992 = 0


forvalues k=1(1)9 {
rename wksem10`k' ws1_wk`k'
rename wksem20`k' ws2_wk`k'
}

forvalues k=10(1)32 {
rename wksem1`k' ws1_wk`k'
rename wksem2`k' ws2_wk`k'
}


forvalues k=1(1)32 {
replace ws1_wk`k' = . if pp_mis`k' != 1
replace ws2_wk`k' = . if pp_mis`k' != 1

}



forvalues k=1(1)12 {
replace total_hours1991 = total_hours1991 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace total_hours1992 = total_hours1992 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace total_hours1991 = total_hours1991 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace total_hours1992 = total_hours1992 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace total_hours1991 = total_hours1991 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace total_hours1992 = total_hours1992 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace total_hours1991 = total_hours1991 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace total_hours1992 = total_hours1992 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}


replace hrlypayv21991 = earnings_annual1991 / total_hours1991 if hrlypay1991 == 0 | hrlypay1991 == .
replace hrlypayv21992 = earnings_annual1992 / total_hours1992 if hrlypay1992 == 0 | hrlypay1992 == .

forvalues k=1991(1)1992 {
replace hrlypay`k' = hrlypayv1`k'
replace hrlypay`k' = hrlypayv2`k' if hrlypay`k' == . | hrlypay`k' == 0
}

sum hrlypay*

bysort rot: sum hrlypay1991 if hrlypay1991 > 1






sum age1991 age1992

sum black* hispanic*

sum hrlypay*, d



/* State and region */
/* I take the state from the first wave as the state for 1991 and the fourth wave for 1992 */
rename geo_ste1 state

replace state = geo_ste2 if state == 0 | state == .
replace state = geo_ste3 if state == 0 | state == .


gen west = 0
gen northeast = 0
gen midwest = 0
gen south = 0

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1991 = west
gen northeast1991 = northeast
gen midwest1991 = midwest
gen south1991 = south

rename state state_ba_degree 


/* geo_ste4 is the state from the 4th wave, which is in the second year */
rename geo_ste4 state

replace state = geo_ste5 if state == 0 | state == .
replace state = geo_ste6 if state == 0 | state == .

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1992 = west
gen northeast1992 = northeast
gen midwest1992 = midwest
gen south1992 = south


drop west south midwest northeast 



/* Division of degree */
gen ba_newengland = 0
gen ba_midatlantic = 0
gen ba_eastnorthcentral = 0
gen ba_westnorthcentral = 0
gen ba_southatlantic = 0
gen ba_eastsouthcentral = 0
gen ba_westsouthcentral = 0
gen ba_mountain = 0
gen ba_pacific = 0


replace ba_newengland = 1 if state_ba_degree == 9 | state_ba_degree == 25 | state_ba_degree == 33  | state_ba_degree == 44 | state_ba_degree == 23 | state_ba_degree == 50 | state_ba_degree == 61
replace ba_midatlantic = 1 if state_ba_degree == 34 | state_ba_degree == 36 | state_ba_degree == 42
replace ba_eastnorthcentral = 1 if  state_ba_degree == 55 | state_ba_degree == 39 | state_ba_degree == 26 | state_ba_degree == 18 | state_ba_degree == 17
replace ba_westnorthcentral = 1 if state_ba_degree == 62 | state_ba_degree == 19 | state_ba_degree == 38 | state_ba_degree == 46 | state_ba_degree == 31| state_ba_degree == 20 | state_ba_degree == 29 | state_ba_degree == 27
replace ba_southatlantic = 1 if state_ba_degree == 10 | state_ba_degree == 11 | state_ba_degree == 24 | state_ba_degree == 54 | state_ba_degree == 51 | state_ba_degree == 37 | state_ba_degree == 45 | state_ba_degree == 12 | state_ba_degree == 13
replace ba_eastsouthcentral = 1 if state_ba_degree == 28 | state_ba_degree == 21 | state_ba_degree == 47 | state_ba_degree == 1
replace ba_westsouthcentral = 1 if state_ba_degree == 5 | state_ba_degree == 22 | state_ba_degree == 40 | state_ba_degree == 48
replace ba_mountain = 1 if state_ba_degree == 4 | state_ba_degree == 8 | state_ba_degree == 16 | state_ba_degree == 30 | state_ba_degree == 32 | state_ba_degree == 35 | state_ba_degree == 49 | state_ba_degree == 56
replace ba_pacific = 1 if state_ba_degree == 2 | state_ba_degree == 15 | state_ba_degree == 6 | state_ba_degree == 41 | state_ba_degree == 53

/* There are a few aggregated state variables for the early years that we can't tell which division they are in (e.g., "Mississippi and West Virginia"); these are small numbers of people */






/* Survey weights */
rename fnlwgt91 survey_weight1991
rename fnlwgt92 survey_weight1992





/* Are you employed? */
/* How should I do this? I have 12 observations per year */
/* For now, what I do (also for occupation and industry and full-time) is take the middle months of the person's year */

gen employed1991 = 0
gen employed1992 = 0


forvalues k=1(1)12 {
replace employed1991 = employed1991 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace employed1992 = employed1992 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace employed1991 = employed1991 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace employed1992 = employed1992 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace employed1991 = employed1991 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace employed1992 = employed1992 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace employed1991 = employed1991 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace employed1992 = employed1992 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 4
}

sum employed*

replace employed1991 = employed1991 / (months_seen1991-months_enrolled1991)
replace employed1992 = employed1992 / (months_seen1992-months_enrolled1992)

sum employed*, d




/* Are you full-time? */

gen fulltime1991 = 0
gen fulltime1992 = 0

forvalues k=1(1)12 {
replace fulltime1991 = fulltime1991 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace fulltime1992 = fulltime1992 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace fulltime1991 = fulltime1991 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace fulltime1992 = fulltime1992 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace fulltime1991 = fulltime1991 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace fulltime1992 = fulltime1992 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace fulltime1991 = fulltime1991 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace fulltime1992 = fulltime1992 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

sum fulltime*

replace fulltime1991 = fulltime1991 / (months_seen1991-months_enrolled1991)
replace fulltime1992 = fulltime1992 / (months_seen1992-months_enrolled1992)

sum employed*, d
sum fulltime*, d



/* OCCUPATION */
/* I use the 6th month occupation as the occupation. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace occ1_0`k' = . if occ1_0`k' == 0 | occ1_0`k' == 905
rename occ1_0`k' ws1_oc`k'
}

forvalues k=10(1)32 {
replace occ1_`k' = . if occ1_`k' == 0 | occ1_`k' == 905
rename occ1_`k' ws1_oc`k'

}


forvalues k=1(1)12 {
gen occ`k'_1991 = .
gen occ`k'_1992 = .
}

forvalues k=1(1)12 {
local j = `k'
replace occ`j'_1991 = ws1_oc`k' if rot == 1
}


forvalues k=13(1)24 {
local j = `k' - 12
replace occ`j'_1992 = ws1_oc`k' if rot == 1
}


forvalues k=4(1)15 {
local j = `k' - 3
replace occ`j'_1991 = ws1_oc`k' if rot == 2
}

forvalues k=16(1)27 {
local j = `k' - 15
replace occ`j'_1992 = ws1_oc`k' if rot == 2
}


forvalues k=3(1)14 {
local j = `k' - 2
replace occ`j'_1991 = ws1_oc`k' if rot == 3
}

forvalues k=15(1)26 {
local j = `k' - 14
replace occ`j'_1992 = ws1_oc`k' if rot == 3
}


forvalues k=2(1)13 {
local j = `k' - 1
replace occ`j'_1991 = ws1_oc`k' if rot == 4
}

forvalues k=14(1)25 {
local j = `k' - 13
replace occ`j'_1992 = ws1_oc`k' if rot == 4
}


/* INDUSTRY */
/* I use the 6th month industry as the industry. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace ind1_0`k' = . if ind1_0`k' == 0 | ind1_0`k' == 991
rename ind1_0`k' ws1_in`k'
}

forvalues k=10(1)32 {
replace ind1_`k' = . if ind1_`k' == 0 | ind1_`k' == 991
rename ind1_`k' ws1_in`k'
}


forvalues k=1(1)12 {
gen ind`k'_1991 = .
gen ind`k'_1992 = .
}

forvalues k=1(1)12 {
local j = `k'
replace ind`j'_1991 = ws1_in`k' if rot == 1
}


forvalues k=13(1)24 {
local j = `k' - 12
replace ind`j'_1992 = ws1_in`k' if rot == 1
}


forvalues k=4(1)15 {
local j = `k' - 3
replace ind`j'_1991 = ws1_in`k' if rot == 2
}

forvalues k=16(1)27 {
local j = `k' - 15
replace ind`j'_1992 = ws1_in`k' if rot == 2
}


forvalues k=3(1)14 {
local j = `k' - 2
replace ind`j'_1991 = ws1_in`k' if rot == 3
}

forvalues k=15(1)26 {
local j = `k' - 14
replace ind`j'_1992 = ws1_in`k' if rot == 3
}


forvalues k=2(1)13 {
local j = `k' - 1
replace ind`j'_1991 = ws1_in`k' if rot == 4
}

forvalues k=14(1)25 {
local j = `k' - 13
replace ind`j'_1992 = ws1_in`k' if rot == 4
}


drop *month*

bysort rot: sum ind* occ*



/* Identifying variables */
keep *1991 *1992 rot pp_id pp_entry pp_pnum u_brthyr state_ba* ba_*

rename pp_id su_id
sort su_id pp_entry pp_pnum
compress
save Temp/sipp91_full_cleaned.dta, replace


*************************************************************************************8

clear

use Temp/sipp91wave2.dta


/**** WAVE 2 DATASET ****/



/* Identifiers */
rename id su_id
rename entry pp_entry 
rename pnum pp_pnum 

sum su_id pp_entry pp_pnum



/********** COLLEGE DEGREE INFORMATION *********/

/* 2 questions: highest degree and BA degree. Need to check both */

/* Need year of degree, age at degree, and field of degree. Also need highest degree completed */


gen col = 0
gen morcol = 0
gen hgc = .

replace hgc = 12 if tm8422 == 0 | tm8422 == -1 | tm8422 == 7
replace hgc = 14 if tm8422 == 6 | tm8422 == 5
replace hgc = 16 if tm8422 == 4
replace hgc = 18 if tm8422 == 3
replace hgc = 19 if tm8422 == 2
replace hgc = 20 if tm8422 == 1
replace hgc = 10 if tm8408 == 2 // 2 means did not grad HS in 91 SIPP 

tab hgc, mi

replace col = 1 if hgc == 16
replace morcol = 1 if hgc > 16

tab col morcol


gen gradyear = .

replace tm8426 = . if tm8426 <= 0
replace tm8434 = . if tm8434 <= 0

replace gradyear = tm8426 if hgc == 16

replace gradyear = tm8434 if gradyear == .

tab gradyear


/* Field of bachelor's degree */

rename tm8428 major_field
replace major_field = . if major_field == 0

tab major_field, mi





keep hgc major_field gradyear col morcol su_id pp_entry pp_pnum


sort su_id pp_entry pp_pnum



merge su_id pp_entry pp_pnum using Temp/sipp91_full_cleaned.dta

tab _merge
drop _merge


gen age_grad = .

replace age_grad = gradyear - u_brthyr

tab age_grad


egen pid=group(su_id pp_entry pp_pnum)
*bysort su_id pp_entry pp_pnum: gen pid = _n

drop su_id pp_entry pp_pnum

drop earnings_job* earnings_se* 

drop year1991 year1992


reshape long total_hours survey_weight age male hispanic black earnings_annual hrlypay hrlypayv1 hrlypayv2 enrolled west northeast midwest south employed fulltime occ1_ occ2_ occ3_ occ4_ occ5_ occ6_ occ7_ occ8_ occ9_ occ10_ occ11_ occ12_ ind1_ ind2_ ind3_ ind4_ ind5_ ind6_ ind7_ ind8_ ind9_ ind10_ ind11_ ind12_, i(pid) j(year)


forvalues k=1(1)12 {
rename occ`k'_ occ`k'
rename ind`k'_ ind`k'
}

* keep if age >= 22

* keep if major_field != .
tab major_field, mi
tab major_field if hgc == 16
tab gradyear
gen potexp = year - gradyear
tab potexp

tab gradyear potexp if hgc == 16 & potexp <= 13

sum

gen panel = 1991
gen survey = 9091

sort pid
compress
save Temp/sipp91_ready.dta, replace


clear







/* 1992 */



set maxvar 8000

use Temp/sipp92_full.dta


/* Age at survey */
gen year1992 = 1992
gen year1993 = 1993
gen year1994 = 1994

gen age1992 = 1992 - u_brthyr
gen age1993 = 1993 - u_brthyr
gen age1994 = 1994 - u_brthyr



/* Gender */
gen male1992 = (sex == 1)
gen male1993 = (sex == 1)
gen male1994 = (sex == 1)


/* Race */
gen hispanic1992 = (ethnicty >= 14 & ethnicty <= 20)
gen hispanic1993 = (ethnicty >= 14 & ethnicty <= 20)
gen hispanic1994 = (ethnicty >= 14 & ethnicty <= 20)

gen black1992 = (race == 2 & hispanic1992 != 1)
gen black1993 = (race == 2 & hispanic1993 != 1)
gen black1994 = (race == 2 & hispanic1993 != 1)


forvalues k=1(1)9 {
rename enrl_m0`k' enrl_m`k'
rename pp_mis0`k' pp_mis`k'
}

forvalues k=1(1)40 {
replace enrl_m`k' = . if pp_mis`k' != 1
}



gen months_seen1992 = 0
gen months_seen1993 = 0
gen months_seen1994 = 0


/* Each wave asks about the past four months */

forvalues k=1(1)12 {
replace months_seen1992 = months_seen1992 + 1 if pp_mis`k' == 1 & rot == 1
}

forvalues k=13(1)24 {
replace months_seen1993 = months_seen1993 + 1 if pp_mis`k' == 1 & rot == 1
}

forvalues k=25(1)36 {
replace months_seen1994 = months_seen1994 + 1 if pp_mis`k' == 1 & rot == 1
}



forvalues k=4(1)15 {
replace months_seen1992 = months_seen1992 + 1 if pp_mis`k' == 1 & rot == 2
}

forvalues k=16(1)27 {
replace months_seen1993 = months_seen1993 + 1 if pp_mis`k' == 1 & rot == 2
}

forvalues k=28(1)39 {
replace months_seen1994 = months_seen1994 + 1 if pp_mis`k' == 1 & rot == 2
}


forvalues k=3(1)14 {
replace months_seen1992 = months_seen1992 + 1 if pp_mis`k' == 1 & rot == 3
}

forvalues k=15(1)26 {
replace months_seen1993 = months_seen1993 + 1 if pp_mis`k' == 1 & rot == 3
}

forvalues k=27(1)38 {
replace months_seen1994 = months_seen1994 + 1 if pp_mis`k' == 1 & rot == 3
}



forvalues k=2(1)13 {
replace months_seen1992 = months_seen1992 + 1 if pp_mis`k' == 1 & rot == 4
}

forvalues k=14(1)25 {
replace months_seen1993 = months_seen1993 + 1 if pp_mis`k' == 1 & rot == 4
}

forvalues k=26(1)37 {
replace months_seen1994 = months_seen1994 + 1 if pp_mis`k' == 1 & rot == 4
}




/*
/* The first survey is in Feb 1992, so we don't have obs for many people in 1991 */
replace months_seen1991 = 3 if rot == 2
replace months_seen1991 = 2 if rot == 3
replace months_seen1991 = 1 if rot == 4
replace months_seen1991 = 0 if rot == 1


/* We see everyone through all of 1992 */
replace months_seen1992 = 12 if rot == 2
replace months_seen1992 = 12 if rot == 3
replace months_seen1992 = 12 if rot == 4
replace months_seen1992 = 12 if rot == 1


/* We see everyone through all of 1993 */
replace months_seen1993 = 12 if rot == 2
replace months_seen1993 = 12 if rot == 3
replace months_seen1993 = 12 if rot == 4
replace months_seen1993 = 12 if rot == 1


/* We see everyone through all of 1994 */
replace months_seen1994 = 12 if rot == 2
replace months_seen1994 = 12 if rot == 3
replace months_seen1994 = 12 if rot == 4
replace months_seen1994 = 12 if rot == 1
*/





/* Enrolled? */

/* I will code you as enrolled in the year if you are enrolled at least 2 months of the year */
gen months_enrolled1992 = 0
gen months_enrolled1993 = 0
gen months_enrolled1994 = 0




forvalues k=1(1)12 {
replace months_enrolled1992 = months_enrolled1992 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=13(1)24 {
replace months_enrolled1993 = months_enrolled1993 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=25(1)36 {
replace months_enrolled1994 = months_enrolled1994 + 1 if enrl_m`k' == 1 & rot == 1
}



forvalues k=4(1)15 {
replace months_enrolled1992 = months_enrolled1992 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=16(1)27 {
replace months_enrolled1993 = months_enrolled1993 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=28(1)39 {
replace months_enrolled1994 = months_enrolled1994 + 1 if enrl_m`k' == 1 & rot == 2
}


forvalues k=3(1)14 {
replace months_enrolled1992 = months_enrolled1992 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=15(1)26 {
replace months_enrolled1993 = months_enrolled1993 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=27(1)38 {
replace months_enrolled1994 = months_enrolled1994 + 1 if enrl_m`k' == 1 & rot == 3
}



forvalues k=2(1)13 {
replace months_enrolled1992 = months_enrolled1992 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=14(1)25 {
replace months_enrolled1993 = months_enrolled1993 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=26(1)37 {
replace months_enrolled1994 = months_enrolled1994 + 1 if enrl_m`k' == 1 & rot == 4
}

sum months_enrolled*
sum months_seen*


gen enrolled1992 = months_enrolled1992 / months_seen1992
gen enrolled1993 = months_enrolled1993 / months_seen1993
gen enrolled1994 = months_enrolled1994 / months_seen1994

sum enrolled*





/**** ANNUAL EARNINGS ****/

/* Earnings are by month. Month #s to actual month mapping differs by rotation group */
forvalues k=1(1)9 {
rename ernam10`k' earnings_job1_month`k' 
rename ernam20`k' earnings_job2_month`k' 
gen earnings_se1_month`k' = 0
gen earnings_se2_month`k' = 0
}

forvalues k=10(1)40 {
rename ernam1`k' earnings_job1_month`k' 
rename ernam2`k' earnings_job2_month`k' 
gen earnings_se1_month`k' = 0
gen earnings_se2_month`k' = 0
}


forvalues k=1(1)40 {
replace earnings_job1_month`k' = 0 if earnings_job1_month`k' < 0 | earnings_job1_month`k' == .
replace earnings_job2_month`k' = 0 if earnings_job2_month`k' < 0 | earnings_job2_month`k' == .
replace earnings_se1_month`k' = 0 if earnings_se1_month`k' < 0 | earnings_se1_month`k' == .
replace earnings_se2_month`k' = 0 if earnings_se2_month`k' < 0 | earnings_se2_month`k' == .
}

forvalues k=1(1)40 {
replace earnings_job1_month`k' = . if pp_mis`k' != 1
replace earnings_job2_month`k' = . if pp_mis`k' != 1
replace earnings_se1_month`k' = . if pp_mis`k' != 1
replace earnings_se2_month`k' = . if pp_mis`k' != 1
}


gen earnings_job1_1992 = 0
gen earnings_job1_1993 = 0
gen earnings_job2_1992 = 0
gen earnings_job2_1993 = 0
gen earnings_se1_1992 = 0
gen earnings_se1_1993 = 0
gen earnings_se2_1992 = 0
gen earnings_se2_1993 = 0

gen earnings_annual1992 = 0
gen earnings_annual1993 = 0

gen earnings_job1_1994 = 0
gen earnings_job2_1994 = 0
gen earnings_se1_1994 = 0
gen earnings_se2_1994 = 0
gen earnings_annual1994 = 0



/* Rotation group 1: 1992 is months 1-12, 1993 is months 13-24 */
forvalues k=1(1)12 {
replace earnings_annual1992 = earnings_annual1992 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}

forvalues k=13(1)24 {
replace earnings_annual1993 = earnings_annual1993 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}

forvalues k=25(1)36 {
replace earnings_annual1994 = earnings_annual1994 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}


replace earnings_annual1992 = (earnings_annual1992/(months_seen1992-months_enrolled1992)) * 12  if rot == 1
replace earnings_annual1993 = (earnings_annual1993/(months_seen1993-months_enrolled1993)) * 12  if rot == 1
replace earnings_annual1994 = (earnings_annual1994/(months_seen1994-months_enrolled1994)) * 12  if rot == 1

replace earnings_annual1992 = 0 if months_enrolled1992 == 12 & rot == 1
replace earnings_annual1993 = 0 if months_enrolled1993 == 12 & rot == 1
replace earnings_annual1994 = 0 if months_enrolled1994 == 12 & rot == 1

sum earnings_annual* if rot == 1






/* Rotation group 2: 1992 is months 4-15, 1993 is months 16-27 */
forvalues k=4(1)15 {
replace earnings_annual1992 = earnings_annual1992 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}

forvalues k=16(1)27 {
replace earnings_annual1993 = earnings_annual1993 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}

forvalues k=28(1)39 {
replace earnings_annual1994 = earnings_annual1994 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}


replace earnings_annual1992 = (earnings_annual1992/(months_seen1992-months_enrolled1992)) * 12  if rot == 2
replace earnings_annual1993 = (earnings_annual1993/(months_seen1993-months_enrolled1993)) * 12  if rot == 2
replace earnings_annual1994 = (earnings_annual1994/(months_seen1994-months_enrolled1994)) * 12  if rot == 2

replace earnings_annual1992 = 0 if months_enrolled1992 == 12 & rot == 2
replace earnings_annual1993 = 0 if months_enrolled1993 == 12 & rot == 2
replace earnings_annual1994 = 0 if months_enrolled1994 == 12 & rot == 2

sum earnings_annual* if rot == 2








/* Rotation group 3: 1992 is months 3-14, 1993 is months 15-26 */
forvalues k=3(1)14 {
replace earnings_annual1992 = earnings_annual1992 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}

forvalues k=15(1)26 {
replace earnings_annual1993 = earnings_annual1993 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}

forvalues k=27(1)38 {
replace earnings_annual1994 = earnings_annual1994 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}

replace earnings_annual1992 = (earnings_annual1992/(months_seen1992-months_enrolled1992)) * 12  if rot == 3
replace earnings_annual1993 = (earnings_annual1993/(months_seen1993-months_enrolled1993)) * 12  if rot == 3
replace earnings_annual1994 = (earnings_annual1994/(months_seen1994-months_enrolled1994)) * 12  if rot == 3

replace earnings_annual1992 = 0 if months_enrolled1992 == 12 & rot == 3
replace earnings_annual1993 = 0 if months_enrolled1993 == 12 & rot == 3
replace earnings_annual1994 = 0 if months_enrolled1994 == 12 & rot == 3

sum earnings_annual* if rot == 3






/* Rotation group 4: 1992 is months 2-13, 1993 is months 14-25 */
forvalues k=2(1)13 {
replace earnings_annual1992 = earnings_annual1992 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}

forvalues k=14(1)25 {
replace earnings_annual1993 = earnings_annual1993 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}

forvalues k=26(1)37 {
replace earnings_annual1994 = earnings_annual1994 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}

replace earnings_annual1992 = (earnings_annual1992/(months_seen1992-months_enrolled1992)) * 12  if rot == 4
replace earnings_annual1993 = (earnings_annual1993/(months_seen1993-months_enrolled1993)) * 12  if rot == 4
replace earnings_annual1994 = (earnings_annual1994/(months_seen1994-months_enrolled1994)) * 12  if rot == 4

replace earnings_annual1992 = 0 if months_enrolled1992 == 12 & rot == 4
replace earnings_annual1993 = 0 if months_enrolled1993 == 12 & rot == 4
replace earnings_annual1994 = 0 if months_enrolled1994 == 12 & rot == 4

sum earnings_annual* if rot == 4

bysort rot: sum earnings_annual1992 if earnings_annual1992 > 300
bysort rot: sum earnings_annual1993 if earnings_annual1993 > 300
bysort rot: sum earnings_annual1994 if earnings_annual1994 > 300






/**** WAGES ****/
/* For hourly workers, we actually have an hourly rate of pay variable */
forvalues k=1(1)9 {
rename hrrat10`k' wage_month`k'
}

forvalues k=10(1)40 {
rename hrrat1`k' wage_month`k'
}


forvalues k=1(1)40 {
replace wage_month`k' = . if pp_mis`k' != 1
}



/* Annual wage measure will be the average of the non-missing wage measures in the year (for job 1 only) */

/* Need to get # of non-missing wage measures each year */
gen wage_count1992 = 0
gen wage_count1993 = 0
gen wage_count1994 = 0

forvalues k=1(1)12 {
replace wage_count1992 = wage_count1992 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace wage_count1993 = wage_count1993 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=25(1)36 {
replace wage_count1994 = wage_count1994 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace wage_count1992 = wage_count1992 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace wage_count1993 = wage_count1993 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=28(1)39 {
replace wage_count1994 = wage_count1994 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}



forvalues k=3(1)14 {
replace wage_count1992 = wage_count1992 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace wage_count1993 = wage_count1993 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=27(1)38 {
replace wage_count1994 = wage_count1994 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace wage_count1992 = wage_count1992 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace wage_count1993 = wage_count1993 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=26(1)37 {
replace wage_count1994 = wage_count1994 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}



/* Now, we construct the annual wage measure */
gen hrlypay1992 = .
gen hrlypay1993 = .
gen hrlypay1994 = .

gen hrlypayv11992 = .
gen hrlypayv11993 = .
gen hrlypayv11994 = .

gen hrlypayv21992 = .
gen hrlypayv21993 = .
gen hrlypayv21994 = .

gen total_wage1992 = 0
gen total_wage1993 = 0
gen total_wage1994 = 0


forvalues k=1(1)12 {
replace total_wage1992 = total_wage1992 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace total_wage1993 = total_wage1993 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=25(1)36 {
replace total_wage1994 = total_wage1994 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace total_wage1992 = total_wage1992 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace total_wage1993 = total_wage1993 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=28(1)39 {
replace total_wage1994 = total_wage1994 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace total_wage1992 = total_wage1992 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace total_wage1993 = total_wage1993 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=27(1)38 {
replace total_wage1994 = total_wage1994 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace total_wage1992 = total_wage1992 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace total_wage1993 = total_wage1993 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=26(1)37 {
replace total_wage1994 = total_wage1994 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}


replace hrlypayv11992 = total_wage1992/wage_count1992 
replace hrlypayv11993 = total_wage1993/wage_count1993
replace hrlypayv11994 = total_wage1994/wage_count1994

sum hrlypay*

drop total_wage* wage_count* wage_month*



************************* PICK UP HERE *******************************/


/* Alternative if you don't work by the hour: get earnings/hours */
forvalues k=1(1)9 {
replace wshrs10`k' = 0 if wshrs10`k' < 0
rename wshrs10`k' hours_job1_month`k'

replace wshrs20`k' = 0 if wshrs20`k' < 0
rename wshrs20`k' hours_job2_month`k'
}

forvalues k=10(1)40 {
replace wshrs1`k' = 0 if wshrs1`k' < 0
rename wshrs1`k' hours_job1_month`k'
rename wshrs2`k' hours_job2_month`k'

}

forvalues k=1(1)40 {
replace hours_job1_month`k' = . if pp_mis`k' != 1
replace hours_job2_month`k' = . if pp_mis`k' != 1

}


/* Need to get # of non-missing hours measures each year */
gen hours_count1992 = 0
gen hours_count1993 = 0
gen hours_count1994 = 0

forvalues k=1(1)12 {
replace hours_count1992 = hours_count1992 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace hours_count1993 = hours_count1993 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=25(1)36 {
replace hours_count1994 = hours_count1994 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace hours_count1992 = hours_count1992 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace hours_count1993 = hours_count1993 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=28(1)39 {
replace hours_count1994 = hours_count1994 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}



forvalues k=3(1)14 {
replace hours_count1992 = hours_count1992 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace hours_count1993 = hours_count1993 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=27(1)38 {
replace hours_count1994 = hours_count1994 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}



forvalues k=2(1)13 {
replace hours_count1992 = hours_count1992 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace hours_count1993 = hours_count1993 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=26(1)37 {
replace hours_count1994 = hours_count1994 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}


gen total_hours1992 = 0
gen total_hours1993 = 0
gen total_hours1994 = 0


forvalues k=1(1)9 {
rename wksem10`k' ws1_wk`k'
rename wksem20`k' ws2_wk`k'
}

forvalues k=10(1)40 {
rename wksem1`k' ws1_wk`k'
rename wksem2`k' ws2_wk`k'
}

forvalues k=1(1)40 {
replace ws1_wk`k' = . if pp_mis`k' != 1
replace ws2_wk`k' = . if pp_mis`k' != 1

}



forvalues k=1(1)12 {
replace total_hours1992 = total_hours1992 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace total_hours1993 = total_hours1993 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}

forvalues k=25(1)36 {
replace total_hours1994 = total_hours1994 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace total_hours1992 = total_hours1992 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace total_hours1993 = total_hours1993 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}

forvalues k=28(1)39 {
replace total_hours1994 = total_hours1994 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}



forvalues k=3(1)14 {
replace total_hours1992 = total_hours1992 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace total_hours1993 = total_hours1993 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}

forvalues k=27(1)38 {
replace total_hours1994 = total_hours1994 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace total_hours1992 = total_hours1992 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace total_hours1993 = total_hours1993 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}

forvalues k=26(1)37 {
replace total_hours1994 = total_hours1994 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}


replace hrlypayv21992 = earnings_annual1992 / total_hours1992
replace hrlypayv21993 = earnings_annual1993 / total_hours1993
replace hrlypayv21994 = earnings_annual1994 / total_hours1994

forvalues k=1992(1)1994 {
replace hrlypay`k' = hrlypayv1`k'
replace hrlypay`k' = hrlypayv2`k' if hrlypay`k' == . | hrlypay`k' == 0
}


sum hrlypay*

bysort rot: sum hrlypay1992 if hrlypay1992 > 1






sum age1992 age1993 age1994

sum black* hispanic*

sum hrlypay*, d



/* State and region */
/* I take the state from the first wave as the state for 1992 and the fourth wave for 1993 */
rename geo_st01 state

replace state = geo_st02 if state == 0 | state == .
replace state = geo_st03 if state == 0 | state == .


gen west = 0
gen northeast = 0
gen midwest = 0
gen south = 0

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1992 = west
gen northeast1992 = northeast
gen midwest1992 = midwest
gen south1992 = south

rename state state_ba_degree 


/* geo_st04 is the state from the 4th wave, which is in the second year */
rename geo_st04 state

replace state = geo_st05 if state == 0 | state == .
replace state = geo_st06 if state == 0 | state == .


replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1993 = west
gen northeast1993 = northeast
gen midwest1993 = midwest
gen south1993 = south

drop state


/* geo_st07 is the state from the 7th wave, which is in the third year */
rename geo_st07 state

replace state = geo_st08 if state == 0 | state == .
replace state = geo_st09 if state == 0 | state == .


replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1994 = west
gen northeast1994 = northeast
gen midwest1994 = midwest
gen south1994 = south


drop west south midwest northeast 



/* Division of degree */
gen ba_newengland = 0
gen ba_midatlantic = 0
gen ba_eastnorthcentral = 0
gen ba_westnorthcentral = 0
gen ba_southatlantic = 0
gen ba_eastsouthcentral = 0
gen ba_westsouthcentral = 0
gen ba_mountain = 0
gen ba_pacific = 0


replace ba_newengland = 1 if state_ba_degree == 9 | state_ba_degree == 25 | state_ba_degree == 33  | state_ba_degree == 44 | state_ba_degree == 23 | state_ba_degree == 50 | state_ba_degree == 61
replace ba_midatlantic = 1 if state_ba_degree == 34 | state_ba_degree == 36 | state_ba_degree == 42
replace ba_eastnorthcentral = 1 if  state_ba_degree == 55 | state_ba_degree == 39 | state_ba_degree == 26 | state_ba_degree == 18 | state_ba_degree == 17
replace ba_westnorthcentral = 1 if state_ba_degree == 62 | state_ba_degree == 19 | state_ba_degree == 38 | state_ba_degree == 46 | state_ba_degree == 31| state_ba_degree == 20 | state_ba_degree == 29 | state_ba_degree == 27
replace ba_southatlantic = 1 if state_ba_degree == 10 | state_ba_degree == 11 | state_ba_degree == 24 | state_ba_degree == 54 | state_ba_degree == 51 | state_ba_degree == 37 | state_ba_degree == 45 | state_ba_degree == 12 | state_ba_degree == 13
replace ba_eastsouthcentral = 1 if state_ba_degree == 28 | state_ba_degree == 21 | state_ba_degree == 47 | state_ba_degree == 1
replace ba_westsouthcentral = 1 if state_ba_degree == 5 | state_ba_degree == 22 | state_ba_degree == 40 | state_ba_degree == 48
replace ba_mountain = 1 if state_ba_degree == 4 | state_ba_degree == 8 | state_ba_degree == 16 | state_ba_degree == 30 | state_ba_degree == 32 | state_ba_degree == 35 | state_ba_degree == 49 | state_ba_degree == 56
replace ba_pacific = 1 if state_ba_degree == 2 | state_ba_degree == 15 | state_ba_degree == 6 | state_ba_degree == 41 | state_ba_degree == 53

/* There are a few aggregated state variables for the early years that we can't tell which division they are in (e.g., "Mississippi and West Virginia"); these are small numbers of people */





/* Survey weights */
rename fnlwgt92 survey_weight1992
rename fnlwgt93 survey_weight1993
rename fnlwgt94 survey_weight1994





/* Are you employed? */
/* How should I do this? I have 12 observations per year */
/* For now, what I do (also for occupation and industry and full-time) is take the middle months of the person's year */

gen employed1992 = 0
gen employed1993 = 0
gen employed1994 = 0


forvalues k=1(1)12 {
replace employed1992 = employed1992 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace employed1993 = employed1993 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=25(1)36 {
replace employed1994 = employed1994 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 1
}



forvalues k=4(1)15 {
replace employed1992 = employed1992 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace employed1993 = employed1993 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=28(1)39 {
replace employed1994 = employed1994 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace employed1992 = employed1992 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace employed1993 = employed1993 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=27(1)38 {
replace employed1994 = employed1994 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace employed1992 = employed1992 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace employed1993 = employed1993 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=26(1)37 {
replace employed1994 = employed1994 + 1 if (ws1_wk`k' > 0 | ws2_wk`k' > 0) & enrl_m`k' == 0 & rot == 4
}


sum employed*

replace employed1992 = employed1992 / (months_seen1992-months_enrolled1992)
replace employed1993 = employed1993 / (months_seen1993-months_enrolled1993)
replace employed1994 = employed1994 / (months_seen1994-months_enrolled1994)

sum employed*, d




/* Are you full-time? */

gen fulltime1992 = 0
gen fulltime1993 = 0
gen fulltime1994 = 0

forvalues k=1(1)12 {
replace fulltime1992 = fulltime1992 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace fulltime1993 = fulltime1993 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}

forvalues k=25(1)36 {
replace fulltime1994 = fulltime1994 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace fulltime1992 = fulltime1992 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace fulltime1993 = fulltime1993 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}

forvalues k=28(1)39 {
replace fulltime1994 = fulltime1994 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace fulltime1992 = fulltime1992 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace fulltime1993 = fulltime1993 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}

forvalues k=27(1)38 {
replace fulltime1994 = fulltime1994 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace fulltime1992 = fulltime1992 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace fulltime1993 = fulltime1993 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

forvalues k=26(1)37 {
replace fulltime1994 = fulltime1994 + 1 if (hours_job1_month`k' >= 30 | hours_job2_month`k' >= 30) & enrl_m`k' == 0 & rot == 4
}

sum fulltime*

replace fulltime1992 = fulltime1992 / (months_seen1992-months_enrolled1992)
replace fulltime1993 = fulltime1993 / (months_seen1993-months_enrolled1993)
replace fulltime1994 = fulltime1994 / (months_seen1994-months_enrolled1994)

sum employed*, d
sum fulltime*, d



/* OCCUPATION */
/* I use the 6th month occupation as the occupation. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace occ1_0`k' = . if occ1_0`k' == 0 | occ1_0`k' == 905
rename occ1_0`k' ws1_oc`k'
}

forvalues k=10(1)40 {
replace occ1_`k' = . if occ1_`k' == 0 | occ1_`k' == 905
rename occ1_`k' ws1_oc`k'

}


forvalues k=1(1)12 {
gen occ`k'_1992 = .
gen occ`k'_1993 = .
gen occ`k'_1994 = .
}

forvalues k=1(1)12 {
local j = `k'
replace occ`j'_1992 = ws1_oc`k' if rot == 1
}


forvalues k=13(1)24 {
local j = `k' - 12
replace occ`j'_1993 = ws1_oc`k' if rot == 1
}

forvalues k=25(1)36 {
local j = `k' - 24
replace occ`j'_1994 = ws1_oc`k' if rot == 1
}


forvalues k=4(1)15 {
local j = `k' - 3
replace occ`j'_1992 = ws1_oc`k' if rot == 2
}

forvalues k=16(1)27 {
local j = `k' - 15
replace occ`j'_1993 = ws1_oc`k' if rot == 2
}

forvalues k=28(1)39 {
local j = `k' - 27
replace occ`j'_1994 = ws1_oc`k' if rot == 2
}


forvalues k=3(1)14 {
local j = `k' - 2
replace occ`j'_1992 = ws1_oc`k' if rot == 3
}

forvalues k=15(1)26 {
local j = `k' - 14
replace occ`j'_1993 = ws1_oc`k' if rot == 3
}

forvalues k=27(1)37 {
local j = `k' - 26
replace occ`j'_1994 = ws1_oc`k' if rot == 3
}

forvalues k=2(1)13 {
local j = `k' - 1
replace occ`j'_1992 = ws1_oc`k' if rot == 4
}

forvalues k=14(1)25 {
local j = `k' - 13
replace occ`j'_1993 = ws1_oc`k' if rot == 4
}

forvalues k=26(1)37 {
local j = `k' - 25
replace occ`j'_1994 = ws1_oc`k' if rot == 4
}


/* INDUSTRY */
/* I use the 6th month industry as the industry. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace ind1_0`k' = . if ind1_0`k' == 0 | ind1_0`k' == 991
rename ind1_0`k' ws1_in`k'
}

forvalues k=10(1)40 {
replace ind1_`k' = . if ind1_`k' == 0 | ind1_`k' == 991
rename ind1_`k' ws1_in`k'
}


forvalues k=1(1)12 {
gen ind`k'_1992 = .
gen ind`k'_1993 = .
gen ind`k'_1994 = .
}

forvalues k=1(1)12 {
local j = `k'
replace ind`j'_1992 = ws1_in`k' if rot == 1
}


forvalues k=13(1)24 {
local j = `k' - 12
replace ind`j'_1993 = ws1_in`k' if rot == 1
}

forvalues k=25(1)36 {
local j = `k' - 24
replace ind`j'_1994 = ws1_in`k' if rot == 1
}


forvalues k=4(1)15 {
local j = `k' - 3
replace ind`j'_1992 = ws1_in`k' if rot == 2
}

forvalues k=16(1)27 {
local j = `k' - 15
replace ind`j'_1993 = ws1_in`k' if rot == 2
}

forvalues k=28(1)39 {
local j = `k' - 27
replace ind`j'_1994 = ws1_in`k' if rot == 2
}


forvalues k=3(1)14 {
local j = `k' - 2
replace ind`j'_1992 = ws1_in`k' if rot == 3
}

forvalues k=15(1)26 {
local j = `k' - 14
replace ind`j'_1993 = ws1_in`k' if rot == 3
}

forvalues k=27(1)37 {
local j = `k' - 26
replace ind`j'_1994 = ws1_in`k' if rot == 3
}

forvalues k=2(1)13 {
local j = `k' - 1
replace ind`j'_1992 = ws1_in`k' if rot == 4
}

forvalues k=14(1)25 {
local j = `k' - 13
replace ind`j'_1993 = ws1_in`k' if rot == 4
}

forvalues k=26(1)37 {
local j = `k' - 25
replace ind`j'_1994 = ws1_in`k' if rot == 4
}

drop *month*

bysort rot: sum ind* occ*



/* Identifying variables */
keep *1992 *1993 *1994 rot pp_id pp_entry pp_pnum u_brthyr state_ba* ba_*

rename pp_id su_id

destring su_id, replace
destring pp_entry, replace
destring pp_pnum, replace

sort su_id pp_entry pp_pnum
compress
save Temp/sipp92_full_cleaned.dta, replace


*************************************************************************************8

clear

use Temp/sipp92wave2.dta


/**** WAVE 2 DATASET ****/



/* Identifiers */
rename id su_id
rename entry pp_entry 
rename pnum pp_pnum 

destring su_id, replace
destring pp_entry, replace
destring pp_pnum, replace

sum su_id pp_entry pp_pnum



/********** COLLEGE DEGREE INFORMATION *********/

/* 2 questions: highest degree and BA degree. Need to check both */

/* Need year of degree, age at degree, and field of degree. Also need highest degree completed */


gen col = 0
gen morcol = 0
gen hgc = .

replace hgc = 12 if tm8422 == 0 | tm8422 == -1 | tm8422 == 7
replace hgc = 14 if tm8422 == 6 | tm8422 == 5
replace hgc = 16 if tm8422 == 4
replace hgc = 18 if tm8422 == 3
replace hgc = 19 if tm8422 == 2
replace hgc = 20 if tm8422 == 1
replace hgc = 10 if tm8408 == 2 // 2 means did not grad HS in 92 SIPP 

tab hgc, mi

replace col = 1 if hgc == 16
replace morcol = 1 if hgc > 16

tab col morcol


gen gradyear = .

replace tm8426 = . if tm8426 <= 0
replace tm8434 = . if tm8434 <= 0

replace gradyear = tm8426 if hgc == 16

replace gradyear = tm8434 if gradyear == .

tab gradyear

/* Field of bachelor's degree */

rename tm8428 major_field
replace major_field = . if major_field == 0

tab major_field, mi





keep hgc major_field gradyear col morcol su_id pp_entry pp_pnum


sort su_id pp_entry pp_pnum



merge su_id pp_entry pp_pnum using Temp/sipp92_full_cleaned.dta

tab _merge
drop _merge


gen age_grad = .

replace age_grad = gradyear - u_brthyr

tab age_grad


egen pid=group(su_id pp_entry pp_pnum)
*bysort su_id pp_entry pp_pnum: gen pid = _n

drop su_id pp_entry pp_pnum

drop earnings_job* earnings_se* u_brth*

drop year1992 year1993


reshape long total_hours survey_weight age male hispanic black earnings_annual hrlypay hrlypayv1 hrlypayv2 enrolled west northeast midwest south employed fulltime occ1_ occ2_ occ3_ occ4_ occ5_ occ6_ occ7_ occ8_ occ9_ occ10_ occ11_ occ12_ ind1_ ind2_ ind3_ ind4_ ind5_ ind6_ ind7_ ind8_ ind9_ ind10_ ind11_ ind12_, i(pid) j(year)


forvalues k=1(1)12 {
rename occ`k'_ occ`k'
rename ind`k'_ ind`k'
}

* keep if age >= 22

* keep if major_field != .
tab major_field, mi
tab major_field if hgc == 16
tab gradyear
gen potexp = year - gradyear
tab potexp

tab gradyear potexp if hgc == 16 & potexp <= 13

sum

gen panel = 1992
gen survey = 9091

sort pid
compress
save Temp/sipp92_ready.dta, replace


clear




/* 1993 */


set maxvar 8000
use Temp/sipp93_full.dta


/* Age at survey */
gen year1993 = 1993
gen year1994 = 1994
gen year1995 = 1995

gen age1993 = 1993 - u_brthyr
gen age1994 = 1994 - u_brthyr
gen age1995 = 1995 - u_brthyr



/* Gender */
gen male1993 = (sex == 1)
gen male1994 = (sex == 1)
gen male1995 = (sex == 1)


/* Race */
gen hispanic1993 = (ethnicty >= 14 & ethnicty <= 20)
gen hispanic1994 = (ethnicty >= 14 & ethnicty <= 20)
gen hispanic1995 = (ethnicty >= 14 & ethnicty <= 20)

gen black1993 = (race == 2 & hispanic1993 != 1)
gen black1994 = (race == 2 & hispanic1994 != 1)
gen black1995 = (race == 2 & hispanic1994 != 1)



forvalues k=1(1)9 {
rename enrl_m0`k' enrl_m`k'
rename pp_mis0`k' pp_mis`k'
}

forvalues k=1(1)36 {
replace enrl_m`k' = . if pp_mis`k' != 1
}



gen months_seen1993 = 0
gen months_seen1994 = 0
gen months_seen1995 = 0


/* Each wave asks about the past four months */

forvalues k=1(1)12 {
replace months_seen1993 = months_seen1993 + 1 if pp_mis`k' == 1 & rot == 1
}

forvalues k=13(1)24 {
replace months_seen1994 = months_seen1994 + 1 if pp_mis`k' == 1 & rot == 1
}

forvalues k=25(1)36 {
replace months_seen1995 = months_seen1995 + 1 if pp_mis`k' == 1 & rot == 1
}



forvalues k=4(1)15 {
replace months_seen1993 = months_seen1993 + 1 if pp_mis`k' == 1 & rot == 2
}

forvalues k=16(1)27 {
replace months_seen1994 = months_seen1994 + 1 if pp_mis`k' == 1 & rot == 2
}

forvalues k=28(1)36 {
replace months_seen1995 = months_seen1995 + 1 if pp_mis`k' == 1 & rot == 2
}


forvalues k=3(1)14 {
replace months_seen1993 = months_seen1993 + 1 if pp_mis`k' == 1 & rot == 3
}

forvalues k=15(1)26 {
replace months_seen1994 = months_seen1994 + 1 if pp_mis`k' == 1 & rot == 3
}

forvalues k=27(1)36 {
replace months_seen1995 = months_seen1995 + 1 if pp_mis`k' == 1 & rot == 3
}



forvalues k=2(1)13 {
replace months_seen1993 = months_seen1993 + 1 if pp_mis`k' == 1 & rot == 4
}

forvalues k=14(1)25 {
replace months_seen1994 = months_seen1994 + 1 if pp_mis`k' == 1 & rot == 4
}

forvalues k=26(1)36 {
replace months_seen1995 = months_seen1995 + 1 if pp_mis`k' == 1 & rot == 4
}



/*
/* The first survey is in Feb 1993, so we don't have obs for many people in 1992 */
replace months_seen1992 = 3 if rot == 2
replace months_seen1992 = 2 if rot == 3
replace months_seen1992 = 1 if rot == 4
replace months_seen1992 = 0 if rot == 1


/* We see everyone through all of 1993 */
replace months_seen1993 = 12 if rot == 2
replace months_seen1993 = 12 if rot == 3
replace months_seen1993 = 12 if rot == 4
replace months_seen1993 = 12 if rot == 1


/* We see everyone through all of 1994 */
replace months_seen1994 = 12 if rot == 2
replace months_seen1994 = 12 if rot == 3
replace months_seen1994 = 12 if rot == 4
replace months_seen1994 = 12 if rot == 1


/* We don't see everyone through all of 1995 */
replace months_seen1995 = 9 if rot == 2
replace months_seen1995 = 10 if rot == 3
replace months_seen1995 = 11 if rot == 4
replace months_seen1995 = 12 if rot == 1
*/


/* Enrolled? */



/* I will code you as enrolled in the year if you are enrolled at least 2 months of the year */
gen months_enrolled1993 = 0
gen months_enrolled1994 = 0
gen months_enrolled1995 = 0




forvalues k=1(1)12 {
replace months_enrolled1993 = months_enrolled1993 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=13(1)24 {
replace months_enrolled1994 = months_enrolled1994 + 1 if enrl_m`k' == 1 & rot == 1
}

forvalues k=25(1)36 {
replace months_enrolled1995 = months_enrolled1995 + 1 if enrl_m`k' == 1 & rot == 1
}



forvalues k=4(1)15 {
replace months_enrolled1993 = months_enrolled1993 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=16(1)27 {
replace months_enrolled1994 = months_enrolled1994 + 1 if enrl_m`k' == 1 & rot == 2
}

forvalues k=28(1)36 {
replace months_enrolled1995 = months_enrolled1995 + 1 if enrl_m`k' == 1 & rot == 2
}


forvalues k=3(1)14 {
replace months_enrolled1993 = months_enrolled1993 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=15(1)26 {
replace months_enrolled1994 = months_enrolled1994 + 1 if enrl_m`k' == 1 & rot == 3
}

forvalues k=27(1)36 {
replace months_enrolled1995 = months_enrolled1995 + 1 if enrl_m`k' == 1 & rot == 3
}



forvalues k=2(1)13 {
replace months_enrolled1993 = months_enrolled1993 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=14(1)25 {
replace months_enrolled1994 = months_enrolled1994 + 1 if enrl_m`k' == 1 & rot == 4
}

forvalues k=26(1)36 {
replace months_enrolled1995 = months_enrolled1995 + 1 if enrl_m`k' == 1 & rot == 4
}

sum months_enrolled*



gen enrolled1993 = months_enrolled1993 / months_seen1993
gen enrolled1994 = months_enrolled1994 / months_seen1994
gen enrolled1995 = months_enrolled1995 / months_seen1995






/**** ANNUAL EARNINGS ****/

/* Earnings are by month. Month #s to actual month mapping differs by rotation group */
forvalues k=1(1)9 {
rename ernam10`k' earnings_job1_month`k' 
rename ernam20`k' earnings_job2_month`k' 
gen earnings_se1_month`k' = 0
gen earnings_se2_month`k' = 0
}

forvalues k=10(1)36 {
rename ernam1`k' earnings_job1_month`k' 
rename ernam2`k' earnings_job2_month`k' 
gen earnings_se1_month`k' = 0
gen earnings_se2_month`k' = 0
}


forvalues k=1(1)36 {
replace earnings_job1_month`k' = 0 if earnings_job1_month`k' < 0 | earnings_job1_month`k' == .
replace earnings_job2_month`k' = 0 if earnings_job2_month`k' < 0 | earnings_job2_month`k' == .
replace earnings_se1_month`k' = 0 if earnings_se1_month`k' < 0 | earnings_se1_month`k' == .
replace earnings_se2_month`k' = 0 if earnings_se2_month`k' < 0 | earnings_se2_month`k' == .
}

forvalues k=1(1)36 {
replace earnings_job1_month`k' = . if pp_mis`k' != 1
replace earnings_job2_month`k' = . if pp_mis`k' != 1
replace earnings_se1_month`k' = . if pp_mis`k' != 1
replace earnings_se2_month`k' = . if pp_mis`k' != 1
}


gen earnings_job1_1993 = 0
gen earnings_job1_1994 = 0
gen earnings_job2_1993 = 0
gen earnings_job2_1994 = 0
gen earnings_se1_1993 = 0
gen earnings_se1_1994 = 0
gen earnings_se2_1993 = 0
gen earnings_se2_1994 = 0

gen earnings_annual1993 = 0
gen earnings_annual1994 = 0

gen earnings_job1_1995 = 0
gen earnings_job2_1995 = 0
gen earnings_se1_1995 = 0
gen earnings_se2_1995 = 0
gen earnings_annual1995 = 0



/* Rotation group 1: 1993 is months 1-12, 1994 is months 13-24 */
forvalues k=1(1)12 {
replace earnings_annual1993 = earnings_annual1993 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}

forvalues k=13(1)24 {
replace earnings_annual1994 = earnings_annual1994 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}

forvalues k=25(1)36 {
replace earnings_annual1995 = earnings_annual1995 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 1 & enrl_m`k' == 0
}


replace earnings_annual1993 = (earnings_annual1993/(months_seen1993-months_enrolled1993)) * 12  if rot == 1
replace earnings_annual1994 = (earnings_annual1994/(months_seen1994-months_enrolled1994)) * 12  if rot == 1
replace earnings_annual1995 = (earnings_annual1995/(months_seen1995-months_enrolled1995)) * 12  if rot == 1

replace earnings_annual1993 = 0 if months_enrolled1993 == 12 & rot == 1
replace earnings_annual1994 = 0 if months_enrolled1994 == 12 & rot == 1
replace earnings_annual1995 = 0 if months_enrolled1995 == 12 & rot == 1

sum earnings_annual* if rot == 1






/* Rotation group 2: 1993 is months 4-15, 1994 is months 16-27 */
forvalues k=4(1)15 {
replace earnings_annual1993 = earnings_annual1993 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}

forvalues k=16(1)27 {
replace earnings_annual1994 = earnings_annual1994 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}

forvalues k=28(1)36 {
replace earnings_annual1995 = earnings_annual1995 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 2 & enrl_m`k' == 0
}


replace earnings_annual1993 = (earnings_annual1993/(months_seen1993-months_enrolled1993)) * 12  if rot == 2
replace earnings_annual1994 = (earnings_annual1994/(months_seen1994-months_enrolled1994)) * 12  if rot == 2
replace earnings_annual1995 = (earnings_annual1995/(months_seen1995-months_enrolled1995)) * 12  if rot == 2

replace earnings_annual1993 = 0 if months_enrolled1993 == 12 & rot == 2
replace earnings_annual1994 = 0 if months_enrolled1994 == 12 & rot == 2
replace earnings_annual1995 = 0 if months_enrolled1995 == 12 & rot == 2

sum earnings_annual* if rot == 2








/* Rotation group 3: 1993 is months 3-14, 1994 is months 15-26 */
forvalues k=3(1)14 {
replace earnings_annual1993 = earnings_annual1993 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}

forvalues k=15(1)26 {
replace earnings_annual1994 = earnings_annual1994 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}

forvalues k=27(1)36 {
replace earnings_annual1995 = earnings_annual1995 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 3 & enrl_m`k' == 0
}

replace earnings_annual1993 = (earnings_annual1993/(months_seen1993-months_enrolled1993)) * 12  if rot == 3
replace earnings_annual1994 = (earnings_annual1994/(months_seen1994-months_enrolled1994)) * 12  if rot == 3
replace earnings_annual1995 = (earnings_annual1995/(months_seen1995-months_enrolled1995)) * 12  if rot == 3

replace earnings_annual1993 = 0 if months_enrolled1993 == 12 & rot == 3
replace earnings_annual1994 = 0 if months_enrolled1994 == 12 & rot == 3
replace earnings_annual1995 = 0 if months_enrolled1995 == 12 & rot == 3

sum earnings_annual* if rot == 3






/* Rotation group 4: 1993 is months 2-13, 1994 is months 14-25 */
forvalues k=2(1)13 {
replace earnings_annual1993 = earnings_annual1993 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}

forvalues k=14(1)25 {
replace earnings_annual1994 = earnings_annual1994 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}

forvalues k=26(1)36 {
replace earnings_annual1995 = earnings_annual1995 + earnings_job1_month`k' + earnings_job2_month`k' if rot == 4 & enrl_m`k' == 0
}

replace earnings_annual1993 = (earnings_annual1993/(months_seen1993-months_enrolled1993)) * 12  if rot == 4
replace earnings_annual1994 = (earnings_annual1994/(months_seen1994-months_enrolled1994)) * 12  if rot == 4
replace earnings_annual1995 = (earnings_annual1995/(months_seen1995-months_enrolled1995)) * 12  if rot == 4

replace earnings_annual1993 = 0 if months_enrolled1993 == 12 & rot == 4
replace earnings_annual1994 = 0 if months_enrolled1994 == 12 & rot == 4
replace earnings_annual1995 = 0 if months_enrolled1995 == 12 & rot == 4

sum earnings_annual* if rot == 4

bysort rot: sum earnings_annual1993 if earnings_annual1993 > 300
bysort rot: sum earnings_annual1994 if earnings_annual1994 > 300
bysort rot: sum earnings_annual1995 if earnings_annual1995 > 300






/**** WAGES ****/
/* For hourly workers, we actually have an hourly rate of pay variable */
forvalues k=1(1)9 {
rename hrrat10`k' wage_month`k'
}

forvalues k=10(1)36 {
rename hrrat1`k' wage_month`k'
}

forvalues k=1(1)36 {
replace wage_month`k' = . if pp_mis`k' != 1
}


/* Annual wage measure will be the average of the non-missing wage measures in the year (for job 1 only) */

/* Need to get # of non-missing wage measures each year */
gen wage_count1993 = 0
gen wage_count1994 = 0
gen wage_count1995 = 0

forvalues k=1(1)12 {
replace wage_count1993 = wage_count1993 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace wage_count1994 = wage_count1994 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}

forvalues k=25(1)36 {
replace wage_count1995 = wage_count1995 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace wage_count1993 = wage_count1993 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace wage_count1994 = wage_count1994 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}

forvalues k=28(1)36 {
replace wage_count1995 = wage_count1995 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 2
}



forvalues k=3(1)14 {
replace wage_count1993 = wage_count1993 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace wage_count1994 = wage_count1994 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}

forvalues k=27(1)36 {
replace wage_count1995 = wage_count1995 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace wage_count1993 = wage_count1993 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace wage_count1994 = wage_count1994 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}

forvalues k=26(1)36 {
replace wage_count1995 = wage_count1995 + 1 if wage_month`k' > 0 & enrl_m`k' == 0 & rot == 4
}



/* Now, we construct the annual wage measure */
gen hrlypay1993 = .
gen hrlypay1994 = .
gen hrlypay1995 = .

gen hrlypayv11993 = .
gen hrlypayv11994 = .
gen hrlypayv11995 = .

gen hrlypayv21993 = .
gen hrlypayv21994 = .
gen hrlypayv21995 = .

gen total_wage1993 = 0
gen total_wage1994 = 0
gen total_wage1995 = 0


forvalues k=1(1)12 {
replace total_wage1993 = total_wage1993 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace total_wage1994 = total_wage1994 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}

forvalues k=25(1)36 {
replace total_wage1995 = total_wage1995 + wage_month`k' if enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace total_wage1993 = total_wage1993 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace total_wage1994 = total_wage1994 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}

forvalues k=28(1)36 {
replace total_wage1995 = total_wage1995 + wage_month`k' if enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace total_wage1993 = total_wage1993 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace total_wage1994 = total_wage1994 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}

forvalues k=27(1)36 {
replace total_wage1995 = total_wage1995 + wage_month`k' if enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace total_wage1993 = total_wage1993 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace total_wage1994 = total_wage1994 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}

forvalues k=26(1)36 {
replace total_wage1995 = total_wage1995 + wage_month`k' if enrl_m`k' == 0 & rot == 4
}


replace hrlypayv11993 = total_wage1993/wage_count1993 
replace hrlypayv11994 = total_wage1994/wage_count1994
replace hrlypayv11995 = total_wage1995/wage_count1995

sum hrlypay*

drop total_wage* wage_count* wage_month*



************************* PICK UP HERE *******************************/


/* Alternative if you don't work by the hour: get earnings/hours */
forvalues k=1(1)9 {
replace wshrs10`k' = 0 if wshrs10`k' < 0
rename wshrs10`k' hours_job1_month`k'

replace wshrs20`k' = 0 if wshrs20`k' < 0
rename wshrs20`k' hours_job2_month`k'
}

forvalues k=10(1)36 {
replace wshrs1`k' = 0 if wshrs1`k' < 0
rename wshrs1`k' hours_job1_month`k'
rename wshrs2`k' hours_job2_month`k'

}

forvalues k=1(1)36 {
replace hours_job1_month`k' = . if pp_mis`k' != 1
replace hours_job2_month`k' = . if pp_mis`k' != 1

}


/* Need to get # of non-missing hours measures each year */
gen hours_count1993 = 0
gen hours_count1994 = 0
gen hours_count1995 = 0

forvalues k=1(1)12 {
replace hours_count1993 = hours_count1993 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace hours_count1994 = hours_count1994 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}

forvalues k=25(1)36 {
replace hours_count1995 = hours_count1995 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace hours_count1993 = hours_count1993 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace hours_count1994 = hours_count1994 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}

forvalues k=28(1)36 {
replace hours_count1995 = hours_count1995 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 2
}



forvalues k=3(1)14 {
replace hours_count1993 = hours_count1993 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace hours_count1994 = hours_count1994 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}

forvalues k=27(1)36 {
replace hours_count1995 = hours_count1995 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 3
}



forvalues k=2(1)13 {
replace hours_count1993 = hours_count1993 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace hours_count1994 = hours_count1994 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}

forvalues k=26(1)36 {
replace hours_count1995 = hours_count1995 + 1 if (hours_job1_month`k' > 0 | hours_job2_month`k' > 0) & enrl_m`k' == 0 & rot == 4
}


gen total_hours1993 = 0
gen total_hours1994 = 0
gen total_hours1995 = 0


forvalues k=1(1)9 {
rename wksem10`k' ws1_wk`k'
rename wksem20`k' ws2_wk`k'
}

forvalues k=10(1)36 {
rename wksem1`k' ws1_wk`k'
rename wksem2`k' ws2_wk`k'
}

forvalues k=1(1)36 {
replace ws1_wk`k' = . if pp_mis`k' != 1
replace ws2_wk`k' = . if pp_mis`k' != 1

}



forvalues k=1(1)12 {
replace total_hours1993 = total_hours1993 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace total_hours1994 = total_hours1994 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}

forvalues k=25(1)36 {
replace total_hours1995 = total_hours1995 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace total_hours1993 = total_hours1993 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace total_hours1994 = total_hours1994 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}

forvalues k=28(1)36 {
replace total_hours1995 = total_hours1995 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 2
}



forvalues k=3(1)14 {
replace total_hours1993 = total_hours1993 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace total_hours1994 = total_hours1994 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}

forvalues k=27(1)36 {
replace total_hours1995 = total_hours1995 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace total_hours1993 = total_hours1993 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace total_hours1994 = total_hours1994 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}

forvalues k=26(1)36 {
replace total_hours1995 = total_hours1995 + (hours_job1_month`k'*ws1_wk`k') + (hours_job2_month`k'*ws2_wk`k') if enrl_m`k' == 0 & rot == 4
}


replace hrlypayv21993 = earnings_annual1993 / total_hours1993
replace hrlypayv21994 = earnings_annual1994 / total_hours1994
replace hrlypayv21995 = earnings_annual1995 / total_hours1995

forvalues k=1993(1)1995 {
replace hrlypay`k' = hrlypayv1`k'
replace hrlypay`k' = hrlypayv2`k' if hrlypay`k' == . | hrlypay`k' == 0
}


sum hrlypay*

bysort rot: sum hrlypay1993 if hrlypay1993 > 1






sum age1993 age1994 age1995

sum black* hispanic*

sum hrlypay*, d



/* State and region */
/* I take the state from the first wave as the state for 1993 and the fourth wave for 1994 */
rename geo_ste1 state

replace state = geo_ste2 if state == 0 | state == .
replace state = geo_ste3 if state == 0 | state == .


gen west = 0
gen northeast = 0
gen midwest = 0
gen south = 0

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1993 = west
gen northeast1993 = northeast
gen midwest1993 = midwest
gen south1993 = south

rename state state_ba_degree 


/* geo_ste4 is the state from the 4th wave, which is in the second year */
rename geo_ste4 state

replace state = geo_ste5 if state == 0 | state == .
replace state = geo_ste6 if state == 0 | state == .


replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1994 = west
gen northeast1994 = northeast
gen midwest1994 = midwest
gen south1994 = south

drop state


/* geo_ste7 is the state from the 7th wave, which is in the third year */
rename geo_ste7 state

replace state = geo_ste8 if state == 0 | state == .
replace state = geo_ste9 if state == 0 | state == .

replace west = 1 if state == 4 | state == 6 | state == 8 | state == 15 | state == 32 | state == 35 | state == 41 | state == 49 | state == 63
replace northeast = 1 if state == 9 | state == 25 | state == 33 | state == 34 | state == 36 | state == 42 | state == 44 | state == 61
replace midwest = 1 if state == 62  | state == 55 | state == 39 | state == 31 | state == 29 | state == 27 | state == 26 | state == 20 | state == 18 | state == 17
replace south = 1 if west == 0 & northeast == 0 & midwest == 0 & state != 0

gen west1995 = west
gen northeast1995 = northeast
gen midwest1995 = midwest
gen south1995 = south


drop west south midwest northeast 



/* Division of degree */
gen ba_newengland = 0
gen ba_midatlantic = 0
gen ba_eastnorthcentral = 0
gen ba_westnorthcentral = 0
gen ba_southatlantic = 0
gen ba_eastsouthcentral = 0
gen ba_westsouthcentral = 0
gen ba_mountain = 0
gen ba_pacific = 0


replace ba_newengland = 1 if state_ba_degree == 9 | state_ba_degree == 25 | state_ba_degree == 33  | state_ba_degree == 44 | state_ba_degree == 23 | state_ba_degree == 50 | state_ba_degree == 61
replace ba_midatlantic = 1 if state_ba_degree == 34 | state_ba_degree == 36 | state_ba_degree == 42
replace ba_eastnorthcentral = 1 if  state_ba_degree == 55 | state_ba_degree == 39 | state_ba_degree == 26 | state_ba_degree == 18 | state_ba_degree == 17
replace ba_westnorthcentral = 1 if state_ba_degree == 62 | state_ba_degree == 19 | state_ba_degree == 38 | state_ba_degree == 46 | state_ba_degree == 31| state_ba_degree == 20 | state_ba_degree == 29 | state_ba_degree == 27
replace ba_southatlantic = 1 if state_ba_degree == 10 | state_ba_degree == 11 | state_ba_degree == 24 | state_ba_degree == 54 | state_ba_degree == 51 | state_ba_degree == 37 | state_ba_degree == 45 | state_ba_degree == 12 | state_ba_degree == 13
replace ba_eastsouthcentral = 1 if state_ba_degree == 28 | state_ba_degree == 21 | state_ba_degree == 47 | state_ba_degree == 1
replace ba_westsouthcentral = 1 if state_ba_degree == 5 | state_ba_degree == 22 | state_ba_degree == 40 | state_ba_degree == 48
replace ba_mountain = 1 if state_ba_degree == 4 | state_ba_degree == 8 | state_ba_degree == 16 | state_ba_degree == 30 | state_ba_degree == 32 | state_ba_degree == 35 | state_ba_degree == 49 | state_ba_degree == 56
replace ba_pacific = 1 if state_ba_degree == 2 | state_ba_degree == 15 | state_ba_degree == 6 | state_ba_degree == 41 | state_ba_degree == 53

/* There are a few aggregated state variables for the early years that we can't tell which division they are in (e.g., "Mississippi and West Virginia"); these are small numbers of people */





/* Survey weights */
rename fnlwgt93 survey_weight1993
rename fnlwgt94 survey_weight1994

/* they don't give us a weight for 1995, so we use the 1994 weight */
gen survey_weigth1995 = survey_weight1994




/* Are you employed? */
/* How should I do this? I have 12 observations per year */
/* For now, what I do (also for occupation and industry and full-time) is take the middle months of the person's year */

gen employed1993 = 0
gen employed1994 = 0
gen employed1995 = 0


forvalues k=1(1)12 {
replace employed1993 = employed1993 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) | (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace employed1994 = employed1994 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) | (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & enrl_m`k' == 0 & rot == 1
}

forvalues k=25(1)36 {
replace employed1995 = employed1995 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) | (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & enrl_m`k' == 0 & rot == 1
}



forvalues k=4(1)15 {
replace employed1993 = employed1993 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) | (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace employed1994 = employed1994 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) | (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & enrl_m`k' == 0 & rot == 2
}

forvalues k=28(1)36 {
replace employed1995 = employed1995 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) | (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace employed1993 = employed1993 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) | (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace employed1994 = employed1994 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) | (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & enrl_m`k' == 0 & rot == 3
}

forvalues k=27(1)36 {
replace employed1995 = employed1995 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) | (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace employed1993 = employed1993 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) | (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace employed1994 = employed1994 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) | (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & enrl_m`k' == 0 & rot == 4
}

forvalues k=26(1)36 {
replace employed1995 = employed1995 + 1 if ((ws1_wk`k' >= 1 & ws1_wk`k' != .) | (ws2_wk`k' >= 1 & ws2_wk`k' != .)) & enrl_m`k' == 0 & rot == 4
}


sum employed*

replace employed1993 = employed1993 / (months_seen1993-months_enrolled1993)
replace employed1994 = employed1994 / (months_seen1994-months_enrolled1994)
replace employed1995 = employed1995 / (months_seen1995-months_enrolled1995)

sum employed*, d




/* Are you full-time? */

gen fulltime1993 = 0
gen fulltime1994 = 0
gen fulltime1995 = 0

forvalues k=1(1)12 {
replace fulltime1993 = fulltime1993 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 1
}

forvalues k=13(1)24 {
replace fulltime1994 = fulltime1994 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 1
}

forvalues k=25(1)36 {
replace fulltime1995 = fulltime1995 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 1
}


forvalues k=4(1)15 {
replace fulltime1993 = fulltime1993 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 2
}

forvalues k=16(1)27 {
replace fulltime1994 = fulltime1994 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 2
}

forvalues k=28(1)36 {
replace fulltime1995 = fulltime1995 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 2
}


forvalues k=3(1)14 {
replace fulltime1993 = fulltime1993 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 3
}

forvalues k=15(1)26 {
replace fulltime1994 = fulltime1994 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 3
}

forvalues k=27(1)36 {
replace fulltime1995 = fulltime1995 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 3
}


forvalues k=2(1)13 {
replace fulltime1993 = fulltime1993 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 4
}

forvalues k=14(1)25 {
replace fulltime1994 = fulltime1994 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 4
}

forvalues k=26(1)36 {
replace fulltime1995 = fulltime1995 + 1 if ((hours_job1_month`k' >= 30 & hours_job1_month`k' != .) | (hours_job2_month`k' >= 30 & hours_job2_month`k' != .)) & enrl_m`k' == 0 & rot == 4
}

sum fulltime*

replace fulltime1993 = fulltime1993 / (months_seen1993-months_enrolled1993)
replace fulltime1994 = fulltime1994 / (months_seen1994-months_enrolled1994)
replace fulltime1995 = fulltime1995 / (months_seen1995-months_enrolled1995)

sum employed*, d
sum fulltime*, d



/* OCCUPATION */
/* I use the 6th month occupation as the occupation. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace occ1_0`k' = . if occ1_0`k' == 0 | occ1_0`k' == 905
rename occ1_0`k' ws1_oc`k'
}

forvalues k=10(1)36 {
replace occ1_`k' = . if occ1_`k' == 0 | occ1_`k' == 905
rename occ1_`k' ws1_oc`k'

}


forvalues k=1(1)12 {
gen occ`k'_1993 = .
gen occ`k'_1994 = .
gen occ`k'_1995 = .
}

forvalues k=1(1)12 {
local j = `k'
replace occ`j'_1993 = ws1_oc`k' if rot == 1
}


forvalues k=13(1)24 {
local j = `k' - 12
replace occ`j'_1994 = ws1_oc`k' if rot == 1
}

forvalues k=25(1)36 {
local j = `k' - 24
replace occ`j'_1995 = ws1_oc`k' if rot == 1
}


forvalues k=4(1)15 {
local j = `k' - 3
replace occ`j'_1993 = ws1_oc`k' if rot == 2
}

forvalues k=16(1)27 {
local j = `k' - 15
replace occ`j'_1994 = ws1_oc`k' if rot == 2
}

forvalues k=28(1)36 {
local j = `k' - 27
replace occ`j'_1995 = ws1_oc`k' if rot == 2
}


forvalues k=3(1)14 {
local j = `k' - 2
replace occ`j'_1993 = ws1_oc`k' if rot == 3
}

forvalues k=15(1)26 {
local j = `k' - 14
replace occ`j'_1994 = ws1_oc`k' if rot == 3
}

forvalues k=27(1)36 {
local j = `k' - 26
replace occ`j'_1995 = ws1_oc`k' if rot == 3
}

forvalues k=2(1)13 {
local j = `k' - 1
replace occ`j'_1993 = ws1_oc`k' if rot == 4
}

forvalues k=14(1)25 {
local j = `k' - 13
replace occ`j'_1994 = ws1_oc`k' if rot == 4
}

forvalues k=26(1)36 {
local j = `k' - 25
replace occ`j'_1995 = ws1_oc`k' if rot == 4
}


/* INDUSTRY */
/* I use the 6th month industry as the industry. If that's missing, I use the 7th month. If both are missing, I leave it missing */

/* THESE ARE 1980 3-DIGIT CODES */
forvalues k=1(1)9 {
replace ind1_0`k' = . if ind1_0`k' == 0 | ind1_0`k' == 991
rename ind1_0`k' ws1_in`k'
}

forvalues k=10(1)36 {
replace ind1_`k' = . if ind1_`k' == 0 | ind1_`k' == 991
rename ind1_`k' ws1_in`k'
}


forvalues k=1(1)12 {
gen ind`k'_1993 = .
gen ind`k'_1994 = .
gen ind`k'_1995 = .
}

forvalues k=1(1)12 {
local j = `k'
replace ind`j'_1993 = ws1_in`k' if rot == 1
}


forvalues k=13(1)24 {
local j = `k' - 12
replace ind`j'_1994 = ws1_in`k' if rot == 1
}

forvalues k=25(1)36 {
local j = `k' - 24
replace ind`j'_1995 = ws1_in`k' if rot == 1
}


forvalues k=4(1)15 {
local j = `k' - 3
replace ind`j'_1993 = ws1_in`k' if rot == 2
}

forvalues k=16(1)27 {
local j = `k' - 15
replace ind`j'_1994 = ws1_in`k' if rot == 2
}

forvalues k=28(1)36 {
local j = `k' - 27
replace ind`j'_1995 = ws1_in`k' if rot == 2
}


forvalues k=3(1)14 {
local j = `k' - 2
replace ind`j'_1993 = ws1_in`k' if rot == 3
}

forvalues k=15(1)26 {
local j = `k' - 14
replace ind`j'_1994 = ws1_in`k' if rot == 3
}

forvalues k=27(1)36 {
local j = `k' - 26
replace ind`j'_1995 = ws1_in`k' if rot == 3
}

forvalues k=2(1)13 {
local j = `k' - 1
replace ind`j'_1993 = ws1_in`k' if rot == 4
}

forvalues k=14(1)25 {
local j = `k' - 13
replace ind`j'_1994 = ws1_in`k' if rot == 4
}

forvalues k=26(1)36 {
local j = `k' - 25
replace ind`j'_1995 = ws1_in`k' if rot == 4
}

drop *month*

bysort rot: sum ind* occ*



/* Identifying variables */
keep *1993 *1994 *1995 rot pp_id pp_entry pp_pnum u_brthyr state_ba* ba_*

rename pp_id su_id

destring su_id, replace
destring pp_entry, replace
destring pp_pnum, replace

sort su_id pp_entry pp_pnum
compress
save Temp/sipp93_full_cleaned.dta, replace


*************************************************************************************8

clear

use Temp/sipp93wave2.dta


/**** WAVE 2 DATASET ****/



/* Identifiers */
rename id su_id
rename entry pp_entry 
rename pnum pp_pnum 

destring su_id, replace
destring pp_entry, replace
destring pp_pnum, replace

sum su_id pp_entry pp_pnum



/********** COLLEGE DEGREE INFORMATION *********/

/* 2 questions: highest degree and BA degree. Need to check both */

/* Need year of degree, age at degree, and field of degree. Also need highest degree completed */


gen col = 0
gen morcol = 0
gen hgc = .

replace hgc = 12 if tm8422 == 0 | tm8422 == -1 | tm8422 == 7
replace hgc = 14 if tm8422 == 6 | tm8422 == 5
replace hgc = 16 if tm8422 == 4
replace hgc = 18 if tm8422 == 3
replace hgc = 19 if tm8422 == 2
replace hgc = 20 if tm8422 == 1
replace hgc = 10 if tm8408 == 2 // 2 means did not grad HS in 93 SIPP 

tab hgc, mi

replace col = 1 if hgc == 16
replace morcol = 1 if hgc > 16

tab col morcol


gen gradyear = .

replace tm8426 = . if tm8426 <= 0
replace tm8434 = . if tm8434 <= 0

replace gradyear = tm8426 if hgc == 16

replace gradyear = tm8434 if gradyear == .

tab gradyear


/* Field of bachelor's degree */

rename tm8428 major_field
replace major_field = . if major_field == 0

tab major_field, mi





keep hgc major_field gradyear col morcol su_id pp_entry pp_pnum


sort su_id pp_entry pp_pnum



merge su_id pp_entry pp_pnum using Temp/sipp93_full_cleaned.dta

tab _merge
drop _merge


gen age_grad = .

replace age_grad = gradyear - u_brthyr

tab age_grad


egen pid=group(su_id pp_entry pp_pnum)
*bysort su_id pp_entry pp_pnum: gen pid = _n

drop su_id pp_entry pp_pnum

drop earnings_job* earnings_se* u_brth*

drop year1993 year1994


reshape long total_hours survey_weight age male hispanic black earnings_annual hrlypay hrlypayv1 hrlypayv2 enrolled west northeast midwest south employed fulltime occ1_ occ2_ occ3_ occ4_ occ5_ occ6_ occ7_ occ8_ occ9_ occ10_ occ11_ occ12_ ind1_ ind2_ ind3_ ind4_ ind5_ ind6_ ind7_ ind8_ ind9_ ind10_ ind11_ ind12_, i(pid) j(year)


forvalues k=1(1)12 {
rename occ`k'_ occ`k'
rename ind`k'_ ind`k'
}

* keep if age >= 22

* keep if major_field != .
tab major_field, mi
tab major_field if hgc == 16
tab gradyear
gen potexp = year - gradyear
tab potexp

tab gradyear potexp if hgc == 16 & potexp <= 13

sum

gen panel = 1993
gen survey = 9091

sort pid
compress
save Temp/sipp93_ready.dta, replace








/* NOW WE COMBINE THE YEARS */








use Temp/sipp84_ready.dta

append using Temp/sipp86_ready.dta

append using Temp/sipp87_ready.dta

append using Temp/sipp88_ready.dta

append using Temp/sipp90_ready.dta

append using Temp/sipp91_ready.dta

append using Temp/sipp92_ready.dta

append using Temp/sipp93_ready.dta


tab gradyear potexp

tab gradyear potexp if earnings_annual > 500

tab survey



/* 1984-1992 occupation and industry codes are in 1980 form, need to put in 1990 form */
forvalues k=1(1)12 {
gen occ80 = occ`k'
replace occ80 = . if panel == 1993

rename occ`k' occ90
rename occ80 occ`k'

rename occ`k' occ
sort occ

merge m:1 occ using Crosswalks/occ80_to_occ90.dta
tab _merge
drop _merge

drop occ
gen occ`k' = .
replace occ`k' = occ1990 if panel < 1993
replace occ`k' = occ90 if panel == 1993
drop occ1990 occ90

replace occ`k' = . if occ`k' == 999

bysort panel: sum occ`k'
}



forvalues k=1(1)12 {
gen ind80 = ind`k'
replace ind80 = . if panel == 1993

rename ind`k' ind90
rename ind80 ind`k'

rename ind`k' ind
sort ind

merge m:1 ind using Crosswalks/ind80_to_ind90.dta
tab _merge
drop _merge

drop ind
gen ind`k' = .
replace ind`k' = ind1990 if panel < 1993
replace ind`k' = ind90 if panel == 1993
drop ind1990 ind90

replace ind`k' = . if ind`k' == 999

bysort panel: sum ind`k'
}




/* Deflating to 1982-84 dollars */
replace earnings_annual = earnings_annual / 1.039 if year == 1984
replace earnings_annual = earnings_annual / 1.076 if year == 1985
replace earnings_annual = earnings_annual / 1.096 if year == 1986
replace earnings_annual = earnings_annual / 1.136 if year == 1987
replace earnings_annual = earnings_annual / 1.183 if year == 1988
replace earnings_annual = earnings_annual / 1.240 if year == 1989
replace earnings_annual = earnings_annual / 1.307 if year == 1990
replace earnings_annual = earnings_annual / 1.362 if year == 1991
replace earnings_annual = earnings_annual / 1.403 if year == 1992
replace earnings_annual = earnings_annual / 1.445 if year == 1993
replace earnings_annual = earnings_annual / 1.482 if year == 1994
replace earnings_annual = earnings_annual / 1.524 if year == 1995


replace hrlypay = hrlypay / 1.039 if year == 1984
replace hrlypay = hrlypay / 1.076 if year == 1985
replace hrlypay = hrlypay / 1.096 if year == 1986
replace hrlypay = hrlypay / 1.136 if year == 1987
replace hrlypay = hrlypay / 1.183 if year == 1988
replace hrlypay = hrlypay / 1.240 if year == 1989
replace hrlypay = hrlypay / 1.307 if year == 1990
replace hrlypay = hrlypay / 1.362 if year == 1991
replace hrlypay = hrlypay / 1.403 if year == 1992
replace hrlypay = hrlypay / 1.445 if year == 1993
replace hrlypay = hrlypay / 1.482 if year == 1994
replace hrlypay = hrlypay / 1.524 if year == 1995


replace hrlypayv1 = hrlypayv1 / 1.039 if year == 1984
replace hrlypayv1 = hrlypayv1 / 1.076 if year == 1985
replace hrlypayv1 = hrlypayv1 / 1.096 if year == 1986
replace hrlypayv1 = hrlypayv1 / 1.136 if year == 1987
replace hrlypayv1 = hrlypayv1 / 1.183 if year == 1988
replace hrlypayv1 = hrlypayv1 / 1.240 if year == 1989
replace hrlypayv1 = hrlypayv1 / 1.307 if year == 1990
replace hrlypayv1 = hrlypayv1 / 1.362 if year == 1991
replace hrlypayv1 = hrlypayv1 / 1.403 if year == 1992
replace hrlypayv1 = hrlypayv1 / 1.445 if year == 1993
replace hrlypayv1 = hrlypayv1 / 1.482 if year == 1994
replace hrlypayv1 = hrlypayv1 / 1.524 if year == 1995


replace hrlypayv2 = hrlypayv2 / 1.039 if year == 1984
replace hrlypayv2 = hrlypayv2 / 1.076 if year == 1985
replace hrlypayv2 = hrlypayv2 / 1.096 if year == 1986
replace hrlypayv2 = hrlypayv2 / 1.136 if year == 1987
replace hrlypayv2 = hrlypayv2 / 1.183 if year == 1988
replace hrlypayv2 = hrlypayv2 / 1.240 if year == 1989
replace hrlypayv2 = hrlypayv2 / 1.307 if year == 1990
replace hrlypayv2 = hrlypayv2 / 1.362 if year == 1991
replace hrlypayv2 = hrlypayv2 / 1.403 if year == 1992
replace hrlypayv2 = hrlypayv2 / 1.445 if year == 1993
replace hrlypayv2 = hrlypayv2 / 1.482 if year == 1994
replace hrlypayv2 = hrlypayv2 / 1.524 if year == 1995



/* Merging in occbeta */
/* We will redo this later */

forvalues k=1(1)12 {
rename occ`k' occ1990
sort occ1990

merge m:1 occ1990 using Crosswalks/occupation_betas_and_scores.dta

rename occbeta occbeta`k'
tab _merge
drop _merge

rename occ1990 occ`k'
}

sum occbeta*



/* Getting an occbeta measure for the entire year */

/* First, I need the # of non-missing occbeta observations we have for each year */
gen occ_count = 0
forvalues k=1(1)12 {
replace occ_count = occ_count + 1 if occbeta`k' != .
}

gen total_occbeta = 0
forvalues k=1(1)12 {
replace total_occbeta = total_occbeta + occbeta`k' if occbeta`k' != .
}

gen occbeta = total_occbeta / occ_count

tab occ_count

drop occ_count total_occbeta occbeta1* occbeta2 occbeta3 occbeta4 occbeta5 occbeta6 occbeta7 occbeta8 occbeta9

sum occbeta






gen lnearnings = ln(earnings_annual)
gen lnpay = ln(hrlypay)
gen lnpay1 = ln(hrlypayv1)
gen lnpay2 = ln(hrlypayv2)

gen potexp2 = potexp^2


rename year bob
rename gradyear year
sort year

/*
tab hgc, mi
merge m:1 year using Crosswalks/unemployment_rates_national.dta
drop if _merge != 3
tab hgc, mi
*/

* rename urate_natl urate_grad
rename year gradyear
rename bob year


rename major_field major_field_84to93


keep *earnings* occ1 occ2 occ3 occ4 occ5 occ6 occ7 occ8 occ9 occ10 occ11 occ12 age_grad survey_weight ba_* state_ba_degree total_hours *pay* pid year major_field_84to93 col morcol hgc gradyear age male black hispanic potexp* enrolled employed occbeta fulltime northeast south midwest west survey panel

tab hgc, mi

compress
save Temp/sipp84to93_ready.dta, replace
!gzip -f Temp/sipp84to93_ready.dta

log close

*********************
