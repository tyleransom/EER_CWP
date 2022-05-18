#!/bin/sh

# Download SIPP data from NBER website

cd NBER

# download raw data dictionaries
wget -O sip84fp.dct      https://data.nber.org/sipp/1984/sip84fp.dct
wget -O sip84rt3.dct     https://data.nber.org/sipp/1984/sip84rt3.dct
wget -O sip86fp.dct      https://data.nber.org/sipp/1986/sip86fp.dct
wget -O sip86rt2.dct     https://data.nber.org/sipp/1986/sip86rt2.dct
wget -O sip87fp.dct      https://data.nber.org/sipp/1987/sip87fp.dct
wget -O sip87rt2.dct     https://data.nber.org/sipp/1987/sip87rt2.dct
wget -O sip88fp.dct      https://data.nber.org/sipp/1988/sip88fp.dct
wget -O sip88rt2.dct     https://data.nber.org/sipp/1988/sip88rt2.dct
wget -O sip90fp.dct      https://data.nber.org/sipp/1990/sip90fp.dct
wget -O sip90t2.dct      https://data.nber.org/sipp/1990/sip90t2.dct
wget -O sip91fp.dct      https://data.nber.org/sipp/1991/sip91fp.dct
wget -O sip91t2.dct      https://data.nber.org/sipp/1991/sip91t2.dct
wget -O sip92fp.dct      https://data.nber.org/sipp/1992/sip92fp.dct
wget -O sip92t2.dct      https://data.nber.org/sipp/1992/sip92t2.dct
wget -O sip93fp.dct      https://data.nber.org/sipp/1993/sip93fp.dct
wget -O sip93t2.dct      https://data.nber.org/sipp/1993/sip93t2.dct
wget -O sip96l1.dct      https://data.nber.org/sipp/1996/sip96l1.dct
wget -O sip96l2.dct      https://data.nber.org/sipp/1996/sip96l2.dct
wget -O sip96l3.dct      https://data.nber.org/sipp/1996/sip96l3.dct
wget -O sip96l4.dct      https://data.nber.org/sipp/1996/sip96l4.dct
wget -O sip96l5.dct      https://data.nber.org/sipp/1996/sip96l5.dct
wget -O sip96l6.dct      https://data.nber.org/sipp/1996/sip96l6.dct
wget -O sip96l7.dct      https://data.nber.org/sipp/1996/sip96l7.dct
wget -O sip96l8.dct      https://data.nber.org/sipp/1996/sip96l8.dct
wget -O sip96l9.dct      https://data.nber.org/sipp/1996/sip96l9.dct
wget -O sip96l10.dct     https://data.nber.org/sipp/1996/sip96l10.dct
wget -O sip96l11.dct     https://data.nber.org/sipp/1996/sip96l11.dct
wget -O sip96l12.dct     https://data.nber.org/sipp/1996/sip96l12.dct
wget -O sip96t2.dct      https://data.nber.org/sipp/1996/sip96t2.dct
wget -O sip01w1.dct      https://data.nber.org/sipp/2001/sip01w1.dct
wget -O sip01w2.dct      https://data.nber.org/sipp/2001/sip01w2.dct
wget -O sip01w3.dct      https://data.nber.org/sipp/2001/sip01w3.dct
wget -O sip01w4.dct      https://data.nber.org/sipp/2001/sip01w4.dct
wget -O sip01w5.dct      https://data.nber.org/sipp/2001/sip01w5.dct
wget -O sip01w6.dct      https://data.nber.org/sipp/2001/sip01w6.dct
wget -O sip01w7.dct      https://data.nber.org/sipp/2001/sip01w7.dct
wget -O sip01w8.dct      https://data.nber.org/sipp/2001/sip01w8.dct
wget -O sip01w9.dct      https://data.nber.org/sipp/2001/sip01w9.dct
wget -O sip01t2.dct      https://data.nber.org/sipp/2001/sip01t2.dct
wget -O sip04w1.dct      https://data.nber.org/sipp/2004/sip04w1.dct
wget -O sip04w2.dct      https://data.nber.org/sipp/2004/sip04w2.dct
wget -O sip04w3.dct      https://data.nber.org/sipp/2004/sip04w3.dct
wget -O sip04w4.dct      https://data.nber.org/sipp/2004/sip04w4.dct
wget -O sip04w5.dct      https://data.nber.org/sipp/2004/sip04w5.dct
wget -O sip04w6.dct      https://data.nber.org/sipp/2004/sip04w6.dct
wget -O sip04w7.dct      https://data.nber.org/sipp/2004/sip04w7.dct
wget -O sip04w8.dct      https://data.nber.org/sipp/2004/sip04w8.dct
wget -O sip04w9.dct      https://data.nber.org/sipp/2004/sip04w9.dct
wget -O sip04w10.dct     https://data.nber.org/sipp/2004/sip04w10.dct
wget -O sip04w11.dct     https://data.nber.org/sipp/2004/sip04w11.dct
wget -O sip04w12.dct     https://data.nber.org/sipp/2004/sip04w12.dct
wget -O sip04t2.dct      https://data.nber.org/sipp/2004/sip04t2.dct
sleep 1
wget -O sippl08puw1.dct  https://data.nber.org/sipp/2008/sippl08puw1.dct
sleep 1
wget -O sippl08puw2.dct  https://data.nber.org/sipp/2008/sippl08puw2.dct
sleep 1
wget -O sippl08puw3.dct  https://data.nber.org/sipp/2008/sippl08puw3.dct
sleep 1
wget -O sippl08puw4.dct  https://data.nber.org/sipp/2008/sippl08puw4.dct
sleep 1
wget -O sippl08puw5.dct  https://data.nber.org/sipp/2008/sippl08puw5.dct
sleep 1
wget -O sippl08puw6.dct  https://data.nber.org/sipp/2008/sippl08puw6.dct
sleep 1
wget -O sippl08puw7.dct  https://data.nber.org/sipp/2008/sippl08puw7.dct
sleep 1
wget -O sippl08puw8.dct  https://data.nber.org/sipp/2008/sippl08puw8.dct
sleep 1
wget -O sippl08puw9.dct  https://data.nber.org/sipp/2008/sippl08puw9.dct
sleep 1
wget -O sippl08puw10.dct https://data.nber.org/sipp/2008/sippl08puw10.dct
sleep 1
wget -O sippl08puw11.dct https://data.nber.org/sipp/2008/sippl08puw11.dct
sleep 1
wget -O sippl08puw12.dct https://data.nber.org/sipp/2008/sippl08puw12.dct
sleep 1
wget -O sippl08puw13.dct https://data.nber.org/sipp/2008/sippl08puw13.dct
sleep 1
wget -O sippl08puw14.dct https://data.nber.org/sipp/2008/sippl08puw14.dct
sleep 1
wget -O sippl08puw15.dct https://data.nber.org/sipp/2008/sippl08puw15.dct
sleep 1
wget -O sippl08puw16.dct https://data.nber.org/sipp/2008/sippl08puw16.dct
sleep 1
wget -O sippp08putm2.dct https://data.nber.org/sipp/2008/sippp08putm2.dct
sleep 1

