//
//  facebookfriendinformationparser.h
//  Horoscopes
//
//  Created by Jasf on 07.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef facebookfriendinformationparser_h
#define facebookfriendinformationparser_h


#include "friends/htmlparser/htmlparser.h"
#include "thirdparty/gumbo/gumbo.h"
#include <set>

namespace horo {
    using namespace std;
    class FacebookFriendInformationParser : public HtmlParser {
    public:
        FacebookFriendInformationParser(std::string text) : text_(text) {}
        ~FacebookFriendInformationParser() override {}
        
    public:
        Json::Value parse() override;
        
    private:
        void iterate(const GumboNode* root);
        
    private:
        std::string text_;
        Json::Value results_;
        Json::Value parameters_;
        set<string> hrefs_;
    };
};

#endif /* facebookfriendinformationparser_h */
