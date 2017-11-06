//
//  htmlparser.h
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef htmlparser_h
#define htmlparser_h

#include "base/horobase.h"

namespace horo {
    class _HtmlParser {
    public:
        virtual ~_HtmlParser() {}
    public:
        virtual Json::Value parse() = 0;
    };
    
    typedef reff<_HtmlParser> HtmlParser;
};

#endif /* htmlparser_h */
