* Import, rename, reshape, recode and label the schooling variables

infile using school.dct, clear

****************
* Rename
****************

rename R0000100 id
rename R0015600 enroll_current1979
rename R0015700 grade_current1979
rename R0017300 high_grade_comp_raw1979
rename R0018300 diploma_or_ged1979
rename R0216701 high_grade_comp_May1979
rename R0228500 enroll_current1980
rename R0228600 grade_current1980
rename R0229200 high_grade_comp_raw1980
rename R0230000 diploma_or_ged1980
rename R0406401 high_grade_comp_May1980
rename R0414800 enroll_status_Jan_prev1981
rename R0414900 enroll_status_Feb_prev1981
rename R0415000 enroll_status_Mar_prev1981
rename R0415100 enroll_status_Apr_prev1981
rename R0415200 enroll_status_May_prev1981
rename R0415300 enroll_status_Jun_prev1981
rename R0415400 enroll_status_Jul_prev1981
rename R0415500 enroll_status_Aug_prev1981
rename R0415600 enroll_status_Sep_prev1981
rename R0415700 enroll_status_Oct_prev1981
rename R0415800 enroll_status_Nov_prev1981
rename R0415900 enroll_status_Dec_prev1981
rename R0416000 enroll_status_Jan_curr1981
rename R0416100 enroll_status_Feb_curr1981
rename R0416200 enroll_status_Mar_curr1981
rename R0416300 enroll_status_Apr_curr1981
rename R0416400 enroll_status_May_curr1981
rename R0416500 enroll_status_Jun_curr1981
rename R0416600 enroll_status_Jul_curr1981
rename R0416700 enroll_status_Aug_curr1981
rename R0416800 enroll_current1981
rename R0416900 grade_current1981
rename R0417400 high_grade_comp_raw1981
rename R0418200 diploma_or_ged1981
rename R0618901 high_grade_comp_May1981
rename R0661900 enroll_status_Jan_prev1982
rename R0662000 enroll_status_Feb_prev1982
rename R0662100 enroll_status_Mar_prev1982
rename R0662200 enroll_status_Apr_prev1982
rename R0662300 enroll_status_May_prev1982
rename R0662400 enroll_status_Jun_prev1982
rename R0662500 enroll_status_Jul_prev1982
rename R0662600 enroll_status_Aug_prev1982
rename R0662700 enroll_status_Sep_prev1982
rename R0662800 enroll_status_Oct_prev1982
rename R0662900 enroll_status_Nov_prev1982
rename R0663000 enroll_status_Dec_prev1982
rename R0663100 enroll_status_Jan_curr1982
rename R0663200 enroll_status_Feb_curr1982
rename R0663300 enroll_status_Mar_curr1982
rename R0663400 enroll_status_Apr_curr1982
rename R0663500 enroll_status_May_curr1982
rename R0663600 enroll_status_Jun_curr1982
rename R0663700 enroll_status_Jul_curr1982
rename R0663800 enroll_status_Aug_curr1982
rename R0663900 enroll_current1982
rename R0664000 grade_current1982
rename R0665300 diploma_or_ged1982
rename R0898201 high_grade_comp_May1982
rename R0903400 enroll_status_Jan_prev1983
rename R0903500 enroll_status_Feb_prev1983
rename R0903600 enroll_status_Mar_prev1983
rename R0903700 enroll_status_Apr_prev1983
rename R0903800 enroll_status_May_prev1983
rename R0903900 enroll_status_Jun_prev1983
rename R0904000 enroll_status_Jul_prev1983
rename R0904100 enroll_status_Aug_prev1983
rename R0904200 enroll_status_Sep_prev1983
rename R0904300 enroll_status_Oct_prev1983
rename R0904400 enroll_status_Nov_prev1983
rename R0904500 enroll_status_Dec_prev1983
rename R0904600 enroll_status_Jan_curr1983
rename R0904700 enroll_status_Feb_curr1983
rename R0904800 enroll_status_Mar_curr1983
rename R0904900 enroll_status_Apr_curr1983
rename R0905000 enroll_status_May_curr1983
rename R0905100 enroll_status_Jun_curr1983
rename R0905200 enroll_status_Jul_curr1983
rename R0905300 enroll_current1983
rename R0905400 grade_current1983
rename R0905900 high_grade_comp_raw1983
rename R0906700 diploma_or_ged1983
rename R1145001 high_grade_comp_May1983
rename R1203200 enroll_status_Jan_prev1984
rename R1203300 enroll_status_Feb_prev1984
rename R1203400 enroll_status_Mar_prev1984
rename R1203500 enroll_status_Apr_prev1984
rename R1203600 enroll_status_May_prev1984
rename R1203700 enroll_status_Jun_prev1984
rename R1203800 enroll_status_Jul_prev1984
rename R1203900 enroll_status_Aug_prev1984
rename R1204000 enroll_status_Sep_prev1984
rename R1204100 enroll_status_Oct_prev1984
rename R1204200 enroll_status_Nov_prev1984
rename R1204300 enroll_status_Dec_prev1984
rename R1204400 enroll_status_Jan_curr1984
rename R1204500 enroll_status_Feb_curr1984
rename R1204600 enroll_status_Mar_curr1984
rename R1204700 enroll_status_Apr_curr1984
rename R1204800 enroll_status_May_curr1984
rename R1204900 enroll_status_Jun_curr1984
rename R1205200 enroll_current1984
rename R1205300 grade_current1984
rename R1205800 high_grade_comp_raw1984
rename R1206600 diploma_or_ged1984
rename R1214900 HSvocClubNeverHS
rename R1215000 HSvocClubIndustrialArts
rename R1215100 HSvocClubDistrEd
rename R1215200 HSvocClubFBLA
rename R1215300 HSvocClubFFA
rename R1215400 HSvocClubFHA
rename R1215500 HSvocClubHomeEc
rename R1215600 HSvocClubHealthOcc
rename R1215700 HSvocClubOfficeEd
rename R1215800 HSvocClubVocIndClub
rename R1215900 HSvocClubOther
rename R1216000 HSvocClubNone
rename R1216100 HSvocClubMostActive
rename R1216200 HSvocClubActiveParticipant
rename R1216300 HSvocClubYrsParticip
rename R1216400 HSclubCYO
rename R1216500 HSclubHobby
rename R1216600 HSclubStudentCouncil
rename R1216700 HSclubYrbookPaper
rename R1216800 HSclubAthletics
rename R1216900 HSclubPerfArts
rename R1217000 HSclubNHS
rename R1217100 HSclubOther
rename R1217200 HSclubNone
rename R1217300 HSclubMostActive
rename R1217400 HSclubActiveParticipant
rename R1520201 high_grade_comp_May1984
rename R1602500 enroll_status_Jan_prev1985
rename R1602600 enroll_status_Feb_prev1985
rename R1602700 enroll_status_Mar_prev1985
rename R1602800 enroll_status_Apr_prev1985
rename R1602900 enroll_status_May_prev1985
rename R1603000 enroll_status_Jun_prev1985
rename R1603100 enroll_status_Jul_prev1985
rename R1603200 enroll_status_Aug_prev1985
rename R1603300 enroll_status_Sep_prev1985
rename R1603400 enroll_status_Oct_prev1985
rename R1603500 enroll_status_Nov_prev1985
rename R1603600 enroll_status_Dec_prev1985
rename R1603700 enroll_status_Jan_curr1985
rename R1603800 enroll_status_Feb_curr1985
rename R1603900 enroll_status_Mar_curr1985
rename R1604000 enroll_status_Apr_curr1985
rename R1604100 enroll_status_May_curr1985
rename R1604200 enroll_status_Jun_curr1985
rename R1604500 enroll_current1985
rename R1604600 grade_current1985
rename R1605100 high_grade_comp_raw1985
rename R1605900 diploma_or_ged1985
rename R1890901 high_grade_comp_May1985
rename R1903000 enroll_status_Jan_prev1986
rename R1903100 enroll_status_Feb_prev1986
rename R1903200 enroll_status_Mar_prev1986
rename R1903300 enroll_status_Apr_prev1986
rename R1903400 enroll_status_May_prev1986
rename R1903500 enroll_status_Jun_prev1986
rename R1903600 enroll_status_Jul_prev1986
rename R1903700 enroll_status_Aug_prev1986
rename R1903800 enroll_status_Sep_prev1986
rename R1903900 enroll_status_Oct_prev1986
rename R1904000 enroll_status_Nov_prev1986
rename R1904100 enroll_status_Dec_prev1986
rename R1904200 enroll_status_Jan_curr1986
rename R1904300 enroll_status_Feb_curr1986
rename R1904400 enroll_status_Mar_curr1986
rename R1904500 enroll_status_Apr_curr1986
rename R1904600 enroll_status_May_curr1986
rename R1904700 enroll_status_Jun_curr1986
rename R1904800 enroll_status_Jul_curr1986
rename R1905000 enroll_current1986
rename R1905100 grade_current1986
rename R1905600 high_grade_comp_raw1986
rename R1906100 diploma_or_ged1986
rename R2258001 high_grade_comp_May1986
rename R2303800 enroll_status_Jan_prev1987
rename R2303900 enroll_status_Feb_prev1987
rename R2304000 enroll_status_Mar_prev1987
rename R2304100 enroll_status_Apr_prev1987
rename R2304200 enroll_status_May_prev1987
rename R2304300 enroll_status_Jun_prev1987
rename R2304400 enroll_status_Jul_prev1987
rename R2304500 enroll_status_Aug_prev1987
rename R2304600 enroll_status_Sep_prev1987
rename R2304700 enroll_status_Oct_prev1987
rename R2304800 enroll_status_Nov_prev1987
rename R2304900 enroll_status_Dec_prev1987
rename R2305000 enroll_status_Jan_curr1987
rename R2305100 enroll_status_Feb_curr1987
rename R2305200 enroll_status_Mar_curr1987
rename R2305300 enroll_status_Apr_curr1987
rename R2305400 enroll_status_May_curr1987
rename R2305500 enroll_status_Jun_curr1987
rename R2305600 enroll_status_Jul_curr1987
rename R2305700 enroll_status_Aug_curr1987
rename R2305800 enroll_status_Sep_curr1987
rename R2305900 enroll_current1987
rename R2306000 grade_current1987
rename R2306500 high_grade_comp_raw1987
rename R2307000 diploma_or_ged1987
rename R2445401 high_grade_comp_May1987
rename R2506000 enroll_status_Jan_prev1988
rename R2506100 enroll_status_Feb_prev1988
rename R2506200 enroll_status_Mar_prev1988
rename R2506300 enroll_status_Apr_prev1988
rename R2506400 enroll_status_May_prev1988
rename R2506500 enroll_status_Jun_prev1988
rename R2506600 enroll_status_Jul_prev1988
rename R2506700 enroll_status_Aug_prev1988
rename R2506800 enroll_status_Sep_prev1988
rename R2506900 enroll_status_Oct_prev1988
rename R2507000 enroll_status_Nov_prev1988
rename R2507100 enroll_status_Dec_prev1988
rename R2507200 enroll_status_Jan_curr1988
rename R2507300 enroll_status_Feb_curr1988
rename R2507400 enroll_status_Mar_curr1988
rename R2507500 enroll_status_Apr_curr1988
rename R2507600 enroll_status_May_curr1988
rename R2507700 enroll_status_Jun_curr1988
rename R2507800 enroll_status_Jul_curr1988
rename R2507900 enroll_status_Aug_curr1988
rename R2508000 enroll_status_Sep_curr1988
rename R2508100 enroll_status_Oct_curr1988
rename R2508200 enroll_status_Nov_curr1988
rename R2508300 enroll_status_Dec_curr1988
rename R2508400 enroll_current1988
rename R2508500 grade_current1988
rename R2509500 diploma_or_ged1988
rename R2871101 high_grade_comp_May1988
rename R2905100 enroll_status_Jan_prev1989
rename R2905200 enroll_status_Feb_prev1989
rename R2905300 enroll_status_Mar_prev1989
rename R2905400 enroll_status_Apr_prev1989
rename R2905500 enroll_status_May_prev1989
rename R2905600 enroll_status_Jun_prev1989
rename R2905700 enroll_status_Jul_prev1989
rename R2905800 enroll_status_Aug_prev1989
rename R2905900 enroll_status_Sep_prev1989
rename R2906000 enroll_status_Oct_prev1989
rename R2906100 enroll_status_Nov_prev1989
rename R2906200 enroll_status_Dec_prev1989
rename R2906300 enroll_status_Jan_curr1989
rename R2906400 enroll_status_Feb_curr1989
rename R2906500 enroll_status_Mar_curr1989
rename R2906600 enroll_status_Apr_curr1989
rename R2906700 enroll_status_May_curr1989
rename R2906800 enroll_status_Jun_curr1989
rename R2906900 enroll_status_Jul_curr1989
rename R2907000 enroll_status_Aug_curr1989
rename R2907100 enroll_status_Sep_curr1989
rename R2907200 enroll_status_Oct_curr1989
rename R2907300 enroll_status_Nov_curr1989
rename R2907400 enroll_status_Dec_curr1989
rename R2907500 enroll_current1989
rename R2907600 grade_current1989
rename R2908100 high_grade_comp_raw1989
rename R2908600 diploma_or_ged1989
rename R3074801 high_grade_comp_May1989
rename R3107200 enroll_status_Jan_prev1990
rename R3107300 enroll_status_Feb_prev1990
rename R3107400 enroll_status_Mar_prev1990
rename R3107500 enroll_status_Apr_prev1990
rename R3107600 enroll_status_May_prev1990
rename R3107700 enroll_status_Jun_prev1990
rename R3107800 enroll_status_Jul_prev1990
rename R3107900 enroll_status_Aug_prev1990
rename R3108000 enroll_status_Sep_prev1990
rename R3108100 enroll_status_Oct_prev1990
rename R3108200 enroll_status_Nov_prev1990
rename R3108300 enroll_status_Dec_prev1990
rename R3108400 enroll_status_Jan_curr1990
rename R3108500 enroll_status_Feb_curr1990
rename R3108600 enroll_status_Mar_curr1990
rename R3108700 enroll_status_Apr_curr1990
rename R3108800 enroll_status_May_curr1990
rename R3108900 enroll_status_Jun_curr1990
rename R3109000 enroll_status_Jul_curr1990
rename R3109100 enroll_status_Aug_curr1990
rename R3109200 enroll_status_Sep_curr1990
rename R3109300 enroll_status_Oct_curr1990
rename R3109400 enroll_status_Nov_curr1990
rename R3109500 enroll_status_Dec_curr1990
rename R3109600 enroll_current1990
rename R3109700 grade_current1990
rename R3110200 high_grade_comp_raw1990
rename R3110700 diploma_or_ged1990
rename R3401501 high_grade_comp_May1990
rename R3507200 enroll_status_Jan_prev1991
rename R3507300 enroll_status_Feb_prev1991
rename R3507400 enroll_status_Mar_prev1991
rename R3507500 enroll_status_Apr_prev1991
rename R3507600 enroll_status_May_prev1991
rename R3507700 enroll_status_Jun_prev1991
rename R3507800 enroll_status_Jul_prev1991
rename R3507900 enroll_status_Aug_prev1991
rename R3508000 enroll_status_Sep_prev1991
rename R3508100 enroll_status_Oct_prev1991
rename R3508200 enroll_status_Nov_prev1991
rename R3508300 enroll_status_Dec_prev1991
rename R3508400 enroll_status_Jan_curr1991
rename R3508500 enroll_status_Feb_curr1991
rename R3508600 enroll_status_Mar_curr1991
rename R3508700 enroll_status_Apr_curr1991
rename R3508800 enroll_status_May_curr1991
rename R3508900 enroll_status_Jun_curr1991
rename R3509000 enroll_status_Jul_curr1991
rename R3509100 enroll_status_Aug_curr1991
rename R3509200 enroll_status_Sep_curr1991
rename R3509300 enroll_status_Oct_curr1991
rename R3509400 enroll_status_Nov_curr1991
rename R3509500 enroll_status_Dec_curr1991
rename R3509600 enroll_current1991
rename R3509700 grade_current1991
rename R3510200 high_grade_comp_raw1991
rename R3510700 diploma_or_ged1991
rename R3656901 high_grade_comp_May1991
rename R3707200 enroll_status_Jan_prev1992
rename R3707300 enroll_status_Feb_prev1992
rename R3707400 enroll_status_Mar_prev1992
rename R3707500 enroll_status_Apr_prev1992
rename R3707600 enroll_status_May_prev1992
rename R3707700 enroll_status_Jun_prev1992
rename R3707800 enroll_status_Jul_prev1992
rename R3707900 enroll_status_Aug_prev1992
rename R3708000 enroll_status_Sep_prev1992
rename R3708100 enroll_status_Oct_prev1992
rename R3708200 enroll_status_Nov_prev1992
rename R3708300 enroll_status_Dec_prev1992
rename R3708400 enroll_status_Jan_curr1992
rename R3708500 enroll_status_Feb_curr1992
rename R3708600 enroll_status_Mar_curr1992
rename R3708700 enroll_status_Apr_curr1992
rename R3708800 enroll_status_May_curr1992
rename R3708900 enroll_status_Jun_curr1992
rename R3709000 enroll_status_Jul_curr1992
rename R3709100 enroll_status_Aug_curr1992
rename R3709200 enroll_status_Sep_curr1992
rename R3709300 enroll_status_Oct_curr1992
rename R3709400 enroll_status_Nov_curr1992
rename R3709500 enroll_status_Dec_curr1992
rename R3709600 enroll_current1992
rename R3709700 grade_current1992
rename R3710200 high_grade_comp_raw1992
rename R3710700 diploma_or_ged1992
rename R4007401 high_grade_comp_May1992
rename R4134800 enroll_status_Jan_prev1993
rename R4134801 enroll_status_Feb_prev1993
rename R4134802 enroll_status_Mar_prev1993
rename R4134803 enroll_status_Apr_prev1993
rename R4134804 enroll_status_May_prev1993
rename R4134805 enroll_status_Jun_prev1993
rename R4134806 enroll_status_Jul_prev1993
rename R4134807 enroll_status_Aug_prev1993
rename R4134808 enroll_status_Sep_prev1993
rename R4134809 enroll_status_Oct_prev1993
rename R4134810 enroll_status_Nov_prev1993
rename R4134811 enroll_status_Dec_prev1993
rename R4134812 enroll_status_Jan_curr1993
rename R4134813 enroll_status_Feb_curr1993
rename R4134814 enroll_status_Mar_curr1993
rename R4134815 enroll_status_Apr_curr1993
rename R4134816 enroll_status_May_curr1993
rename R4134817 enroll_status_Jun_curr1993
rename R4134818 enroll_status_Jul_curr1993
rename R4134819 enroll_status_Aug_curr1993
rename R4134820 enroll_status_Sep_curr1993
rename R4134821 enroll_status_Oct_curr1993
rename R4134822 enroll_status_Nov_curr1993
rename R4134823 enroll_status_Dec_curr1993
rename R4137400 enroll_current1993
rename R4137500 grade_current1993
rename R4137900 high_grade_comp_raw1993
rename R4138500 diploma_or_ged1993
rename R4418501 high_grade_comp_May1993
rename R4523400 enroll_status_Jan_prev1994
rename R4523401 enroll_status_Feb_prev1994
rename R4523402 enroll_status_Mar_prev1994
rename R4523403 enroll_status_Apr_prev1994
rename R4523404 enroll_status_May_prev1994
rename R4523405 enroll_status_Jun_prev1994
rename R4523406 enroll_status_Jul_prev1994
rename R4523407 enroll_status_Aug_prev1994
rename R4523408 enroll_status_Sep_prev1994
rename R4523409 enroll_status_Oct_prev1994
rename R4523410 enroll_status_Nov_prev1994
rename R4523411 enroll_status_Dec_prev1994
rename R4523412 enroll_status_Jan_curr1994
rename R4523413 enroll_status_Feb_curr1994
rename R4523414 enroll_status_Mar_curr1994
rename R4523415 enroll_status_Apr_curr1994
rename R4523416 enroll_status_May_curr1994
rename R4523417 enroll_status_Jun_curr1994
rename R4523418 enroll_status_Jul_curr1994
rename R4523419 enroll_status_Aug_curr1994
rename R4523420 enroll_status_Sep_curr1994
rename R4523421 enroll_status_Oct_curr1994
rename R4523422 enroll_status_Nov_curr1994
rename R4523423 enroll_status_Dec_curr1994
rename R4523424 enroll_status_Mos_none1994
rename R4526000 enroll_current1994
rename R4526100 grade_current1994
rename R4526500 high_grade_comp_raw1994
rename R4527100 diploma_or_ged1994
rename R5103900 high_grade_comp_May1994
rename R5166901 high_grade_comp_May1996
rename R5221100 enroll_status_Jan_2prev1996
rename R5221101 enroll_status_Feb_2prev1996
rename R5221102 enroll_status_Mar_2prev1996
rename R5221103 enroll_status_Apr_2prev1996
rename R5221104 enroll_status_May_2prev1996
rename R5221105 enroll_status_Jun_2prev1996
rename R5221106 enroll_status_Jul_2prev1996
rename R5221107 enroll_status_Aug_2prev1996
rename R5221108 enroll_status_Sep_2prev1996
rename R5221109 enroll_status_Oct_2prev1996
rename R5221110 enroll_status_Nov_2prev1996
rename R5221111 enroll_status_Dec_2prev1996
rename R5221112 enroll_status_Jan_prev1996
rename R5221113 enroll_status_Feb_prev1996
rename R5221114 enroll_status_Mar_prev1996
rename R5221115 enroll_status_Apr_prev1996
rename R5221116 enroll_status_May_prev1996
rename R5221117 enroll_status_Jun_prev1996
rename R5221118 enroll_status_Jul_prev1996
rename R5221119 enroll_status_Aug_prev1996
rename R5221120 enroll_status_Sep_prev1996
rename R5221121 enroll_status_Oct_prev1996
rename R5221122 enroll_status_Nov_prev1996
rename R5221123 enroll_status_Dec_prev1996
rename R5221124 enroll_status_Mos_noneprev1996
rename R5221200 enroll_status_Jan_curr1996
rename R5221201 enroll_status_Feb_curr1996
rename R5221202 enroll_status_Mar_curr1996
rename R5221203 enroll_status_Apr_curr1996
rename R5221204 enroll_status_May_curr1996
rename R5221205 enroll_status_Jun_curr1996
rename R5221206 enroll_status_Jul_curr1996
rename R5221207 enroll_status_Aug_curr1996
rename R5221208 enroll_status_Sep_curr1996
rename R5221209 enroll_status_Oct_curr1996
rename R5221210 enroll_status_Nov_curr1996
rename R5221211 enroll_status_Dec_curr1996
rename R5221212 enroll_status_Mos_none1996
rename R5221300 enroll_current1996
rename R5221400 grade_current1996
rename R5221800 high_grade_comp_raw1996
rename R5222400 diploma_or_ged1996
rename R5821200 enroll_status_Jan_2prev1998
rename R5821201 enroll_status_Feb_2prev1998
rename R5821202 enroll_status_Mar_2prev1998
rename R5821203 enroll_status_Apr_2prev1998
rename R5821204 enroll_status_May_2prev1998
rename R5821205 enroll_status_Jun_2prev1998
rename R5821206 enroll_status_Jul_2prev1998
rename R5821207 enroll_status_Aug_2prev1998
rename R5821208 enroll_status_Sep_2prev1998
rename R5821209 enroll_status_Oct_2prev1998
rename R5821210 enroll_status_Nov_2prev1998
rename R5821211 enroll_status_Dec_2prev1998
rename R5821212 enroll_status_Jan_prev1998
rename R5821213 enroll_status_Feb_prev1998
rename R5821214 enroll_status_Mar_prev1998
rename R5821215 enroll_status_Apr_prev1998
rename R5821216 enroll_status_May_prev1998
rename R5821217 enroll_status_Jun_prev1998
rename R5821218 enroll_status_Jul_prev1998
rename R5821219 enroll_status_Aug_prev1998
rename R5821220 enroll_status_Sep_prev1998
rename R5821221 enroll_status_Oct_prev1998
rename R5821222 enroll_status_Nov_prev1998
rename R5821223 enroll_status_Dec_prev1998
rename R5821224 enroll_status_Jan_curr1998
rename R5821225 enroll_status_Feb_curr1998
rename R5821226 enroll_status_Mar_curr1998
rename R5821227 enroll_status_Apr_curr1998
rename R5821228 enroll_status_May_curr1998
rename R5821229 enroll_status_Jun_curr1998
rename R5821230 enroll_status_Jul_curr1998
rename R5821231 enroll_status_Aug_curr1998
rename R5821232 enroll_status_Sep_curr1998
rename R5821233 enroll_status_Oct_curr1998
rename R5821234 enroll_status_Nov_curr1998
rename R5821235 enroll_status_Dec_curr1998
rename R5821300 enroll_current1998
rename R5821400 grade_current1998
rename R5821800 high_grade_comp_raw1998
rename R5822300 diploma_or_ged1998
rename R6479600 high_grade_comp_May1998
rename R6539900 enroll_status_Jan_2prev2000
rename R6539901 enroll_status_Feb_2prev2000
rename R6539902 enroll_status_Mar_2prev2000
rename R6539903 enroll_status_Apr_2prev2000
rename R6539904 enroll_status_May_2prev2000
rename R6539905 enroll_status_Jun_2prev2000
rename R6539906 enroll_status_Jul_2prev2000
rename R6539907 enroll_status_Aug_2prev2000
rename R6539908 enroll_status_Sep_2prev2000
rename R6539909 enroll_status_Oct_2prev2000
rename R6539910 enroll_status_Nov_2prev2000
rename R6539911 enroll_status_Dec_2prev2000
rename R6539912 enroll_status_Jan_prev2000
rename R6539913 enroll_status_Feb_prev2000
rename R6539914 enroll_status_Mar_prev2000
rename R6539915 enroll_status_Apr_prev2000
rename R6539916 enroll_status_May_prev2000
rename R6539917 enroll_status_Jun_prev2000
rename R6539918 enroll_status_Jul_prev2000
rename R6539919 enroll_status_Aug_prev2000
rename R6539920 enroll_status_Sep_prev2000
rename R6539921 enroll_status_Oct_prev2000
rename R6539922 enroll_status_Nov_prev2000
rename R6539923 enroll_status_Dec_prev2000
rename R6539924 enroll_status_Jan_curr2000
rename R6539925 enroll_status_Feb_curr2000
rename R6539926 enroll_status_Mar_curr2000
rename R6539927 enroll_status_Apr_curr2000
rename R6539928 enroll_status_May_curr2000
rename R6539929 enroll_status_Jun_curr2000
rename R6539930 enroll_status_Jul_curr2000
rename R6539931 enroll_status_Aug_curr2000
rename R6539932 enroll_status_Sep_curr2000
rename R6539933 enroll_status_Oct_curr2000
rename R6539934 enroll_status_Nov_curr2000
rename R6539935 enroll_status_Dec_curr2000
rename R6540000 enroll_current2000
rename R6540100 grade_current2000
rename R6540400 high_grade_comp_raw2000
rename R6540900 diploma_or_ged2000
rename R7007300 high_grade_comp_May2000
rename R7103100 enroll_status_Jan_3prev2002
rename R7103101 enroll_status_Feb_3prev2002
rename R7103102 enroll_status_Mar_3prev2002
rename R7103103 enroll_status_Apr_3prev2002
rename R7103104 enroll_status_May_3prev2002
rename R7103105 enroll_status_Jun_3prev2002
rename R7103106 enroll_status_Jul_3prev2002
rename R7103107 enroll_status_Aug_3prev2002
rename R7103108 enroll_status_Sep_3prev2002
rename R7103109 enroll_status_Oct_3prev2002
rename R7103110 enroll_status_Nov_3prev2002
rename R7103111 enroll_status_Dec_3prev2002
rename R7103112 enroll_status_Jan_2prev2002
rename R7103113 enroll_status_Feb_2prev2002
rename R7103114 enroll_status_Mar_2prev2002
rename R7103115 enroll_status_Apr_2prev2002
rename R7103116 enroll_status_May_2prev2002
rename R7103117 enroll_status_Jun_2prev2002
rename R7103118 enroll_status_Jul_2prev2002
rename R7103119 enroll_status_Aug_2prev2002
rename R7103120 enroll_status_Sep_2prev2002
rename R7103121 enroll_status_Oct_2prev2002
rename R7103122 enroll_status_Nov_2prev2002
rename R7103123 enroll_status_Dec_2prev2002
rename R7103124 enroll_status_Jan_prev2002
rename R7103125 enroll_status_Feb_prev2002
rename R7103126 enroll_status_Mar_prev2002
rename R7103127 enroll_status_Apr_prev2002
rename R7103128 enroll_status_May_prev2002
rename R7103129 enroll_status_Jun_prev2002
rename R7103130 enroll_status_Jul_prev2002
rename R7103131 enroll_status_Aug_prev2002
rename R7103132 enroll_status_Sep_prev2002
rename R7103133 enroll_status_Oct_prev2002
rename R7103134 enroll_status_Nov_prev2002
rename R7103135 enroll_status_Dec_prev2002
rename R7103136 enroll_status_Jan_curr2002
rename R7103137 enroll_status_Feb_curr2002
rename R7103138 enroll_status_Mar_curr2002
rename R7103139 enroll_status_Apr_curr2002
rename R7103140 enroll_status_May_curr2002
rename R7103141 enroll_status_Jun_curr2002
rename R7103142 enroll_status_Jul_curr2002
rename R7103143 enroll_status_Aug_curr2002
rename R7103144 enroll_status_Sep_curr2002
rename R7103145 enroll_status_Oct_curr2002
rename R7103146 enroll_status_Nov_curr2002
rename R7103147 enroll_status_Dec_curr2002
rename R7103200 enroll_current2002
rename R7103300 grade_current2002
rename R7103600 high_grade_comp_raw2002
rename R7104100 diploma_or_ged2002
rename R7704600 high_grade_comp_May2002
rename R7810000 enroll_status_Jan_2prev2004
rename R7810001 enroll_status_Feb_2prev2004
rename R7810002 enroll_status_Mar_2prev2004
rename R7810003 enroll_status_Apr_2prev2004
rename R7810004 enroll_status_May_2prev2004
rename R7810005 enroll_status_Jun_2prev2004
rename R7810006 enroll_status_Jul_2prev2004
rename R7810007 enroll_status_Aug_2prev2004
rename R7810008 enroll_status_Sep_2prev2004
rename R7810009 enroll_status_Oct_2prev2004
rename R7810010 enroll_status_Nov_2prev2004
rename R7810011 enroll_status_Dec_2prev2004
rename R7810012 enroll_status_Jan_prev2004
rename R7810013 enroll_status_Feb_prev2004
rename R7810014 enroll_status_Mar_prev2004
rename R7810015 enroll_status_Apr_prev2004
rename R7810016 enroll_status_May_prev2004
rename R7810017 enroll_status_Jun_prev2004
rename R7810018 enroll_status_Jul_prev2004
rename R7810019 enroll_status_Aug_prev2004
rename R7810020 enroll_status_Sep_prev2004
rename R7810021 enroll_status_Oct_prev2004
rename R7810022 enroll_status_Nov_prev2004
rename R7810023 enroll_status_Dec_prev2004
rename R7810024 enroll_status_Jan_curr2004
rename R7810025 enroll_status_Feb_curr2004
rename R7810026 enroll_status_Mar_curr2004
rename R7810027 enroll_status_Apr_curr2004
rename R7810028 enroll_status_May_curr2004
rename R7810029 enroll_status_Jun_curr2004
rename R7810030 enroll_status_Jul_curr2004
rename R7810031 enroll_status_Aug_curr2004
rename R7810032 enroll_status_Sep_curr2004
rename R7810033 enroll_status_Oct_curr2004
rename R7810034 enroll_status_Nov_curr2004
rename R7810035 enroll_status_Dec_curr2004
rename R7810100 enroll_current2004
rename R7810200 grade_current2004
rename R7810500 high_grade_comp_raw2004
rename R7811000 diploma_or_ged2004
rename R8497000 high_grade_comp_May2004
rename T0013900 enroll_status_Jan_2prev2006
rename T0013901 enroll_status_Feb_2prev2006
rename T0013902 enroll_status_Mar_2prev2006
rename T0013903 enroll_status_Apr_2prev2006
rename T0013904 enroll_status_May_2prev2006
rename T0013905 enroll_status_Jun_2prev2006
rename T0013906 enroll_status_Jul_2prev2006
rename T0013907 enroll_status_Aug_2prev2006
rename T0013908 enroll_status_Sep_2prev2006
rename T0013909 enroll_status_Oct_2prev2006
rename T0013910 enroll_status_Nov_2prev2006
rename T0013911 enroll_status_Dec_2prev2006
rename T0013912 enroll_status_Jan_prev2006
rename T0013913 enroll_status_Feb_prev2006
rename T0013914 enroll_status_Mar_prev2006
rename T0013915 enroll_status_Apr_prev2006
rename T0013916 enroll_status_May_prev2006
rename T0013917 enroll_status_Jun_prev2006
rename T0013918 enroll_status_Jul_prev2006
rename T0013919 enroll_status_Aug_prev2006
rename T0013920 enroll_status_Sep_prev2006
rename T0013921 enroll_status_Oct_prev2006
rename T0013922 enroll_status_Nov_prev2006
rename T0013923 enroll_status_Dec_prev2006
rename T0013924 enroll_status_Jan_curr2006
rename T0013925 enroll_status_Feb_curr2006
rename T0013926 enroll_status_Mar_curr2006
rename T0013927 enroll_status_Apr_curr2006
rename T0013928 enroll_status_May_curr2006
rename T0013929 enroll_status_Jun_curr2006
rename T0013930 enroll_status_Jul_curr2006
rename T0013931 enroll_status_Aug_curr2006
rename T0013932 enroll_status_Sep_curr2006
rename T0013933 enroll_status_Oct_curr2006
rename T0013934 enroll_status_Nov_curr2006
rename T0013935 enroll_status_Dec_curr2006
rename T0014000 enroll_current2006
rename T0014100 grade_current2006
rename T0014400 high_grade_comp_raw2006
rename T0014900 diploma_or_ged2006
rename T0988800 high_grade_comp_May2006
rename T1213800 enroll_status_Jan_2prev2008
rename T1213801 enroll_status_Feb_2prev2008
rename T1213802 enroll_status_Mar_2prev2008
rename T1213803 enroll_status_Apr_2prev2008
rename T1213804 enroll_status_May_2prev2008
rename T1213805 enroll_status_Jun_2prev2008
rename T1213806 enroll_status_Jul_2prev2008
rename T1213807 enroll_status_Aug_2prev2008
rename T1213808 enroll_status_Sep_2prev2008
rename T1213809 enroll_status_Oct_2prev2008
rename T1213810 enroll_status_Nov_2prev2008
rename T1213811 enroll_status_Dec_2prev2008
rename T1213812 enroll_status_Jan_prev2008
rename T1213813 enroll_status_Feb_prev2008
rename T1213814 enroll_status_Mar_prev2008
rename T1213815 enroll_status_Apr_prev2008
rename T1213816 enroll_status_May_prev2008
rename T1213817 enroll_status_Jun_prev2008
rename T1213818 enroll_status_Jul_prev2008
rename T1213819 enroll_status_Aug_prev2008
rename T1213820 enroll_status_Sep_prev2008
rename T1213821 enroll_status_Oct_prev2008
rename T1213822 enroll_status_Nov_prev2008
rename T1213823 enroll_status_Dec_prev2008
rename T1213824 enroll_status_Jan_curr2008
rename T1213825 enroll_status_Feb_curr2008
rename T1213826 enroll_status_Mar_curr2008
rename T1213827 enroll_status_Apr_curr2008
rename T1213828 enroll_status_May_curr2008
rename T1213829 enroll_status_Jun_curr2008
rename T1213830 enroll_status_Jul_curr2008
rename T1213831 enroll_status_Aug_curr2008
rename T1213832 enroll_status_Sep_curr2008
rename T1213833 enroll_status_Oct_curr2008
rename T1213834 enroll_status_Nov_curr2008
rename T1213835 enroll_status_Dec_curr2008
rename T1213900 enroll_current2008
rename T1214000 grade_current2008
rename T1214300 high_grade_comp_raw2008
rename T1214900 diploma_or_ged2008
rename T2210700 high_grade_comp_May2008
rename T2272300 enroll_status_Jan_2prev2010
rename T2272301 enroll_status_Feb_2prev2010
rename T2272303 enroll_status_Apr_2prev2010
rename T2272304 enroll_status_May_2prev2010
rename T2272305 enroll_status_Jun_2prev2010
rename T2272306 enroll_status_Jul_2prev2010
rename T2272307 enroll_status_Aug_2prev2010
rename T2272308 enroll_status_Sep_2prev2010
rename T2272309 enroll_status_Oct_2prev2010
rename T2272310 enroll_status_Nov_2prev2010
rename T2272311 enroll_status_Dec_2prev2010
rename T2272312 enroll_status_Jan_prev2010
rename T2272313 enroll_status_Feb_prev2010
rename T2272314 enroll_status_Mar_prev2010
rename T2272315 enroll_status_Apr_prev2010
rename T2272316 enroll_status_May_prev2010
rename T2272317 enroll_status_Jun_prev2010
rename T2272318 enroll_status_Jul_prev2010
rename T2272319 enroll_status_Aug_prev2010
rename T2272320 enroll_status_Sep_prev2010
rename T2272321 enroll_status_Oct_prev2010
rename T2272322 enroll_status_Nov_prev2010
rename T2272323 enroll_status_Dec_prev2010
rename T2272324 enroll_status_Jan_curr2010
rename T2272325 enroll_status_Feb_curr2010
rename T2272326 enroll_status_Mar_curr2010
rename T2272327 enroll_status_Apr_curr2010
rename T2272328 enroll_status_May_curr2010
rename T2272329 enroll_status_Jun_curr2010
rename T2272330 enroll_status_Jul_curr2010
rename T2272331 enroll_status_Aug_curr2010
rename T2272332 enroll_status_Sep_curr2010
rename T2272333 enroll_status_Oct_curr2010
rename T2272334 enroll_status_Nov_curr2010
rename T2272335 enroll_status_Dec_curr2010
rename T2272400 enroll_current2010
rename T2272500 grade_current2010
rename T2272800 high_grade_comp_raw2010
rename T2273400 diploma_or_ged2010
rename T3108600 high_grade_comp_May2010
rename T3212400 enroll_status_Jan_2prev2012
rename T3212401 enroll_status_Feb_2prev2012
rename T3212403 enroll_status_Apr_2prev2012
rename T3212404 enroll_status_May_2prev2012
rename T3212405 enroll_status_Jun_2prev2012
rename T3212406 enroll_status_Jul_2prev2012
rename T3212407 enroll_status_Aug_2prev2012
rename T3212408 enroll_status_Sep_2prev2012
rename T3212409 enroll_status_Oct_2prev2012
rename T3212410 enroll_status_Nov_2prev2012
rename T3212411 enroll_status_Dec_2prev2012
rename T3212412 enroll_status_Jan_prev2012
rename T3212413 enroll_status_Feb_prev2012
rename T3212414 enroll_status_Mar_prev2012
rename T3212415 enroll_status_Apr_prev2012
rename T3212416 enroll_status_May_prev2012
rename T3212417 enroll_status_Jun_prev2012
rename T3212418 enroll_status_Jul_prev2012
rename T3212419 enroll_status_Aug_prev2012
rename T3212420 enroll_status_Sep_prev2012
rename T3212421 enroll_status_Oct_prev2012
rename T3212422 enroll_status_Nov_prev2012
rename T3212423 enroll_status_Dec_prev2012
rename T3212424 enroll_status_Jan_curr2012
rename T3212425 enroll_status_Feb_curr2012
rename T3212426 enroll_status_Mar_curr2012
rename T3212427 enroll_status_Apr_curr2012
rename T3212428 enroll_status_May_curr2012
rename T3212429 enroll_status_Jun_curr2012
rename T3212430 enroll_status_Jul_curr2012
rename T3212431 enroll_status_Aug_curr2012
rename T3212432 enroll_status_Sep_curr2012
rename T3212433 enroll_status_Oct_curr2012
rename T3212434 enroll_status_Nov_curr2012
rename T3212435 enroll_status_Dec_curr2012
rename T3212500 enroll_current2012
rename T3212600 grade_current2012
rename T3212900 high_grade_comp_raw2012
rename T3213500 diploma_or_ged2012
rename T4113000 high_grade_comp_May2012
rename R0216601 enroll_status_svy1979
rename R0406501 enroll_status_svy1980
rename R0619001 enroll_status_svy1981
rename R0898301 enroll_status_svy1982
rename R1145101 enroll_status_svy1983
rename R1520301 enroll_status_svy1984
rename R1891001 enroll_status_svy1985
rename R2258101 enroll_status_svy1986
rename R2445501 enroll_status_svy1987
rename R2871201 enroll_status_svy1988
rename R3074901 enroll_status_svy1989
rename R3401601 enroll_status_svy1990
rename R3657001 enroll_status_svy1991
rename R4007501 enroll_status_svy1992
rename R4418601 enroll_status_svy1993
rename R5104000 enroll_status_svy1994
rename R5166902 enroll_status_svy1996
rename R6479700 enroll_status_svy1998
rename R7007400 enroll_status_svy2000
rename R7704700 enroll_status_svy2002
rename R8497100 enroll_status_svy2004
rename T0988900 enroll_status_svy2006
rename R2509800 high_deg_recd1988
rename R2909200 high_deg_recd1989
rename R3111200 high_deg_recd1990
rename R3511200 high_deg_recd1991
rename R3711200 high_deg_recd1992
rename R4138900 high_deg_recd1993
rename R4527600 high_deg_recd1994
rename R5222900 high_deg_recd1996
rename R5822800 high_deg_recd1998
rename R6541400 high_deg_recd2000
rename R7104600 high_deg_recd2002
rename R7811500 high_deg_recd2004
rename T0015400 high_deg_recd2006
rename T1215400 high_deg_recd2008
rename T1215600 nonamedropper2008 // highest degree received 2008
rename T2273900 high_deg_recd2010 
rename T2274100 nonamedropper2010 // highest degree received 2010
rename T3214000 high_deg_recd2012
rename T3214200 nonamedropper2012 // highest degree received 2012

