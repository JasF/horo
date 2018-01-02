logs = require('../common/logger').getLogger();
var Curl = require('node-libcurl').Curl;
var storage = require('../common/horostorage');

exports.sendTodayPushToZodiacName = function(time, zodiacName) {
    var todayDate = new Date();
    storage.dayHoroscopeWithDate(todayDate, zodiacName, function (content) {
      logs.info('prediction for ' + zodiacName + ' length: ' + content.length);
    })
}
