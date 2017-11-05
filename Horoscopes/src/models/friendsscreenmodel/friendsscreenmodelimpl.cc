//
//  friendsscreenmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "friendsscreenmodelimpl.h"

namespace horo {
  
    FriendsScreenModelImpl::FriendsScreenModelImpl(strong<CoreComponents> components,
                                                   strong<FriendsManager> friendsManager,
                                               strong<Settings> settings)
    : components_(components)
    , friendsManager_(friendsManager)
    , settings_(settings) {
        SCParameterAssert(components_.get());
        SCParameterAssert(friendsManager_.get());
        SCParameterAssert(settings_.get());
        friendsManager_->authorizationUrlCallback_ = [this](std::string url, std::vector<std::string> allowedPatterns) {
            if (this->authorizationUrlCallback_) {
                this->authorizationUrlCallback_(url, allowedPatterns);
            }
        };
    }
    
    FriendsScreenModelImpl::~FriendsScreenModelImpl() {
        
    }
    
    void FriendsScreenModelImpl::updateFriendsFromFacebook() {
        friendsManager_->loadFacebookFriends();
    }
    
    bool FriendsScreenModelImpl::webViewDidLoad(std::string url) {
        return friendsManager_->webViewDidLoad(url);
    }
    
};
