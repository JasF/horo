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
        friendsManager_->friendsUpdatedCallback_ = [this](set<strong<Person>> friends){
            this->loadFriends(friends);
            if (this->friendsUpdatedCallback_) {
                this->friendsUpdatedCallback_(friends);
            }
        };
        loadFriends(friendsManager_->readFacebookFriendsFromDatabase());
    }
    
    FriendsScreenModelImpl::~FriendsScreenModelImpl() {
        
    }
    
    void FriendsScreenModelImpl::updateFriendsFromFacebook() {
        friendsManager_->loadFacebookFriends();
    }
    
    bool FriendsScreenModelImpl::webViewDidLoad(std::string url) {
        return friendsManager_->webViewDidLoad(url);
    }
    
    int FriendsScreenModelImpl::friendsCount() {
        return(int)friendsList_.size();
    }
    
    void FriendsScreenModelImpl::friendDataAtIndex(int index, std::function<void(string name, string birthday)> callback) {
        SCAssert(index < friendsCount(), "index out of bounds");
        if (index >= friendsCount()) {
            if (callback) {
                callback("", "");
            }
            return;
        }
        
        list<strong<Person>>::iterator it = friendsList_.begin();
        advance(it, index);
        strong<Person> person = *it;
        if (!person.get()) {
            if (callback) {
                callback("", "");
            }
            return;
        }
        Json::Value data = person->encoded();
        if (callback) {
            callback(person->name(), person->birthdayDate().toString());
        }
    }
    
    void FriendsScreenModelImpl::loadFriends(set<strong<Person>> friends) {
        friendsList_.clear();
        for(auto& ptr: friends){
            friendsList_.push_back(ptr);
        }
    }
};
