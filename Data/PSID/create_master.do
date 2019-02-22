version 13.0
clear all
set more off
capture log close
log using create_master.log, replace

cd RawData
********************************************************************
* This do-file creates the PSID extract to be used
********************************************************************

* [requires downloading of "Cross-year Individual: 1968-2015" file]
psid install

#delimit ;
psid use 

|| selfEmp
[68]V198 [69]V641 [70]V1280 [71]V1986 [72]V2584 [73]V3117 [74]V3532 [75]V3970 [76]V4461 [77]V5376 [78]V5875 [79]V6493 [80]V7096 [81]V7707 [82]V8375 [83]V9006 [84]V10456 [85]V11640 [86]V13049 [87]V14149 [88]V15157 [89]V16658 [90]V18096 [91]V19396 [92]V20696 [93]V22451 [94]ER2074 [95]ER5073 [96]ER7169 [97]ER10086 [99]ER13210 [01]ER17221

|| empStat
[79]ER30293 [80]ER30323 [81]ER30353 [82]ER30382 [83]ER30411 [84]ER30441 [85]ER30474 [86]ER30509 [87]ER30545 [88]ER30580 [89]ER30616 [90]ER30653 [91]ER30699 [92]ER30744 [93]ER30816 [94]ER33111 [95]ER33211 [96]ER33311 [97]ER33411 [99]ER33512 [01]ER33612 [03]ER33712 [05]ER33813 [07]ER33913 [09]ER34016 [11]ER34116 [13]ER34216 [15]ER34317

|| hrsWorkedIndiv
[68]ER30013 [69]ER30034 [70]ER30058 [71]ER30082 [72]ER30107 [73]ER30131 [74]ER30153 [75]ER30177 [76]ER30204 [77]ER30233 [78]ER30270 [79]ER30300 [80]ER30330 [81]ER30360 [82]ER30388 [83]ER30417 [84]ER30447 [85]ER30482 [86]ER30517 [87]ER30553 [88]ER30588 [89]ER30624 [90]ER30661 [91]ER30709 [92]ER30754 [93]ER30823

|| hrsWorkedHead
[68]V47 [69]V465 [70]V1138 [71]V1839 [72]V2439 [73]V3027 [74]V3423 [75]V3823 [76]V4332 [77]V5232 [78]V5731 [79]V6336 [80]V6934 [81]V7530 [82]V8228 [83]V8830 [84]V10037 [85]V11146 [86]V12545 [87]V13745 [88]V14835 [89]V16335 [90]V17744 [91]V19044 [92]V20344 [93]V21634 [94]ER4096 [95]ER6936 [96]ER9187 [97]ER12174 [99]ER16471 [01]ER20399 [03]ER24080 [05]ER27886 [07]ER40876 [09]ER46767 [11]ER52175 [13]ER57976 [15]ER65156

|| hrsWorkedWife
[68]V53 [69]V475 [70]V1148 [71]V1849 [72]V2449 [73]V3035 [74]V3431 [75]V3831 [76]V4344 [77]V5244 [78]V5743 [79]V6348 [80]V6946 [81]V7540 [82]V8238 [83]V8840 [84]V10131 [85]V11258 [86]V12657 [87]V13809 [88]V14865 [89]V16365 [90]V17774 [91]V19074 [92]V20374 [93]V21670 [94]ER4107 [95]ER6947 [96]ER9198 [97]ER12185 [99]ER16482 [01]ER20410 [03]ER24091 [05]ER27897 [07]ER40887 [09]ER46788 [11]ER52196 [13]ER57997 [15]ER65177

|| laborIncomeHead
[68]V74 [69]V514 [70]V1196 [71]V1897 [72]V2498 [73]V3051 [74]V3463 [75]V3863 [76]V5031 [77]V5627 [78]V6174 [79]V6767 [80]V7413 [81]V8066 [82]V8690 [83]V9376 [84]V11023 [85]V12372 [86]V13624 [87]V14671 [88]V16145 [89]V17534 [90]V18878 [91]V20178 [92]V21484 [93]V23323 [94]ER4140 [95]ER6980 [96]ER9231 [97]ER12080 [99]ER16463 [01]ER20443 [03]ER24116 [05]ER27931 [07]ER40921 [09]ER46829 [11]ER52237 [13]ER58038 [15]ER65216

