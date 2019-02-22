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
using [path]\J244930.txt, clear 
;
label variable ER30000       "RELEASE NUMBER"                           ;
label variable ER30001       "1968 INTERVIEW NUMBER"                    ;
label variable ER30002       "PERSON NUMBER                         68" ;
label variable ER32000       "SEX OF INDIVIDUAL"                        ;
label variable ER32006       "WHETHER SAMPLE OR NONSAMPLE"              ;
label variable ER32009       "1968 ID OF MOTHER"                        ;
label variable ER32016       "1968 ID OF FATHER"                        ;
label variable ER32050       "YEAR OF DEATH"                            ;
