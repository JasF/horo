logs = require('../common/logger').getLogger();
var Curl = require('node-libcurl').Curl;
var storage = require('../common/horostorage');

function sendPushRequest(roomname, title, text) {
    /*
    newText = text.substring(0,Math.min(text.length, 128));
    if (newText.length != text.length) {
      newText += "..."
      text = newText
    }*/
    
    var curl = new Curl();
    data = { //Data to send, inputName : value
      'interests' : [roomname],
      'apns' : {'aps' : {'alert':{'title':title,'body':text}}}
    };
    data = JSON.stringify( data );
    logs.info('JSON payload: ' + data);
    curl.setOpt( Curl.option.URL, 'https://54423f63-b8dd-4f21-8563-b009f25c399f.pushnotifications.pusher.com/publish_api/v1/instances/54423f63-b8dd-4f21-8563-b009f25c399f/publishes' );
    curl.setOpt( Curl.option.POSTFIELDS, data );
    curl.setOpt( Curl.option.HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer C14C4D4FCE687A45EB5B791A2596DCC'] );
    curl.setOpt( Curl.option.VERBOSE, true );
    curl.perform();
    curl.on('end', function( statusCode, body ) {
      logs.info('pushSended: ' + statusCode + '; body: ' + body);
    });
    curl.on( 'error', curl.close.bind( curl ) );
}

exports.sendTodayPushToZodiacName = function(time, zodiacName) {
    var todayDate = new Date();
    storage.dayHoroscopeWithDate(todayDate, zodiacName, function (content) {
      roomname = zodiacName + time
      logs.info('prediction for ' + zodiacName + ' length: ' + content.length + '; roomname: ' + roomname);
      sendPushRequest(roomname, zodiacName, content)
    })
}