|| laborIncomeWife
[68]V75 [69]V516 [70]V1198 [71]V1899 [72]V2500 [73]V3053 [74]V3465 [75]V3865 [76]V4379 [77]V5289 [78]V5788 [79]V6398 [80]V6988 [81]V7580 [82]V8273 [83]V8881 [84]V10263 [85]V11404 [86]V12803 [87]V13905 [88]V14920 [89]V16420 [90]V17836 [91]V19136 [92]V20436 [93]V23324

|| laborIncomeIndiv
[68]ER30012 [69]ER30033 [70]ER30057 [71]ER30081 [72]ER30106 [73]ER30130 [74]ER30152

|| txblIncomeIndiv
[75]ER30173 [76]ER30202 [77]ER30231 [78]ER30268 [79]ER30298 [80]ER30328 [81]ER30358 [82]ER30386 [83]ER30415 [84]ER30445 [85]ER30480 [86]ER30515 [87]ER30551 [88]ER30586 [89]ER30622 [90]ER30659 [05]ER33838F [07]ER33938F [09]ER34032D [11]ER34144D [13]ER34251D [15]ER34401D

|| wageSalaryHead
[68]V251 [69]V699 [70]V1191 [71]V1892 [72]V2493 [73]V3046 [74]V3458 [75]V3858 [76]V4373 [77]V5283 [78]V5782 [79]V6391 [80]V6981 [81]V7573 [82]V8265 [83]V8873 [84]V10256 [85]V11397 [86]V12796 [87]V13898 [88]V14913 [89]V16413 [90]V17829 [91]V19129 [92]V20429 [93]V21739 [94]ER4122 [95]ER6962 [96]ER9213 [97]ER12196 [99]ER16493 [01]ER20425 [03]ER24117 [05]ER27913 [07]ER40903 [09]ER46811 [11]ER52219 [13]ER58020 [15]ER65200

|| hrlyWageIndiv
[99]ER33537O [01]ER33628O [03]ER33728O

|| hrlyWageHead
[68]V337 [69]V871 [70]V1567 [71]V2279 [72]V2906 [73]V3275 [74]V3695 [75]V4174 [76]V5050 [77]V5631 [78]V6178 [79]V6771 [80]V7417 [81]V8069 [82]V8693 [83]V9379 [84]V11026 [85]V12377 [86]V13629 [87]V14676 [88]V16150 [89]V17536 [90]V18887 [91]V20187 [92]V21493 [94]ER4148 [95]ER6988 [96]ER9239 [97]ER12217 [99]ER16514 [01]ER20451 [03]ER24137 [05]ER28003 [07]ER40993 [09]ER46901 [11]ER52309 [13]ER58118 [15]ER65315

|| hrlyWageWife
[68]V338 [69]V873 [70]V1569 [71]V2281 [72]V2908 [73]V3277 [74]V3697 [75]V4176 [76]V5052 [77]V5632 [78]V6179 [79]V6772 [80]V7418 [81]V8070 [82]V8694 [83]V9380 [84]V11027 [85]V12378 [86]V13630 [87]V14677 [88]V16151 [89]V17537 [90]V18888 [91]V20188 [92]V21494 [94]ER4149 [95]ER6989 [96]ER9240 [97]ER12218 [99]ER16515 [01]ER20452 [03]ER24138 [05]ER28004 [07]ER40994 [09]ER46902 [11]ER52310 [13]ER58119 [15]ER65316

|| hgc 
[68]ER30010 [70]ER30052 [71]ER30076 [72]ER30100 [73]ER30126 [74]ER30147 [75]ER30169 [76]ER30197 [77]ER30226 [78]ER30255 [79]ER30296 [80]ER30326 [81]ER30356 [82]ER30384 [83]ER30413 [84]ER30443 [85]ER30478 [86]ER30513 [87]ER30549 [88]ER30584 [89]ER30620 [90]ER30657 [91]ER30703 [92]ER30748 [93]ER30820 [94]ER33115 [95]ER33215 [96]ER33315 [97]ER33415 [99]ER33516 [01]ER33616 [03]ER33716 [05]ER33817 [07]ER33917 [09]ER34020 [11]ER34119 [13]ER34230 [15]ER34349 

