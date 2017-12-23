//
//  notificationsscreenviewmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 23.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "notificationsscreenviewmodelimpl.h"

namespace horo {
  
NotificationsScreenViewModelImpl::NotificationsScreenViewModelImpl(strong<NotificationsScreenModel> model, strong<ScreensManager> screensManager)
    : model_(model)
    , screensManager_(screensManager) {
        SCParameterAssert(model_.get());
        SCParameterAssert(screensManager_.get());
}

NotificationsScreenViewModelImpl::~NotificationsScreenViewModelImpl() {
    
}
    
void NotificationsScreenViewModelImpl::menuTapped() {
    screensManager_->showMenuViewController(true);
}

};
