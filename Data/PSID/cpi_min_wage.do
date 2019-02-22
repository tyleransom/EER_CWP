***********************************************
* Create fed min wage and cpi
* http://www.dol.gov/whd/minwage/chart.htm
* http://lmi2.detma.org/lmi/pdf/MinimumWage.pdf
* and
* http://www.bls.gov/cpi/
***********************************************

generat fedMinWage=0.25 if wave==1938
replace fedMinWage=0.30 if wave==1939
replace fedMinWage=0.30 if wave==1940
replace fedMinWage=0.30 if wave==1941
replace fedMinWage=0.30 if wave==1942
replace fedMinWage=0.30 if wave==1943
replace fedMinWage=0.30 if wave==1944
replace fedMinWage=0.40 if wave==1945
replace fedMinWage=0.40 if wave==1946
replace fedMinWage=0.40 if wave==1947
replace fedMinWage=0.40 if wave==1948
replace fedMinWage=0.40 if wave==1949
replace fedMinWage=0.75 if wave==1950
replace fedMinWage=0.75 if wave==1951
replace fedMinWage=0.75 if wave==1952
replace fedMinWage=0.75 if wave==1953
replace fedMinWage=0.75 if wave==1954
replace fedMinWage=0.75 if wave==1955
replace fedMinWage=1.00 if wave==1956
replace fedMinWage=1.00 if wave==1957
replace fedMinWage=1.00 if wave==1958
replace fedMinWage=1.00 if wave==1959
replace fedMinWage=1.00 if wave==1960
replace fedMinWage=1.15 if wave==1961
replace fedMinWage=1.15 if wave==1962
replace fedMinWage=1.25 if wave==1963
replace fedMinWage=1.25 if wave==1964
replace fedMinWage=1.25 if wave==1965
replace fedMinWage=1.25 if wave==1966
replace fedMinWage=1.40 if wave==1967
replace fedMinWage=1.60 if wave==1968
replace fedMinWage=1.60 if wave==1969
replace fedMinWage=1.60 if wave==1970
replace fedMinWage=1.60 if wave==1971
replace fedMinWage=1.60 if wave==1972
replace fedMinWage=1.60 if wave==1973
replace fedMinWage=2.00 if wave==1974
replace fedMinWage=2.10 if wave==1975
replace fedMinWage=2.30 if wave==1976
replace fedMinWage=2.30 if wave==1977
replace fedMinWage=2.65 if wave==1978
replace fedMinWage=2.90 if wave==1979
replace fedMinWage=3.10 if wave==1980
replace fedMinWage=3.35 if wave==1981
replace fedMinWage=3.35 if wave==1982
replace fedMinWage=3.35 if wave==1983
replace fedMinWage=3.35 if wave==1984
replace fedMinWage=3.35 if wave==1985
replace fedMinWage=3.35 if wave==1986
replace fedMinWage=3.35 if wave==1987
replace fedMinWage=3.35 if wave==1988
replace fedMinWage=3.35 if wave==1989
replace fedMinWage=3.80 if wave==1990
replace fedMinWage=4.25 if wave==1991
replace fedMinWage=4.25 if wave==1992
replace fedMinWage=4.25 if wave==1993
replace fedMinWage=4.25 if wave==1994
replace fedMinWage=4.25 if wave==1995
replace fedMinWage=4.75 if wave==1996
replace fedMinWage=5.15 if wave==1997
replace fedMinWage=5.15 if wave==1998
replace fedMinWage=5.15 if wave==1999
replace fedMinWage=5.15 if wave==2000
replace fedMinWage=5.15 if wave==2001
replace fedMinWage=5.15 if wave==2002
replace fedMinWage=5.15 if wave==2003
replace fedMinWage=5.15 if wave==2004
replace fedMinWage=5.15 if wave==2005
replace fedMinWage=5.15 if wave==2006
replace fedMinWage=5.85 if wave==2007
replace fedMinWage=6.55 if wave==2008
replace fedMinWage=7.25 if wave==2009
replace fedMinWage=7.25 if wave==2010
replace fedMinWage=7.25 if wave==2011
replace fedMinWage=7.25 if wave==2012

