
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database(':memory:');
var gumbo = require("gumbo-parser");

latestUrl = ""
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
urls = []
function iterateLanguages(root) {
    if (root.nodeType == 3) {
        if (latestUrl.length) {
            text = root.textContent
            urls.push({text:text, url:latestUrl})
            latestUrl = "";
        }
    }
    if (root.nodeType != 1) {
        return;
    }
    
    if (root.nodeName == "a") {
        for (var y = 0; y < root.attributes.length; y++) {
            attribute = root.attributes[y];
            if (attribute.name == "href") {
                url = attribute.value
                if (url.includes('language.php')) {
                    latestUrl = url
                }
            }
        }
    }
    
    for (var i = 0; i < root.childNodes.length; i++) {
        var child = root.childNodes[i];
        iterateLanguages(child)
    }
    return urls;
}

function preiterateLanguages(root) {
    urls = []
    iterateLanguages(root)
    return urls;
}

gInsideProfileCard = false
function parseProfileCard(root, data, uproot) {
    if (root.nodeType == 3) {
        if (gInsideProfileCard) {
            day = data.day;
            text = root.textContent
            if(text.indexOf(day) > -1) {
                console.log('url: ' + data.url + '; birthday: ' + text);
            }
        }
        console.log(root.textContent)
        if (root.textContent.indexOf('1979') > -1) {
            console.log('uproot')
            console.log(uproot)
            console.log(uproot.attributes)
        }
    }
    
    mInsideProfileCard = false;
    if (root.nodeName == "div") {
       console.log(root.attributes)
        for (var y = 0; y < root.attributes.length; y++) {
            attribute = root.attributes[y];
            if (attribute.name == "data-sigil") {
                url = attribute.value
                if (url.includes('profile-card')) {
                    gInsideProfileCard = true
                    mInsideProfileCard = true;
                }
            }
        }
    }
    
    if (root.nodeType != 1) {
        return;
    }
    for (var i = 0; i < root.childNodes.length; i++) {
        var child = root.childNodes[i];
        parseProfileCard(child, data, root)
    }
    
    if (mInsideProfileCard == true) {
        mInsideProfileCard = false;
        gInsideProfileCard = false;
    }
    /*
     <div class="_56be _2xfb" id="basic-info" data-sigil="profile-card"><div class="_55wo _55x2 _56bf"><header class="_56bq _52ja _52jh _59e9 _55wp _3knw __gy" data-sigil="profile-card-header"><div class="_55wr _4g33 _52we _5b6o"><div class="_4g34 _5b6q _5b6p"><div class="__gx">Основная информация</div></div><div class="_4g34 _5b6r _5b6p"><div></div></div></div></header><div class="_55x2 _5ji7"><div class="_5cds _2lcw _5cdu" title="Имя (Русский)"><div class="lr"><div class="_5cdv r">Olga  Stjarna</div><div class="_52ja _5ejs"><span class="_52jd _52ja _52jg">Имя (Русский)</span></div><div class="clear"></div></div></div><div class="_5cds _2lcw _5cdu" title="Дата рождения"><div class="lr"><div class="_5cdv r">21 декабря</div><div class="_52ja _5ejs"><span class="_52jd _52ja _52jg">Дата рождения</span></div><div class="clear"></div></div></div><div class="_5cds _2lcw _5cdu" title="Пол"><div class="lr"><div class="_5cdv r">Женский</div><div class="_52ja _5ejs"><span class="_52jd _52ja _52jg">Пол</span></div><div class="clear"></div></div></div><div class="_5cds _2lcw _5cdu" title="Языки"><div class="lr"><div class="_5cdv r">Русский язык и Английский язык</div><div class="_52ja _5ejs"><span class="_52jd _52ja _52jg">Языки</span></div><div class="clear"></div></div></div></div></div></div>
    */
     
}

