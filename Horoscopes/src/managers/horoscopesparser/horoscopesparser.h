//
//  horoscopesparser.h
//  Horoscopes
//
//  Created by Jasf on 31.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef horoscopesparser_h
#define horoscopesparser_h

#include "base/horobase.h"
#include "horoscopesservice.h"

namespace horo {
    class _HoroscopesParser {
    public:
        virtual ~_HoroscopesParser(){}
    public:
        virtual void parse(Json::Value data, HoroscopesServiceCallback parsedData) = 0;
    };
    typedef reff<_HoroscopesParser> HoroscopesParser;
};

#endif /* horoscopesparser_h */
