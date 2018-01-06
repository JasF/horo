//
//  horoscopesparserimpl.c
//  Horoscopes
//
//  Created by Jasf on 31.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "horoscopesparserimpl.h"

namespace horo {
    using namespace std;
    template <typename T>
    void assign(Json::Value &to, Json::Value &from, T what) {
        to[what] = from[what];
    }

    enum DateParts {
        DatePartDay,
        DatePartMonth,
        DatePartYear,
        DatePartsCount
    };
    static int const kMaximumDaysCount = 31;
    static int const kMaximumMonthCount = 12;
    
    
    int64_t dateStringToDate(std::string dateString) {
        vector<string> parts = separateString(dateString, '.');
        SCAssert(parts.size() == DatePartsCount, "date error");
        if (parts.size() != DatePartsCount) {
            return 0;
        }
        
        int day = std::stoi(parts[DatePartDay]);
        int month = std::stoi(parts[DatePartMonth]);
        int year = std::stoi(parts[DatePartYear]);
        SCAssert(day <= kMaximumDaysCount, "days error");
        if (day > kMaximumDaysCount) {
            return 0;
        }
        SCAssert(month <= kMaximumMonthCount, "month error");
        if (month > kMaximumMonthCount) {
            return 0;
        }
        
        using namespace std::chrono;
        
        tm horoscopeTimeTm = {
            0,
            0,
            0,
            day,
            month - 1,
            year - 1900,
            0,
            0,
            0,
            0,
            nullptr
        };
        
        time_t horoscopeTime = timegm(&horoscopeTimeTm);
        auto unix_timestamp = std::chrono::seconds(horoscopeTime);
        long long nTimestemp = std::chrono::seconds(unix_timestamp).count();
        
        return nTimestemp;
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
            string dateString = object["date"].asString();
            int64_t date = dateStringToDate(dateString);
            mapped["date"] = date;
            mapped["type"] = types[object["type"].asString()].asInt();
            
            horoscope->decode(mapped);
            horoscope->AddRef();
            pointers[object["type"].asString()] = (Json::UInt64) horoscope;
            horoscopes.push_back(horoscope);
            
            
            LOG(LS_WARNING) << "date: " << date;
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

