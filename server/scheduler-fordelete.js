console.log('hello scheduler');
var schedule = require('node-schedule');
const util = require('util');
const exec = util.promisify(require('child_process').exec);

async function performServerUpdater() {
    console.log('performing bash ./updater.sh');
    const { stdout, stderr } = await exec('bash ./updater.sh');
    console.log('updater.sh finished. stderr: ' + stderr)
}

performServerUpdater();

var rule = new schedule.RecurrenceRule();
rule.hour = 1;
//rule.second = 1;
var j = schedule.scheduleJob(rule, function(){
  console.log('rule.second = 1;');
  performServerUpdater()
});

rule = new schedule.RecurrenceRule();
rule.hour = 6;
//rule.second = 6;
schedule.scheduleJob(rule, function(){
  console.log('rule.second = 6;');
  performServerUpdater()
});

rule = new schedule.RecurrenceRule();
rule.hour = 12;
//rule.second = 12;
schedule.scheduleJob(rule, function(){
  console.log('rule.second = 12;');
  performServerUpdater()
});

rule = new schedule.RecurrenceRule();
rule.hour = 18;
//rule.second = 18;
schedule.scheduleJob(rule, function(){
  console.log('The answer to life, the universe, and everything!');
  performServerUpdater()
});

