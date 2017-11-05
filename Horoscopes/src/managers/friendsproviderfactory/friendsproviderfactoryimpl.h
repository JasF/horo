//
//  friendsproviderfactoryimpl.h
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef friendsproviderfactoryimpl_h
#define friendsproviderfactoryimpl_h

#include "friendsproviderfactory.h"
#include "managers/networkingservice/networkingservicefactory.h"

namespace horo {
    class FriendsProviderFactoryImpl : public FriendsProviderFactory {
    public:
        FriendsProviderFactoryImpl(strong<NetworkingServiceFactory> factory)
        : factory_(factory)
        {
            SCParameterAssert(factory_.get());
        }
        ~FriendsProviderFactoryImpl() override {}
    public:
        strong<FriendsProvider> createFacebookFriendsProvider() override;
        
    private:
        strong<NetworkingServiceFactory> factory_;
    };
};

#endif /* friendsproviderfactoryimpl_h */
