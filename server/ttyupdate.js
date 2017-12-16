const Firestore = require('@google-cloud/firestore');
credentialsJson = {
    "type": "service_account",
    "project_id": "horo-ios",
    "private_key_id": "287dcbc8f4c6c2b20f780cafe7e2d41fc6e4db86",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC/Tzu5JlkwEkQP\nVMYQxazgcngAwFAGOUCgio1Copm453o5J0WAoxl1OLr0wDtQb1hYAJhFHH5oyT2R\nmcwDO9c3/yLwkNtF8i2SAVUMRGkjap/js6n9op2t1UdW5NfnuR+lBB7sC3BinppY\n4GsH5J3f9ME7ubUVM/k1ywFUM3T8lWEvfAhQ2Iz8kC0IHMpIOB0BIhF3+ixUJkJi\nOeeVVS8URTh8cbFfo2LEYVGj8ygJb+gZ//0bKUxkuz7BYePARYwyhjF+9loGzJsg\ngU+qucdLWORJcv/D5T/1isiBcLy9drY+DAjcZESlpJHA7qD2DwVZAyaQxeXDOsM1\n3xQuF0otAgMBAAECggEAQv8VdD6oxzvuV8whXOhNJYEQ43p1y+gq6M38sFRPL0Dp\nPbCyF12G4dVPK71SSFXmA1OZ/8H9xuaKyD2rA4rmUPbpnoOsNq+cI+CRjy06AKwr\neEuIAYn8XE8vn4+eyMi8+0YZKiLLZc4TUYKuGOKII1EMhsT/VICSCrOgMIOguX9e\nvarg8jGNY88uS0i1QvGsbzh2sZgyknmnzO692LEBKyqIF1nYpR0ToUcfxPMJ61qk\nzj+4cjaeqfN/9fYtYmAESsWQD+mPxUJpNH3/sKr2X4Cv3ubAPBgdkHteIXVGEiM/\nsu5kRrsgHxZCXEBCNFsJpfMin0/u90itrm92m2P0BQKBgQD3zmjaDvGxpkN+tpHh\nAUEjRlw51GMbkD3+2iIJZAsGpCgiZr12i2xg+8KKr6gTpDN4i3irXRYhdXdE+/QF\nsFQvLTeUeap0KstGH0xd4ZkT+WyKMjvYM83rai+odYnnTFHRBxNRwKqcOJe9fmHo\nWza58LmszmP77YEM3zn5OAQ7/wKBgQDFoplTTLoZga7ZDmTyigCQW2fTFmPr8BBw\nKgYaDWLPb8siLV+5w6G1/KhE1B2VSfrnL80gLIi+2BXU7Hp9eM9kMfs0QVJIGK6Y\nn17+Z58iAlODT16x1P9z8qq50fky5f3vgg+DGybhp+JfC8O3pmAp7wsVdK0W8KT8\n9y+KIwIp0wKBgDOWIZe7Yq8zyHs5cHbhtvir7gkP4K3dQjqqmElSLUVtqPk4YBqs\nfZxW7LHITXoBRcHDbxRlZXUDqhePR8ZjZbMIe7iJ92UFf5mSbGhizWYuF11RhcnF\nRwnJ6i/sgA/JgIK+MVRkgl/RHC2TgLhJPMRKi6ygronEcIgIdF4gPilrAoGAFvhT\n+7OCOa6x5LZgkzPo5t5IzebfTC/FqVOpC+QcZOGoaVt+sbeEFwO7huxkV9KWX8JV\ng/TJG+0/dFTb07Nz30BT4vnol0qPGFwFjWn7u9crX6qc5exMmGxO3XQDE6BZiDnE\nlcdVGIsLq2JRqAmlSZpn3mGGMJFdi60rEFILUVMCgYEAogETqbdU5XX69Y1i4mcb\nkToRZIHy4uRKTp4lHBvi0wMYtKCRIErRF8/HoemdwtER6+vHDYQaoGV5aefrJMi1\ncLAS9BtOwTXZIYUV3d+O9DDg8+/fRRSf+sSx8CVPYs5Ti1Jpg61fvDH2kf8lY7rs\nlXydv+6pgeG2LbEHQrvwgk4=\n-----END PRIVATE KEY-----\n",
    "client_email": "redactor@horo-ios.iam.gserviceaccount.com",
    "client_id": "113164697857028802069",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://accounts.google.com/o/oauth2/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/redactor%40horo-ios.iam.gserviceaccount.com"
}

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


