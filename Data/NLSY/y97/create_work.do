gen wage    = .
gen hours   = .
gen occ     = .
gen ind     = .
gen selfemp = .
forvalues x=1/13 {
    qui replace wage    = Hrly_comp_Job`x'_    if Main_job==`x'
    qui replace wage    = Hrly_wage_Job`x'_    if Main_job==`x' & mi(Hrly_comp_Job`x'_)
    qui replace hours   = Hrs_per_week_Job`x'_ if Main_job==`x'
    qui replace occ     = Job`x'_Occupation    if Main_job==`x'
    qui replace ind     = Job`x'_Industry      if Main_job==`x'
    qui replace selfemp = Job`x'_self_employed if Main_job==`x'
}

qui replace wage    = .n if Interview_date==.n
qui replace hours   = .n if Interview_date==.n
qui replace occ     = .n if Interview_date==.n
qui replace ind     = .n if Interview_date==.n
qui replace selfemp = .n if Interview_date==.n
qui replace wage    = .  if mi(hours)
qui replace occ     = .  if mi(hours)
qui replace ind     = .  if mi(hours)
qui replace selfemp = .  if mi(hours)

* Deflate wages
qui generat wagereal = wage/(100*cpi)

* top- and bottom-code wages at $2 and $100
local top_limit 100
local bot_limit 2
sum wagereal, d
qui replace wagereal = `top_limit' if wagereal>=`top_limit' & ~mi(wagereal)
qui replace wagereal = `bot_limit' if wagereal<=`bot_limit' & ~mi(wagereal)
sum wagereal, d

* create log wage
qui generat lnwage = ln(wagereal)
qui replace lnwage = occ if lnwage>=. & occ>=.

* Work experience
ren Tot_Weeks_Worked_all wksWorkLastYr
generat empFT = inrange(wksWorkLastYr,40.01,.) & inrange(hours,34.01,.)
generat empPT = (inrange(wksWorkLastYr,0,40) & inrange(hours,0,.)) | (inrange(hours,0,34) & inrange(wksWorkLastYr,0,.))
replace empFT = . if mi(hours)
replace empPT = . if mi(hours)
bys id (year): generat exper = sum(L.empFT)+.5*sum(L.empPT)
l id year wksWorkLastYr hours empFT empPT exper in 1/100, sepby(id)

lab var lnwage   "Log hourly wage, in 1982-84 $"
lab var exper    "Work experience (cum. # years 40+ weeks worked)"
lab var hours    "Usual hours per week at main job"
lab var occ      "Occupation of main job"
lab var ind      "Industry of main job"
lab var selfemp  "Dummy for whether main job is self-employed"

** Variables to keep:
global keeperwork lnwage exper hours empPT empFT occ ind hours* occ* wage* selfemp wksWorkLastYr
