//
//  helloscreenviewmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "helloscreenviewmodelimpl.h"

namespace horo {
  
    HelloScreenViewModelImpl::HelloScreenViewModelImpl(strong<HelloScreenModel> model,
                                                       strong<ScreensManager> screensManager)
    : model_(model),
    screensManager_(screensManager) {
        model_->personGatheredCallback_ = [this]() {
            if (userLoggedInCallback_) {
                userLoggedInCallback_();
            }
        };
    }
    
    HelloScreenViewModelImpl::~HelloScreenViewModelImpl() {
        
    }
    
    void HelloScreenViewModelImpl::continueTapped() {
        
    }
    
    void HelloScreenViewModelImpl::loggedInOverFacebook() {
        model_->loginOnFacebook();
    }
};