function fetchLanguageFromUrlsArray(browser, urlsArray) {
    if (!urlsArray.length) {
        console.log('urls array is empty');
        return;
    }
    data = urlsArray[0]
    urlsArray.shift()
    url = data.url;
    if (!url.length) {
        console.log('wrong');
        return;
    }
     browser.visit(url, function(err) {
       var markup = browser.document.documentElement.innerHTML;
       var tree = gumbo(markup);
                   console.log('parsing profile card: ' + markup.length)
       parseProfileCard(tree.root, data, null)
     });
}

function handleLanguagesArray(browser, languages) {
    if (!languages.length) {
        console.log('Languages empty. Possible Authorization error');
        return;
    }
    console.log('Successfully authorized! List of languages: ' + languages.length);
    first = languages[0]
    console.log(first)
    if (first.url.length) {
        url = first.url
    }
    console.log('selecting: ' + url);
    browser.visit("https://m.facebook.com" + url, function(err) {
                  urlsWithMonthsNames = [{month:"january", url:"https://m.facebook.com/danikin2/about?lst=100001547389445%3A100001052329626%3A1510297976", year:"1979", day: "13"},
                                         {month:"february", url:"https://m.facebook.com/alexey.antropov/about?lst=100001547389445%3A100001328802913%3A1510297834", year: "1984", day: "5"},
                                         {month:"march", url:"https://m.facebook.com/zombiehamon/about?lst=100001547389445%3A100000348924649%3A1510298181", year: "", day: "11"},
                                         {month:"april", url:"https://m.facebook.com/postnikov/about?lst=100001547389445%3A619000915%3A1510298002", year: "1982", day: "29"},
                                         {month:"may", url:"https://m.facebook.com/korolev.petr/about?lst=100001547389445%3A100000272556300%3A1510298390", year: "1989", day: "20"},
                                         {month:"june", url:"https://m.facebook.com/jenja.kuznetsov/about?lst=100001547389445%3A100002691857319%3A1510211827", year: "7", day: "1982"},
                                         {month:"july", url:"https://m.facebook.com/st.shambala/about?lst=100001547389445%3A1599670057%3A1510298404", year: "", day: "19"},
                                         {month:"august", url:"https://m.facebook.com/vadim.balashov/about?lst=100001547389445%3A1250453135%3A1510298318", year: "1984", day: "5"},
                                         {month:"september", url:"https://m.facebook.com/okokawa/about?lst=100001547389445%3A1398444205%3A1510297867", year: "", day: "12"},
                                         {month:"october", url:"https://m.facebook.com/trofkate/about?lst=100001547389445%3A100001679278750%3A1510298522", year: "1993", day: "11"},
                                         {month:"november", url:"https://m.facebook.com/gagafonov/about?lst=100001547389445%3A100000619129853%3A1510297945", year: "1982", day: "17"},
                                         {month:"december", url:"https://m.facebook.com/olga.stjarna/about?lst=100001547389445%3A100002901729072%3A1510297758", year: "", day: "21"}];
                  fetchLanguageFromUrlsArray(browser, urlsWithMonthsNames)
     })
}

const Browser = require('zombie');
var url = "https://m.facebook.com/a/language.php?l=en_US&gfid=AQD7j6syLtmVSq7R";
var browser = new Browser();
browser.visit(url, function(err) {
              var markup = browser.document.documentElement.innerHTML;
              //console.log('inside. markup:' + markup)
              //iterateLanguages(tree.root)
              
              browser.fill('input[name="email"]', "jasfasola@mail.ru")
              .fill('input[name="pass"]', "7q13Po46")
              .pressButton('input[name="login"]', function(res) {
                           var markup = browser.document.documentElement.innerHTML;
                          // console.log('inside. markup:' + markup)
                           browser.pressButton('input[type="submit"]', function(res) {
                                               browser.visit("https://m.facebook.com/language.php", function(res) {
                                                               var markup = browser.document.documentElement.innerHTML;
                                                              // console.log('inside2. markup:' + markup)
                                                              var tree = gumbo(markup);
                                                              languages = preiterateLanguages(tree.root)
                                                              handleLanguagesArray(browser, languages)
                                                             })
                                            })
                           });
})

console.log('zz ok')
