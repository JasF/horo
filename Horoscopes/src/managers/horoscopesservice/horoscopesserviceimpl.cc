//
//  horoscopesserviceimpl.c
//  Horoscopes
//
//  Created by Jasf on 31.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "horoscopesserviceimpl.h"

namespace horo {

    bool isOffline() {
        return false;
    }
    
    void HoroscopesServiceImpl::fetchHoroscopes(HoroscopesServiceCallback callback) {
        if (isOffline()) {
            offlineFetchHoroscopes(callback);
            return;
        }
        strong<CollectionReference> collectionReference = firestore_->collectionWithPath("horoscopes");
        SCParameterAssert(collectionReference.get());
        if (!collectionReference.get()) {
            if (callback) {
                callback(nullptr, nullptr, nullptr, nullptr, nullptr, nullptr);
            }
            return;
        }
        strong<DocumentReference> documentReference = collectionReference->documentWithPath("capricorn");
        SCParameterAssert(documentReference.get());
        if (!documentReference.get()) {
            if (callback) {
                callback(nullptr, nullptr, nullptr, nullptr, nullptr, nullptr);
            }
            return;
        }
        documentReference->getDocumentWithCompletion([this, callback](strong<DocumentSnapshot> snapshot, error err){
            Json::Value data = snapshot->data();
            parser_->parse(data, [this, callback](strong<HoroscopeDTO> yesterday,
                                    strong<HoroscopeDTO> today,
                                    strong<HoroscopeDTO> tomorrow,
                                    strong<HoroscopeDTO> week,
                                    strong<HoroscopeDTO> month,
                                    strong<HoroscopeDTO> year){
                if (!today) {
                    if (callback) {
                        callback(yesterday, today, tomorrow, week, month, year);
                    }
                    return;
                }
                horoscopeDAO_->writeHoroscope(yesterday);
                horoscopeDAO_->writeHoroscope(today);
                horoscopeDAO_->writeHoroscope(tomorrow);
                horoscopeDAO_->writeHoroscope(week);
                horoscopeDAO_->writeHoroscope(month);
                horoscopeDAO_->writeHoroscope(year);
                if (callback) {
                    callback(yesterday, today, tomorrow, week, month, year);
                }
            });
        });
    }
    
    void HoroscopesServiceImpl::offlineFetchHoroscopes(HoroscopesServiceCallback callback) {
        time_t timestempTime = timestempToTime(localtime());
        tm local_tm = *::localtime(&timestempTime);
        int wday = local_tm.tm_wday;
        if (wday) {
            wday = wday - 1;
        }
        else {
            wday = 6;
        }
        int mday = local_tm.tm_mday - 1;
        int yday = local_tm.tm_yday;
        local_tm.tm_sec = 0;
        local_tm.tm_min = 0;
        local_tm.tm_hour = 0;
        local_tm.tm_wday = 0;
        local_tm.tm_yday = 0;
        local_tm.tm_isdst = 0;
        local_tm.tm_gmtoff = 0;
        local_tm.tm_zone = nullptr;
        time_t datetime = timegm(&local_tm);
        long long timestemp = timeToTimestemp(datetime);
        int secondsInDay = 60 * 60 * 24;
        strong<HoroscopeDTO> yesterday = horoscopeDAO_->readHoroscope(timestemp - secondsInDay, HoroscopeDay);
        strong<HoroscopeDTO> today = horoscopeDAO_->readHoroscope(timestemp, HoroscopeDay);
        strong<HoroscopeDTO> tomorrow = horoscopeDAO_->readHoroscope(timestemp + secondsInDay, HoroscopeDay);
        strong<HoroscopeDTO> week = horoscopeDAO_->readHoroscope(timestemp - secondsInDay * wday, HoroscopeWeek);
        strong<HoroscopeDTO> month = horoscopeDAO_->readHoroscope(timestemp - secondsInDay * mday, HoroscopeMonth);
        strong<HoroscopeDTO> year = horoscopeDAO_->readHoroscope(timestemp - secondsInDay * yday, HoroscopeYear);
        
        if (callback) {
            callback(yesterday, today, tomorrow, week, month, year);
        }
    }
};
