#!/bin/bash

# downloads financial statement datasets from www.sec.gov/files/dera and builds a mongodb database
#
# prerequisites for running this script successfully include:
# bash or similar shellscript, unzip, wget, mongo database, mongo client,
# mongoimport, network connection, free storage (maybe ~40GB)
#
# warning: this builds dera mongo database from scratch i.e. this drops the existing database
# https://github.com/molkko

ZIPDIR="originals"
UNZIPDIR="out"
DBNAME="fsds"
DERAURL="https://www.sec.gov/files/dera/data/financial-statement-data-sets"
STARTYEAR=2010
ENDYEAR=2021

usage() { echo "Usage: $0 -e" 1>&2; exit 1; }

ISE=0
while getopts "e" o; do
    case "${o}" in
        e)
	    ISE=1
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
if [ "$ISE" == 0 ]; then
    usage
fi

echo "proceeding"
mkdir -p $ZIPDIR
mkdir -p $UNZIPDIR
mongo $DBNAME --eval "db.dropDatabase()"

for y in $( seq $STARTYEAR $ENDYEAR )
do
    echo "year: $y"
    for q in 1 2 3 4
    do
    echo "quarter: $q"
	ZIPFILE=$ZIPDIR/"$y"q"$q".zip
	if [ -f "$ZIPFILE" ]; then
	    echo "$ZIPFILE already downloaded. Delete it if you want to reload it from the source"
	    else
		echo "Downloading $DERAURL/'$y'q'$q'.zip to $ZIPFILE"
		wget -O $ZIPFILE $DERAURL/"$y"q"$q".zip || rm -f $ZIPFILE
	fi
	UNZIPSUBDIR=$UNZIPDIR/"$y"q"$q"
	echo "Unzipping to $UNZIPSUBDIR"
unzip -o -d $UNZIPSUBDIR $ZIPFILE
for d in  sub tag num pre 
do
    echo "Mongoimporting '$UNZIPSUBDIR'/'$d'.txt to $DBNAME"
mongoimport -d $DBNAME -c $d --file $UNZIPSUBDIR/$d.txt --type=tsv -v --headerline
        done
    done
done

# create indexes. optimize these for your application
echo "Creating indexes"
mongo $DBNAME --eval "db.sub.createIndex({ 'cik': 1 })"
mongo $DBNAME --eval "db.sub.createIndex({ 'adsh': 1 })"
mongo $DBNAME --eval "db.sub.createIndex( { name: 'text', bas1: 'text' } )"
mongo $DBNAME --eval "db.tag.createIndex({ 'tag': 1, 'version': 1 })"
mongo $DBNAME --eval "db.num.createIndex({ 'adsh': 1, 'tag': 1, 'version': 1 })"
mongo $DBNAME --eval "db.pre.createIndex({ 'adsh': 1, 'stmt': 1, 'line': 1 })"

# Testing. Should output sensible results if database was successfully created and operational
echo "Testing. Some sensible results below if database was successfully created and is operational"
mongo $DBNAME --eval "db.sub.find({ cik : 885275 } )"
mongo $DBNAME --eval "db.sub.find({ adsh : '0001104659-20-000041' } )"