# download raw data files
wget -O sipp84fp.zip  https://data.nber.org/sipp/1984/sipp84fp.zip
wget -O sipp84rt3.zip https://data.nber.org/sipp/1984/sipp84rt3.zip
wget -O sipp86fp.zip  https://data.nber.org/sipp/1986/sipp86fp.zip
wget -O sipp86rt2.zip https://data.nber.org/sipp/1986/sipp86rt2.zip
wget -O sipp87fp.zip  https://data.nber.org/sipp/1987/sipp87fp.zip
wget -O sipp87rt2.zip https://data.nber.org/sipp/1987/sipp87rt2.zip
wget -O sipp88fp.zip  https://data.nber.org/sipp/1988/sipp88fp.zip
wget -O sipp88rt2.zip https://data.nber.org/sipp/1988/sipp88rt2.zip
wget -O sipp90fp.zip  https://data.nber.org/sipp/1990/sipp90fp.zip
wget -O sipp90t2.zip  https://data.nber.org/sipp/1990/sipp90t2.zip
wget -O sipp91fp.zip  https://data.nber.org/sipp/1991/sipp91fp.zip
wget -O sipp91t2.zip  https://data.nber.org/sipp/1991/sipp91t2.zip
wget -O sipp92fp.zip  https://data.nber.org/sipp/1992/sipp92fp.zip
wget -O sipp92t2.zip  https://data.nber.org/sipp/1992/sipp92t2.zip
wget -O sipp93fp.zip  https://data.nber.org/sipp/1993/sipp93fp.zip
wget -O sipp93t2.zip  https://data.nber.org/sipp/1993/sipp93t2.zip
wget -O sipp96l1.zip  https://data.nber.org/sipp/1996/sipp96l1.zip
wget -O sipp96l2.zip  https://data.nber.org/sipp/1996/sipp96l2.zip
wget -O sipp96l3.zip  https://data.nber.org/sipp/1996/sipp96l3.zip
wget -O sipp96l4.zip  https://data.nber.org/sipp/1996/sipp96l4.zip
wget -O sipp96l5.zip  https://data.nber.org/sipp/1996/sipp96l5.zip
wget -O sipp96l6.zip  https://data.nber.org/sipp/1996/sipp96l6.zip
wget -O sipp96l7.zip  https://data.nber.org/sipp/1996/sipp96l7.zip
wget -O sipp96l8.zip  https://data.nber.org/sipp/1996/sipp96l8.zip
wget -O sipp96l9.zip  https://data.nber.org/sipp/1996/sipp96l9.zip
wget -O sipp96l10.zip https://data.nber.org/sipp/1996/sipp96l10.zip
wget -O sipp96l11.zip https://data.nber.org/sipp/1996/sipp96l11.zip
wget -O sipp96l12.zip https://data.nber.org/sipp/1996/sipp96l12.zip
wget -O sipp96t2.zip  https://data.nber.org/sipp/1996/sipp96t2.zip
wget -O sipp01w1.zip  https://data.nber.org/sipp/2001/sipp01w1.zip
wget -O sipp01w2.zip  https://data.nber.org/sipp/2001/sipp01w2.zip
wget -O sipp01w3.zip  https://data.nber.org/sipp/2001/sipp01w3.zip
wget -O sipp01w4.zip  https://data.nber.org/sipp/2001/sipp01w4.zip
wget -O sipp01w5.zip  https://data.nber.org/sipp/2001/sipp01w5.zip
wget -O sipp01w6.zip  https://data.nber.org/sipp/2001/sipp01w6.zip
wget -O sipp01w7.zip  https://data.nber.org/sipp/2001/sipp01w7.zip
wget -O sipp01w8.zip  https://data.nber.org/sipp/2001/sipp01w8.zip
wget -O sipp01w9.zip  https://data.nber.org/sipp/2001/sipp01w9.zip
wget -O sipp01t2.zip  https://data.nber.org/sipp/2001/sipp01t2.zip
wget -O sipp04w1.zip  https://data.nber.org/sipp/2004/sipp04w1.zip
wget -O sipp04w2.zip  https://data.nber.org/sipp/2004/sipp04w2.zip
wget -O sipp04w3.zip  https://data.nber.org/sipp/2004/sipp04w3.zip
wget -O sipp04w4.zip  https://data.nber.org/sipp/2004/sipp04w4.zip
wget -O sipp04w5.zip  https://data.nber.org/sipp/2004/sipp04w5.zip
wget -O sipp04w6.zip  https://data.nber.org/sipp/2004/sipp04w6.zip
wget -O sipp04w7.zip  https://data.nber.org/sipp/2004/sipp04w7.zip
wget -O sipp04w8.zip  https://data.nber.org/sipp/2004/sipp04w8.zip
wget -O sipp04w9.zip  https://data.nber.org/sipp/2004/sipp04w9.zip
wget -O sipp04w10.zip https://data.nber.org/sipp/2004/sipp04w10.zip
wget -O sipp04w11.zip https://data.nber.org/sipp/2004/sipp04w11.zip
wget -O sipp04w12.zip https://data.nber.org/sipp/2004/sipp04w12.zip
wget -O sipp04t2.zip  https://data.nber.org/sipp/2004/sipp04t2.zip
wget -O l08puw1.zip   https://data.nber.org/sipp/2008/l08puw1.zip
wget -O l08puw2.zip   https://data.nber.org/sipp/2008/l08puw2.zip
wget -O l08puw3.zip   https://data.nber.org/sipp/2008/l08puw3.zip
wget -O l08puw4.zip   https://data.nber.org/sipp/2008/l08puw4.zip
wget -O l08puw5.zip   https://data.nber.org/sipp/2008/l08puw5.zip
wget -O l08puw6.zip   https://data.nber.org/sipp/2008/l08puw6.zip
wget -O l08puw7.zip   https://data.nber.org/sipp/2008/l08puw7.zip
wget -O l08puw8.zip   https://data.nber.org/sipp/2008/l08puw8.zip
wget -O l08puw9.zip   https://data.nber.org/sipp/2008/l08puw9.zip
wget -O l08puw10.zip  https://data.nber.org/sipp/2008/l08puw10.zip
wget -O l08puw11.zip  https://data.nber.org/sipp/2008/l08puw11.zip
wget -O l08puw12.zip  https://data.nber.org/sipp/2008/l08puw12.zip
wget -O l08puw13.zip  https://data.nber.org/sipp/2008/l08puw13.zip
wget -O l08puw14.zip  https://data.nber.org/sipp/2008/l08puw14.zip
wget -O l08puw15.zip  https://data.nber.org/sipp/2008/l08puw15.zip
wget -O l08puw16.zip  https://data.nber.org/sipp/2008/l08puw16.zip
wget -O p08putm2.zip  https://data.nber.org/sipp/2008/p08putm2.zip

