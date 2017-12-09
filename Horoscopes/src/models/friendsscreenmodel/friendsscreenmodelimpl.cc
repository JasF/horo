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
                                               strong<Settings> settings,
                                                   strong<ScreensManager> screensManager)
    : components_(components)
    , friendsManager_(friendsManager)
    , settings_(settings),
    screensManager_(screensManager) {
        SCParameterAssert(components_.get());
        SCParameterAssert(friendsManager_.get());
        SCParameterAssert(settings_.get());
        SCParameterAssert(screensManager_.get());
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
    
    void FriendsScreenModelImpl::loadFriends(set<strong<Person>> friends) {
        friendsList_.clear();
        for(auto& ptr: friends){
            friendsList_.push_back(ptr);
        }
    }
    
    void FriendsScreenModelImpl::friendWithIndexSelected(int index) {
        SCAssert(index< friendsList_.size(), "index out of bounds");
        if (index >= friendsList_.size()) {
            return;
        }
        
        list<strong<Person>>::iterator it = friendsList_.begin();
        advance(it, index);
        strong<Person> person = *it;
        
        if (!person.get()) {
            return;
        }
        
        if (person->status() == StatusCompleted) {
            screensManager_->showPredictionViewController(person);
        }
        else if (person->status() == StatusReadyForRequest) {
            friendsManager_->updateUserInformationForPerson(person, [this, person](bool success){
                if (success) {
                    screensManager_->showPredictionViewController(person);
                }
                else {
                    LOG(LS_ERROR) << "Show error message about unknown birthday date";
                }
            });
        }
        else if (person->status() == StatusFailed) {
            LOG(LS_ERROR) << "Show error message about unknown birthday date";
        }
        else {
            SCAssert(person->status() == StatusReadyForRequest || person->status() == StatusCompleted, "unhandled failed selection of friend");
        }
    }
    
    list<strong<Person>> FriendsScreenModelImpl::allFriends() {
        list<strong<Person>> list = friendsList_;
        return list;
    }
};
