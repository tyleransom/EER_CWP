***************************************************
* Generate various demographic variables
***************************************************


* age
genera now_1997 = (1997-1960)*12
genera DOB = (birth_year-1960)*12+birth_month-1
format now_1997 %tm
format DOB %tm
genera age_cts = (now_1997-DOB)/12
genera age     = year-birth_year-1
genera birthq  = 1*inrange(birth_month,1,3)+2*inrange(birth_month,4,6)+3*inrange(birth_month,7,9)+4*inrange(birth_month,10,12)
genera birthmo = birth_month
genera birthyr = birth_year

* parental education
recode  Bio_father_highest_educ (95 = .)
recode  Bio_mother_highest_educ (95 = .)
rename  Bio_mother_highest_educ hgcMoth
generat m_hgcMoth = mi(hgcMoth)
replace hgcMoth = 0 if mi(hgcMoth)
rename  Bio_father_highest_educ hgcFath
generat m_hgcFath = mi(hgcFath)
replace hgcFath = 0 if mi(hgcFath)
label var m_hgcMoth "MISSING MOTHER'S HGC"
label var m_hgcFath "MISSING FATHER'S HGC"

* Fix AFQT variables
generat m_afqt = mi(afqt)
replace afqt   = 0 if mi(afqt)
foreach var in AR CS MK NO PC WK {
    generat m_asvab`var' = mi(asvab`var')
    replace asvab`var' = 0 if mi(asvab`var')
}

