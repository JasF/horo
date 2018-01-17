var arrays = require('async-arrays');
logs = require('../common/logger').getPusherLogger();
scheduler = require('../common/scheduler')
sender = require('./pushsender')

var times = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
var zodiacs = ["aquarius", "pisces", "aries", "taurus", "gemini", "cancer", "leo", "virgo", "libra", "scorpio", "sagittarius", "capricorn"];

function scheduleJobForTime(time) {
    logs.debug('Pusher start scheduling jobs for ' + time)
    scheduler.scheduleJobAtHour(time, function () {
      logs.debug('job for hour: ' + time + ' faired!')
      zodiacs.forEach(function(zodiacName) {
        //sender.sendTodayPushToZodiacName(time, zodiacName)
      })
    })
}

exports.scheduleJobs = function () {
    //sender.sendTodayPushToZodiacName(11, "capricorn")
    times.forEach(function(time){
      scheduleJobForTime(time)
    });
}
