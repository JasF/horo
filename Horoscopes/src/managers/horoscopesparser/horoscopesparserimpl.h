//
//  horoscopesparserimpl.h
//  Horoscopes
//
//  Created by Jasf on 31.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef horoscopesparserimpl_h
#define horoscopesparserimpl_h

#include "horoscopesparser.h"

namespace horo {
    class HoroscopesParserImpl : public HoroscopesParser {
    public:
        HoroscopesParserImpl() {}
        ~HoroscopesParserImpl() override {}
    public:
        void parse(Json::Value data, HoroscopesServiceCallback parsedData) override;
    };
};

#endif /* horoscopesparserimpl_h */
