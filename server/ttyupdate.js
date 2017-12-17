const Firestore = require('@google-cloud/firestore');
credentialsFilename = "/home/andreivoe/serverscripts/horo-ios-287dcbc8f4c6.json"
const Browser = require('zombie');
var gumbo = require("gumbo-parser");

var zodiacs = [
               "aquarius",
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


var HoroTypeDay = "days"
var HoroTypeWeek = "week"
var HoroTypeMonth = "month"
var HoroTypeYear = "year"

horoTypes = {yesterday:HoroTypeDay,
today:HoroTypeDay,
tomorrow:HoroTypeDay,
weekly:HoroTypeWeek,
monthly:HoroTypeMonth,
    year:HoroTypeYear};

const firestore = new Firestore({projectId: 'horo-ios',
                                keyFilename: credentialsFilename });

function dateForType(type) {
    function dateToDateString(aDate) {
        var result = "" + aDate.getDate()+ "." + Number(parseInt(aDate.getMonth(), 10) + 1) + "." + aDate.getFullYear()
        return result;
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
    return dateString;
}

function requestPredictionsForZodiacA(zodiacName, aTypes, callback, dictionary) {
    
    console.log("aTypes");
    console.log(aTypes);
    if (!aTypes.length) {
        console.log('callbacking! dictionary: ');
        console.log(dictionary)
        if (callback != null) {
            callback(dictionary.yesterday, dictionary.today, dictionary.tomorrow, dictionary.weekly, dictionary.monthly, dictionary.year);
        }
        return;
    }
    type = aTypes[0]
    aTypes.splice(0, 1);
    
    horoType = horoTypes[type]
    
    dateString = dateForType(type)
    path = 'storage/' + horoType + '/' + zodiacName + '/' + dateString
    console.log('path for: ' + type + ' is: ' + path)
    const document = firestore.doc(path);
    document.get().then(doc => {
                        data = doc.data()
                        dictionary[type] = data.content;
                        requestPredictionsForZodiacA(zodiacName, aTypes, callback, dictionary)
                        });
}

function requestPredictionsForZodiac(zodiacName, callback) {
    
    horoTypes = {yesterday:HoroTypeDay,
    today:HoroTypeDay,
    tomorrow:HoroTypeDay,
    weekly:HoroTypeWeek,
    monthly:HoroTypeMonth,
        year:HoroTypeYear};
    
    types = ["yesterday", "today", "tomorrow", "weekly", "monthly"]
    requestPredictionsForZodiacA(zodiacName, types.slice(), callback, {});
    
}

function createTTYforZodiac(zodiacName, yesterday, today, tomorrow, weekly, monthly, year) {
    console.log('zodiacName: ' + zodiacName)
    console.log('yestreday: ' + yesterday)
    console.log('today: ' + today)
    console.log('tomorrow: ' + tomorrow)
    console.log('weekly: ' + weekly)
    console.log('monthly: ' + monthly)
    console.log('year: ' + year)
    array = []
    if (yesterday != null) {
        array.push({ type:"yesterday", content:yesterday, date:dateForType("yesterday")})
    }
    if (today != null) {
        array.push({ type:"today", content:today, date:dateForType("today")})
    }
    if (tomorrow != null) {
        array.push({ type:"tomorrow", content:tomorrow, date:dateForType("tomorrow")})
    }
    if (weekly != null) {
        array.push({ type:"week", content:weekly, date:dateForType("weekly")})
    }
    if (monthly != null) {
        array.push({ type:"month", content:monthly, date:dateForType("monthly")})
    }
    if (year != null) {
        array.push({ type:"year", content:year, date:dateForType("year")})
    }
    object = {result:array};
    
    path = 'horoscopes/' + zodiacName
    const document = firestore.doc(path);
    document.set(object).then(() => {
                              console.log('writted!')
                              });
}

function createTTYforZodiacsInArray(array, callback) {
    if (array.length == 0) {
        console.log("end of array. Array empty");
        if (callback != null) {
            callback();
        }
        return;
    }
    zodiacName = array[0]
    array.splice(0, 1);
    requestPredictionsForZodiac(zodiacName, function(yesterday, today, tomorrow, weekly, monthly, year) {
                                createTTYforZodiac(zodiacName, yesterday, today, tomorrow, weekly, monthly, year)
                                createTTYforZodiacsInArray(array, callback)
                                })
}

createTTYforZodiacsInArray(zodiacs.slice(), function() {
                           
                           
                           })
/*
 const document = firestore.doc('posts/intro-to-firestore');
 */
// Enter new data into the document.
/*
 document.set({
 title: 'Welcome to Firestore',
 body: 'Hello World',
 }).then(() => {
 console.log('created!');
 
 // Update an existing document.
 document.update({
 body: 'My first Firestore app',
 }).then(() => {
 console.log('updated!');
 // Document updated successfully.
 
 // Read the document.
 document.get().then(doc => {
 console.log('Read!');
 // Document read successfully.
 
 
 // Delete the document.
 //       document.delete().then(() => {
 //                              console.log('Delete!');
 //                              // Document deleted successfully.
 //                             });
 
 });
 
 });
 
 
 });
 */


