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
        return dateToDateString(newDate)
    }, monthly:function () {
        var newDate = new Date(date)
        newDate.setDate(1)
        return dateToDateString( newDate )
    }, year:function () {
        var newDate = new Date(date)
        newDate.setDate(1)
        newDate.setMonth(0)
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

function monthIndexFromName(name) {
    name = name.toLowerCase()
    switch (name) {
        case "january": return 1;
        case "february": return 2;
        case "march": return 3;
        case "april": return 4;
        case "may": return 5;
        case "june": return 6;
        case "july": return 7;
        case "august": return 8;
        case "september": return 9;
        case "october": return 10;
        case "november": return 11;
        case "december": return 12;
    }
    return 0;
}

function getDayDateString(source) {
    parts = source.split(" ")
    if (parts.length != 3) {
        logs.debug('parts incorrect: ' + parts);
        return "";
    }
    monthIndex = monthIndexFromAbbreviature(parts[0])
    if (monthIndex == 0) {
        logs.debug('cannot decode month abbreviation: ' + parts[0]);
        return "";
    }
    dayNumber = parts[1]
    index = dayNumber.indexOf( ',' )
    if (index >= 0) {
        dayNumber = dayNumber.substring(0, index)
    }
    year = parts[2]
    result = dayNumber + "." + monthIndex + "." + year;
    logs.debug('result is: ' + result);
    return result;
}

function getMonthDateString(source) {
    parts = source.split(" ")
    if (parts.length != 2) {
        logs.debug('parts incorrect: ' + parts);
        return "";
    }
    monthIndex = monthIndexFromName(parts[0])
    if (monthIndex == 0) {
        logs.debug('cannot decode month name: ' + parts[0]);
        return "";
    }
    year = parts[1]
    result = 1 + "." + monthIndex + "." + year;
    logs.debug('result is: ' + result);
    return result;
}

exports.dateStringFromPredictionText = function(prediction, tabsType) {
    horoType = horoTypes[tabsType];
    if (horoType == HoroTypeDay || horoType == HoroTypeWeek) {
        var index = prediction.indexOf('-');
        logs.debug('index is: ' + index);
        if (index < 0) {
            return "";
        }
        index = index - 1
        rawDateString = prediction.substring(0, index);
        dateString = getDayDateString(rawDateString)
        logs.debug('rds: ' + rawDateString + '; dateString: ' + dateString);
        return dateString;
    }
    else if (horoType == HoroTypeMonth) {
        var index = prediction.indexOf(' ', prediction.indexOf(' ') + 1);
        if (index < 0) {
            logs.debug('err: ' + index);
            return "";
        }
        rawDateString = exports.trim(prediction.substring(0, index));
        dateString = getMonthDateString(rawDateString);
        logs.debug('rds: ' + rawDateString + '; dateString: ' + dateString);
        return dateString;
    }
    else if (horoType == HoroTypeYear) {
        return exports.dateStringFromType(tabsType);
    }
    return "";
}

exports.trim = function(str) {
    return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}