|| hgcHead
[68]V313 [69]V794 [70]V1485 [71]V2197 [72]V2823 [73]V3241 [74]V3663 [75]V4198 [76]V5074 [77]V5647 [78]V6194 [79]V6787 [80]V7433 [81]V8085 [82]V8709 [83]V9395 [84]V11042 [85]V12400 [86]V13640 [87]V14687 [88]V16161 [89]V17545 [90]V18898

|| hgcHeadAlt
[75]V4093 [76]V4684 [77]V5608 [78]V6157 [79]V6754 [80]V7387 [81]V8039 [82]V8663 [83]V9349 [84]V10996 [91]V20198 [92]V21504 [93]V23333 [94]ER4158 [95]ER6998 [96]ER9249 [97]ER12222 [99]ER16516 [01]ER20457 [03]ER24148 [05]ER28047 [07]ER41037 [09]ER46981 [11]ER52405 [13]ER58223 [15]ER65459

|| gradBAHead
[75]V4099 [76]V4690 [77]V5614 [78]V6163 [79]V6760 [80]V7393 [81]V8045 [82]V8669 [83]V9355 [84]V11002 [85]V11960 [86]V13583 [87]V14630 [88]V16104 [89]V17501 [90]V18832 [91]V20132 [92]V21438 [93]V23294 [94]ER3963 [95]ER6833 [96]ER9079 [97]ER11869 [99]ER15952 [01]ER20013 [03]ER23450 [05]ER27417 [07]ER40589 [09]ER46567 [11]ER51928 [13]ER57684 [15]ER64836

|| hgcWife
[68]V246 [72]V2687 [73]V3216 [74]V3638 [75]V4199 [76]V5075 [77]V5648 [78]V6195 [79]V6788 [80]V7434 [81]V8086 [82]V8710 [83]V9396 [84]V11043 [85]V12401 [86]V13641 [87]V14688 [88]V16162 [89]V17546 [90]V18899

|| hgcWifeAlt
[75]V4102 [76]V4695 [77]V5567 [78]V6116 [79]V6713 [80]V7346 [81]V7998 [82]V8622 [83]V9308 [84]V10955 [91]V20199 [92]V21505 [93]V23334 [94]ER4159 [95]ER6999 [96]ER9250 [97]ER12223 [99]ER16517 [01]ER20458 [03]ER24149 [05]ER28048 [07]ER41038 [09]ER46982 [11]ER52406 [13]ER58224 [15]ER65460

|| gradBAwife
[75]V4105 [76]V4698 [77]V5570 [78]V6119 [79]V6716 [80]V7349 [81]V8001 [82]V8625 [83]V9311 [84]V10958 [85]V12315 [86]V13513 [87]V14560 [88]V16034 [89]V17431 [90]V18762 [91]V20062 [92]V21368 [93]V23225 [94]ER3897 [95]ER6767 [96]ER9013 [97]ER11781 [99]ER15860 [01]ER19921 [03]ER23358 [05]ER27321 [07]ER40496 [09]ER46473 [11]ER51834 [13]ER57574 [15]ER64697

|| in_school 
[68]ER30009 [79]ER30294 [80]ER30324 [81]ER30354 [82]ER30383 [83]ER30412 [84]ER30442 [85]ER30477 [86]ER30512 [87]ER30548 [88]ER30583 [89]ER30619 [90]ER30656 [91]ER30702 [92]ER30747 [93]ER30819 [94]ER33114 [95]ER33214 [96]ER33314 [97]ER33414 [99]ER33515 [01]ER33615 [03]ER33715 [05]ER33816 [07]ER33916 [09]ER34019 

|| age 
[68]ER30004 [69]ER30023 [70]ER30046 [71]ER30070 [72]ER30094 [73]ER30120 [74]ER30141 [75]ER30163 [76]ER30191 [77]ER30220 [78]ER30249 [79]ER30286 [80]ER30316 [81]ER30346 [82]ER30376 [83]ER30402 [84]ER30432 [85]ER30466 [86]ER30501 [87]ER30538 [88]ER30573 [89]ER30609 [90]ER30645 [91]ER30692 [92]ER30736 [93]ER30809 [94]ER33104 [95]ER33204 [96]ER33304 [97]ER33404 [99]ER33504 [01]ER33604 [03]ER33704 [05]ER33804 [07]ER33904 [09]ER34004 [11]ER34104 [13]ER34204 [15]ER34305 

