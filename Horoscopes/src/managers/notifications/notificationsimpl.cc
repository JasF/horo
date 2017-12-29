//
//  notificationsimpl.c
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "notificationsimpl.h"
#include "base/platform.h"

namespace horo {
  
static Notifications *privateInstance = nullptr;
void NotificationsImpl::setPrivateInstance(Notifications *instance) {
    privateInstance = instance;
}

NotificationsImpl::NotificationsImpl(strong<CoreComponents> components, strong<Settings> settings) : components_(components),
    settings_(settings) {
    SCParameterAssert(components_.get());
    SCParameterAssert(settings_.get());
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

string NotificationsImpl::deviceToken() {
    if (privateInstance) {
        return privateInstance->deviceToken();
    }
    return "";
}

void NotificationsImpl::didReceiveRemoteNotification(Json::Value userInfo) {
    SCParameterAssert(privateInstance);
    if (privateInstance) {
        privateInstance->didReceiveRemoteNotification(userInfo);
    }
}

void NotificationsImpl::didRegisterForRemoteNotificationsWithDeviceToken(string token) {
    SCParameterAssert(privateInstance);
    if (privateInstance) {
        privateInstance->didRegisterForRemoteNotificationsWithDeviceToken(token);
    }
    sendSettingsIfNeeded();
}

void NotificationsImpl::didFailToRegisterForRemoteNotificationsWithError(error err) {
    SCParameterAssert(privateInstance);
    if (privateInstance) {
        privateInstance->didFailToRegisterForRemoteNotificationsWithError(err);
    }
    sendSettingsIfNeeded();
}

void NotificationsImpl::sendSettingsIfNeeded() {
    string checkingString = generatePushSettingsString();
    if (checkingString == sendedSettings_) {
        return;
    }
    sendedSettings_ = checkingString;
    sendSettings();
}

void NotificationsImpl::sendSettingsForZodiacName(string zodiacName) {
    if (privateInstance) {
        privateInstance->sendSettingsForZodiacName(zodiacName);
    }
}

bool NotificationsImpl::notificationsDisabled() {
    return settings_->notificationsDisabled();
}

void NotificationsImpl::sendSettings() {
    SCParameterAssert(components_->person_.get());
    SCParameterAssert(components_->person_->zodiac().get());
    string zodiacName = toLowerCase(components_->person_->zodiac()->name());
    SCParameterAssert(zodiacName.length());
    sendSettingsForZodiacName(zodiacName);
}

int NotificationsImpl::pushTime() {
    SCParameterAssert(privateInstance);
    if (privateInstance) {
        return privateInstance->pushTime();
    }
    return 0;
}

void NotificationsImpl::setPushTime(int aPushTime) {
    SCParameterAssert(privateInstance);
    if (privateInstance) {
        return privateInstance->setPushTime(aPushTime);
    }
}

string NotificationsImpl::generatePushSettingsString() {
    SCParameterAssert(components_->person_.get());
    SCParameterAssert(components_->person_->zodiac().get());
    ZodiacTypes type = components_->person_->zodiac()->type();
    SCParameterAssert(type != Unknown);
    Json::Value value;
    value["type"]=type;
    value["time"]=pushTime();
    string result = value.toStyledString();
    return result;
}

};
