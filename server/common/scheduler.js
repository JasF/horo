var schedule = require('node-schedule');
logs = require('./logger').getLogger();

exports.scheduleJobAtHour = function (hour, callback) {
  rule = new schedule.RecurrenceRule();
  rule.hour = hour;
  schedule.scheduleJob(rule, function(){
                         callback()
                       });
}

exports.scheduleJobAtMinute = function (minute, callback) {
    rule = new schedule.RecurrenceRule();
    rule.minute = minute;
    schedule.scheduleJob(rule, function(){
                         callback()
                         });
}