* Check all missings accounted for
foreach V in hgcMoth hgcFath afqt asvabAR asvabCS asvabMK asvabNO asvabPC asvabWK {
    assert !missing( `V')
    count if m_`V'
    assert r(N)~=0
}

* foreignBorn
bys id: egen born_here = mean(Born_in_US)
replace born_here=1 if born_here>0 & born_here<1
generat foreignBorn = 1-born_here
drop    born_here

* race
gen black    = race_ethnicity==1
gen hispanic = race_ethnicity==2
gen mixed    = race_ethnicity==3
gen white    = race_ethnicity==4 & race==1
gen asian    = race_ethnicity==4 & race!=1
capture drop race
gen race     = 1 if white
replace race = 2 if black
replace race = 3 if hispanic
replace race = 4 if asian
replace race = 5 if mixed
assert race != 0
lab var white "WHITE"
lab var black "BLACK"
lab var hispanic "HISPANIC"
lab var mixed "MIXED"
lab var asian "ASIAN"
lab var race "RACE"
lab def vlracefinal 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian" 5 "Mixed"
lab val race vlracefinal

* female
gen female = sex==2
label var female "FEMALE"

* birth cohorts
gen     born1980 = birthyr==1980
gen     born1981 = birthyr==1981
gen     born1982 = birthyr==1982
gen     born1983 = birthyr==1983
gen     born1984 = birthyr==1984
lab var born1980 "BIRTH COHORT DUMMY 1980"
lab var born1981 "BIRTH COHORT DUMMY 1981"
lab var born1982 "BIRTH COHORT DUMMY 1982"
lab var born1983 "BIRTH COHORT DUMMY 1983"
lab var born1984 "BIRTH COHORT DUMMY 1984"

* live with mom at 14
generat      true_rel_HH_headA = Relationship_HH_head if year==1997
replace      true_rel_HH_headA = min(Relationship_to_Par_age12_, Relationship_HH_head) if (mi(Relationship_HH_head) | mi(Relationship_to_Par_age12_)) & year==1997 & Relationship_HH_head~=Relationship_to_Par_age12_
bys id: egen true_rel_HH_head  = mean(true_rel_HH_headA)
drop         true_rel_HH_headA
lab val      true_rel_HH_head vl_relPar
generat liveWithMom14 = inlist(true_rel_HH_head,1,2,4)
label var liveWithMom14  "LIVE WITH MOTHER AT AGE 14"
generat femaleHeadHH14 = true_rel_HH_head==4
label var femaleHeadHH14 "FEMALE HEADED HOUSEHOLD AT AGE 14"


* deflate family income

* Grab family income from parent supplement (for round 2, since it's missing at high rates in rounds 3-5)
egen    Family_income_alt = rowtotal(parIncome parSpIncome parSpOthIncome), mi
replace Family_income_alt = .n if Family_income==.n
replace Family_income_alt = .d if Family_income==.d
replace Family_income_alt = .i if Family_income==.i
replace Family_income_alt = .r if Family_income==.r
replace Family_income_alt = .v if Family_income==.v

* Family income in survey round 1
generat FincTest96 = Family_income if year==1996
replace FincTest96 = FincTest96/cpi 
bys id: egen famIncTest96 = mean(FincTest96)

* Parent supplement reported income in survey round 2
generat FincAltTest97 = Family_income_alt if year==1997
replace FincAltTest97 = FincAltTest97/cpi 
bys id: egen famIncAltTest97 = mean(FincAltTest97)

* Parent supplement reported income in survey round 3
generat FincAltTest98 = Family_income_alt if year==1998
replace FincAltTest98 = FincAltTest98/cpi 
bys id: egen famIncAltTest98 = mean(FincAltTest98)

* Parent supplement reported income in survey round 4
generat FincAltTest99 = Family_income_alt if year==1999
replace FincAltTest99 = FincAltTest99/cpi 
bys id: egen famIncAltTest99 = mean(FincAltTest99)

* Parent supplement reported income in survey round 4
generat FincAltTest00 = Family_income_alt if year==2000
replace FincAltTest00 = FincAltTest00/cpi 
bys id: egen famIncAltTest00 = mean(FincAltTest00)

* Pre-college family income = survey round 1 income OR round 2 parent supplement reported income if missing round 1 data
generat famIncAsTeen = famIncTest96
replace famIncAsTeen = famIncAltTest97 if mi(famIncAsTeen)
replace famIncAsTeen = famIncAltTest98 if mi(famIncAsTeen)
replace famIncAsTeen = famIncAltTest99 if mi(famIncAsTeen)
replace famIncAsTeen = famIncAltTest00 if mi(famIncAsTeen)

* Express in logs and 1000s of dollars
replace famIncAsTeen = 1 if famIncAsTeen<=0
generat lnfamIncAsTeen = ln(famIncAsTeen)
replace famIncAsTeen = famIncAsTeen/1000

generat m_famIncAsTeen=(famIncAsTeen>=.)
replace famIncAsTeen = 0 if m_famIncAsTeen==1
lab var famIncAsTeen   "FAMILY INCOME IN 1978, 1000's of 1982-4 $"
lab var lnfamIncAsTeen "LOG FAMILY INCOME IN 1978, 1982-4 $"
lab var m_famIncAsTeen "MISSING FAMILY INCOME IN 1978"

* weights
replace weight_panel = . if year~=1997
bys id: egen svywgt  = mean(weight_panel)
drop weight_panel

*============================================================================
* missed interviews
* variables that flag if the year is missing, how long the missing has 
*  gone on, how long the missing lasts, and if it's the last missing spell
*  Also, variables that list whether the element is the first after a spell
*  and the last year of data before the spell.
*============================================================================
generat Interview_date = Int_month+239 // add 239 to convert from NLSY base month (Dec 1979) to Stata base month (Jan 1960)
format  Interview_date %tm
replace Interview_date = .n if Int_month==.n

foreach x of numlist 1/17 {
    if (`x'<=15) {
        local temp=`x'+17
    }
    else if (`x'==16) {
        local temp=`x'+18
    }
    else if (`x'==17) {
        local temp=`x'+19
    }
    bys id: gen R`x'interviewDate  = Interview_date[`temp']
    bys id: gen R`x'interviewDay   = mdy(InterviewM[`temp'],InterviewD[`temp'],InterviewY[`temp'])
    bys id: gen R`x'interviewWeek  = wofd(mdy(InterviewM[`temp'],InterviewD[`temp'],InterviewY[`temp']))
    format R`x'interviewDate %tm
    format R`x'interviewDay  %td
    format R`x'interviewWeek %tw
}
gen flag1 = yofd(dofm(R1interviewDate)) ==1998 // create flag for imputing schooling before first interview
gen flag2 = yofd(dofm(R17interviewDate))==2016 // create flag for dropping observations after last interview

gen Interview_day                           = mdy(InterviewM,InterviewD,InterviewY)
gen Interview_month                         = month(dofm(Interview_date))
replace Interview_month                     = .n if Interview_date==.n
replace Interview_month                     = .  if Interview_date==.

gen miss_interview                          = (Interview_date==.n)
clonevar missInt = miss_interview
bys id: egen miss_interview_dumB            = mean(miss_interview)
gen ever_miss_interview                     = (miss_interview_dumB > 0)
drop miss_interview_dumB

gen age_at_miss_int                         = age*miss_interview
gen year_miss_int                           = year*miss_interview

bys id (year): egen yrFirstMissInt = min(year_miss_int) if year_miss_int>0
bys id (year): egen yrFirstMissIntFull = mean(yrFirstMissInt)
gen         missIntEverBefore = year>=yrFirstMissIntFull

gen miss_interview_cum                      = 0
by id: replace miss_interview_cum           = miss_interview_cum[_n-1] + 1 if miss_interview[_n]==1 & year[_n]<=2011
by id: replace miss_interview_cum           = miss_interview_cum[_n-2] + 1 if miss_interview[_n]==1 & inlist(year[_n],2013,2015)
clonevar missIntCum = miss_interview_cum

gsort +id -year
gen miss_interview_length                   = miss_interview_cum
by id: replace miss_interview_length        = miss_interview_length[_n-1] if miss_interview_cum[_n]!=0 & miss_interview_cum[_n-1]!=0 & year~=2014

sort id year
* create flag for long missed interview spell
generate year_first_long_spellA             = year*(miss_interview_length>2)
replace  year_first_long_spellA             = . if year_first_long_spellA==0
bys id (year): egen year_first_long_spell   = min(year_first_long_spellA)
drop year_first_long_spellA
gen long_miss_flag                          = year>=year_first_long_spell

* create flag for any missed interview spell
generate year_first_short_spellA             = year*(miss_interview_length>0)
replace  year_first_short_spellA             = . if year_first_short_spellA==0
bys id (year): egen year_first_short_spell   = min(year_first_short_spellA)
drop year_first_short_spellA
gen short_miss_flag                          = year>=year_first_short_spell

gsort +id -year
gen miss_interview_last_spell               = 0
by id: replace miss_interview_last_spell    = 1 if miss_interview_cum[_n]!=0 & ( (year==2015 & ~flag2) | miss_interview_last_spell[_n-1]==1)
sort id year
label var miss_interview            "Missed Interview In Current Year"
label var miss_interview_cum        "Running Tally Of Current Missed Interview Spell"
label var miss_interview_length     "Length Of Current Missed Interview Spell"
label var miss_interview_last_spell "Element Of Last Missed Interview Spell"

* identify right-censored interview spells -- no one in 2016 should enter the data (since they are all interviewed before October)
generat not_missing_interview               = 1-miss_interview if year<2016
replace not_missing_interview               = 0 if year==2016 & R17interviewDate>=ym(2016,1 ) // don't use 2016 data for anyone interviewed in 2016, since no one in R16 was interviewed after Jul 2016
* replace not_missing_interview               = 0 if year==2015 & R15interviewDate< ym(2015,10) // we don't have data on those interviewed in R16 before Oct 2015 for latest round
generat nonmissing_int_year                 = year*not_missing_interview
bys id (year): egen max_nonmissing_int_year = max(nonmissing_int_year)
generat missIntLastSpell                    = (year>max_nonmissing_int_year)

* interview month of last survey year (either the last year before a 3+ missed spell, the last year before a right-censored spell, or 2015)
generat last_survey_yearA                   = year_first_long_spell-1 if year==year_first_long_spell
replace last_survey_yearA                   = max_nonmissing_int_year if year==2015

generat last_survey_year_hastyA             = year_first_short_spell-1 if year==year_first_short_spell
replace last_survey_year_hastyA             = max_nonmissing_int_year if year==2015

bys id (year): egen last_survey_year        = min(last_survey_yearA)
bys id (year): egen last_survey_year_hasty  = min(last_survey_year_hastyA)

by id: gen     lastValidInt           = last_survey_year

gen            temp_date              = mdy(InterviewM,InterviewD,InterviewY) if year==lastValidInt
by id: egen    lastValidIntDate       = max(temp_date)
format         lastValidIntDate %td
drop           temp_date


gen last_int_dayA                           = Interview_day if year==last_survey_year
bys id (year): egen last_int_day            = mean(last_int_dayA)
format last_int_day %td



*--------------------------------------------------------------------------------
* Some summary stats on people's missing interview behavior throughout the survey
*--------------------------------------------------------------------------------
* get proportion of people who ever missed any number of consecutive interviews
foreach x of numlist 1/14 {
    by id: gen miss_`x'_intA  = (miss_interview_length==`x')
}
foreach x of numlist 1/14 {
    by id: egen miss_`x'_intB  = mean(miss_`x'_intA )
}
foreach x of numlist 1/14 {
    by id: gen ever_miss_`x'_int  = (miss_`x'_intB >0)
}
drop miss_*intA miss_*intB

gen ever_miss_3plus_int = ((ever_miss_3_int)|(ever_miss_4_int)|(ever_miss_5_int)|(ever_miss_6_int)|(ever_miss_7_int)|(ever_miss_8_int)|(ever_miss_9_int)|(ever_miss_10_int)|(ever_miss_11_int)|(ever_miss_12_int))

* get proportion of people who return after missing any number of consecutive interviews
foreach x of numlist 1/14 {
    by id: gen return_after_`x'_miss_intA  = (miss_interview_length[_n-1]==`x'  & miss_interview_length[_n]==0)
}
foreach x of numlist 1/14 {
    by id: egen return_after_`x'_miss_intB  = mean(return_after_`x'_miss_intA )
}
foreach x of numlist 1/14 {
    by id: gen ever_return_after_`x'_miss_int  = (return_after_`x'_miss_intB >0)
}
drop return_after*A return_after*B

gen ever_return_after_3plus_miss_int = ((ever_return_after_3_miss_int)|(ever_return_after_4_miss_int)|(ever_return_after_5_miss_int)|(ever_return_after_6_miss_int)|(ever_return_after_7_miss_int)|(ever_return_after_8_miss_int)|(ever_return_after_9_miss_int)|(ever_return_after_10_miss_int)|(ever_return_after_11_miss_int)|(ever_return_after_12_miss_int)|(ever_return_after_13_miss_int))

* Count number of people who have multiple missing interview spells lasting different lengths
foreach x of numlist 1/14 {
    count if ever_return_after_1_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 2/14 {
    count if ever_return_after_2_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 3/14 {
    count if ever_return_after_3_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 4/14 {
    count if ever_return_after_4_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 5/14 {
    count if ever_return_after_5_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 6/14 {
    count if ever_return_after_6_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 7/14 {
    count if ever_return_after_7_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 8/14 {
    count if ever_return_after_8_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 9/14 {
    count if ever_return_after_9_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 10/14 {
    count if ever_return_after_10_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 11/14 {
    count if ever_return_after_11_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 12/14 {
    count if ever_return_after_12_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 13/14 {
    count if ever_return_after_13_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}

foreach x of numlist 1/14 {
    sum ever_return_after_`x'_miss_int if ever_miss_`x'_int==1 & year==1997
}

sum ever_return_after_3plus_miss_int if ever_miss_3plus_int==1 & year==1997

tab age_at_miss_int            if age_at_miss_int>0, mi
tab age_at_miss_int birth_year if age_at_miss_int>0, mi col nofreq
tab year_miss_int              if year_miss_int>0, mi // show momentary interview missers
tab last_survey_year           if  year==2015 // show cumulative attrition in our sample (either because of permanent attrition from NLSY or having missed 3+ interviews)
tab last_survey_year_hasty     if  year==2015 // show cumulative attrition in our sample if we never made use of backfilled observations
tab max_nonmissing_int_year    if year==2015 // show cumulative attrition in our sample if we always used backfilled obs (i.e. if we kept super-long missed spells)

lab var birthq  "Quarter of birth"
lab var birthmo "Month of birth"
lab var birthyr "Year of birth"

** Variables to keep:
global keeperdemog id year svyRound age birthq birthmo birthyr hgcMoth m_hgcMoth m_hgcFath hgcFath asvab* m_asvab* afqt m_afqt famIncAsTeen lnfamIncAsTeen m_famIncAsTeen svywgt *iss* lastValid* foreignBorn black hispanic white asian mixed race female born* liveWithMom14 femaleHeadHH14
