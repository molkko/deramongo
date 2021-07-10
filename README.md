deramongo.sh

downloads financial statement datasets from www.sec.gov/files/dera and builds a mongodb database

prerequisites for running this script successfully include:
bash or similar shellscript, unzip, wget, mongo database, mongo client,
mongoimport, network connection, free storage (maybe ~40GB)

warning: this builds dera mongo database from scratch i.e. this drops the existing database
https://github.com/molkko
