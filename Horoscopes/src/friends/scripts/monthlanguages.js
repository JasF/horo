
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database(':memory:');

/*
db.serialize(function() {
             db.run("CREATE TABLE localizedMonths (nameInEnglish TEXT, languageCode TEXT, localizedString TEXT)");
             
             var stmt = db.prepare("INSERT INTO lorem VALUES (?)");
             for (var i = 0; i < 10; i++) {
             stmt.run("Ipsum " + i);
             }
             stmt.finalize();
             
             db.each("SELECT rowid AS id, info FROM lorem", function(err, row) {
                     console.log(row.id + ": " + row.info);
                     });
             });

db.close();
*/
const Browser = require('zombie');

// Which will be routed to our test server localhost:3000

var url = "https://m.facebook.com";
var browser = new Browser();
browser.visit(url, function(err) {
              
              browser.fill('input[name="email"]', "jasfasola@mail.ru")
              .fill('input[name="pass"]', "7q13Po46")
              .pressButton('input[name="login"]', function(res) {
                           var markup = browser.document.documentElement.innerHTML;
                           console.log('inside. markup:' + markup)
                           });
             // http://krasimirtsonev.com/blog/article/Testing-with-headless-browser-Zombiejs-Jasmine-TDD-NodeJS-example
})

console.log('zz ok')
