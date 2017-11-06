//
//  htmlparserfactory.h
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef htmlparserfactory_h
#define htmlparserfactory_h

#include "base/horobase.h"
#include "friends/htmlparser/htmlparser.h"

namespace horo {
    class _HtmlParserFactory {
    public:
        virtual ~_HtmlParserFactory() {}
        virtual strong<HtmlParser> createFacebookHomePageParser(std::string text)=0;
        virtual strong<HtmlParser> createFacebookUserInformationParser(std::string text)=0;
        virtual strong<HtmlParser> createFacebookFriendsParser(std::string text)=0;
    };
    
    typedef reff<_HtmlParserFactory> HtmlParserFactory;
};

#endif /* htmlparserfactory_h */
