//
//  friendsproviderfactory.h
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef friendsproviderfactory_h
#define friendsproviderfactory_h

#include "base/horobase.h"
#include "managers/friendsprovider/friendsprovider.h"

namespace horo {
    class _FriendsProviderFactory {
    public:
        virtual ~_FriendsProviderFactory(){}
        virtual strong<FriendsProvider> createFacebookFriendsProvider()=0;
    };
    typedef reff<_FriendsProviderFactory> FriendsProviderFactory;
};


#endif /* friendsproviderfactory_h */
