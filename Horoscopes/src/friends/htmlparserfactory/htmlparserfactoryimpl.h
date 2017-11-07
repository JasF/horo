//
//  htmlparserfactoryimpl.h
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef htmlparserfactoryimpl_h
#define htmlparserfactoryimpl_h

#include "htmlparserfactory.h"

namespace horo {
    class HtmlParserFactoryImpl : public HtmlParserFactory {
    public:
        HtmlParserFactoryImpl() {}
        ~HtmlParserFactoryImpl() override {}
        strong<HtmlParser> createFacebookHomePageParser(std::string text) override;
        strong<HtmlParser> createFacebookUserInformationParser(std::string text) override;
        strong<HtmlParser> createFacebookFriendsParser(std::string text) override;
        strong<HtmlParser> createFacebookFriendInformationParser(std::string text) override;
        strong<HtmlParser> createFacebookUserDetailParser(std::string text) override;
    };
}

#endif /* htmlparserfactoryimpl_h */
