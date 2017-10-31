//
//  horoscopesserviceimpl.c
//  Horoscopes
//
//  Created by Jasf on 31.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "horoscopesserviceimpl.h"

namespace horo {

    void HoroscopesServiceImpl::fetchHoroscopes(HoroscopesServiceCallback callback) {
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
            parser_->parse(data, [this, callback](HoroscopeDTO *yesterday,
                                    HoroscopeDTO *today,
                                    HoroscopeDTO *tomorrow,
                                    HoroscopeDTO *week,
                                    HoroscopeDTO *month,
                                    HoroscopeDTO *year){
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
            LOG(LS_WARNING) << "received data: " << data.toStyledString();
        });
    }
};
