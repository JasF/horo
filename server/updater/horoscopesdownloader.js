logs = require('../common/logger').getLogger();
requests = require('../common/networkingservice')

function urlComponentForType(type) {
    urlComponents = {today:function () {
        return "daily-" + type;
    }, yesterday:function () {
        return "daily-" + type;
    }, tomorrow:function () {
        return "daily-" + type;
    }, weekly:function () {
        return type;
    }, monthly:function () {
        return type;
    }, year:function () {
        return "";
    }}
    return urlComponents[type]()
}

exports.performDownloadHoroscope = function (zodiacIndex, type, completion) {
    component = urlComponentForType(type)
    var url = "https://www.horoscope.com/us/horoscopes/general/horoscope-general-" + component + ".aspx?sign=" + zodiacIndex
    requests.performRequest(url, function(body, error) {
        completion(body, error)
    })
};
