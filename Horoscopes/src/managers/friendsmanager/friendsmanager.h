//
//  friendsmanager.h
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef friendsmanager_h
#define friendsmanager_h

#include "base/horobase.h"
#include "data/person.h"

namespace horo {
    using namespace std;
    class _FriendsManager {
    public:
        virtual ~_FriendsManager(){}
    public:
        virtual void loadFacebookFriends()=0;
        virtual bool webViewDidLoad(std::string url)=0;
        virtual set<strong<Person>> readFacebookFriendsFromDatabase()=0;
        
    public:
        std::function<void(std::string url, std::vector<std::string> allowedPatterns)> authorizationUrlCallback_;
        std::function<void(set<strong<Person>> friends)> friendsUpdatedCallback_;
    };
    typedef reff<_FriendsManager> FriendsManager;
};

#endif /* friendsmanager_h */
