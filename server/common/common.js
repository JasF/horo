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
