logs = require('../common/logger').getLogger();
const Firestore = require('@google-cloud/firestore');
var common = require('../common/common');
credentialsFilename = "./../horo-ios-287dcbc8f4c6.json"

const firestore = new Firestore({projectId: 'horo-ios',
                                keyFilename: credentialsFilename });

exports.writeHoroscope = function (zodiacName, tabsType, horoscope, callback) {
    horoType = common.horoTypeByTabsType(tabsType);
    dateString = common.dateStringFromType(tabsType)
    logs.info('horoType for ' + tabsType + ' is ' + horoType);
    path = 'storage/' + horoType + '/' + zodiacName + '/' + dateString
    logs.info('firestore document patch is: ' + path);
    const document = firestore.doc(path)
    document.set({ content : horoscope }).then(() => {
                                          callback()
                                          });
}

exports.getDocumentData = function (path, completion) {
    logs.info('getting document from path: ' + path);
    const document = firestore.doc(path);
    document.get().then(doc => {
      data = doc.data()
      completion(data.content)
    });
}

exports.createTTYDocument = function (zodiacName, yesterday, today, tomorrow, weekly, monthly, year, completion) {
    array = []
    if (yesterday != null) {
        array.push({ type:"yesterday", content:yesterday, date:common.dateStringFromType("yesterday")})
    }
    if (today != null) {
        array.push({ type:"today", content:today, date:common.dateStringFromType("today")})
    }
    if (tomorrow != null) {
        array.push({ type:"tomorrow", content:tomorrow, date:common.dateStringFromType("tomorrow")})
    }
    if (weekly != null) {
        array.push({ type:"week", content:weekly, date:common.dateStringFromType("weekly")})
    }
    if (monthly != null) {
        array.push({ type:"month", content:monthly, date:common.dateStringFromType("monthly")})
    }
    if (year != null) {
        array.push({ type:"year", content:year, date:common.dateStringFromType("year")})
    }
    object = {result:array};
    path = 'horoscopes/' + zodiacName
    const document = firestore.doc(path);
    document.set(object).then(() => {
                              logs.info('TTY document created');
                              completion()
                              });
}

exports.dayHoroscopeWithDate = function (date, zodiacName, completion) {
    var day = date.getUTCDate();
    var month = date.getUTCMonth() + 1;
    var year = date.getUTCFullYear();
    dateString = "" + day + "." + month + "." + year
    path = 'storage/days/' + zodiacName + '/' + dateString
    const document = firestore.doc(path)
    document.get().then(doc => {
      data = doc.data()
      content = data.content
      completion(content)
    });
}