|| birthyr 
[83]ER30404 [84]ER30434 [85]ER30468 [86]ER30503 [87]ER30540 [88]ER30575 [89]ER30611 [90]ER30647 [91]ER30694 [92]ER30738 [93]ER30811 [94]ER33106 [95]ER33206 [96]ER33306 [97]ER33406 [99]ER33506 [01]ER33606 [03]ER33706 [05]ER33806 [07]ER33906 [09]ER34006 [11]ER34106 [13]ER34206 [15]ER34307 

|| svywgt 
[68]ER30019 [69]ER30042 [70]ER30066 [71]ER30090 [72]ER30116 [73]ER30137 [74]ER30159 [75]ER30187 [76]ER30216 [77]ER30245 [78]ER30282 [79]ER30312 [80]ER30342 [81]ER30372 [82]ER30398 [83]ER30428 [84]ER30462 [85]ER30497 [86]ER30534 [87]ER30569 [88]ER30605 [89]ER30641 [90]ER30686 [91]ER30730 [92]ER30803 [93]ER30864 [94]ER33119 [95]ER33275 [96]ER33318 [97]ER33430 [99]ER33546 [01]ER33637 [03]ER33740 [05]ER33848 [07]ER33950 [09]ER34045 [11]ER34154 [13]ER34268 [15]ER34413 

|| raceHead
[68]V181 [69]V801 [70]V1490 [71]V2202 [72]V2828 [73]V3300 [74]V3720 [75]V4204 [76]V5096 [77]V5662 [78]V6209 [79]V6802 [80]V7447 [81]V8099 [82]V8723 [83]V9408 [84]V11055 [85]V11938 [86]V13565 [87]V14612 [88]V16086 [89]V17483 [90]V18814 [91]V20114 [92]V21420 [93]V23276 [94]ER3944 [95]ER6814 [96]ER9060 [97]ER11848 [99]ER15928 [01]ER19989 [03]ER23426 [05]ER27393 [07]ER40565 [09]ER46543 [11]ER51904 [13]ER57659 [15]ER64810

|| raceWife
[85]V12293 [86]V13500 [87]V14547 [88]V16021 [89]V17418 [90]V18749 [91]V20049 [92]V21355 [93]V23212 [94]ER3883 [95]ER6753 [96]ER8999 [97]ER11760 [99]ER15836 [01]ER19897 [03]ER23334 [05]ER27297 [07]ER40472 [09]ER46449 [11]ER51810 [13]ER57549 [15]ER64671

|| relHD
[68]ER30003 [69]ER30022 [70]ER30045 [71]ER30069 [72]ER30093 [73]ER30119 [74]ER30140 [75]ER30162 [76]ER30190 [77]ER30219 [78]ER30248 [79]ER30285 [80]ER30315 [81]ER30345 [82]ER30375 [83]ER30401 [84]ER30431 [85]ER30465 [86]ER30500 [87]ER30537 [88]ER30572 [89]ER30608 [90]ER30644 [91]ER30691 [92]ER30735 [93]ER30808 [94]ER33103 [95]ER33203 [96]ER33303 [97]ER33403 [99]ER33503 [01]ER33603 [03]ER33703 [05]ER33803 [07]ER33903 [09]ER34003 [11]ER34103 [13]ER34203 [15]ER34303

|| mightMoveHD
[68]V111 [69]V605 [70]V1276 [71]V1981 [72]V2579 [73]V3112 [74]V3526 [75]V3944 [76]V4455 [77]V5369 [78]V5869 [79]V6487 [80]V7092 [81]V7703 [82]V8371 [83]V9002 [84]V10450 [85]V11631 [86]V13040 [87]V14143 [88]V15151 [89]V16652 [90]V18090 [91]V19390 [92]V20690 [93]V22445 [95]ER5066A [96]ER7161 [97]ER10079 [99]ER13084 [01]ER17095 [03]ER21121 [05]ER25102 [07]ER36107 [09]ER42138 [11]ER47446 [13]ER53146 [15]ER60161

