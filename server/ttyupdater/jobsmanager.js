logs = require('../common/logger').getLogger();
scheduler = require('../common/scheduler')
creator = require('./ttycreator')

exports.scheduleJobs = function () {
    logs.info('scheduler!');
    creator.createTTYHoroscopes(function () {
      logs.info('creation TTY completed!');
    })
}
