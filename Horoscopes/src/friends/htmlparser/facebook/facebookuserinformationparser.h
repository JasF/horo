//
//  facebookuserinformationparser.h
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef facebookuserinformationparser_h
#define facebookuserinformationparser_h

#include "friends/htmlparser/htmlparser.h"
#include "thirdparty/gumbo/gumbo.h"
#include <set>

namespace horo {
    using namespace std;
    class FacebookUserInformationParser : public HtmlParser {
    public:
        FacebookUserInformationParser(std::string text) : text_(text) {}
        ~FacebookUserInformationParser() override {}
        
    public:
        Json::Value parse() override;
        
    private:
        void iterate(const GumboNode* root);
        string friendsUrl();
        
    private:
        std::string text_;
        Json::Value results_;
        Json::Value parameters_;
        set<string> hrefs_;
    };
};

#endif /* facebookuserinformationparser_h */
