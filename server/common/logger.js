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

var logger = new (winston.Logger)({
                                  transports: [
                                               new (winston.transports.Console)({
                                                                                level: 'debug'
                                                                                }),
                                               new (winston.transports.File)({
                                                                             filename: './../../updater.log',
                                                                             level: 'debug'
                                                                             })
                                               ]
                                  });

exports.getLogger =  function() {
    return logger;
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