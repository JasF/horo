//
//  horoscopedto.h
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef horoscopedto_h
#define horoscopedto_h

#include "base/coding.h"
#include "zodiac.h"

namespace horo {
    
    enum HoroscopeType {
        HoroscopeDay,
        HoroscopeWeek,
        HoroscopeMonth,
        HoroscopeYear
    };
    
    class _HoroscopeDTO : public Coding {
    public:
        _HoroscopeDTO() : zodiac_(Unknown), type_(HoroscopeDay), date_(0) {}
        virtual ~_HoroscopeDTO() {}
        
    public:
        void encode(Json::Value &coder) override;
        void decode(Json::Value &coder) override;
        
        
    public:
        ZodiacTypes zodiac() const { return zodiac_; }
        HoroscopeType type() const { return type_; }
        std::string content() const { return content_; }
        uint64_t date() const { return date_; }
        
    private:
        ZodiacTypes zodiac_;
        HoroscopeType type_;
        std::string content_;
        uint64_t date_;
    };
    
    typedef reff<_HoroscopeDTO> HoroscopeDTO;
};

#endif /* horoscopedto_h */