generat cpi= 14.100 if wave==1938
replace cpi= 13.900 if wave==1939
replace cpi= 14.000 if wave==1940
replace cpi= 14.700 if wave==1941
replace cpi= 16.300 if wave==1942
replace cpi= 17.300 if wave==1943
replace cpi= 17.600 if wave==1944
replace cpi= 18.000 if wave==1945
replace cpi= 19.500 if wave==1946
replace cpi= 22.300 if wave==1947
replace cpi= 24.100 if wave==1948
replace cpi= 23.800 if wave==1949
replace cpi= 24.100 if wave==1950
replace cpi= 26.000 if wave==1951
replace cpi= 26.500 if wave==1952
replace cpi= 26.700 if wave==1953
replace cpi= 26.900 if wave==1954
replace cpi= 26.800 if wave==1955
replace cpi= 27.200 if wave==1956
replace cpi= 28.100 if wave==1957
replace cpi= 28.900 if wave==1958
replace cpi= 29.100 if wave==1959
replace cpi= 29.600 if wave==1960
replace cpi= 29.900 if wave==1961
replace cpi= 30.200 if wave==1962
replace cpi= 30.600 if wave==1963
replace cpi= 31.000 if wave==1964
replace cpi= 31.500 if wave==1965
replace cpi= 32.400 if wave==1966
replace cpi= 33.400 if wave==1967
replace cpi= 34.800 if wave==1968
replace cpi= 36.700 if wave==1969
replace cpi= 38.800 if wave==1970
replace cpi= 40.500 if wave==1971
replace cpi= 41.800 if wave==1972
replace cpi= 44.400 if wave==1973
replace cpi= 49.300 if wave==1974
replace cpi= 53.800 if wave==1975
replace cpi= 56.900 if wave==1976
replace cpi= 60.600 if wave==1977
replace cpi= 65.200 if wave==1978
replace cpi= 72.600 if wave==1979
replace cpi= 82.400 if wave==1980
replace cpi= 90.900 if wave==1981
replace cpi= 96.500 if wave==1982
replace cpi= 99.600 if wave==1983
replace cpi=103.900 if wave==1984
replace cpi=107.600 if wave==1985
replace cpi=109.600 if wave==1986
replace cpi=113.600 if wave==1987
replace cpi=118.300 if wave==1988
replace cpi=124.000 if wave==1989
replace cpi=130.700 if wave==1990
replace cpi=136.200 if wave==1991
replace cpi=140.300 if wave==1992
replace cpi=144.500 if wave==1993
replace cpi=148.200 if wave==1994
replace cpi=152.400 if wave==1995
replace cpi=156.900 if wave==1996
replace cpi=160.500 if wave==1997
replace cpi=163.000 if wave==1998
replace cpi=166.600 if wave==1999
replace cpi=172.200 if wave==2000
replace cpi=177.100 if wave==2001
replace cpi=179.900 if wave==2002
replace cpi=184.000 if wave==2003
replace cpi=188.900 if wave==2004
replace cpi=195.300 if wave==2005
replace cpi=201.600 if wave==2006
replace cpi=207.342 if wave==2007
replace cpi=215.303 if wave==2008
replace cpi=214.537 if wave==2009
replace cpi=218.056 if wave==2010
replace cpi=224.939 if wave==2011
replace cpi=229.594 if wave==2012
replace cpi=232.957 if wave==2013
replace cpi=236.704 if wave==2014
replace cpi=236.987 if wave==2015
replace cpi=240.001 if wave==2016

replace fedMinWage = fedMinWage*100
replace cpi=cpi/100

lab var fedMinWage "Federal Minimum Wage (undeflated)"
lab var cpi "CPI-Urban/100 (1982-84)"
