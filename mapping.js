// this script outputs <tag> - <common name> pairs found in edgar submission primary financial statements
// column 1 - tag
// column 2 - plabel (common name)
// column 3 - IS-income statement, BS-balance sheet, CS-Cashflow statement, EQ-changes in equity
// column 4 - number of occurences of this tag - <common name> pairs

// run this script as:  > mongo fsds mapping.js
// where fsds is the name of the edgar mongo database created with deramongo.sh script


function get_results (result) {
    print(result._id.tag + "|" + result._id.plabel + "|" + result._id.stmt + "|" + result.countdocs);
}

db.pre.aggregate([
    { $group: { _id: { "tag": "$tag" ,  "plabel": "$plabel", "stmt": "$stmt"}, countdocs: {"$sum": 1}  } },
    {$match: {countdocs: {$gt: 1}}},
    {$sort: {countdocs:-1}}
]    ,{allowDiskUse: true} ).forEach(get_results)

