var winston = require('winston');

var logger = null;
logger = new (winston.Logger)({
                     transports: [
                                  new (winston.transports.Console)({
                                                                   level: 'silly'
                                                                   }),
                                  new (winston.transports.File)({
                                                                filename: './../../updater.log',
                                                                level: 'verbose'
                                                                })
                                  ]
                     });
var pusherLogger = null;
var ttyLogger = null;
var commonLogger = null;

exports.getLogger =  function() {
    return logger;
}

exports.getPusherLogger =  function() {
    return exports.getLogger()
}

exports.getTTYLogger =  function() {
    return exports.getLogger()
}

exports.getCommonLogger =  function() {
     return exports.getLogger()
}


/*
function createLogger(filename) {
    return new (winston.Logger)({
                                transports: [
                                             new (winston.transports.Console)({
                                                                              level: 'silly'
                                                                              }),
                                             new (winston.transports.File)({
                                                                           filename: './../../' + filename,
                                                                           level: 'i'
                                                                           })
                                             ]
                                });
}

var pusherLogger = null;
var ttyLogger = null;
var commonLogger = null;

exports.getLogger =  function() {
    return logger;
}

exports.getPusherLogger =  function() {
    if (pusherLogger == null) {
        pusherLogger = createLogger('pusher.log');
    }
    return pusherLogger;
}

exports.getTTYLogger =  function() {
    if (ttyLogger == null) {
        ttyLogger = createLogger('ttyupdater.log');
    }
    return ttyLogger;
}

exports.getCommonLogger =  function() {
    if (commonLogger == null) {
        commonLogger = createLogger('common.log');
    }
    return commonLogger;
}

*/
