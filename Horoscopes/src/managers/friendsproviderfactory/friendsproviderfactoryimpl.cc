//
//  friendsproviderfactoryimpl.c
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "friendsproviderfactoryimpl.h"
#include "managers/friendsprovider/facebookfriendsprovider.h"

namespace horo {
  
strong<FriendsProvider> FriendsProviderFactoryImpl::createFacebookFriendsProvider() {
    return new FacebookFriendsProvider(factory_, parserFactory_, timerFactory_);
}

};
