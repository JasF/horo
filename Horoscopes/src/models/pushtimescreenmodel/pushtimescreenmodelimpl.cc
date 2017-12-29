//
//  pushtimescreenmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 27.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "pushtimescreenmodelimpl.h"

namespace horo {
  
PushTimeScreenModelImpl::PushTimeScreenModelImpl(strong<Notifications> notifications) : notifications_(notifications) {
    SCParameterAssert(notifications_.get());
}

PushTimeScreenModelImpl::~PushTimeScreenModelImpl() {
    
}

int PushTimeScreenModelImpl::pushTime() {
    return notifications_->pushTime();
}

void PushTimeScreenModelImpl::setPushTime(int aPushTime) {
    notifications_->setPushTime(aPushTime);
}

void PushTimeScreenModelImpl::sendSettingsIfNeeded() {
    notifications_->sendSettingsIfNeeded();
}

};
