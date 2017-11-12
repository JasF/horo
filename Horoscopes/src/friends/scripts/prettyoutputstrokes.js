var fs = require('fs')
databaseFilename = "localizedMonths-gm.sql";
//fs.unlink(databaseFilename);
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database(databaseFilename);
var gumbo = require("gumbo-parser");
const queryString = require('query-string');

// здесь нам надо получить массив языков. ключ-значение

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function fetchLanguageMonthValuesW(arrMonths, languageCode, storage, callback) {
    if (!arrMonths.length) {
        console.log('montharr empty');
        if (callback) {
            callback(storage);
        }
        return;
    }
    
    var monthText = arrMonths[0]
    arrMonths.splice(0,1)
    
    console.log('l:' + languageCode + '; monthTxt:'  + monthText)
    
    db.all("SELECT * FROM localizedMonths WHERE localizedBirthdayString = ? AND monthInEnglish = ?;", [languageCode, monthText], function(err, rows) {
           if (!rows.length) {
           console.log('empty!')
           fetchLanguageMonthValuesW(arrMonths, storage, callback);
           return;
           }
           
           console.log(rows);
           row = rows[0];
           storage[monthText] = row.localizedString
           fetchLanguageMonthValuesW(arrMonths, storage, callback)
         });
}

function fetchLanguageMonthValues(arrMonths, languageCode, callback) {
    fetchLanguageMonthValuesW(arrMonths, languageCode, {}, callback);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
function fetchLanguageCodeForEveryStrokeW(arrList, storage, callback) {
    if (!arrList.length) {
        if (callback) {
            callback(storage)
        }
        return;
    }
    localizedBirthdayName = arrList[0]
    arrList.splice(0,1);
    db.all("SELECT * FROM localizedMonths WHERE localizedBirthdayString = ?;", [localizedBirthdayName], function(err, rows) {
           if (err) console.log(err);
           langsSet = new Set()
           rows.forEach(function (v) {
                        langsSet.add(v.languageCode)
                        })
           langsList = []
           langsSet.forEach(function (v) {
                            langsList.push(v)
                            })
           storage[localizedBirthdayName.toLowerCase()] = langsList
           //console.log(storage)
           fetchLanguageCodeForEveryStrokeW(arrList, storage, callback);
           });
}


function fetchLanguageCodeForEveryStroke(arrList, callback) {
    fetchLanguageCodeForEveryStrokeW(arrList, {}, callback)
}
///////////////////////////////////////////////////////////////////////////////////////////////

db.all("SELECT DISTINCT localizedBirthdayString FROM localizedMonths;", function(err, rows) {
        if (!rows.length) {
        console.log('localizedBirthdayString error')
        return;
        }
       
       arrList=[]
       rows.forEach(function (v) {
                    arrList.push(v.localizedBirthdayString)
                    })
       // здесь надо получить список разновидностей localizedBirthdayString и для каждого получить его languageCode
       // что бы при нахождении совпадения сразу брать нужный словарь значений по языковому ключу и определять
       // arrLangs
       
       fetchLanguageCodeForEveryStroke(arrList, function(values) {
                                       json = JSON.stringify(values);
                                       console.log(json)
                                       
                                       fs.writeFile("./birthdayslocstr.json", json, function(err) {
                                                    if(err) {
                                                    return console.log(err);
                                                    }
                                                    
                                                    console.log("The file ./birthdayslocstr.json was saved!");
                                                    });
                                       })
        });

