version 13.0
clear all
set more off
capture log close

log using "y97_create_all.log", replace

* do y97_import_all
do y97_create_master
do y97_create_trim

log using "y97_create_all.log", append
log close
