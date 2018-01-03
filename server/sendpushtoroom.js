const Firestore = require('@google-cloud/firestore');
credentialsFilename = "./horo-ios-287dcbc8f4c6.json"
var Curl = require( 'node-libcurl' ).Curl;
const firestore = new Firestore({projectId: 'horo-ios',
                                keyFilename: credentialsFilename });


time = process.argv[2]
zodiacName = process.argv[3]

roomname = zodiacName + time

function sendPushRequest(title, text) {
    
    var curl = new Curl();
    data = { //Data to send, inputName : value
        'interests' : [roomname],
        'apns' : {'aps' : {'alert':{'title':title,'body':text}}}
    };
    data = JSON.stringify( data );
    console.log('POST body: ' + data);
    curl.setOpt( Curl.option.URL, 'https://54423f63-b8dd-4f21-8563-b009f25c399f.pushnotifications.pusher.com/publish_api/v1/instances/54423f63-b8dd-4f21-8563-b009f25c399f/publishes' );
    curl.setOpt( Curl.option.POSTFIELDS, data );
    curl.setOpt( Curl.option.HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer C14C4D4FCE687A45EB5B791A2596DCC'] );
    curl.setOpt( Curl.option.VERBOSE, true );
    curl.perform();
    curl.on('end', function( statusCode, body ) {
            console.log( 'statusCode: ' + statusCode + '; body: ' + body );
            process.exit(0)
            });
    curl.on( 'error', curl.close.bind( curl ) );
}
var todayDate = new Date();
var day = todayDate.getUTCDate();
var month = todayDate.getUTCMonth() + 1; //months from 1-12
var year = todayDate.getUTCFullYear();

dateString = "" + day + "." + month + "." + year
path = 'storage/days/' + zodiacName + '/' + dateString
console.log("setting document: " + path);
const document = firestore.doc(path)

document.get().then(doc => {
                    data = doc.data()
                    content = data.content
                    console.log('data content is: ' + content)
                    sendPushRequest(zodiacName, content);
                    });

console.log('sending push to room: ' + roomname);