# uncompress all raw data files
unzip sipp84fp.zip
unzip sipp84rt3.zip
unzip sipp86fp.zip
unzip sipp86rt2.zip
unzip sipp87fp.zip
unzip sipp87rt2.zip
unzip sipp88fp.zip
unzip sipp88rt2.zip
unzip sipp90fp.zip
unzip sipp90t2.zip
unzip sipp91fp.zip
unzip sipp91t2.zip
unzip sipp92fp.zip
unzip sipp92t2.zip
unzip sipp93fp.zip
unzip sipp93t2.zip
unzip sipp96l1.zip
unzip sipp96l2.zip
unzip sipp96l3.zip
unzip sipp96l4.zip
unzip sipp96l5.zip
unzip sipp96l6.zip
unzip sipp96l7.zip
unzip sipp96l8.zip
unzip sipp96l9.zip
unzip sipp96l10.zip
unzip sipp96l11.zip
unzip sipp96l12.zip
unzip sipp96t2.zip
unzip sipp01w1.zip
unzip sipp01w2.zip
unzip sipp01w3.zip
unzip sipp01w4.zip
unzip sipp01w5.zip
unzip sipp01w6.zip
unzip sipp01w7.zip
unzip sipp01w8.zip
unzip sipp01w9.zip
unzip sipp01t2.zip
unzip sipp04w1.zip
unzip sipp04w2.zip
unzip sipp04w3.zip
unzip sipp04w4.zip
unzip sipp04w5.zip
unzip sipp04w6.zip
unzip sipp04w7.zip
unzip sipp04w8.zip
unzip sipp04w9.zip
unzip sipp04w10.zip
unzip sipp04w11.zip
unzip sipp04w12.zip
unzip sipp04t2.zip
unzip l08puw1.zip
unzip l08puw2.zip
unzip l08puw3.zip
unzip l08puw4.zip
unzip l08puw5.zip
unzip l08puw6.zip
unzip l08puw7.zip
unzip l08puw8.zip
unzip l08puw9.zip
unzip l08puw10.zip
unzip l08puw11.zip
unzip l08puw12.zip
unzip l08puw13.zip
unzip l08puw14.zip
unzip l08puw15.zip
unzip l08puw16.zip
unzip p08putm2.zip

