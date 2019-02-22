* Highest grade completed
gen hgc = high_grade_comp_May

gen grad4yr  = hgc>=16 & ~mi(hgc)
gen gradGrad = inlist(high_deg_recd,5,6,7)

bys id (year): egen maxged = max(diploma_or_ged)
gen ged = inlist(maxged,2,3)

gen gradHS  = (hgc>=12 & ~mi(hgc)) | ged

replace gradHS   = .n if !mi(reason_noninterview)
replace grad4yr  = .n if !mi(reason_noninterview)
replace gradGrad = .n if !mi(reason_noninterview)

lab var hgc            "Highest Grade Completed (years)"
lab var ged            "Holds a GED"
lab var gradHS         "Absorbing indicator for HS graduation (or GED)"
lab var grad4yr        "Absorbing indicator for 4-year college graduation"
lab var gradGrad       "Absorbing indicator for earning graduate degree"

generat enrolled = inlist(enroll_status_svy,2,3)
replace enrolled = 0  if year>2006
replace enrolled = .n if !mi(reason_noninterview)

** Variables to keep:
global keeperschool hgc ged gradHS grad4yr gradGrad enrolled
