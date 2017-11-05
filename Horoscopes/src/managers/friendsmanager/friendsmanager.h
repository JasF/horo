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

namespace horo {
    class _FriendsManager {
    public:
        virtual ~_FriendsManager(){}
    public:
        virtual void loadFacebookFriends()=0;
        
    public:
        std::function<void(std::string url, std::vector<std::string> allowedPatterns)> authorizationUrlCallback_;
    };
    typedef reff<_FriendsManager> FriendsManager;
};

#endif /* friendsmanager_h */
