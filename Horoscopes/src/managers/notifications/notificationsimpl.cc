//
//  notificationsimpl.c
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "notificationsimpl.h"

namespace horo {
  
static Notifications *privateInstance = nullptr;
void NotificationsImpl::setPrivateInstance(Notifications *instance) {
    privateInstance = instance;
}

NotificationsImpl::NotificationsImpl() {
    
}

NotificationsImpl::~NotificationsImpl() {
    
}
    
void NotificationsImpl::initialize() {
    SCParameterAssert(privateInstance);
    if (privateInstance) {
        privateInstance->initialize();
    }
}

void NotificationsImpl::openSettings() {
    SCParameterAssert(privateInstance);
    if (privateInstance) {
        privateInstance->openSettings();
    }
}

bool NotificationsImpl::isRegisteredForRemoteNotifications() {
    SCParameterAssert(privateInstance);
    if (privateInstance) {
        privateInstance->isRegisteredForRemoteNotifications();
    }
    return false;
}

};
