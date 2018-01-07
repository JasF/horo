//
//  horoscopedto.c
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "horoscopedto.h"

namespace horo {
  
    void _HoroscopeDTO::encode(Json::Value &coder) {
        coder["type"] = type_;
        coder["content"] = content_;
        coder["date"] = (Json::UInt64) date_;
        coder["zodiac"] = zodiac_;
    }
    
    void _HoroscopeDTO::decode(Json::Value &coder) {
        type_ = (HoroscopeType) coder["type"].asInt();
        content_= coder["content"].asString();
        date_ = coder["date"].asUInt64();
        zodiac_ = (ZodiacTypes) coder["zodiac"].asInt();
    }
    
    std::string _HoroscopeDTO::content() const {
        return content_;
    }
    
};