drop nonamedropper*

***************************************************
* Reshape and recode certain variables.
***************************************************

* exclued from reshape: id (i), HSvocClub* HSclub*
forvalues yr=1970/1994 {
    gen temp`yr'=0
}
forvalues yr=1996(2)2012 {
    gen temp`yr'=0
}
reshape long temp diploma_or_ged enroll_status_Apr_3prev enroll_status_Apr_2prev enroll_status_Apr_curr enroll_status_Apr_prev enroll_status_Aug_3prev enroll_status_Aug_2prev enroll_status_Aug_curr enroll_status_Aug_prev enroll_status_Dec_3prev enroll_status_Dec_2prev enroll_status_Dec_curr enroll_status_Dec_prev enroll_status_Feb_3prev enroll_status_Feb_2prev enroll_status_Feb_curr enroll_status_Feb_prev enroll_status_Jan_3prev enroll_status_Jan_2prev enroll_status_Jan_curr enroll_status_Jan_prev enroll_status_Jul_3prev enroll_status_Jul_2prev enroll_status_Jul_curr enroll_status_Jul_prev enroll_status_Jun_3prev enroll_status_Jun_2prev enroll_status_Jun_curr enroll_status_Jun_prev enroll_status_Mar_3prev enroll_status_Mar_2prev enroll_status_Mar_curr enroll_status_Mar_prev enroll_status_May_3prev enroll_status_May_2prev enroll_status_May_curr enroll_status_May_prev enroll_status_Nov_3prev enroll_status_Nov_2prev enroll_status_Nov_curr enroll_status_Nov_prev enroll_status_Oct_3prev enroll_status_Oct_2prev enroll_status_Oct_curr enroll_status_Oct_prev enroll_status_Sep_3prev enroll_status_Sep_2prev enroll_status_Sep_curr enroll_status_Sep_prev enroll_status_Mos_none enroll_status_svy grade_current enroll_current high_deg_recd high_grade_attend high_grade_comp_May high_grade_comp_raw , i(id) j(year)
drop temp
drop if id==.

