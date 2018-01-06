logs = require('../common/logger').getLogger();
var arrays = require('async-arrays');
var storage = require('../common/horostorage');
var common = require('../common/common');

var zodiacs = ["aquarius", "pisces", "aries", "taurus", "gemini", "cancer", "leo", "virgo", "libra", "scorpio", "sagittarius", "capricorn"];

function requestPredictionsForZodiac(zodiacName, rootCompletion) {
    dictionary = {}
    types = ["yesterday", "today", "tomorrow", "weekly", "monthly"]
    arrays.map(types.slice(), function(tabsType, tabsCallback){
        logs.debug('creating tty for: ' + tabsType);
        horoType = common.horoTypeByTabsType(tabsType);
        dateString = common.dateStringFromType(tabsType);
        path = 'storage/' + horoType + '/' + zodiacName + '/' + dateString
        storage.getDocumentData(path, function (content) {
          dictionary[tabsType] = content
          tabsCallback()
        });
    }, function (err) {
        logs.debug('tty creating finitshed. err: ' + err + '; dictionary length: ' + JSON.stringify(dictionary).length);
        rootCompletion(dictionary.yesterday, dictionary.today, dictionary.tomorrow, dictionary.weekly, dictionary.monthly, dictionary.year);
    });
}

exports.createTTYHoroscopes = function(rootCompletion) {
    arrays.map(zodiacs.slice(), function(signName, signCallback){
        logs.debug('creating tty for: ' + signName);
        requestPredictionsForZodiac(signName, function (yesterday, today, tomorrow, weekly, monthly, year) {
          storage.createTTYDocument(signName, yesterday, today, tomorrow, weekly, monthly, year, function (){
            logs.debug('createTTYDocument for ' + signName + ' finished');
            signCallback()
          });
        });
    }, function (err) {
        logs.debug('tty creating finitshed. err: ' + err);
        rootCompletion()
    });
}
