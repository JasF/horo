//
//  friendsmanagerimpl.h
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef friendsmanagerimpl_h
#define friendsmanagerimpl_h

#include "friendsmanager.h"
#include "managers/friendsproviderfactory/friendsproviderfactory.h"

namespace horo {
    class FriendsManagerImpl : public FriendsManager {
    public:
        FriendsManagerImpl(strong<FriendsProviderFactory> factory)
        : factory_(factory)
        {
            SCParameterAssert(factory_.get());
        }
        ~FriendsManagerImpl() override {}
    public:
        void loadFacebookFriends() override;
        bool webViewDidLoad(std::string url) override;
    private:
        strong<FriendsProviderFactory> factory_;
        strong<FriendsProvider> provider_;
    };
};

#endif /* friendsmanagerimpl_h */
