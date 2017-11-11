var fs = require('fs')
databaseFilename = "localizedMonths-copy.sql";
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database(databaseFilename);

function fetchLanguageMonthValuesW(arrMonths, languageCode, storage, callback) {
    if (!arrMonths.length) {
        if (callback) {
            callback(storage);
        }
        return;
    }
    
    var monthText = arrMonths[0]
    arrMonths.splice(0,1)
    
    
    db.all("SELECT * FROM localizedMonths WHERE languageCode = ? AND monthInEnglish = ?;", [languageCode, monthText], function(err, rows) {
           if (!rows.length) {
           fetchLanguageMonthValuesW(arrMonths, languageCode, storage, callback);
           return;
           }
          // console.log('l:' + languageCode + '; monthTxt:'  + monthText)
           
          // console.log(rows);
           row = rows[0];
           storage[monthText] = row.localizedString
           fetchLanguageMonthValuesW(arrMonths, languageCode, storage, callback)
         });
}

function fetchLanguageMonthValues(arrMonths, languageCode, callback) {
    fetchLanguageMonthValuesW(arrMonths, languageCode, {}, callback);
}

/*
 Решение 2
 для определения месяца по дате рождения нужно теперь ключи:
 {fr_FR: {"yanuary:" + "правила_поиска_для_января" }}
 {en_GB: {"yanuary:" + "правила_поиска_для_января" }} и так далее
*/

function fetchLanguageCodeInfoW(arrList, storage, callback) {
    if (!arrList.length) {
        if (callback) {
            callback(storage)
        }
        return;
    }
    languageCode = arrList[0]
    arrList.splice(0,1);
   // console.log('languageCode: ' + languageCode);
    
    
    
    db.all("SELECT DISTINCT monthInEnglish FROM localizedMonths;", function(err, rows) {
           if (!rows.length) {
           return;
           }
           //console.log(rows)
           
           monthsList=[]
           rows.forEach(function (v) {
                        monthsList.push(v.monthInEnglish)
                        })
           // здесь надо получить список разновидностей localizedBirthdayString и для каждого получить его languageCode
           // что бы при нахождении совпадения сразу брать нужный словарь значений по языковому ключу и определять
           // arrLangs
           
           fetchLanguageMonthValues(monthsList, languageCode, function(values) {
                                    storage[languageCode] = values
                                    fetchLanguageCodeInfoW(arrList, storage, callback)
                                           })
           });
}

function fetchLanguageCodeInfo(arrList, callback) {
    fetchLanguageCodeInfoW(arrList, {}, callback)
}

db.all("SELECT DISTINCT languageCode FROM localizedMonths;", function(err, rows) {
       arrList=[]
       rows.forEach(function (v) {
                    arrList.push(v.languageCode)
                  })
       fetchLanguageCodeInfo(arrList, function (storage) {
                             console.log('got it')
                             console.log(storage)
                           })
       });

