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
    , settings_(settings)
    , screensManager_(screensManager) {
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
    
    void FriendsScreenModelImpl::cancelOperation(enum CancelTypes type) {
        friendsManager_->cancelLoading();
        if (type == CancelFriendBirthdayLoad && currentPerson_.get()) {
            currentPerson_->setUpdating(false);
            if (serialRequestAlertViewControllerCallback_) {
                serialRequestAlertViewControllerCallback_(currentPerson_, true);
            }
            currentPerson_ = nullptr;
        }
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
    
    void FriendsScreenModelImpl::showPersonViewController(strong<Person> person) {
        screensManager_->showPredictionViewController(person, true);
    }
    
    void FriendsScreenModelImpl::personSelected(strong<Person> person) {
        SCParameterAssert(person.get());
        if (!person.get()) {
            return;
        }
        if (person->status() == StatusCompleted) {
            showPersonViewController(person);
        }
        else if (person->status() == StatusReadyForRequest) {
            if (currentPerson_.get() && currentPerson_ != person) {
                handleSerialRequestForPerson(currentPerson_);
                return;
            }
            currentPerson_ = person;
            person->setUpdating(true);
            if (personStateChangedCallback_) {
                personStateChangedCallback_(person);
            }
            friendsManager_->updateUserInformationForPerson(person, [this, person](bool success){
                person->setUpdating(false);
                if (this->personStateChangedCallback_) {
                    this->personStateChangedCallback_(person);
                }
                if (success) {
                    showPersonViewController(person);
                }
                else {
                    LOG(LS_ERROR) << "Show error message about unknown birthday date";
                }
                if (this->currentPerson_ == person) {
                    this->currentPerson_ = nullptr;
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
    
    void FriendsScreenModelImpl::handleSerialRequestForPerson(strong<Person> person) {
        if (serialRequestAlertViewControllerCallback_) {
            serialRequestAlertViewControllerCallback_(person, false);
        }
    }
};
