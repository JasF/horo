const Firestore = require('@google-cloud/firestore');
credentialsFilename = "/home/andreivoe/serverscripts/horo-ios-287dcbc8f4c6.json"
const Browser = require('zombie');
var gumbo = require("gumbo-parser");

var zodiacs = ["aquarius",
               "pisces",
               "aries",
               "taurus",
               "gemini",
               "cancer",
               "leo",
               "virgo",
               "libra",
               "scorpio",
               "sagittarius",
               "capricorn"];

const firestore = new Firestore({projectId: 'horo-ios',
                                keyFilename: credentialsFilename });

// We're going to make requests to http://example.com/signup
// Which will be routed to our test server localhost:3000
Browser.localhost('mail.ru', 80);
Browser.extend(function(browser) {
               browser.on('console', function(level, message) {
                          logger.log(message);
                          console.log(message);
                          });
               browser.on('log', function(level, message) {
                          logger.log(message);
                          console.log(message);
                          });
               });

console.log('hello1')

var zodiacKey = ""
var parameters = {}
var textStorage = ""

function invokeTextFromTreeWithZodiacKey(tree, key) {
    console.log('key: ' + key)
    var classValue = ""
    if (tree.nodeName == "p") {
        console.log("paragraph detected");
        for (var i = 0; i < tree.attributes.length; i++) {
            var attr = tree.attributes[i];
            if (attr.name == "class") {
                classValue = attr.value
            }
            //console.log('attr name: ' + attr.name + '; value: ' + attr.value)
        }
        console.log("paragraph 1");
        parameters.paragraph = true;
        if (classValue.length) {
            console.log("paragraph 2");
            parameters[classValue] = true;
        }
        console.log("paragraph 3");
    }
    
    console.log('tree')
    if (!key.length) {
        console.log("key cannot be empty");
        return
    }
    
    for (var i = 0; i < tree.childNodes.length; i++) {
        var child = tree.childNodes[i];
        if (child.nodeType == 1 /*1 == Element*/) {
            invokeTextFromTreeWithZodiacKey(child, key)
        }
        else if (child.nodeType == 3 /*3 == Text*/) {
            console.log("text node");
            textStorage += child.textContent
        }
    }
    
    if (tree.nodeName == "p") {
        parameters.paragraph = false;
        if (classValue.length) {
            console.log('predel');
            delete parameters[classValue];
            console.log('postde');
        }
    }
}

function invokePayloadData(tree, completion) {
    // console.log(tree);
    if (tree.nodeName == "div") {
        for (var y = 0; y < tree.attributes.length; y++) {
            attribute = tree.attributes[y];
            //console.log(attribute.value);
            if (attribute.name == "class" && attribute.value == "horoscope-content") {
                console.log('found payload tree: ');
                textStorage = ""
                invokeTextFromTreeWithZodiacKey(tree, zodiacKey)
                console.log( "" + zodiacKey + ': textStorage: ' + textStorage)
            }
        }
    }
    if (tree.nodeName == "body") {
        for (var y = 0; y < tree.attributes.length; y++) {
            attribute = tree.attributes[y];
            if (attribute.name == "class") {
                zodiacKey = attribute.value
            }
        }
    }
    
    for (var i = 0; i < tree.childNodes.length; i++) {
        var child = tree.childNodes[i];
        if (child.nodeType == 1 /*1 == Element*/) {
            invokePayloadData(child, null)
        }
        if (child.nodeType == 3) {
            // console.log(child.textContent)
        }
    }
    if (completion != null) {
        completion(zodiacKey, textStorage)
    }
}

var HoroTypeDay = "days"
var HoroTypeWeek = "week"
var HoroTypeMonth = "month"
var HoroTypeYear = "year"

