// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');
const fs = require('memfs');
// The Firebase Admin SDK to access the Firebase Realtime Database. 
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

credentialsJson = {
    "type": "service_account",
    "project_id": "horo-ios",
    "private_key_id": "287dcbc8f4c6c2b20f780cafe7e2d41fc6e4db86",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC/Tzu5JlkwEkQP\nVMYQxazgcngAwFAGOUCgio1Copm453o5J0WAoxl1OLr0wDtQb1hYAJhFHH5oyT2R\nmcwDO9c3/yLwkNtF8i2SAVUMRGkjap/js6n9op2t1UdW5NfnuR+lBB7sC3BinppY\n4GsH5J3f9ME7ubUVM/k1ywFUM3T8lWEvfAhQ2Iz8kC0IHMpIOB0BIhF3+ixUJkJi\nOeeVVS8URTh8cbFfo2LEYVGj8ygJb+gZ//0bKUxkuz7BYePARYwyhjF+9loGzJsg\ngU+qucdLWORJcv/D5T/1isiBcLy9drY+DAjcZESlpJHA7qD2DwVZAyaQxeXDOsM1\n3xQuF0otAgMBAAECggEAQv8VdD6oxzvuV8whXOhNJYEQ43p1y+gq6M38sFRPL0Dp\nPbCyF12G4dVPK71SSFXmA1OZ/8H9xuaKyD2rA4rmUPbpnoOsNq+cI+CRjy06AKwr\neEuIAYn8XE8vn4+eyMi8+0YZKiLLZc4TUYKuGOKII1EMhsT/VICSCrOgMIOguX9e\nvarg8jGNY88uS0i1QvGsbzh2sZgyknmnzO692LEBKyqIF1nYpR0ToUcfxPMJ61qk\nzj+4cjaeqfN/9fYtYmAESsWQD+mPxUJpNH3/sKr2X4Cv3ubAPBgdkHteIXVGEiM/\nsu5kRrsgHxZCXEBCNFsJpfMin0/u90itrm92m2P0BQKBgQD3zmjaDvGxpkN+tpHh\nAUEjRlw51GMbkD3+2iIJZAsGpCgiZr12i2xg+8KKr6gTpDN4i3irXRYhdXdE+/QF\nsFQvLTeUeap0KstGH0xd4ZkT+WyKMjvYM83rai+odYnnTFHRBxNRwKqcOJe9fmHo\nWza58LmszmP77YEM3zn5OAQ7/wKBgQDFoplTTLoZga7ZDmTyigCQW2fTFmPr8BBw\nKgYaDWLPb8siLV+5w6G1/KhE1B2VSfrnL80gLIi+2BXU7Hp9eM9kMfs0QVJIGK6Y\nn17+Z58iAlODT16x1P9z8qq50fky5f3vgg+DGybhp+JfC8O3pmAp7wsVdK0W8KT8\n9y+KIwIp0wKBgDOWIZe7Yq8zyHs5cHbhtvir7gkP4K3dQjqqmElSLUVtqPk4YBqs\nfZxW7LHITXoBRcHDbxRlZXUDqhePR8ZjZbMIe7iJ92UFf5mSbGhizWYuF11RhcnF\nRwnJ6i/sgA/JgIK+MVRkgl/RHC2TgLhJPMRKi6ygronEcIgIdF4gPilrAoGAFvhT\n+7OCOa6x5LZgkzPo5t5IzebfTC/FqVOpC+QcZOGoaVt+sbeEFwO7huxkV9KWX8JV\ng/TJG+0/dFTb07Nz30BT4vnol0qPGFwFjWn7u9crX6qc5exMmGxO3XQDE6BZiDnE\nlcdVGIsLq2JRqAmlSZpn3mGGMJFdi60rEFILUVMCgYEAogETqbdU5XX69Y1i4mcb\nkToRZIHy4uRKTp4lHBvi0wMYtKCRIErRF8/HoemdwtER6+vHDYQaoGV5aefrJMi1\ncLAS9BtOwTXZIYUV3d+O9DDg8+/fRRSf+sSx8CVPYs5Ti1Jpg61fvDH2kf8lY7rs\nlXydv+6pgeG2LbEHQrvwgk4=\n-----END PRIVATE KEY-----\n",
    "client_email": "redactor@horo-ios.iam.gserviceaccount.com",
    "client_id": "113164697857028802069",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://accounts.google.com/o/oauth2/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/redactor%40horo-ios.iam.gserviceaccount.com"
}
const util = require('util');
const Firestore = require('@google-cloud/firestore');
const Browser = require('zombie');
var gumbo = require("gumbo-parser");
var jsonfile = require('jsonfile')


var newCredentialsFilename = '/credentials.json'
var firestore = null


// Take the text parameter passed to this HTTP endpoint and insert it into the
// Realtime Database under the path /messages/:pushId/original
exports.addNextMessage = functions.https.onRequest((req, res) => {
  // Grab the text parameter.
  const original = req.query.text;
  
  fs.writeFileSync(newCredentialsFilename, 'World!');
  
                              
  firestore = new Firestore({projectId: 'horo-ios', keyFilename: newCredentialsFilename });
   string = "str-init";
   if (firestore == null) {
     string = "err-null"
   }

                                                   admin.database().ref('/messages').push({original: string}).then(snapshot => {
                                                                                                                        // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
                                                                                                                        res.redirect(303, snapshot.ref);
                                                                                                                        });
/*
  jsonfile.writeFile(newCredentialsFilename, credentialsJson, function (err) {
                     string = "str-init";
                     if (err == null) {
                        string = "err-null"
                     }
                     else {
                       string = util.inspect(err, { showHidden: true, depth: null })
                     }
  });
                                                    */
/*
  jsonfile.writeFile(newCredentialsFilename, credentialsJson, function (err) {
      console.error(err)
      firestore = new Firestore({projectId: 'horo-ios', keyFilename: newCredentialsFilename });
                     path = 'checking/functions'
                     console.log("setting document: " + path);
                     const document = firestore.doc(path)
                     document.set({ content : "hello publication" }).then(() => {
  // Push the new message into the Realtime Database using the Firebase Admin SDK.
                            });
  });
*/
                                                   
});



// Listens for new messages added to /messages/:pushId/original and creates an
// uppercase version of the message to /messages/:pushId/uppercase
exports.makeUppercase = functions.database.ref('/messages/{pushId}/original')
.onWrite(event => {
  // Grab the current value of what was written to the Realtime Database.
  const original = event.data.val();
  console.log('Uppercasing', event.params.pushId, original);
  const uppercase = original.toUpperCase();
  // You must return a Promise when performing asynchronous tasks inside a Functions such as
  // writing to the Firebase Realtime Database.
  // Setting an "uppercase" sibling in the Realtime Database returns a Promise.
  return event.data.ref.parent.child('OUuppercase').set(uppercase);
});


