logs = require('../common/logger').getLogger();
horoscopesUpdater = require('./horoscopesupdater')
scheduler = require('../common/scheduler')

exports.scheduleJobs = function () {
  //  scheduler.scheduleJobAtMinute(54, function(){
      logs.info('hi from minute job horoscopesUpdater.beginUpdate')
      horoscopesUpdater.beginUpdate(function () {
        logs.info('horoscopes updated!')
                                  })
  //  })
  
}
