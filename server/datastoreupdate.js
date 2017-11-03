const Firestore = require('@google-cloud/firestore');
credentialsFilename = "./horo-ios-287dcbc8f4c6.json"
const Browser = require('zombie');
var gumbo = require("gumbo-parser");

var zodiacs = [
"aquarius",
"pisces",
"aries",
"taurus",
"gemini",
"cancer",
"leo",
"virgo",
"libra",
"scorpio",
"sagittarius",
               "capricorn"];

const firestore = new Firestore({projectId: 'horo-ios',
                                keyFilename: credentialsFilename });
const document = firestore.doc('posts/intro-to-firestore');
// Enter new data into the document.
/*
document.set({
             title: 'Welcome to Firestore',
             body: 'Hello World',
             }).then(() => {
                     console.log('created!');
                     
                     // Update an existing document.
                     document.update({
                                     body: 'My first Firestore app',
                                     }).then(() => {
                                             console.log('updated!');
                                             // Document updated successfully.
                                             
                                             // Read the document.
                                             document.get().then(doc => {
                                                                 console.log('Read!');
                                                                 // Document read successfully.
                                                                 
 
                                                                 // Delete the document.
                                                          //       document.delete().then(() => {
                                                          //                              console.log('Delete!');
                                                          //                              // Document deleted successfully.
                                                           //                             });
 
                                                                 });
                                             
                                             });
                     

                     });
*/

// We're going to make requests to http://example.com/signup
// Which will be routed to our test server localhost:3000
Browser.localhost('mail.ru', 80);
Browser.extend(function(browser) {
               browser.on('console', function(level, message) {
                          logger.log(message);
                          console.log(message);
                          });
               browser.on('log', function(level, message) {
                          logger.log(message);
                          console.log(message);
                          });
               });

console.log('hello1')
/*
browser.visit('/', function() {
              console.log(browser.location.href);
              console.log(browser.title)
              });
*/

var zodiacKey = ""
var parameters = {}
var textStorage = ""

function invokeTextFromTreeWithZodiacKey(tree, key) {
    console.log('key: ' + key)
    var classValue = ""
    if (tree.nodeName == "p") {
        console.log("paragraph detected");
        for (var i = 0; i < tree.attributes.length; i++) {
            var attr = tree.attributes[i];
            if (attr.name == "class") {
                classValue = attr.attr.value
            }
            //console.log('attr name: ' + attr.name + '; value: ' + attr.value)
        }
        console.log("paragraph 1");
        parameters.paragraph = true;
        if (classValue.length) {
            console.log("paragraph 2");
            parameters[classValue] = true;
        }
        console.log("paragraph 3");
    }
    
    console.log('tree')
    if (!key.length) {
        console.log("key cannot be empty");
        return
    }
    
    for (var i = 0; i < tree.childNodes.length; i++) {
        var child = tree.childNodes[i];
        if (child.nodeType == 1 /*1 == Element*/) {
            invokeTextFromTreeWithZodiacKey(child, key)
        }
        else if (child.nodeType == 3 /*3 == Text*/) {
            console.log("text node");
            textStorage += child.textContent
        }
    }
    
    if (tree.nodeName == "p") {
        parameters.paragraph = false;
        if (classValue.length) {
            console.log('predel');
            delete parameters[classValue];
            console.log('postde');
        }
    }
}

function invokePayloadData(tree, completion) {
    if (tree.nodeName == "div") {
        for (var y = 0; y < tree.attributes.length; y++) {
            attribute = tree.attributes[y];
            if (attribute.name == "class" && attribute.value == "horoscope-content") {
               // console.log('found payload tree: ');
                textStorage = ""
                invokeTextFromTreeWithZodiacKey(tree, zodiacKey)
               // console.log( "" + zodiacKey + ': textStorage: ' + textStorage)
            }
        }
    }
    if (tree.nodeName == "body") {
        for (var y = 0; y < tree.attributes.length; y++) {
            attribute = tree.attributes[y];
            if (attribute.name == "class") {
                zodiacKey = attribute.value
            }
        }
    }
    
    for (var i = 0; i < tree.childNodes.length; i++) {
        var child = tree.childNodes[i];
        if (child.nodeType == 1 /*1 == Element*/) {
            invokePayloadData(child, null)
        }
    }
    if (completion != null) {
        completion(zodiacKey, textStorage)
    }
}

function doRequest(signIndex, completion) {
    var url = "https://www.horoscope.com/us/horoscopes/general/horoscope-general-daily-today.aspx?sign=" + signIndex
    console.log("start requesting: " + url)
    const browser = new Browser()
    browser.fetch(url)
    .then(function(response) {
          console.log('Status code:', response.status);
          if (response.status === 200)
          return response.text();
          })
    .then(function(text) {
          var tree = gumbo(text);
          var root = tree["root"]
          invokePayloadData(root, function (zodiacName, predictionText) {
                            console.log('zodiacName: ' + zodiacName + '; predictionText: ' + predictionText)
                            })
          if (completion) {
            completion(true)
          }
          })
    .catch(function(error) {
           console.log("parsing html error!");
           console.log(error);
           if (completion) {
             completion(false)
           }
           });
}

function requestHoroscopesWithSignsArray(array) {
    if (array.length == 0) {
        console.log("end of requests horoscopes. Array empty");
        return;
    }
    index = array[0]
    array.splice(0, 1);
    doRequest(index, function (success) {
              console.log("parsing success: " + success)
                requestHoroscopesWithSignsArray(array)
              })
}

indexes = [0]
requestHoroscopesWithSignsArray(indexes)
