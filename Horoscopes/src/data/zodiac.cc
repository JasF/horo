//
//  zodiac.c
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "zodiac.h"

namespace horo {
    static const char *kStartMonth = "kStartMonth";
    static const char *kStartDay = "kStartDay";
    static const char *kEndMonth = "kEndMonth";
    static const char *kEndDay = "kEndDay";
    
    string stringByMonth(Months month) {
        switch (month) {
            case January: return "january";
            case February: return "february";
            case March: return "march";
            case April: return "april";
            case May: return "may";
            case June: return "june";
            case July: return "july";
            case August: return "august";
            case September: return "september";
            case October: return "october";
            case November: return "november";
            case December: return "december";
            case MonthUnknown:
            default:break;
        }
        return "";
    }
    
    Json::Value createValue(Months sM, int sD, Months eM, int eD) {
        Json::Value result;
        result[kStartMonth] = sM;
        result[kStartDay] = sD;
        result[kEndMonth] = eM;
        result[kEndDay] = eD;
        return result;
    }
    
    Json::Value &zodiacTypesDatasource() {
        static Json::Value g_value;
        if (!g_value.size()) {
            g_value[Aries] = createValue(March, 21, April, 19);
            g_value[Taurus] = createValue(April, 20, May, 20);
            g_value[Gemini] = createValue(May, 21, June, 20);
            g_value[Cancer] = createValue(June, 21, July, 22);
            g_value[Leo] = createValue(July, 23, August, 22);
            g_value[Virgo] = createValue(August, 23, September, 22);
            g_value[Libra] = createValue(September, 23, October, 22);
            g_value[Scorpio] = createValue(October, 23, November, 21);
            g_value[Sagittarius] = createValue(November, 22, December, 21);
            g_value[Capricorn] = createValue(December, 22, January, 19);
            g_value[Aquarius] = createValue(January, 20, February, 18);
            g_value[Pisces] = createValue(February, 19, March, 20);
        }
        return g_value;
    }
    
ZodiacTypes _Zodiac::zodiacTypeByDate(Months month, int day, int /*year*/) {
    Json::Value &data = zodiacTypesDatasource();
    for( Json::ValueIterator it = data.begin(); it != data.end(); ++it )
    {
        ZodiacTypes type =(ZodiacTypes)it.key().asInt();
        Json::Value &value = *it;
        Months sM = (Months) value[kStartMonth].asInt();
        int sD = value[kStartDay].asInt();
        Months eM = (Months) value[kEndMonth].asInt();
        int eD = value[kEndDay].asInt();
        if ( (sM == month && day >= sD) ||
             (eM == month && day <= eD)) {
            return type;
        }
    }
    return Unknown;
}
    
ZodiacTypes _Zodiac::zodiacTypeByDate(DateWrapper wrapper) {
    return _Zodiac::zodiacTypeByDate((Months)wrapper.month(), wrapper.day(), wrapper.year());
}

DateWrapper _Zodiac::startDateForType(ZodiacTypes aType) {
    Json::Value &data = zodiacTypesDatasource();
    for( Json::ValueIterator it = data.begin(); it != data.end(); ++it )
    {
        ZodiacTypes type =(ZodiacTypes)it.key().asInt();
        if (type == aType) {
            Json::Value &value = *it;
            Months sM = (Months) value[kStartMonth].asInt();
            int sD = value[kStartDay].asInt();
            DateWrapper date(sD, sM);
            return date;
        }
    }
    return DateWrapper();
}

DateWrapper _Zodiac::endDateForType(ZodiacTypes aType) {
    Json::Value &data = zodiacTypesDatasource();
    for( Json::ValueIterator it = data.begin(); it != data.end(); ++it )
    {
        ZodiacTypes type =(ZodiacTypes)it.key().asInt();
        if (type == aType) {
            Json::Value &value = *it;
            Months eM = (Months) value[kEndMonth].asInt();
            int eD = value[kEndDay].asInt();
            DateWrapper date(eD, eM);
            return date;
        }
    }
    return DateWrapper();
}
     
std::string _Zodiac::name() const {
    static dictionary dict;
    if (!dict.size()) {
        dict[Aquarius] = "aquarius";
        dict[Pisces] = "pisces";
        dict[Aries] = "aries";
        dict[Taurus] = "taurus";
        dict[Gemini] = "gemini";
        dict[Cancer] = "cancer";
        dict[Leo] = "leo";
        dict[Virgo] = "virgo";
        dict[Libra] = "libra";
        dict[Scorpio] = "scorpio";
        dict[Sagittarius] = "sagittarius";
        dict[Capricorn] = "capricorn";
    }
    std::string result = dict[type()].asString();
    SCAssert(result.length(), "unknown zodiac type");
    return result;
}
    
};
