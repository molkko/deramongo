DERA Financials data mongoDB database

deramongo.sh
downloads financial statement datasets from www.sec.gov/files/dera and builds a mongodb database

prerequisites for running this script successfully include:
bash or similar shellscript, unzip, wget, mongo database, mongo client,
mongoimport, network connection, free storage (maybe ~40GB)

warning: this builds mongoDB database from scratch i.e. this drops the existing database

initial author: https://github.com/molkko

Usage:
1) make new local directory
2) store deramongo.sh from this repo into that directory
3) ensure your system fullfills the abovementioned requirements
4) run the script   ./deramongo.sh
5) if you see sensible sample query results the database has been successfully built. Otherwise study the errors and act accordingly


mapping.js

outputs <tag> - <common name> pairs found in edgar submission primary financial statements, a "pair" consists of four columns
// column 1 - tag
// column 2 - plabel (common name)
// column 3 - IS-income statement, BS-balance sheet, CS-Cashflow statement, EQ-changes in equity
// column 4 - number of occurences of this tag - <common name> pairs

// run this script as:  > mongo fsds mapping.js
// where fsds is the name of the edgar mongo database created with deramongo.sh script

map3.txt.gz
sample output from mapping.js script .i.e contains roughly one million tag-<common name> pairs from sec edgar submission primary statements from 2015 to 2q2021
this is a gzipped text file. unzip this with    > gunzip map3.txt.gz
