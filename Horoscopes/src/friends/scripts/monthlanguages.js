
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

function fillAuthorizationPage(browser, err) {
    if (!browser.success) {
        console.log('br fail')
        return false;
    }
    inputValue = browser.document.getElementById("m_login_email");
    if (inputValue == null) {
        console.log('m_login_email null')
        return false;
    }
    inputValue.value = "jasfasola@mail.ru";
    inputValue = browser.document.getElementById("m_login_password");
    if (inputValue == null) {
        console.log('m_login_password null')
        return false;
    }
    inputValue.value = "7q13Po46";
    inputValue = browser.document.getElementById("u_0_5");
    if (inputValue == null) {
        console.log('u_0_5 (login button) null')
        return false;
    }
    inputValue.click()
    return true;
}

const Browser = require('zombie');

// Which will be routed to our test server localhost:3000

var url = "https://m.facebook.com";
var browser = new Browser();
browser.visit(url, function(err) {
              result = fillAuthorizationPage(browser, err)
              console.log('result: ' + result)
})

console.log('zz ok')