|| movedSinceSpring
[69]V603 [70]V1274 [71]V1979 [72]V2577 [73]V3110 [74]V3524 [75]V3941 [76]V4452 [77]V5366 [78]V5866 [79]V6484 [80]V7089 [81]V7700 [82]V8369 [83]V8999 [84]V10447 [85]V11628 [86]V13037 [87]V14140 [88]V15148 [89]V16649 [90]V18087 [91]V19387 [92]V20687 [93]V22441 [94]ER2062 [95]ER5061 [96]ER7155 [97]ER10072 [99]ER13077 [01]ER17088 [03]ER21117 [05]ER25098 [07]ER36103 [09]ER42132 [11]ER47440 [13]ER53140 [15]ER60155

|| advDegDumHD
[75]V4100 [76]V4691 [77]V5615 [78]V6164 [79]V6761 [80]V7394 [81]V8046 [82]V8670 [83]V9356 [84]V11003

|| advDegDumWife
[75]V4106 [76]V4699 [77]V5571 [78]V6120 [79]V6717 [80]V7350 [81]V8002 [82]V8626 [83]V9312 [84]V10959

|| highDegHD
[85]V11961 [86]V13584 [87]V14631 [88]V16105 [89]V17502 [90]V18833 [91]V20133 [92]V21439 [93]V23295 [94]ER3964 [95]ER6834 [96]ER9080 [97]ER11870 [99]ER15953 [01]ER20014 [03]ER23451 [05]ER27418 [07]ER40590 [09]ER46568 [11]ER51929 [13]ER57685 [15]ER64837

|| highDegWife
[85]V12316 [86]V13514 [87]V14561 [88]V16035 [89]V17432 [90]V18763 [91]V20063 [92]V21369 [93]V23226 [94]ER3898 [95]ER6768 [96]ER9014 [97]ER11782 [99]ER15861 [01]ER19922 [03]ER23359 [05]ER27322 [07]ER40497 [09]ER46474 [11]ER51835 [13]ER57575 [15]ER64698

using ../RawData, design(any) clear keepnotes;
#delimit cr

*-------------------------------------------------------------------
* Import gender and 1968 parent IDs
*-------------------------------------------------------------------
preserve
    tempfile sexdata
    #delimit ;
    *  PSID DATA CENTER *****************************************************
       JOBID            : 244930                            
       DATA_DOMAIN      : IND                               
       USER_WHERE       : NULL                              
       FILE_TYPE        : All Individuals Data              
       OUTPUT_DATA_TYPE : ASCII                             
       STATEMENTS       : do                                
       CODEBOOK_TYPE    : PDF                               
       N_OF_VARIABLES   : 8                                 
       N_OF_OBSERVATIONS: 77223                             
       MAX_REC_LENGTH   : 22                                
       DATE & TIME      : May 22, 2018 @ 15:15:12
    *************************************************************************
    ;

    infix
          ER30000              1 - 1           ER30001              2 - 5           ER30002              6 - 8     
          ER32000              9 - 9           ER32006             10 - 10          ER32009             11 - 14    
          ER32016             15 - 18          ER32050             19 - 22    
    using sexdata.txt, clear 
    ;
    label variable ER30000       "RELEASE NUMBER"                           ;
    label variable ER30001       "1968 INTERVIEW NUMBER"                    ;
    label variable ER30002       "PERSON NUMBER                         68" ;
    label variable ER32000       "SEX OF INDIVIDUAL"                        ;
    label variable ER32006       "WHETHER SAMPLE OR NONSAMPLE"              ;
    label variable ER32009       "1968 ID OF MOTHER"                        ;
    label variable ER32016       "1968 ID OF FATHER"                        ;
    label variable ER32050       "YEAR OF DEATH"                            ;

    #delimit cr

    gen  x11101ll=(ER30001 * 1000) + ER30002
    drop ER30000 ER30001 ER30002
    ren  ER32000 sex
    ren  ER32006 sampleOrNot
    ren  ER32009 mothID1968
    ren  ER32016 fathID1968
    ren  ER32050 yrDied

    save `sexdata', replace
restore

merge 1:1 x11101ll using `sexdata', nogen

