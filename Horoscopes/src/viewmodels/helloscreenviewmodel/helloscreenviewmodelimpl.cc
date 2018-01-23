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
        model_->personGatheredCallback_ = [this](bool success) {
            if (userLoggedInCallback_) {
                userLoggedInCallback_(success);
            }
            if (success) {
                screensManager_->showPredictionViewController();
            }
        };
    }
    
    HelloScreenViewModelImpl::~HelloScreenViewModelImpl() {
        
    }
    
    void HelloScreenViewModelImpl::continueTapped(DateWrapper date) {
        model_->createPersonWithBirthdayDate(date);
    }
    
    void HelloScreenViewModelImpl::loggedInOverFacebook() {
        model_->loginOnFacebook();
    }
    
    void HelloScreenViewModelImpl::setUserLoggedInCallback(std::function<void(bool success)> a) {
        userLoggedInCallback_ = a;
    }
    
    string HelloScreenViewModelImpl::zodiacNameWithDate(DateWrapper date) {
        strong<Zodiac> zodiac = new Zodiac(Zodiac::zodiacTypeByDate(date));
        return zodiac->name();
    }
    
};
