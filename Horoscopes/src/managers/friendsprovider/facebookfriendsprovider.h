//
//  facebookfriendsprovider.h
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef facebookfriendsprovider_h
#define facebookfriendsprovider_h

#include "friendsprovider.h"
#include "managers/networkingservice/networkingservicefactory.h"

namespace horo {
    class FacebookFriendsProvider : public FriendsProvider {
    public:
        FacebookFriendsProvider(strong<NetworkingServiceFactory> factory)
        : factory_(factory)
        {
            SCParameterAssert(factory_.get());
        }
        ~FacebookFriendsProvider() override {}
    public:
        void requestFriendsList(std::function<void(std::vector<FacebookFriend> friends, std::string nextUrl, RequestStatus status)> completion) override;
        
    private:
        strong<NetworkingServiceFactory> factory_;
    };
};

#endif /* facebookfriendsprovider_h */
