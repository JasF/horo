//
//  birthdaydetectorimpl.h
//  Horoscopes
//
//  Created by Jasf on 12.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef birthdaydetectorimpl_h
#define birthdaydetectorimpl_h

#include "birthdaydetector.h"

namespace horo {
    class BirthdayDetectorImpl : public BirthdayDetector {
    public:
        BirthdayDetectorImpl();
        ~BirthdayDetectorImpl() override {}
        list<string> isLocalizedBirthdayString(std::string birthdayString) override;
        DateWrapper timestampForDateString(string dateString, list<string> languageCodes) override;
        
    private:
        Json::Value locdates_;
        Json::Value birthdayslocstr_;
    };
};

#endif /* birthdaydetectorimpl_h */
