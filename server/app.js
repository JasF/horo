var http = require('http');
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database('./horoscopes.sql');
var url = require("url");

db.serialize(function() {
             db.each("SELECT rowid AS id, type, content FROM predictions", function(err, row) {
                     console.log(row.id + ": " + row.type + ":"  + row.content);
                     });
             });

// Configure our HTTP server to respond with Hello World to all requests.
var server = http.createServer(function (request, response) {
                               var pathname = url.parse(request.url).pathname;
                               if (pathname == '/byZodiac') {
                               console.log('byZodiac!')
                               console.log(url.parse(request.url).query)
                               
                               response.writeHead(200, {"Content-Type": "text/plain"});
                               todayDict = {type: "today"}
                               db.serialize(function() {
                                            db.each("SELECT type, content FROM predictions WHERE type = \"today\";", function(err, row) {
                                                    todayDict.content = row.content;
                                                    str = JSON.stringify(todayDict);
                                                    response.end(str);
                                                    });
                                            });
                               }
                               else {
                               console.log("Unknown Request for " + pathname + " received.");
                               }

                               });

// Listen on port 8000, IP defaults to 127.0.0.1
server.listen(8002);

// Put a friendly message on the terminal
console.log("Server running at http://127.0.0.1:8000/");


