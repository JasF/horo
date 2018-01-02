logs = require('../common/logger').getLogger();
const Firestore = require('@google-cloud/firestore');
credentialsFilename = "./../horo-ios-287dcbc8f4c6.json"

const firestore = new Firestore({projectId: 'horo-ios',
                                keyFilename: credentialsFilename });

function dateToDateString(aDate) {
    var result = "" + aDate.getDate()+ "." + Number(parseInt(aDate.getMonth(), 10) + 1) + "." + aDate.getFullYear()
    return result;
}

function dateStringFromType(type) {
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
    dateString = dateFunction()
    return dateString;
}

exports.writeHoroscope = function (zodiacName, tabsType, horoscope, callback) {
    dateString = dateStringFromType(tabsType)
    path = 'storage/' + tabsType + '/' + zodiacName + '/' + dateString
    logs.info('firestore document patch is: ' + path);
    const document = firestore.doc(path)
    document.set({ content : horoscope }).then(() => {
                                          callback()
                                          });
}
