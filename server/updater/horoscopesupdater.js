logs = require('../common/logger').getLogger();
downloader = require('./horoscopesdownloader.js');
async = require('async');
var arrays = require('async-arrays');
var parser = require('./horoscopesparser');
var storage = require('./horostorage');

exports.beginUpdate = function (completion) {
  logs.info('begin update')
  tabsTypes = ["yesterday", "today", "tomorrow", "weekly", "monthly"];
  indexes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
  arrays.map(tabsTypes.slice(), function(tabType, tabsCallback){
    logs.info('tabs type: ' + tabType);
    arrays.map(indexes.slice(), function(index, indexCallback){
      logs.info('request with zodiacIndex: ' + index);
      downloader.performDownloadHoroscope(index, tabType, function (body, error) {
        if (body == null) {
          logs.error('body is nil');
          indexCallback();
          return;
        }
        logs.info('response! length: ' + body.length + '; error: ' + error);
        try {
          parser.parse(body, function(zodiacName, predictionText) {
            logs.info('parsed. zodiacName: ' + zodiacName + '; predictionText: ' + predictionText);
            storage.writeHoroscope(zodiacName, tabType, predictionText, function () {
              logs.info('saved!')
              indexCallback()
            })
          })
        } catch (err) {
          logs.info('err: ' + err)
        }
                                          
      })
    }, function () {
      tabsCallback()
    });
  }, function(){
    completion()
  });
}
