//
//  friendsscreenviewmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "friendsscreenviewmodelimpl.h"

namespace horo {
  
    FriendsScreenViewModelImpl::FriendsScreenViewModelImpl(strong<FriendsScreenModel> model,
                                                           strong<ScreensManager> screensManager,
                                                           strong<ThemesManager> themesManager)
    : model_(model)
    , screensManager_(screensManager)
    , themesManager_(themesManager) {
        SCParameterAssert(model_.get());
        SCParameterAssert(screensManager_.get());
        SCParameterAssert(themesManager_.get());
        model->authorizationUrlCallback_ = [this](std::string url, std::vector<std::string> allowedPatterns) {
            if (this->authorizationUrlCallback_) {
                this->authorizationUrlCallback_(url, allowedPatterns);
            }
        };
        model->friendsUpdatedCallback_ = [this](set<strong<Person>> friends){
            if (this->friendsUpdatedCallback_) {
                this->friendsUpdatedCallback_(friends);
            }
        };
        model->personStateChangedCallback_ = [this](strong<Person> person) {
            if (this->personStateChangedCallback_) {
                this->personStateChangedCallback_(person);
            }
        };
        model->serialRequestAlertViewControllerCallback_ = [this](strong<Person> person, bool closeAlert) {
            if (this->serialRequestAlertViewControllerCallback_) {
                this->serialRequestAlertViewControllerCallback_(person, closeAlert);
            }
        };
        model->webViewControllerUICalback_ = [this]() {
            if (this->webViewControllerUICalback_) {
                return this->webViewControllerUICalback_();
            }
            return(void *)nullptr;
        };
    }
    
    FriendsScreenViewModelImpl::~FriendsScreenViewModelImpl() {
        
    }
    
    void FriendsScreenViewModelImpl::updateFriendsFromFacebook() {
        model_->updateFriendsFromFacebook();
    }
    
    void FriendsScreenViewModelImpl::cancelOperation(enum CancelTypes type) {
        model_->cancelOperation(type);
    }
    
    void FriendsScreenViewModelImpl::menuTapped() {
        screensManager_->showMenuViewController(true);
    }
    
    bool FriendsScreenViewModelImpl::webViewDidLoad(std::string url) {
        return model_->webViewDidLoad(url);
    }
    
    list<strong<Person>> FriendsScreenViewModelImpl::allFriends() {
        return model_->allFriends();
    }
    
    void FriendsScreenViewModelImpl::personSelected(strong<Person> person) {
        model_->personSelected(person);
    }
    
    bool FriendsScreenViewModelImpl::needsCancelSearchBeforeSegue() {
        return theme()->needsCancelSearchBeforeSegue();
    }
    
};
