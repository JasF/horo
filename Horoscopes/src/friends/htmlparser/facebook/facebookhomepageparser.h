//
//  facebookhomepageparser.h
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef facebookhomepageparser_h
#define facebookhomepageparser_h

#include "friends/htmlparser/htmlparser.h"
#include "thirdparty/gumbo/gumbo.h"
#include <set>

namespace horo {
    using namespace std;
    class FacebookHomePageParser : public HtmlParser {
    public:
        FacebookHomePageParser(std::string text) : text_(text) {}
        ~FacebookHomePageParser() override {}
        
    public:
        Json::Value parse() override;
        
    private:
        void iterate(const GumboNode* root);
        string userUrl();
        
    private:
        std::string text_;        
        Json::Value results_;
        Json::Value parameters_;
        set<string> hrefs_;
    };
};

#endif /* facebookhomepageparser_h */
