logs = require('../common/logger').getTTYLogger();
scheduler = require('../common/scheduler')
creator = require('./ttycreator')

exports.scheduleJobs = function () {
    logs.debug('scheduler!');
    creator.createTTYHoroscopes(function () {
      logs.debug('creation TTY completed!');
    })
}
