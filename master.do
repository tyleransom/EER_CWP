version 14.1
clear all
set more off
capture log using master.log, replace

*------------------------------------------------------------------------------
* Create data
*------------------------------------------------------------------------------
* ACS/Census
** first need to download file from IPUMS (or zipped version on journal website)
do Data/ACS/finaldo/cleaner.do

* CPS
cd Data/CPS
!./download_MORG_all.sh
do CPS_import.do
cd ../..

* NLSY
do Data/NLSY/y79/import_all.do
do Data/NLSY/y79/create_master.do
do Data/NLSY/y97/import_all.do
do Data/NLSY/y97/create_master.do
do Data/NLSY/data_append.do

* PSID
do Data/PSID/create_master.do

* SIPP
cd Data/SIPP
!./download_NBER_all.sh
do sipp_master_do_file.do
cd ../..


*------------------------------------------------------------------------------
* Analysis
*  Note: The first 11 files can be run in parallel (Modified usage of 
*        gunzip > tmp.dta to allow for parallel jobs within folder)
*------------------------------------------------------------------------------
* ACS/Census
do Analysis/ACS/acs_regs.do
do Analysis/ACS/acs_regs2.do
do Analysis/ACS/acs_means.do

* CPS
do Analysis/CPS/cps_regs.do
do Analysis/CPS/cps_regs_earnings.do
do Analysis/CPS/cps_regs2.do
do Analysis/CPS/cps_means.do

* NLSY
do Analysis/NLSY/nlsy_regs.do
do Analysis/NLSY/nlsy_regs2.do
do Analysis/NLSY/nlsy_means.do

* PSID
do Analysis/PSID/psid_regs.do
do Analysis/PSID/psid_regs2.do
do Analysis/PSID/psid_means.do

* SIPP
do Analysis/SIPP/sipp_regs.do
do Analysis/SIPP/sipp_regs2.do
do Analysis/SIPP/sipp_means.do

* Combined
do Analysis/compare_means.do
do Analysis/compare_premia.do
do Analysis/compare_premia_earnings.do
do Analysis/compare_premia_smooth.do
do Analysis/compare_premia_smooth2.do

log close

