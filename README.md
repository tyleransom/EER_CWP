# EER_CWP
Data and code to replicate Ashworth and Ransom (2019, *Economics of Education Review*)

## Replication
To replicate all analyses, simply run the file `master.do`. You will need roughly 30 GB of free hard-drive space.

## Data
Data for each survey are either provided (NLSY, PSID), or downloadable via a shell script (CPS, SIPP) that is called within `master.do`.

Note that source data for the Decennial Census and American Community Survey is not provided here, as per IPUMS guidelines. Users may download the data themselves by creating an account at IPUMS and selecting from the following samples the following variables:

### IPUMS Samples
```
Sample   Density Note
1980     5%      state 5.0% 
1990     5%      state 5.0% 
2000     5%      5.0% 
2001 ACS 0.43%   Does not include persons in group quarters.
2002 ACS 0.38%   Does not include persons in group quarters.
2003 ACS 0.42%   Does not include persons in group quarters.
2004 ACS 0.42%   Does not include persons in group quarters.
2005 ACS 1.0%    Does not include persons in group quarters.
2006 ACS 1.0% 
2007 ACS 1.0% 
2008 ACS 1.0% 
2009 ACS 1.0% 
2010 ACS 1.0% 
2011 ACS 1.0% 
2012 ACS 1.0% 
2013 ACS 1.0% 
2014 ACS 1.0% 
2015 ACS 1.0% 
2016 ACS 1.0% 
```

### IPUMS variables
```
Type Variable             Label
H    YEAR                 Census year
H    DATANUM              Data set number
H    SERIAL               Household serial number
H    HHWT                 Household weight
H    REGION               Census region and division
H    STATEFIP             State (FIPS code)
H    METRO                Metropolitan status
H    METAREA (general)    Metropolitan area [general version]
H    METAREAD (detailed)  Metropolitan area [detailed version]
H    GQ                   Group quarters status
P    PERNUM               Person number in sample unit
P    PERWT                Person weight
P    SEX                  Sex
P    AGE                  Age
P    RACE (general)       Race [general version]
P    RACED (detailed)     Race [detailed version]
P    HISPAN (general)     Hispanic origin [general version]
P    HISPAND (detailed)   Hispanic origin [detailed version]
P    SCHOOL               School attendance
P    EDUC (general)       Educational attainment [general version]
P    EDUCD (detailed)     Educational attainment [detailed version]
P    EMPSTAT (general)    Employment status [general version]
P    EMPSTATD (detailed)  Employment status [detailed version]
P    LABFORCE             Labor force status
P    OCC1990              Occupation, 1990 basis
P    IND1990              Industry, 1990 basis
P    CLASSWKR (general)   Class of worker [general version]
P    CLASSWKRD (detailed) Class of worker [detailed version]
P    WKSWORK1             Weeks worked last year
P    WKSWORK2             Weeks worked last year, intervalled
P    UHRSWORK             Usual hours worked per week
P    INCWAGE              Wage and salary income
```


