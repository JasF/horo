
const Browser = require('zombie');
var gumbo = require("gumbo-parser");

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

const browser = new Browser();
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

function invokePayloadData(tree) {
    if (tree.nodeName == "div") {
        for (var y = 0; y < tree.attributes.length; y++) {
            attribute = tree.attributes[y];
            if (attribute.name == "class" && attribute.value == "horoscope-content") {
                console.log('found payload tree: ');
                textStorage = ""
                invokeTextFromTreeWithZodiacKey(tree, zodiacKey)
                console.log( "" + zodiacKey + ': textStorage: ' + textStorage)
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
            invokePayloadData(child)
        }
    }
}

browser.fetch("https://www.horoscope.com/us/horoscopes/general/horoscope-general-daily-today.aspx?sign=3")//"https://horoscope.com")
.then(function(response) {
      console.log('Status code:', response.status);
      if (response.status === 200)
      return response.text();
      })
.then(function(text) {
      var tree = gumbo(text);
      var root = tree["root"]
      invokePayloadData(root)
      })
.catch(function(error) {
       console.log('Network error');
       });