function writePrediction(type, signName, text, callback) {
    
    
    function dateToDateString(aDate) {
        var result = "" + aDate.getDate()+ "." + Number(parseInt(aDate.getMonth(), 10) + 1) + "." + aDate.getFullYear()
        return result;
    }
    
    horoTypes = {yesterday:HoroTypeDay,
    today:HoroTypeDay,
    tomorrow:HoroTypeDay,
    weekly:HoroTypeWeek,
    monthly:HoroTypeMonth,
        year:HoroTypeYear};
    horoType = horoTypes[type]
    if (horoType == null) {
        console.log("unknown type: " + type)
        return;
    }
    
    var date = new Date();
    dateFunctions = {today:function () {
        return dateToDateString(date)
    }, yesterday:function () {
        newDate = new Date()
        newDate.setDate(date.getDate() - 1)
        return dateToDateString(newDate)
    }, tomorrow:function () {
        newDate = new Date()
        newDate.setDate(date.getDate() + 1)
        return dateToDateString(newDate)
    }, weekly:function () {
        newDate = new Date()
        day = parseInt(date.getDay())
        if (day > 0) {
            --day;
        }
        else {
            day = 6;
        }
        newDate.setDate(date.getDate() - day)
        console.log("weekly: " + newDate)
        return dateToDateString(newDate)
    }, monthly:function () {
        var newDate = new Date(date)
        newDate.setDate(1)
        console.log("monthly: " + newDate)
        return dateToDateString( newDate )
    }, year:function () {
        var newDate = new Date(date)
        newDate.setDate(1)
        newDate.setMonth(0)
        console.log("year: " + newDate)
        return dateToDateString( newDate )
    }}
    dateFunction = dateFunctions[type];
    if (dateFunction == null) {
        console.log("unknown horoType: " + type);
        return;
    }
    dateString = dateFunction()
    console.log(dateString)
    
    path = 'storage/' + horoType + '/' + signName + '/' + dateString
    console.log("setting document: " + path);
    const document = firestore.doc(path)
    document.set({ content : text }).then(() => {
                                          callback(true)
                                          });
    
}

function doRequest(type, signIndex, completion) {
    
    dateFunctions = {today:function () {
        return "daily-" + type;
    }, yesterday:function () {
        return "daily-" + type;
    }, tomorrow:function () {
        return "daily-" + type;
    }, weekly:function () {
        return type;
    }, monthly:function () {
        return type;
    }, year:function () {
        return "";
    }}
    var url = "https://www.horoscope.com/us/horoscopes/general/horoscope-general-" + dateFunctions[type]() + ".aspx?sign=" + signIndex
    console.log("start requesting: " + url)
    const browser = new Browser()
    browser.fetch(url)
    .then(function(response) {
          console.log('Status code:', response.status);
          if (response.status === 200)
          return response.text();
          })
    .then(function(text) {
          var tree = gumbo(text);
          var root = tree["root"]
          invokePayloadData(root, function (zodiacName, predictionText) {
                            console.log('zodiacName: ' + zodiacName + '; predictionText: ' + predictionText)
                            if (completion) {
                            completion(zodiacName, predictionText)
                            }
                            })
          })
    .catch(function(error) {
           console.log("parsing html error!");
           console.log(error);
           if (completion) {
           completion(null, null)
           }
           });
}

function requestHoroscopesWithSignsArray(array, type, callback) {
    if (array.length == 0) {
        console.log("end of requests horoscopes. Array empty");
        if (callback != null) {
            callback();
        }
        return;
    }
    index = array[0]
    array.splice(0, 1);
    doRequest(type, index, function (zodiacName, predictionText) {
              if (zodiacName == null || predictionText == null) {
              console.log("error receive horoscope for index: " + index + "!");
              return;
              }
              writePrediction(type, zodiacName, predictionText, function (databaseSuccess) {
                              requestHoroscopesWithSignsArray(array, type, callback)
                              console.log("databaseSuccess : " + databaseSuccess)
                              })
              })
}

indexes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
requestHoroscopesWithSignsArray(indexes.slice(), "yesterday", function () {
                                requestHoroscopesWithSignsArray(indexes.slice(), "today", function () {
                                                                requestHoroscopesWithSignsArray(indexes.slice(), "tomorrow", function () {
                                                                                                requestHoroscopesWithSignsArray(indexes.slice(), "weekly", function () {
                                                                                                                                requestHoroscopesWithSignsArray(indexes.slice(), "monthly", function () {
                                                                                                                                                                console.log("done!")
                                                                                                                                                                })
                                                                                                                                })
                                                                                                })
                                                                })
                                })