*-------------------------------------------------------------------
* recode missing wage values
*-------------------------------------------------------------------
foreach yy in 1968 1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1994 1995 1996 1997 1999 2001 2003 2005 2007 2009 2011 2013 2015 {
    if `yy'<1976 {
        recode hrlyWageHead`yy' hrlyWageWife`yy' (99.99 0 = .) 
    }
    else if inrange(`yy',1976,1993) | inrange(`yy',2003,2015) {
        recode hrlyWageHead`yy' hrlyWageWife`yy' (      0 = .) 
    }
    else if inrange(`yy',1994,2001) {
        recode hrlyWageHead`yy' hrlyWageWife`yy' (9998 9999 9999.99 0 = .) 
    }
}

* hgc:
recode hgc* (98 99 = .)

recode raceHead* raceWife* (9 8 = .)

recode advDegDum* highDeg* (0 = 999)

*-------------------------------------------------------------------
* recode 0s as missing
*-------------------------------------------------------------------
recode _all (0 = .)

*-------------------------------------------------------------------
* reshape long
*-------------------------------------------------------------------
psid long

*-------------------------------------------------------------------
* create ID variable and declare panel structure of data
*-------------------------------------------------------------------
ren x11101ll id // individual ID
xtset id wave
gen id1968 = floor(id/1000) // "1968 ID"
gen   hhid = x11102         // year-by-year household ID (not constant across time)

*-------------------------------------------------------------------
* Only keep SRC sample
*-------------------------------------------------------------------
gen     sample = .
replace sample = 1 if inrange(x11102,   1,2999)
replace sample = 2 if inrange(x11102,5001,6999)
replace sample = 3 if inrange(x11102,3001,3999)
replace sample = 4 if inrange(x11102,7001,9999)
lab def vlsample 1 "SRC" 2 "SEO (disadvantaged)" 3 "Immigrant" 4 "Latino"

drop x11102
keep if inlist(sample,1,2,3,4) // only use the original non-disadvantaged sample (to match with NLSY)

sum , d

*-------------------------------------------------------------------
* create head and wife variables
*-------------------------------------------------------------------
replace xsqnr=relHD if wave==1968

gen     head = (xsqnr==1)
replace head = . if mi(xsqnr)

gen     wife = (xsqnr==2)
replace wife = . if mi(xsqnr)

gen     died = inrange(xsqnr,81,89)
replace died = . if mi(xsqnr)

*-------------------------------------------------------------------
* drop obs of people before they arrive in the panel (e.g. future children)
*-------------------------------------------------------------------
drop if mi(age)
drop if !inrange(age,18,60)

* l id hhid wave xsqnr head sex *ncome* *age* hrsWorked* in 1/100 , sepby(id)

* l id hhid wave xsqnr head sex* *age* yrDied in 1/100, sepby(id)

*-------------------------------------------------------------------
* Generate some employment measures
*-------------------------------------------------------------------
gen     empPT = .
replace empPT = inrange(hrsWorkedHead,500,1500) if head==1
replace empPT = inrange(hrsWorkedWife,500,1500) if wife==1
replace empPT = inrange(hrsWorkedIndiv,500,1500) if wife==0 & head==0 & !mi(hrsWorkedIndiv)

gen     empFT = .
replace empFT = inrange(hrsWorkedHead,1500.00001,.) if head==1
replace empFT = inrange(hrsWorkedWife,1500.00001,.) if wife==1
replace empFT = inrange(hrsWorkedIndiv,1500.00001,.) if wife==0 & head==0 & !mi(hrsWorkedIndiv)

gen      wage = .
replace  wage = hrlyWageHead  if head==1 & (empPT | empFT)
replace  wage = hrlyWageWife  if wife==1 & (empPT | empFT)
replace  wage = hrlyWageIndiv if mi(wage) & !mi(hrlyWageIndiv) & (empPT | empFT)

do ../cpi_min_wage.do

replace wage = wage/cpi

sum wage if (empPT | empFT), d

* l id wave head wife hrsWorkedHead hrsWorkedWife wage empPT empFT hgc age birthyr in 1/50, sepby(id)

*-------------------------------------------------------------------
* Create demographic variables
*-------------------------------------------------------------------
* gender
gen female = sex==2
gen   male = sex==1
drop if sex==9

* race
gen     race = .
replace race = raceHead if head==1
replace race = raceWife if wife==1
egen    race_mean = mean(race), by(id)
replace race = round(race_mean) if mi(race)
* l id wave head wife race race_mean hgc age birthyr in 1/50, sepby(id)
drop race_mean