recode _all (-1 = .r) (-2 = .d) (-3 = .i) (-4 = .v) (-5 = .n)
recode enroll_status_Jan* enroll_status_Feb* enroll_status_Mar* ///
       enroll_status_Apr* enroll_status_May* enroll_status_Jun* /// 
       enroll_status_Jul* enroll_status_Aug* enroll_status_Sep* /// 
       enroll_status_Oct* enroll_status_Nov* enroll_status_Dec* (2/36 = 1)

***************************************************
* Label variables and values
***************************************************

label var id                         "ID"
label var year                       "YEAR"
label var diploma_or_ged             "IS HS DEGREE A DIPLOMA OR GED"
label var enroll_current             "CURRENTLY ATTEND/ENROLLED IN SCHL"
label var enroll_status_Apr_3prev    "MONTHLY ENROLLMENT - 3 YR PREV APR"
label var enroll_status_Apr_2prev    "MONTHLY ENROLLMENT - 2 YR PREV APR"
label var enroll_status_Apr_curr     "MONTHLY ENROLLMENT - CURR APR"
label var enroll_status_Apr_prev     "MONTHLY ENROLLMENT - PREV APR"
label var enroll_status_Aug_3prev    "MONTHLY ENROLLMENT - 3 YR PREV AUG"
label var enroll_status_Aug_2prev    "MONTHLY ENROLLMENT - 2 YR PREV AUG"
label var enroll_status_Aug_curr     "MONTHLY ENROLLMENT - CURR AUG"
label var enroll_status_Aug_prev     "MONTHLY ENROLLMENT - PREV AUG"
label var enroll_status_Dec_3prev    "MONTHLY ENROLLMENT - 3 YR PREV DEC"
label var enroll_status_Dec_2prev    "MONTHLY ENROLLMENT - 2 YR PREV DEC"
label var enroll_status_Dec_curr     "MONTHLY ENROLLMENT - CURR DEC"
label var enroll_status_Dec_prev     "MONTHLY ENROLLMENT - PREV DEC"
label var enroll_status_Feb_3prev    "MONTHLY ENROLLMENT - 3 YR PREV FEB"
label var enroll_status_Feb_2prev    "MONTHLY ENROLLMENT - 2 YR PREV FEB"
label var enroll_status_Feb_curr     "MONTHLY ENROLLMENT - CURR FEB"
label var enroll_status_Feb_prev     "MONTHLY ENROLLMENT - PREV FEB"
label var enroll_status_Jan_3prev    "MONTHLY ENROLLMENT - 3 YR PREV JAN"
label var enroll_status_Jan_2prev    "MONTHLY ENROLLMENT - 2 YR PREV JAN"
label var enroll_status_Jan_curr     "MONTHLY ENROLLMENT - CURR JAN"
label var enroll_status_Jan_prev     "MONTHLY ENROLLMENT - PREV JAN"
label var enroll_status_Jul_3prev    "MONTHLY ENROLLMENT - 3 YR PREV JUL"
label var enroll_status_Jul_2prev    "MONTHLY ENROLLMENT - 2 YR PREV JUL"
label var enroll_status_Jul_curr     "MONTHLY ENROLLMENT - CURR JUL"
label var enroll_status_Jul_prev     "MONTHLY ENROLLMENT - PREV JUL"
label var enroll_status_Jun_3prev    "MONTHLY ENROLLMENT - 3 YR PREV JUN"
label var enroll_status_Jun_2prev    "MONTHLY ENROLLMENT - 2 YR PREV JUN"
label var enroll_status_Jun_curr     "MONTHLY ENROLLMENT - CURR JUN"
label var enroll_status_Jun_prev     "MONTHLY ENROLLMENT - PREV JUN"
label var enroll_status_Mar_3prev    "MONTHLY ENROLLMENT - 3 YR PREV MAR"
label var enroll_status_Mar_2prev    "MONTHLY ENROLLMENT - 2 YR PREV MAR"
label var enroll_status_Mar_curr     "MONTHLY ENROLLMENT - CURR MAR"
label var enroll_status_Mar_prev     "MONTHLY ENROLLMENT - PREV MAR"
label var enroll_status_May_3prev    "MONTHLY ENROLLMENT - 3 YR PREV MAY"
label var enroll_status_May_2prev    "MONTHLY ENROLLMENT - 2 YR PREV MAY"
label var enroll_status_May_curr     "MONTHLY ENROLLMENT - CURR MAY"
label var enroll_status_May_prev     "MONTHLY ENROLLMENT - PREV MAY"
label var enroll_status_Nov_3prev    "MONTHLY ENROLLMENT - 3 YR PREV NOV"
label var enroll_status_Nov_2prev    "MONTHLY ENROLLMENT - 2 YR PREV NOV"
label var enroll_status_Nov_curr     "MONTHLY ENROLLMENT - CURR NOV"
label var enroll_status_Nov_prev     "MONTHLY ENROLLMENT - PREV NOV"
label var enroll_status_Oct_3prev    "MONTHLY ENROLLMENT - 3 YR PREV OCT"
label var enroll_status_Oct_2prev    "MONTHLY ENROLLMENT - 2 YR PREV OCT"
label var enroll_status_Oct_curr     "MONTHLY ENROLLMENT - CURR OCT"
label var enroll_status_Oct_prev     "MONTHLY ENROLLMENT - PREV OCT"
label var enroll_status_Sep_3prev    "MONTHLY ENROLLMENT - 3 YR PREV SEP"
label var enroll_status_Sep_2prev    "MONTHLY ENROLLMENT - 2 YR PREV SEP"
label var enroll_status_Sep_curr     "MONTHLY ENROLLMENT - CURR SEP"
label var enroll_status_Sep_prev     "MONTHLY ENROLLMENT - PREV SEP"
label var enroll_status_svy          "ENROLLMT STAT - REV (AS OF MAY 1)"
label var grade_current              "GRD ATTENDING"
label var high_deg_recd              "HIGHEST DGR RCVD"
label var high_grade_comp_May        "HIGHEST GRADE COMPLETED (AS OF MAY 1)"
label var high_grade_comp_raw        "HIGHEST GRADE COMPLETED (SURVEY DATE)"
label var HSvocClubNeverHS           "R NEVER ATTENDED HS"
label var HSvocClubIndustrialArts    "R PARTICIPATED IN AMERICAN INDUSTRIAL ARTS"
label var HSvocClubDistrEd           "R PARTICIPATED IN DISTRIBUTIVE EDUCATION"
label var HSvocClubFBLA              "R PARTICIPATED IN FUTURE BUS. LEADERS OF AMERICA"
label var HSvocClubFFA               "R PARTICIPATED IN FUTURE FARMERS OF AMERICA"
label var HSvocClubFHA               "R PARTICIPATED IN FUTURE HOMEMAKERS OF AMERICA"
label var HSvocClubHomeEc            "R PARTICIPATED IN HOME ECONOMICS"
label var HSvocClubHealthOcc         "R PARTICIPATED IN HEALTH OCCUPATIONS"
label var HSvocClubOfficeEd          "R PARTICIPATED IN OFFICE EDUCATION"
label var HSvocClubVocIndClub        "R PARTICIPATED IN VOCATIONS INDUSTRIAL CLUB"
label var HSvocClubOther             "R PARTICIPATED IN SOME OTHER VOC CLUB"
label var HSvocClubNone              "R ATTENDED HS BUT DID NOT PARTICIPATE IN ANY VOC CLUBS"
label var HSvocClubMostActive        "HS VOCATIONAL CLUB R PARTICIPATED IN MOST ACTIVELY"
label var HSvocClubActiveParticipant "HOW ACTIVE OF A PARTICIPANT WAS R IN MAIN VOC CLUB?"
label var HSvocClubYrsParticip       "HOW MANY YEARS DID R PARTICIPATE IN A VOC CLUB?"
label var HSclubCYO                  "R PARTICIPATED IN COMM YOUTH ORG"
label var HSclubHobby                "R PARTICIPATED IN SCHOOL-SPONSORED HOBBY"
label var HSclubStudentCouncil       "R PARTICIPATED IN STUDENT GOVERNMENT"
label var HSclubYrbookPaper          "R PARTICIPATED IN YEARBOOK / NEWSPAPER"
label var HSclubAthletics            "R PARTICIPATED IN ATHLETICS, CHEER, PEP"
label var HSclubPerfArts             "R PARTICIPATED IN PERFORMING ARTS"
label var HSclubNHS                  "R PARTICIPATED IN NAT'L HONOR SOC"
label var HSclubOther                "R PARTICIPATED IN SOME OTHER CLUB"
label var HSclubNone                 "R ATTENDED HS BUT DID NOT PARTICIPATE IN ANY CLUBS"
label var HSclubMostActive           "HS CLUB R PARTICIPATED IN MOST ACTIVELY"
label var HSclubActiveParticipant    "HOW ACTIVE OF A PARTICIPANT WAS R IN MAIN CLUB?"

