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
                                                       strong<ScreensManager> screensManager)
    : model_(model),
    screensManager_(screensManager) {
        SCParameterAssert(model_.get());
        SCParameterAssert(screensManager_.get());
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
    }
    
    FriendsScreenViewModelImpl::~FriendsScreenViewModelImpl() {
        
    }
    
    void FriendsScreenViewModelImpl::updateFriendsFromFacebook() {
        model_->updateFriendsFromFacebook();
    }
    
    bool FriendsScreenViewModelImpl::webViewDidLoad(std::string url) {
        return model_->webViewDidLoad(url);
    }
    
    int FriendsScreenViewModelImpl::friendsCount() {
        return model_->friendsCount();
    }
    
    void FriendsScreenViewModelImpl::friendDataAtIndex(int index, std::function<void(string name, string birthday)> callback) {
        model_->friendDataAtIndex(index, callback);
    }
};
