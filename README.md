deramongo.sh

downloads financial statement datasets from www.sec.gov/files/dera and builds a mongodb database

prerequisites for running this script successfully include:
bash or similar shellscript, unzip, wget, mongo database, mongo client,
mongoimport, network connection, free storage (maybe ~40GB)

warning: this builds dera mongo database from scratch i.e. this drops the existing database
https://github.com/molkko

Usage:
1) make new local directory
2) store deramongo.sh from this repo into that directory
3) ensure your system fullfills the abovementioned requirements
4) run the script   ./deramongo.sh

