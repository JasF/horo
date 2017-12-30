// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');
const fs = require('memfs');
// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
const querystring = require('querystring');
const https = require('https');
const util = require('util');
const Firestore = require('@google-cloud/firestore');
const Browser = require('zombie');
var gumbo = require("gumbo-parser");
var jsonfile = require('jsonfile')

var newCredentialsFilename = '/credentials.json'
var firestore = null
var Curl = require( 'node-libcurl' ).Curl;

// Take the text parameter passed to this HTTP endpoint and insert it into the
// Realtime Database under the path /messages/:pushId/original
function sendPusher(title,text,roomname) {
    var curl = new Curl();
    data = { //Data to send, inputName : value
        'interests' : ['libra6'],
        'apns' : {'aps' : {'alert':{'title':'Hello','body':'Hello, world!'}}}
    };
    data = JSON.stringify( data );
    curl.setOpt( Curl.option.URL, 'https://54423f63-b8dd-4f21-8563-b009f25c399f.pushnotifications.pusher.com/publish_api/v1/instances/54423f63-b8dd-4f21-8563-b009f25c399f/publishes' );
    curl.setOpt( Curl.option.POSTFIELDS, data );
    curl.setOpt( Curl.option.HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer C14C4D4FCE687A45EB5B791A2596DCC'] );
    curl.setOpt( Curl.option.VERBOSE, true );
    curl.perform();
    curl.on('end', function( statusCode, body ) {
            console.log( body );
            this.close();
           });
    curl.on( 'error', curl.close.bind( curl ) );
}

sendPusher("title","text","roomname")

