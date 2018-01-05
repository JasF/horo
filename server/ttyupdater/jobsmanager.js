logs = require('../common/logger').getLogger();
scheduler = require('../common/scheduler')
creator = require('./ttycreator')

exports.scheduleJobs = function () {
    logs.debug('scheduler!');
    creator.createTTYHoroscopes(function () {
      logs.debug('creation TTY completed!');
    })
}
