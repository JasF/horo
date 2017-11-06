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
#include "managers/networkingservice/networkingservice.h"

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
        void requestFriendsList(std::function<void(std::vector<GenericFriend> friends, std::string nextUrl, RequestStatus status)> completion) override;
        bool webViewDidLoad(std::string url) override;
        
    private:
        void parseHomePage(Json::Value json);
        void executeHomePageRequest();
        
    private:
        strong<NetworkingServiceFactory> factory_;
        strong<NetworkingService> request_;
        std::function<void(std::vector<GenericFriend> friends,
                           std::string nextUrl,
                           RequestStatus status)> callback_;
    };
};

#endif /* facebookfriendsprovider_h */
