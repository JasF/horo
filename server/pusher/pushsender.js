logs = require('../common/logger').getPusherLogger();
var Curl = require('node-libcurl').Curl;
var storage = require('../common/horostorage');

var kNumberOfSpacesCountFromEndOfDateBeforeLastWordInPushMessage = 5;
var kNumberOfCharsWithDateInStartOfPushText = 18;

function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

function sendPushRequest(roomname, zodiacName, text) {
    var currentIndex = kNumberOfCharsWithDateInStartOfPushText;
    for (var i = 0 ; i < kNumberOfSpacesCountFromEndOfDateBeforeLastWordInPushMessage + 1; ++i) {
        var newIndex = text.indexOf(' ', currentIndex)
        if (newIndex >= currentIndex) {
            currentIndex = newIndex + 1;
        }
    }
    text = text.substring(0, currentIndex-1) + '...';
    
    var curl = new Curl();
    data = { //Data to send, inputName : value
      interests : [roomname],
        apns : {aps : {alert:{title:capitalizeFirstLetter(zodiacName),body:text}, sound: "default", badge: 1, zodiacName: zodiacName}}
    };
    data = JSON.stringify( data );
    logs.debug('JSON payload: ' + data);
    curl.setOpt( Curl.option.URL, 'https://54423f63-b8dd-4f21-8563-b009f25c399f.pushnotifications.pusher.com/publish_api/v1/instances/54423f63-b8dd-4f21-8563-b009f25c399f/publishes' );
    curl.setOpt( Curl.option.POSTFIELDS, data );
    curl.setOpt( Curl.option.HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer C14C4D4FCE687A45EB5B791A2596DCC'] );
    curl.setOpt( Curl.option.VERBOSE, true );
    curl.perform();
    curl.on('end', function( statusCode, body ) {
      logs.debug('pushSended: ' + statusCode + '; body: ' + body);
    });
    curl.on( 'error', curl.close.bind( curl ) );
}

exports.sendTodayPushToZodiacName = function(time, zodiacName) {
    var todayDate = new Date();
    storage.dayHoroscopeWithDate(todayDate, zodiacName, function (content) {
      roomname = zodiacName + time
      logs.debug('prediction for ' + zodiacName + ' length: ' + content.length + '; roomname: ' + roomname);
      sendPushRequest(roomname, zodiacName, content)
    })
}
