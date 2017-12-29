//
//  pushtimescreenviewmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 27.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "pushtimescreenviewmodelimpl.h"

namespace horo {
    
    PushTimeScreenViewModelImpl::PushTimeScreenViewModelImpl(strong<PushTimeScreenModel> model)
    : model_(model) {
        SCParameterAssert(model_.get());
    }
    
    PushTimeScreenViewModelImpl::~PushTimeScreenViewModelImpl() {
        
    }
    
    int PushTimeScreenViewModelImpl::pushTime() {
        return model_->pushTime();
    }
    
    void PushTimeScreenViewModelImpl::setPushTime(int pushTime) {
        model_->setPushTime(pushTime);
    }
    
    void PushTimeScreenViewModelImpl::sendSettingsIfNeeded() {
        model_->sendSettingsIfNeeded();
    }
    
};

