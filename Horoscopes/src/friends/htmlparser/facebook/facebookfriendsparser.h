//
//  facebookfriendsparser.h
//  Horoscopes
//
//  Created by Jasf on 06.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef facebookfriendsparser_h
#define facebookfriendsparser_h

#include "friends/htmlparser/htmlparser.h"
#include "thirdparty/gumbo/gumbo.h"
#include <set>

namespace horo {
    using namespace std;
    class FacebookFriendsParser : public HtmlParser {
    public:
        FacebookFriendsParser(std::string text) : text_(text) {}
        ~FacebookFriendsParser() override {}
        
    public:
        Json::Value parse() override;
        
    private:
        void iterate(const GumboNode* root);
        set<string> friendsUrls();
        void processATag(const GumboNode *root, GumboAttribute* cls_attr);
        void cleanLatestPerson();
        
    private:
        std::string text_;
        Json::Value results_;
        Json::Value parameters_;
        Json::Value persons_;
        Json::Value latestPerson_;
        bool latestPersonIsClean_;
        string imageUrl_;
    };
};

#endif /* facebookfriendsparser_h */
