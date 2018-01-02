console.log('hello scheduler');
var schedule = require('node-schedule');
const util = require('util');
const exec = util.promisify(require('child_process').exec);

async function performServerUpdater() {
    console.log('performing bash ./updater_original.sh');
    const { stdout, stderr } = await exec('bash ./updater_original.sh');
    console.log('updater.sh finished. stderr: ' + stderr)
}

async function performSendPushToRoom(time, zodiacName) {
    commandLine = 'node ./sendpushtoroom.js ' + time + ' ' + zodiacName;
    console.log('performing bash ' + commandLine);
    const { stdout, stderr } = await exec(commandLine);
    console.log('commandLine finished. stdout: ' + stdout)
}

performServerUpdater();

var rule = new schedule.RecurrenceRule();
rule.hour = 1;
//rule.second = 1;
var j = schedule.scheduleJob(rule, function(){
                             console.log('rule 1');
                             performServerUpdater()
                             });

rule = new schedule.RecurrenceRule();
rule.hour = 6;
//rule.second = 6;
schedule.scheduleJob(rule, function(){
                     console.log('rule 6');
                     performServerUpdater()
                     });

rule = new schedule.RecurrenceRule();
rule.hour = 12;
//rule.second = 12;
schedule.scheduleJob(rule, function(){
                     console.log('rule 12');
                     performServerUpdater()
                     });

rule = new schedule.RecurrenceRule();
rule.hour = 18;
//rule.second = 18;
schedule.scheduleJob(rule, function(){
                     console.log('rule 18');
                     performServerUpdater()
                     });

function sendPredictionPushToRoom(time, zodiacName) {
    console.log('time: ' + time + '; zodiacName: ' + zodiacName)
    performSendPushToRoom(time, zodiacName)
}

function scheduleJobForTime(time) {
    var rule = new schedule.RecurrenceRule();
    rule.hour = time;
    //rule.second = time;
    schedule.scheduleJob(rule, function(){
                           console.log('rule for time: ' + time + ' performing.')
                           var zodiacs = ["aquarius",
                                        "pisces",
                                        "aries",
                                        "taurus",
                                        "gemini",
                                        "cancer",
                                        "leo",
                                        "virgo",
                                        "libra",
                                        "scorpio",
                                        "sagittarius",
                                        "capricorn"];
                           zodiacs.forEach(function(zodiacName) {
                             sendPredictionPushToRoom(time, zodiacName)
                           })
                         });
    console.log('time: ' + time)
}


indexes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]


//sendPredictionPushToRoom(1, 'gemini')
indexes.forEach(function(time){
                scheduleJobForTime(time)
});
// AV: ну а здесь шедулим
