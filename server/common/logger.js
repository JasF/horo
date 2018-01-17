var winston = require('winston');

/*
 Formatting
 
const { createLogger, format, transports } = require('winston');
const { combine, timestamp, label, printf } = format;

const myFormat = printf(info => {
                        return `${info.timestamp} [${info.label}] ${info.level}: ${info.message}`;
                        });

const logger = createLogger({
                            format: combine(
                                            label({ label: 'right meow!' }),
                                            timestamp(),
                                            myFormat
                                            ),
                            transports: [new transports.Console()]
                            });
*/

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
    /*
    if (pusherLogger == null) {
        pusherLogger = createLogger('pusher.log');
    }
    return pusherLogger;
     */
}

exports.getTTYLogger =  function() {
    return exports.getLogger()
    /*
    if (ttyLogger == null) {
        ttyLogger = createLogger('ttyupdater.log');
    }
    return ttyLogger;
     */
}

exports.getCommonLogger =  function() {
     return exports.getLogger()
     /*
    if (commonLogger == null) {
        commonLogger = createLogger('common.log');
    }
    return commonLogger;
     */
}


/*
 const levels = {
 error: 0,
 warn: 1,
 info: 2,
 verbose: 3,
 debug: 4,
 silly: 5
 }
*/
