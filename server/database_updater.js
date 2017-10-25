var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database('./horoscopes.sql');

db.serialize(function() {
             db.run("CREATE TABLE IF NOT EXISTS predictions (type TEXT, content TEXT)");

             var stmt = db.prepare("INSERT INTO predictions (type, content) VALUES (?, ?)");

             stmt.run("yesterday", "Yesterday horoscope content");
             stmt.run("today", "Today horoscope content");//
             stmt.run("tomorrow", "Tomorrow horoscope content");
             stmt.run("week", "Week horoscope content");
             stmt.run("month", "Month horoscope content");
             stmt.run("year", "Year horoscope content");

             stmt.finalize();

             db.each("SELECT rowid AS id, content, type FROM predictions", function(err, row) {
                     console.log(row.rowid + ":" + row.id + ": " + row.content);
                     });
             });

db.close();

