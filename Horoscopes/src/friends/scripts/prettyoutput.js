var fs = require('fs')
databaseFilename = "localizedMonths-copy.sql";
//fs.unlink(databaseFilename);
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database(databaseFilename);
var gumbo = require("gumbo-parser");
const queryString = require('query-string');

// здесь нам надо получить массив языков. ключ-значение
/*
для хранения в ios-клиенте конечно же.
 {
 "fr_fr": { localizedBirthdayString : "ololo", "" }
 }

 логика следующая
 мы на ios-клиенте получаем страницу личной информации в html-формате, парсим нужный div и получаем из него все text-ноды
 затем находим порядковым индексом уникальную строку lowercase, содержащуюся во всех нужных localizedBirthdayString
 если есть - ! относительно находим нужный текст-нод с датой рождения и парсим уже его сообразно парсингу даты
 
 следовательно две задачи
 1. нахождение даты на странице
 2. нахождение дня, месяца и года рождения в строке даты
 
 
 Решение 1
 для нахождения даты на странице нам понадобятся уникальные localizedBirthdayString
 
*/

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
           storage[stroke] = langsList
           console.log(storage)
          // fetchLanguageCodeForEveryStrokeW(arrList, storage, callback);
           
           
           /*
           db.all("SELECT DISTINCT monthInEnglish FROM localizedMonths;", function(err, aRows) {
                  arrMonths = []
                  aRows.forEach(function (v) {
                                arrMonths.push(v.monthInEnglish)
                                });
                  console.log('lco ' + languageCode);
                  fetchLanguageMonthValues(arrMonths, languageCode, function (monthes) {
                                           console.log('for ' + languageCode + '; monthes: ');
                                           console.log(monthes)
                                         })
           });
           */
    });
}

function fetchLanguageCodeForEveryStroke(arrList, callback) {
    fetchLanguageCodeForEveryStrokeW(arrList, {}, callback)
}

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
                                       console.log(values);
                                       })
        });
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
    stroke = arrList[0]
    arrList.splice(0,1);
    db.all("SELECT * FROM localizedMonths WHERE localizedBirthdayString = ?;", [stroke], function(err, rows) {
           if (err) console.log(err);
           langsSet = new Set()
           rows.forEach(function (v) {
                        langsSet.add(v.languageCode)
                        })
           langsList = []
           langsSet.forEach(function (v) {
                            langsList.push(v)
                            })
           storage[stroke] = langsList
           fetchLanguageCodeForEveryStrokeW(arrList, storage, callback);
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
/*
       if (!codeRow.languageCode) {
        console.log('code error')
        return;
       }
        var code = codeRow.languageCode
       db.each("SELECT DISTINCT monthInEnglish FROM localizedMonths;", function(err, monthRow) {
              if (!monthRow.monthInEnglish) {
                console.log('month error')
                return;
              }
               var month = monthRow.monthInEnglish;
               db.each("SELECT * FROM localizedMonths WHERE languageCode = ? AND monthInEnglish = ?;", [code, month], function(err, row) {
                       console.log(month + ':' + row.localizedBirthdayString + ' : ' + row.localizedString)
                      //console.log('rows for: ' + month + ' in ' + code + ' is ' + rows.length);
                      })
          });
       });
*/

