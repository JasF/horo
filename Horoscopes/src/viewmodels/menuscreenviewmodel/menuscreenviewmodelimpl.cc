//
//  menuscreenviewmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "menuscreenviewmodelimpl.h"

namespace horo {
  
    MenuScreenViewModelImpl::MenuScreenViewModelImpl(strong<MenuScreenModel> model,
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
    
    MenuScreenViewModelImpl::~MenuScreenViewModelImpl() {
        
    }
    
    void MenuScreenViewModelImpl::continueTapped(DateWrapper date) {
        
    }
    
    void MenuScreenViewModelImpl::loggedInOverFacebook() {
        model_->loginOnFacebook();
    }
    
    void MenuScreenViewModelImpl::zodiacsTapped() {
        screensManager_->showPredictionViewController();
    }
    
    void MenuScreenViewModelImpl::friendsTapped() {
        screensManager_->showFriendsViewController();
    }
    
    void MenuScreenViewModelImpl::accountTapped() {
        screensManager_->showAccountViewController();
    }
    
    void MenuScreenViewModelImpl::notificationsTapped() {
        screensManager_->showNotificationsViewController();
    }
    
    void MenuScreenViewModelImpl::feedbackTapped() {
        screensManager_->showFeedbackViewController();
    }
    
    void MenuScreenViewModelImpl::closeTapped() {
        screensManager_->showPredictionViewController();
    }
};
