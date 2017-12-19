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
    
}
    
AccountScreenViewModelImpl::~AccountScreenViewModelImpl() {
    
}
    
void AccountScreenViewModelImpl::menuTapped() {
    screensManager_->showMenuViewController(true);
}

};
