//
//  pushtimescreenviewmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 27.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "pushtimescreenviewmodelimpl.h"

namespace horo {
    
    PushTimeScreenViewModelImpl::PushTimeScreenViewModelImpl(strong<PushTimeScreenModel> model, strong<ScreensManager> screensManager)
    : model_(model)
    , screensManager_(screensManager) {
        SCParameterAssert(model_.get());
        SCParameterAssert(screensManager_.get());
    }
    
    PushTimeScreenViewModelImpl::~PushTimeScreenViewModelImpl() {
        
    }
    
    void PushTimeScreenViewModelImpl::menuTapped() {
        screensManager_->showMenuViewController(true);
    }
    
    void PushTimeScreenViewModelImpl::pushTimeTapped() {
        screensManager_->showPushTimeViewController();
    }
    
};

