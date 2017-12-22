//
//  birthdaydetector.h
//  Horoscopes
//
//  Created by Jasf on 12.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef birthdaydetector_h
#define birthdaydetector_h

#include "base/horobase.h"
#include "data/datewrapper.h"

namespace horo {
    class _BirthdayDetector {
    public:
        virtual ~_BirthdayDetector(){}
        virtual list<string> isLocalizedBirthdayString(std::string birthdayString) = 0;
        virtual DateWrapper timestampForDateString(string dateString, list<string> languageCodes) = 0;
    };
    typedef reff<_BirthdayDetector> BirthdayDetector;
};

#endif /* birthdaydetector_h */
