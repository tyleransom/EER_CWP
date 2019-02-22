version 13.0
clear all

capture log close
log using sipp_master_do_file.log, replace

do sipp_84to93_master_readin
do sipp_84to93_master
do sipp_96to08_master_readin
do sipp_96to08_master
do sipp_combining_master

* At some point should add some code to delete all "Temp" files
* Basically, given the structure of the files, I would say delete all
* Temp/*.dta files, since the ones we want are the .gz files.

* like: rm Temp/*.dta
* Or just rm everything in Temp, but I'd lean towards keeping the gz files
* (check for errors?) 
!rm Temp/*.dta

* Also, consider splitting the master file in two chunks of 49 MB each
*  Splitted it

capture log close
log using sipp_master_do_file.log, append
log close
