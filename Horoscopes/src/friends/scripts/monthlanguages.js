var fs = require('fs')
databaseFilename = "localizedMonths.sql";
//fs.unlink(databaseFilename);
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database(databaseFilename);
var gumbo = require("gumbo-parser");
const queryString = require('query-string');

latestUrl = ""
db.run("CREATE TABLE IF NOT EXISTS localizedMonths (monthInEnglish TEXT, day TEXT, languageCode TEXT, localizedString TEXT, localizedBirthdayString TEXT)");

function fetchValueForMonthsByLanguageCode(monthsList, languageCode, callback) {
    if (!monthsList.length) {
        if (callback) {
            callback(true);
        }
        return;
    }
    
    monthName = monthsList[0]
    monthsList.splice(0,1)
    db.all("SELECT * FROM localizedMonths WHERE monthInEnglish = ? AND languageCode = ?;", [monthName, languageCode], function(err, rows) {
           if (!rows.length) {
           if (callback) {
           callback(false);
           }
            return;
           }
           console.log(rows[0].localizedString)
           fetchValueForMonthsByLanguageCode(monthsList, languageCode, callback)
         })
}

function allEntitiesInDatabaseExists(languageCode, callback) {
    db.all("SELECT DISTINCT monthInEnglish FROM localizedMonths;", function(err, rows) {
           if (!rows.length) {
           if (callback) {
           callback(false);
           }
           return;
           }
           monthsList=[]
           rows.forEach(function (v) {
                        monthsList.push(v.monthInEnglish)
                        })
           fetchValueForMonthsByLanguageCode(monthsList, languageCode, function(success) {
                                             if (callback) {
                                              callback(success)
                                             }
                                    })
           });
}

function entityInDatabaseExists(monthString, languageCode, callback) {
    var count = 0;
    db.all("SELECT * FROM localizedMonths WHERE monthInEnglish = \"" + monthString + "\" AND languageCode = \"" + languageCode + "\";", function(err, rows) {
           if (err) console.log(err);
           if (rows.length) {
             callback(true);
           }
           else {
             callback(false);
           }
            });
    return true;
}

function writeLocalizedBirthdayTextToDatabase(birthdayText, birthdayName, languageCode, monthString, dayString) {
    console.log('writing')
    if (!birthdayText.length || !birthdayName.length || !languageCode.length || !monthString.length || !dayString.length) {
        console.log('writeLocalizedBirthdayTextToDatabase parameter error')
        return;
    }
    db.serialize(function() {
                 
                 db.run("INSERT INTO localizedMonths(monthInEnglish,day,languageCode,localizedString,localizedBirthdayString) VALUES(?,?,?,?,?)", [monthString, dayString, languageCode, birthdayText, birthdayName], function(err) {
                                   if (err) {
                                   return console.log(err.message);
                                   }
                                   // get the last insert id
                                   console.log("writed.");
                                 });
                 });
    
}
urls = []
function iterateLanguages(root) {
    if (root.nodeType == 3) {
        if (latestUrl.length) {
            text = root.textContent
            urls.push({text:text, url:latestUrl})
            latestUrl = "";
        }
    }
    if (root.nodeType != 1) {
        return;
    }
    
    if (root.nodeName == "a") {
        for (var y = 0; y < root.attributes.length; y++) {
            attribute = root.attributes[y];
            if (attribute.name == "href") {
                url = attribute.value
                if (url.includes('language.php')) {
                    latestUrl = url
                }
            }
        }
    }
    
    for (var i = 0; i < root.childNodes.length; i++) {
        var child = root.childNodes[i];
        iterateLanguages(child)
    }
    return urls;
}

function preiterateLanguages(root) {
    urls = []
    iterateLanguages(root)
    return urls;
}

var gGumboStack = []
var birthdayText = ""
var birthdayName = ""
var textsList = []
gInsideProfileCard = false
function parseProfileCard(root, data, uproot) {
    if (root.nodeType == 3) {
        if (textsList.length > 10) {
            textsList.splice(0,1);
        }
        if (gInsideProfileCard) {
            day = data.day;
            text = root.textContent
            if (text.indexOf(day) > -1) {
              birthdayText = text
              birthdayName = ""
                if (textsList.length) {
                    birthdayName = textsList[textsList.length-1]
                }
            }
        }
        textsList.push(root.textContent)
    }
    var mInsideProfileCard = false;
    if (root.attributes != null) {
        for (var y = 0; y < root.attributes.length; y++) {
            attribute = root.attributes[y];
            if (attribute.name == "id") {
                if (attribute.value.includes('basic-info')) {
                    gInsideProfileCard = true
                    mInsideProfileCard = true;
                }
            }
        }
    }
    if (root.nodeType != 1) {
        return;
    }
    gGumboStack.push(root)
    for (var i = 0; i < root.childNodes.length; i++) {
        var child = root.childNodes[i];
        if (child != null) {
            parseProfileCard(child, data, root)
        }
    }
    gGumboStack.pop();
    if (mInsideProfileCard === true) {
        mInsideProfileCard = false;
        gInsideProfileCard = false;
    }
}

