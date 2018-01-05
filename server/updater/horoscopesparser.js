logs = require('../common/logger').getLogger();
var gumbo = require("gumbo-parser");


var zodiacKey = ""
var parameters = {}
var textStorage = ""

function invokeTextFromTreeWithZodiacKey(tree, key) {
    var classValue = ""
    if (tree.nodeName == "p") {
        for (var i = 0; i < tree.attributes.length; i++) {
            var attr = tree.attributes[i];
            if (attr.name == "class") {
                classValue = attr.value
            }
        }
        parameters.paragraph = true;
        if (classValue.length) {
            parameters[classValue] = true;
        }
    }
    
    if (!key.length) {
        return
    }
    
    for (var i = 0; i < tree.childNodes.length; i++) {
        var child = tree.childNodes[i];
        if (child.nodeType == 1 /*1 == Element*/) {
            invokeTextFromTreeWithZodiacKey(child, key)
        }
        else if (child.nodeType == 3 /*3 == Text*/) {
            textStorage += child.textContent
        }
    }
    
    if (tree.nodeName == "p") {
        parameters.paragraph = false;
        if (classValue.length) {
            delete parameters[classValue];
        }
    }
}


function invokePayloadData(tree, completion) {
    if (tree.nodeName == "div") {
        for (var y = 0; y < tree.attributes.length; y++) {
            attribute = tree.attributes[y];
            if (attribute.name == "class" && attribute.value == "horoscope-content") {
                textStorage = ""
                invokeTextFromTreeWithZodiacKey(tree, zodiacKey)
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
        if (child.nodeType == 3) {
            // console.log(child.textContent)
        }
    }
    if (completion != null) {
        completion(zodiacKey, textStorage)
    }
}

exports.parse = function (text, completion) {
    var tree = gumbo(text);
    var root = tree["root"]
    logs.debug('root: ' + root);
    invokePayloadData(root, function (zodiacName, predictionText) {
        logs.debug('zodiacName: ' + zodiacName + '; predictionText length: ' + (predictionText != null) ? predictionText.length : 0)
        completion(zodiacName, predictionText)
    })
}