* label define vl_grade   0 "NONE"  1 "1ST GRADE"  2 "2ND GRADE"  3 "3RD GRADE"  4 "4TH GRADE"  5 "5TH GRADE"  6 "6TH GRADE"  7 "7TH GRADE"  8 "8TH GRADE"  9 "9TH GRADE"  10 "10TH GRADE"  11 "11TH GRADE"  12 "12TH GRADE"  13 "1ST YR COL"  14 "2ND YR COL"  15 "3RD YR COL"  16 "4TH YR COL"  17 "5TH YR COL"  18 "6TH YR COL"  19 "7TH YR COL"  20 "8TH YR COL OR MORE"  95 "UNGRADED" // prev defined
label values grade_current       vl_grade
label values high_grade_attend   vl_grade
label values high_grade_comp_May vl_grade
label values high_grade_comp_raw vl_grade

label define vl_vocclubs  0 "NONE"  1 "AMERICAN INDUSTRAL ARTS ASSOCIATION"  2 "DISTRIBUTIVE EDUCATION CLUBS OF AMERICA"  3 "FUTURE BUSINESS LEADERS OF AMERICA"  4 "FUTURE FARMERS OF AMERICA"  5 "FUTURE HOMEMAKERS OF AMERICA"  6 "HOME ECONOMICS RELATED OCCUPATIONS"  7 "HEALTH OCCUPATIONS STUDENT ASSOCIATION"  8 "OFFICE EDUCATION ASSOCIATION"  9 "VOCATIONS INDUSTRIAL CLUB OF AMERICA" 10 "OTHER"
label val HSvocClubMostActive vl_vocclubs