function fetchLanguageFromUrlsArray(browser, urlsArray, languageCode, callback) {
    if (!urlsArray.length) {
        console.log('urls array is empty');
        if (callback) {
            callback();
        }
        return;
    }
    data = urlsArray[0]
    urlsArray.shift()
    
    entityInDatabaseExists(data.month, languageCode, function(exists){
                           if (exists) {
                            fetchLanguageFromUrlsArray(browser, urlsArray, languageCode, callback);
                            console.log('skipping: ' + data.month + ': ' + languageCode);
                            return;
                           }
                           
                           url = data.url;
                           if (!url.length) {
                           console.log('wrong');
                           return;
                           }
                           browser.visit(url, function(err) {
                                          var markup = browser.document.documentElement.innerHTML;
                                          var tree = gumbo(markup);
                                          console.log('parsing profile card: ' + markup.length);
                                          gGumboStack = [];
                                          textsList = [];
                                          birthdayText = "";
                                          parseProfileCard(tree.root, data, null);
                                          if (birthdayText.length && birthdayName.length) {
                                            writeLocalizedBirthdayTextToDatabase(birthdayText, birthdayName, languageCode, data.month, data.day)
                                          }
                                          else {
                                            console.log('failed gathering date for ' + url);
                                          }
                                          fetchLanguageFromUrlsArray(browser, urlsArray, languageCode, callback);
                                         });
                           
    });
    
    
}

function handleLanguagesArray(browser, languages) {
    if (!languages.length) {
        console.log('Languages empty. Possible Authorization error');
        db.close()
        return;
    }
    console.log('Successfully authorized! List of languages: ' + languages.length);
    langDict = languages[0]
    url = langDict.url
    languages.splice(0, 1)
    if (!url.length) {
        console.log('url error');
        console.log(url);
        handleLanguagesArray(browser, languages);
        return;
    }
    index = url.indexOf('?')
    if (index == -1) {
        console.log('url query error');
        handleLanguagesArray(browser, languages);
        return;
    }
    index += 1
    const query = queryString.parse(url.substring(index, url.length - index));
    console.log('selecting: ' + url + ' with language: ' + query.l);
    
    allEntitiesInDatabaseExists(query.l, function (success) {
                                browser.visit("https://m.facebook.com" + url, function(err) {
                                              urlsWithMonthsNames = [{month:"january", url:"https://m.facebook.com/danikin2/about?lst=100001547389445%3A100001052329626%3A1510297976", year:"1979", day: "13"},
                                                                     {month:"february", url:"https://m.facebook.com/alexey.antropov/about?lst=100001547389445%3A100001328802913%3A1510297834", year: "1984", day: "5"},
                                                                     {month:"march", url:"https://m.facebook.com/zombiehamon/about?lst=100001547389445%3A100000348924649%3A1510298181", year: "", day: "11"},
                                                                     {month:"april", url:"https://m.facebook.com/postnikov/about?lst=100001547389445%3A619000915%3A1510298002", year: "1982", day: "29"},
                                                                     {month:"may", url:"https://m.facebook.com/korolev.petr/about?lst=100001547389445%3A100000272556300%3A1510298390", year: "1989", day: "20"},
                                                                     {month:"june", url:"https://m.facebook.com/jenja.kuznetsov/about?lst=100001547389445%3A100002691857319%3A1510211827", year: "7", day: "1982"},
                                                                     {month:"july", url:"https://m.facebook.com/st.shambala/about?lst=100001547389445%3A1599670057%3A1510298404", year: "", day: "19"},
                                                                     {month:"august", url:"https://m.facebook.com/vadim.balashov/about?lst=100001547389445%3A1250453135%3A1510298318", year: "1984", day: "5"},
                                                                     {month:"september", url:"https://m.facebook.com/okokawa/about?lst=100001547389445%3A1398444205%3A1510297867", year: "", day: "12"},
                                                                     {month:"october", url:"https://m.facebook.com/trofkate/about?lst=100001547389445%3A100001679278750%3A1510298522", year: "1993", day: "11"},
                                                                     {month:"november", url:"https://m.facebook.com/gagafonov/about?lst=100001547389445%3A100000619129853%3A1510297945", year: "1982", day: "17"},
                                                                     {month:"december", url:"https://m.facebook.com/olga.stjarna/about?lst=100001547389445%3A100002901729072%3A1510297758", year: "", day: "21"}];
                                              fetchLanguageFromUrlsArray(browser, urlsWithMonthsNames, query.l, function () {
                                                                         handleLanguagesArray(browser, languages);
                                                                         })
                                              })
                                })
    
    
}

const Browser = require('zombie');
var url = "https://m.facebook.com/";
var browser = new Browser();
browser.visit(url, function(err) {
              var markup = browser.document.documentElement.innerHTML;
              //console.log('inside. markup:' + markup)
              //iterateLanguages(tree.root)
              console.log('authorization')
              browser.fill('input[name="email"]', "jasfasola@mail.ru")
              .fill('input[name="pass"]', "QvWoM4*f")
              .pressButton('input[name="login"]', function(res) {
                           var markup = browser.document.documentElement.innerHTML;
                          // console.log('inside. markup:' + markup)
                           browser.pressButton('input[type="submit"]', function(res) {
                                               browser.visit("https://m.facebook.com/language.php", function(res) {
                                                               var markup = browser.document.documentElement.innerHTML;
                                                              // console.log('inside2. markup:' + markup)
                                                              var tree = gumbo(markup);
                                                              languages = preiterateLanguages(tree.root)
                                                             
                                                              var urlsOnlyArray = []
                                                             languages.forEach(function (value) {
                                                                              urlsOnlyArray.push(value.url)
                                                                               })
                                                              var langsSet = new Set(urlsOnlyArray)
                                                             urlsOnlyArray = []
                                                             langsSet.forEach(function (value) {
                                                                              urlsOnlyArray.push({url:value})
                                                                               })
                                                             console.log('urlsOnlyArray count: ' + urlsOnlyArray.length)
                                                             // while (languages.length > 160) {
                                                               // languages.splice(0,1);
                                                            //  }
                                                             handleLanguagesArray(browser, urlsOnlyArray)
                                                             })
                                            })
                           });
})
