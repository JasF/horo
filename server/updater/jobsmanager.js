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
    scheduler.scheduleJobAtHour(2, function(){
                                makeJobs()
    })
    scheduler.scheduleJobAtHour(12, function(){
                                makeJobs()
                                })
    scheduler.scheduleJobAtHour(18, function(){
                                makeJobs()
                                })
}
