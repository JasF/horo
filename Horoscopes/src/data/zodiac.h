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

namespace horo {
  
enum ZodiacTypes {
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
class _Zodiac {
public:
    _Zodiac():type_(ZodiacsCount){}
    _Zodiac(ZodiacTypes type) : type_(type) {}
    ~_Zodiac() {}
    
public:
    ZodiacTypes type() const { return type_; }
    std::string name() const;
private:
    ZodiacTypes type_;
};
    
    class Zodiac : public rtc::RefCountedObject<_Zodiac> {};
    
};

#endif /* zodiac_h */