# compress all raw data files
gzip -f sipp84fp.dat
gzip -f sipp84rt3.dat
gzip -f sipp86fp.dat
gzip -f sipp86rt2.dat
gzip -f sipp87fp.dat
gzip -f sipp87rt2.dat
gzip -f sipp88fp.dat
gzip -f sipp88rt2.dat
gzip -f sipp90fp.dat
gzip -f sipp90t2.dat
gzip -f sipp91fp.dat
gzip -f sipp91t2.dat
gzip -f sipp92fp.dat
gzip -f sipp92t2.dat
gzip -f sipp93fp.dat
gzip -f sipp93t2.dat
gzip -f sipp96l1.dat
gzip -f sipp96l2.dat
gzip -f sipp96l3.dat
gzip -f sipp96l4.dat
gzip -f sipp96l5.dat
gzip -f sipp96l6.dat
gzip -f sipp96l7.dat
gzip -f sipp96l8.dat
gzip -f sipp96l9.dat
gzip -f sipp96l10.dat
gzip -f sipp96l11.dat
gzip -f sipp96l12.dat
gzip -f sipp96t2.dat
gzip -f sipp01w1.dat
gzip -f sipp01w2.dat
gzip -f sipp01w3.dat
gzip -f sipp01w4.dat
gzip -f sipp01w5.dat
gzip -f sipp01w6.dat
gzip -f sipp01w7.dat
gzip -f sipp01w8.dat
gzip -f sipp01w9.dat
gzip -f sipp01t2.dat
gzip -f l04puw1.dat
gzip -f l04puw2.dat
gzip -f l04puw3.dat
gzip -f l04puw4.dat
gzip -f l04puw5.dat
gzip -f l04puw6.dat
gzip -f l04puw7.dat
gzip -f l04puw8.dat
gzip -f l04puw9.dat
gzip -f l04puw10.dat
gzip -f l04puw11.dat
gzip -f l04puw12.dat
gzip -f p04putm2.dat
gzip -f l08puw1.dat
gzip -f l08puw2.dat
gzip -f l08puw3.dat
gzip -f l08puw4.dat
gzip -f l08puw5.dat
gzip -f l08puw6.dat
gzip -f l08puw7.dat
gzip -f l08puw8.dat
gzip -f l08puw9.dat
gzip -f l08puw10.dat
gzip -f l08puw11.dat
gzip -f l08puw12.dat
gzip -f l08puw13.dat
gzip -f l08puw14.dat
gzip -f l08puw15.dat
gzip -f l08puw16.dat
gzip -f p08putm2.dat

rm -f *.zip

# Get rid of path in dictionary files (since this path is specific to NBER's servers)
for f in *.dct ; do
    # extract modification date and time of file
    MODTIME=`stat -c %Y "$f"`
    HMODTIME=`date -d @"$MODTIME"`
    # make the replacement with sed and update file
    sed -i '1d' $f
    sed -i '1s/^/infile dictionary { \n/' $f
    touch -d @$MODTIME "$f"
    echo "Modified: " "$f"
    echo "Modification date/time: " $HMODTIME "(sec since epoch: "$MODTIME")"
done

# Uncomment rows of dictionary files that are commented
for f in *.dct ; do
    # extract modification date and time of file
    MODTIME=`stat -c %Y "$f"`
    HMODTIME=`date -d @"$MODTIME"`
    # make the replacement with sed and update file
    sed -i 's|*#||ig' $f
    touch -d @$MODTIME "$f"
    echo "Modified: " "$f"
    echo "Modification date/time: " $HMODTIME "(sec since epoch: "$MODTIME")"
done