* impute children's/others' race as same as head in first non-missing instance
bys id (wave): egen firstmissrace = min(cond(race == ., wave, .))
* l id wave head wife race firstmissrace hgc age birthyr in 1/100, sepby(id)
replace race = raceHead if mi(race) & wave==firstmissrace
egen    race_mean = mean(race), by(id)
replace race = round(race_mean) if mi(race)
* l id wave head wife race race_mean firstmissrace hgc age birthyr in 1/100, sepby(id)

gen white = (race==1) if !mi(race)
gen black = (race==2) if !mi(race)
gen other = (race>=3) if !mi(race)

sum white black other if !mi(race)
mdesc race


* birth cohort
drop    birthyr*
gen     birthyr = wave-age
egen    mean_birthyr = mean(birthyr), by(id)
replace birthyr = round(mean_birthyr)

*-------------------------------------------------------------------
* Create education attainment variables
*-------------------------------------------------------------------
mdesc hgc if !mi(wage)
* carry forward hgc variable in years it wasn't updated
bys id (wave): ipolate hgc wave , gen(hgc_ipolate)
replace hgc = hgc_ipolate if mi(hgc)

* l id wave head wife hrsWorkedHead hrsWorkedWife wage empPT empFT hgc hgc_ipolate age birthyr in 501/550, sepby(id)
mdesc hgc if !mi(wage)
drop hgc_ipolate

* carry backwards hgc variable in years it wasn't updated
*bys id (wave): ipolate hgc wave , gen(hgc_ipolate) epolate
*replace hgc = hgc_ipolate if mi(hgc)

* l id wave head wife hrsWorkedHead hrsWorkedWife wage empPT empFT hgc hgc_ipolate age birthyr in 501/550, sepby(id)
mdesc hgc if !mi(wage)
*drop hgc_ipolate

* if only has one valid value of hgc, set that value for all observations of that person
bys id (wave): egen hgc_count = count(hgc)
bys id (wave): egen hgc_const = mean(hgc) if hgc_count==1 
replace hgc = round(hgc_const) if mi(hgc)

* l id wave head wife hrsWorkedHead hrsWorkedWife wage empPT empFT hgc hgc_count hgc_const age birthyr in 501/550, sepby(id)
mdesc hgc if !mi(wage)
drop hgc_*

* generate degree receipt from hgc variable
gen gradHS  = hgc>=12
gen grad4yr = hgc>=16

* generate grad degrees
recode highDegHD   (1/2 = 0) (3/6 = 1) (8/99 = .) (999 = 0)
recode highDegWife (1/2 = 0) (3/6 = 1) (8/99 = .) (999 = 0)
generat advDeg = .
replace advDeg = advDegDumHD   if head==1 & wave<=1984
replace advDeg = advDegDumWife if wife==1 & wave<=1984
recode  advDeg (5 = 0) (9 = .) (999 = 0)
replace advDeg = highDegHD   if head==1 & wave>=1985
replace advDeg = highDegWife if wife==1 & wave>=1985

gen     gradGrad = advDeg
replace gradGrad = 0 if grad4yr==0 | gradHS==0

sum gradGrad if !gradHS
sum gradGrad if  gradHS & !grad4yr
sum gradGrad if            grad4yr

*-------------------------------------------------------------------
* Drop observations missing race or education level
*-------------------------------------------------------------------
drop if mi(race) | mi(hgc)

*-------------------------------------------------------------------
* Do basic wage regressions make sense?
*-------------------------------------------------------------------
gen logwage = ln(wage)
reg logwage gradHS grad4yr gradGrad [aw=svywgt] if   male & inrange(wage,2,100) & empFT==1
reg logwage gradHS grad4yr gradGrad [aw=svywgt] if female & inrange(wage,2,100) & empFT==1

tab hgc if inrange(age,25,34) & !mi(logwage) & inrange(wage,2,100) & empFT==1

* sample size for full-time workers
tab birthyr if inrange(age,25,34) & !mi(logwage) & inrange(wage,2,100) & empFT==1

* keep only necessary variables
keep id wave xsqnr hgc age svywgt sex wage head wife relHD hhid emp?? female male white black other birthyr gradHS grad4yr gradGrad mightMoveHD movedSinceSpring
compress

cd ..
save psid_master, replace

log close

