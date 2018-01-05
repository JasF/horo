function dateToDateString (aDate) {
    var result = "" + aDate.getDate()+ "." + Number(parseInt(aDate.getMonth(), 10) + 1) + "." + aDate.getFullYear()
    return result;
}

exports.dateStringFromType = function (type) {
    var date = new Date();
    dateFunctions = {today:function () {
        return dateToDateString(date)
    }, yesterday:function () {
        newDate = new Date()
        newDate.setDate(date.getDate() - 1)
        return dateToDateString(newDate)
    }, tomorrow:function () {
        newDate = new Date()
        newDate.setDate(date.getDate() + 1)
        return dateToDateString(newDate)
    }, weekly:function () {
        newDate = new Date()
        day = parseInt(date.getDay())
        if (day > 0) {
            --day;
        }
        else {
            day = 6;
        }
        newDate.setDate(date.getDate() - day)
        console.log("weekly: " + newDate)
        return dateToDateString(newDate)
    }, monthly:function () {
        var newDate = new Date(date)
        newDate.setDate(1)
        console.log("monthly: " + newDate)
        return dateToDateString( newDate )
    }, year:function () {
        var newDate = new Date(date)
        newDate.setDate(1)
        newDate.setMonth(0)
        console.log("year: " + newDate)
        return dateToDateString( newDate )
    }}
    dateFunction = dateFunctions[type];
    dateString = dateFunction()
    return dateString;
}

var HoroTypeDay = "days"
var HoroTypeWeek = "week"
var HoroTypeMonth = "month"
var HoroTypeYear = "year"

horoTypes = {yesterday:HoroTypeDay,
today:HoroTypeDay,
tomorrow:HoroTypeDay,
weekly:HoroTypeWeek,
monthly:HoroTypeMonth,
    year:HoroTypeYear};

exports.horoTypeByTabsType = function (tabsType) {
    return horoTypes[tabsType];
}

function monthIndexFromAbbreviature(abbreviation) {
    abbreviation = abbreviation.toLowerCase()
    switch (abbreviation) {
        case "jan": return 1;
        case "feb": return 2;
        case "mar": return 3;
        case "apr": return 4;
        case "may": return 5;
        case "jun": return 6;
        case "jul": return 7;
        case "aug": return 8;
        case "sep": return 9;
        case "oct": return 10;
        case "nov": return 11;
        case "dec": return 12;
    }
    return 0;
}

function getDayDateString(source) {
    parts = source.split(" ")
    if (parts.length != 3) {
        logs.info('parts incorrect: ' + parts);
        return "";
    }
    monthIndex = monthIndexFromAbbreviature(parts[0])
    if (monthIndex == 0) {
        logs.info('cannot decode month abbreviation: ' + parts[0]);
        return "";
    }
    dayNumber = parts[1]
    index = dayNumber.indexOf( ',' )
    if (index >= 0) {
        dayNumber = dayNumber.substring(0, index)
    }
    year = parts[2]
    result = dayNumber + "." + monthIndex + "." + year;
    logs.info('result is: ' + result);
    return result;
}

exports.dateStringFromPredictionText = function(prediction, tabsType) {
    horoType = horoTypes[tabsType];
    if (horoType == HoroTypeDay) {
        var index = prediction.indexOf( ' ', prediction.indexOf( ' ', prediction.indexOf( ' ' ) + 1 ) + 1 );
        if (index < 0) {
            return "";
        }
        rawDateString = prediction.substring(0, index);
        dateString = getDayDateString(rawDateString)
        logs.info('rds: ' + rawDateString + '; dateString: ' + dateString);
        return dateString;
    }
    else if (horoType == HoroTypeWeek) {
        logs.info('unimplemented week');
    }
    else if (horoType == HoroTypeMonth) {
        logs.info('unimplemented month');
    }
    return "";
}

exports.trim = function(str) {
    return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}