label define vl_clubs 0 "NONE" 1 "COMMUNITY YOUTH ORGINIZATION" 2 "SCHOOL SPONSORED HOBBY/SUBJECT MATTER CLUBS" 3 "STUDENT COUNCIL, GOVERNMENT" 4 "STAFF OF SCHOOL YEARBOOK OR NEWSPAPER" 5 "ATHLETICS, CHEERLEADING, PEP CLUBS" 6 "BAND, DRAMA, ORCHESTRA" 7 "NATIONAL HONOR SOCIETY, SCHOLASTIC ACHIEVEMENT CLUB" 8 "OTHER"
label val HSclubMostActive vl_clubs

label define vl_diploma  1 "HIGH SCHOOL DIPLOMA"  2 "GED"  3 "BOTH"
label values diploma_or_ged vl_diploma

label define vl_enroll_status  1 "NOT ENROLLED, COMPLETED LESS THAN 12TH GRADE"  2 "ENROLLED IN HIGH SCHOOL"  3 "ENROLLED IN COLLEGE"  4 "NOT ENROLLED, HIGH SCHOOL GRADUATE"
label values enroll_status_svy vl_enroll_status

* Bring together degree data
label define vl_degree_long   1 "HIGH SCHOOL DIPLOMA (OR EQUIVALENT)"  2 "ASSOCIATE/JUNIOR COLLEGE (AA)"  3 "BACHELOR'S DEGREE/BACHELOR OF ARTS DEGREE (BA)"  4 "BACHELOR OF SCIENCE (BS)"  5 "MASTER'S DEGREE (MA,MBA,MS,MSW)"  6 "DOCTORAL DEGREE (PHD)"  7 "PROFESSIONAL DEGREE (MD,LLD,DDS)"  8 "OTHER"
* label define vl_degree_short  1 "ASSOCIATE'S DEGREE"  2 "BACHELOR'S DEGREE"  3 "MASTER'S DEGREE"  4 "OTHER"
* recode type_*degree_recd (4/290 = 8) (3 = 5) (2 = 3) (1 = 2)
label values high_deg_recd     vl_degree_long

drop HS*lub*
