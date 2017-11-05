//
//  friendsprovider.h
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef friendsprovider_h
#define friendsprovider_h

#include "base/horobase.h"

namespace horo {
    class GenericFriend {
    public:
        std::string name_;
    };
    
    
    class _FriendsProvider {
    public:
        enum RequestStatus {
            Unknown,
            OK,
            AuthorizationRequired,
        };
        virtual ~_FriendsProvider(){}
    public:
        virtual void requestFriendsList(std::function<void(std::vector<GenericFriend> friends, std::string nextUrl, RequestStatus status)> completion)=0;
        virtual bool webViewDidLoad(std::string url)=0;
    private:
        std::function<void(std::string url, std::vector<std::string> allowedPatterns)> authorizationUrlCallback_;
        
    };
    typedef reff<_FriendsProvider> FriendsProvider;
};

#endif /* friendsprovider_h */
