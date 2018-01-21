//
//  zodiac.h
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef zodiac_h
#define zodiac_h

#include "base/horobase.h"
#include "data/datewrapper.h"

namespace horo {
  
enum ZodiacTypes {
    Unknown,
    Aquarius,
    Pisces,
    Aries,
    Taurus,
    Gemini,
    Cancer,
    Leo,
    Virgo,
    Libra,
    Scorpio,
    Sagittarius,
    Capricorn,
    ZodiacsCount
};
    
enum Months {
    MonthUnknown,
    January,
    February,
    March,
    April,
    May,
    June,
    July,
    August,
    September,
    October,
    November,
    December
};
    
string stringByMonth(Months month);
    
class _Zodiac;
typedef reff<_Zodiac> Zodiac;
    
class _Zodiac {
public:
    static ZodiacTypes zodiacTypeByDate(Months month, int day, int year); // start from 1 = first day
    static ZodiacTypes zodiacTypeByDate(DateWrapper wrapper);
    static DateWrapper startDateForType(ZodiacTypes type);
    static DateWrapper endDateForType(ZodiacTypes type);
    static strong<Zodiac> zodiacWithName(string zodiacName);
    static dictionary zodiacsNamesAndTypes();
    static vector<strong<Zodiac>> allZodiacs();
public:
    _Zodiac(int a):type_((ZodiacTypes)a){}
    _Zodiac():type_(Unknown){}
    _Zodiac(ZodiacTypes type) : type_(type) {}
    ~_Zodiac() {}
    
public:
    ZodiacTypes type() const { return type_; }
    std::string name() const;
private:
    ZodiacTypes type_;
};
    
    
};

#endif /* zodiac_h */
