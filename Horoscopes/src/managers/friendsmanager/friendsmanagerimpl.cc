//
//  friendsmanagerimpl.c
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "friendsmanagerimpl.h"
#include "managers/friendsprovider/facebookfriendsprovider.h"

namespace horo {

void FriendsManagerImpl::loadFacebookFriends() {
    strong<FriendsProvider> friendsProvider = factory_->createFacebookFriendsProvider();
    SCAssert(friendsProvider.get(), "friendsProvider zero");
    if (!friendsProvider.get()) {
        return;
    }
    provider_ = friendsProvider;
    std::function<void(std::vector<FacebookFriend> friends, std::string url, FriendsProvider::RequestStatus status)> safeCompletion = [this](std::vector<FacebookFriend> friends, std::string url, FriendsProvider::RequestStatus status) {
        LOG(LS_WARNING) << "status is: " << status;
        if (status == FriendsProvider::AuthorizationRequired) {
            if (this->authorizationUrlCallback_) {
                std::vector<std::string> vec;
                this->authorizationUrlCallback_(url, vec);
            }
            return;
        }
    };
    provider_->requestFriendsList(safeCompletion);
}

};
