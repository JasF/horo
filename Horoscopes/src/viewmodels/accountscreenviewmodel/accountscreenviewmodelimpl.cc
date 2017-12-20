//
//  accountscreenviewmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 19.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "accountscreenviewmodelimpl.h"

namespace horo {
  
AccountScreenViewModelImpl::AccountScreenViewModelImpl(strong<AccountScreenModel> model, strong<ScreensManager> screensManager)
    : model_(model),
      screensManager_(screensManager) {
    SCParameterAssert(model_.get());
    SCParameterAssert(screensManager_.get());
      model_->personGatheredCallback_ = [this](bool success) {
          if (personGatheredCallback_) {
              personGatheredCallback_(success);
          }
      };
}
    
AccountScreenViewModelImpl::~AccountScreenViewModelImpl() {
    
}
    
void AccountScreenViewModelImpl::menuTapped() {
    screensManager_->showMenuViewController(true);
}

void AccountScreenViewModelImpl::loggedInOnFacebook() {
    model_->loggedInOnFacebook();
}

void AccountScreenViewModelImpl::personRepresentation(function<void(std::string imageUrl, std::string name, horo::DateWrapper birthday)> callback) {
    model_->personRepresentation(callback);
}

void AccountScreenViewModelImpl::userLoggedOut() {
    model_->userLoggedOut();
}

void AccountScreenViewModelImpl::birthdayDateChanged(DateWrapper wrapper) {
    model_->birthdayDateChanged(wrapper);
}

};
