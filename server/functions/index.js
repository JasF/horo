// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');
const fs = require('memfs');
// The Firebase Admin SDK to access the Firebase Realtime Database. 
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const querystring = require('querystring');
const http = require('http');
const util = require('util');
const Firestore = require('@google-cloud/firestore');
const Browser = require('zombie');
var gumbo = require("gumbo-parser");
var jsonfile = require('jsonfile')
var Curl = require( 'node-libcurl' ).Curl;
var newCredentialsFilename = '/credentials.json'
var firestore = null

// Take the text parameter passed to this HTTP endpoint and insert it into the
// Realtime Database under the path /messages/:pushId/original
exports.sendPush = functions.https.onRequest((req, res) => {
  // Grab the text parameter.
  const title = req.query.title;
  const text = req.query.text;
  const roomname = req.query.roomname

   var curl = new Curl();
   data = { //Data to send, inputName : value
   'interests' : [roomname],
   'apns' : {'aps' : {'alert':{'title':title,'body':text}}}
   };
   data = JSON.stringify( data );
   curl.setOpt( Curl.option.URL, 'https://54423f63-b8dd-4f21-8563-b009f25c399f.pushnotifications.pusher.com/publish_api/v1/instances/54423f63-b8dd-4f21-8563-b009f25c399f/publishes' );
   curl.setOpt( Curl.option.POSTFIELDS, data );
   curl.setOpt( Curl.option.HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer C14C4D4FCE687A45EB5B791A2596DCC'] );
   curl.setOpt( Curl.option.VERBOSE, true );
   curl.perform();
   curl.on('end', function( statusCode, body ) {
           console.log( body );
           admin.database().ref('/messages').push({original: body}).then(snapshot => {
                                                                           res.redirect(303, snapshot.ref);
                                                                        });
           this.close();
          });
   curl.on( 'error', curl.close.bind( curl ) );
});


