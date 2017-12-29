//
//  notificationsscreenmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 23.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "notificationsscreenmodelimpl.h"

namespace horo {
  
NotificationsScreenModelImpl::NotificationsScreenModelImpl(strong<Notifications> notifications) : notifications_(notifications) {
    SCParameterAssert(notifications_);
}

NotificationsScreenModelImpl::~NotificationsScreenModelImpl() {
    
}
    
void NotificationsScreenModelImpl::sendSettingsIfNeeded() {
    notifications_->sendSettingsIfNeeded();
}

bool NotificationsScreenModelImpl::notificationsDisabled() {
    return notifications_->notificationsDisabled();
}

void NotificationsScreenModelImpl::setNotificationsDisabled(bool disabled) {
    notifications_->setNotificationsDisabled(disabled);
}
  
int NotificationsScreenModelImpl::pushTime() {
    return notifications_->pushTime();
}

};
