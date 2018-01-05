logs = require('../common/logger').getLogger();
horoscopesUpdater = require('./horoscopesupdater')
scheduler = require('../common/scheduler')
ttyjob = require('../ttyupdater/jobsmanager.js');

function makeJobs() {
    horoscopesUpdater.beginUpdate(function () {
      ttyjob.scheduleJobs()
    })
}

exports.scheduleJobs = function () {
    makeJobs()
    scheduler.scheduleJobAtMinute(54, function(){
      //logs.debug('hi from minute job horoscopesUpdater.beginUpdate')
    })
}
