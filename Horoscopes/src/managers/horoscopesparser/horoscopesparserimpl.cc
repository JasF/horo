//
//  horoscopesparserimpl.c
//  Horoscopes
//
//  Created by Jasf on 31.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "horoscopesparserimpl.h"

namespace horo {
    template <typename T>
    void assign(Json::Value &to, Json::Value &from, T what) {
        to[what] = from[what];
    }

    uint64_t dateStringToDate(std::string dateString) {
        
        return 0;
    }
    
    void HoroscopesParserImpl::parse(Json::Value data, HoroscopesServiceCallback parsedData) {
        Json::Value array = data["result"];
        if (!array.isArray()) {
            if (parsedData) {
                parsedData(nullptr, nullptr, nullptr, nullptr, nullptr, nullptr);
            }
            return;
        }
        
        ZodiacTypes zodiac =(ZodiacTypes)data["zodiac"].asInt();
        
        
        Json::Value pointers;
        
        Json::Value types;
        types["yesterday"] = HoroscopeDay;
        types["today"] = HoroscopeDay;
        types["tomorrow"] = HoroscopeDay;
        types["week"] = HoroscopeWeek;
        types["month"] = HoroscopeMonth;
        types["year"] = HoroscopeYear;
        
        std::vector<HoroscopeDTO *> horoscopes;
        for (Json::Value object:array) {
            HoroscopeDTO *horoscope = new HoroscopeDTO();
            
            Json::Value mapped;
            mapped["content"] = object["content"];
            mapped["zodiac"] = zodiac;
            mapped["date"] = dateStringToDate(object["date"].asString());
            mapped["type"] = types[object["type"].asString()].asInt();
            
            horoscope->decode(mapped);
            horoscope->AddRef();
            pointers[horoscope->type()] = (Json::UInt64) horoscope;
            horoscopes.push_back(horoscope);
        }
        
        strong<HoroscopeDTO> yesterday = (HoroscopeDTO *)pointers["yesterday"].asUInt64();
        strong<HoroscopeDTO> today = (HoroscopeDTO *)pointers["today"].asUInt64();
        strong<HoroscopeDTO> tomorrow = (HoroscopeDTO *)pointers["tomorrow"].asUInt64();
        strong<HoroscopeDTO> week = (HoroscopeDTO *)pointers["week"].asUInt64();
        strong<HoroscopeDTO> month = (HoroscopeDTO *)pointers["month"].asUInt64();
        strong<HoroscopeDTO> year = (HoroscopeDTO *)pointers["year"].asUInt64();
        
        for (auto horo:horoscopes) {
            horo->Release();
        }
        
        if (parsedData) {
            parsedData(yesterday, today, tomorrow, week, month, year);
        }
    }
    
};

