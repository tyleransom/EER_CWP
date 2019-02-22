* Highest grade completed
gen hgc = Highest_Grade_Completed
recode hgc (95 = .)

generat grad4yr  = hgc>=16 & ~mi(hgc)
replace grad4yr  = . if mi(hgc)

gen ged = Months_to_GED<.

generat gradHS   = (hgc>=12 & ~mi(hgc)) | ged
replace gradHS   = . if mi(hgc)

generat gradGrad = inlist(Highest_degree_ever,5,6,7)
replace gradGrad = . if mi(Highest_degree_ever)

replace gradHS   = .n if Interview_date==.n
replace gradHS   = .  if Interview_date==. 
replace grad4yr  = .n if Interview_date==.n
replace grad4yr  = .  if Interview_date==. 
replace gradGrad = .n if Interview_date==.n
replace gradGrad = .  if Interview_date==. 

lab var hgc            "Highest Grade Completed (years)"
lab var ged            "Holds a GED"
lab var gradHS         "Absorbing indicator for HS graduation (or GED)"
lab var grad4yr        "Absorbing indicator for 4-year college graduation"
lab var gradGrad       "Absorbing indicator for earning graduate degree"

* Enrollment status at time of interview
generat enrolled =  0
replace enrolled =  1 if month(dofm(Interview_date))==1  & (School_Enrollment_Status_Jan==2 | inrange(College_enrollment_Jan,2,4))
replace enrolled =  1 if month(dofm(Interview_date))==2  & (School_Enrollment_Status_Feb==2 | inrange(College_enrollment_Feb,2,4))
replace enrolled =  1 if month(dofm(Interview_date))==3  & (School_Enrollment_Status_Mar==2 | inrange(College_enrollment_Mar,2,4))
replace enrolled =  1 if month(dofm(Interview_date))==4  & (School_Enrollment_Status_Apr==2 | inrange(College_enrollment_Apr,2,4))
replace enrolled =  1 if month(dofm(Interview_date))==5  & (School_Enrollment_Status_May==2 | inrange(College_enrollment_May,2,4))
replace enrolled =  1 if month(dofm(Interview_date))==6  & (School_Enrollment_Status_Jun==2 | inrange(College_enrollment_Jun,2,4))
replace enrolled =  1 if month(dofm(Interview_date))==7  & (School_Enrollment_Status_Jul==2 | inrange(College_enrollment_Jul,2,4))
replace enrolled =  1 if month(dofm(Interview_date))==8  & (School_Enrollment_Status_Aug==2 | inrange(College_enrollment_Aug,2,4))
replace enrolled =  1 if month(dofm(Interview_date))==9  & (School_Enrollment_Status_Sep==2 | inrange(College_enrollment_Sep,2,4))
replace enrolled =  1 if month(dofm(Interview_date))==10 & (School_Enrollment_Status_Oct==2 | inrange(College_enrollment_Oct,2,4))
replace enrolled =  1 if month(dofm(Interview_date))==11 & (School_Enrollment_Status_Nov==2 | inrange(College_enrollment_Nov,2,4))
replace enrolled =  1 if month(dofm(Interview_date))==12 & (School_Enrollment_Status_Dec==2 | inrange(College_enrollment_Dec,2,4))
replace enrolled = .n if !mi(reason_noninterview)

** Variables to keep:
global keeperschool hgc ged gradHS grad4yr gradGrad enrolled
