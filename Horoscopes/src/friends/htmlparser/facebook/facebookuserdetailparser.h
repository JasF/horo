//
//  facebookuserdetailparser.h
//  Horoscopes
//
//  Created by Jasf on 07.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef facebookuserdetailparser_h
#define facebookuserdetailparser_h


#include "friends/htmlparser/htmlparser.h"
#include "thirdparty/gumbo/gumbo.h"
#include <set>

namespace horo {
    using namespace std;
    class FacebookUserDetailParser : public HtmlParser {
    public:
        FacebookUserDetailParser(std::string text) : text_(text) {}
        ~FacebookUserDetailParser() override {}
        
        
        string birthdayDateDetectorString();
        
    public:
        Json::Value parse() override;
        
    private:
        void iterate(const GumboNode* root);
        
    private:
        std::string text_;
        Json::Value results_;
        Json::Value parameters_;
        set<string> hrefs_;
        list<string> textsList_;
    };
};

#endif /* facebookuserdetailparser_h */
