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

NotificationsImpl::NotificationsImpl(strong<CoreComponents> components,
                                     strong<Settings> settings,
                                     strong<Serializer> serializer,
                                     strong<NotificationCenter> notificationCenter,
                                     strong<ScreensManager> screensManager) :
    components_(components),
    settings_(settings),
    serializer_(serializer),
    notificationCenter_(notificationCenter),
    screensManager_(screensManager) {
    SCParameterAssert(components_.get());
    SCParameterAssert(settings_.get());
    SCParameterAssert(serializer_.get());
    SCParameterAssert(notificationCenter_.get());
    SCParameterAssert(screensManager_.get());
    SCParameterAssert(privateInstance);
    notificationCenter_->addDidEnterBackgroundCallback(this, [this]{
        sendSettingsIfNeeded();
    });
    notificationCenter_->addWillEnterForegroundCallback(this, []{
        privateInstance->cleanBadgeNumber();
    });
    privateInstance->cleanBadgeNumber();
}

NotificationsImpl::~NotificationsImpl() {
    
}
    
void NotificationsImpl::initialize() {
    SCParameterAssert(privateInstance);
    privateInstance->initialize();
}

void NotificationsImpl::openSettings() {
    SCParameterAssert(privateInstance);
    privateInstance->openSettings();
}

bool NotificationsImpl::isRegisteredForRemoteNotifications() {
    SCParameterAssert(privateInstance);
    return privateInstance->isRegisteredForRemoteNotifications();
    return false;
}

string NotificationsImpl::deviceToken() {
    return privateInstance->deviceToken();
}

void NotificationsImpl::didReceiveRemoteNotification(Json::Value userInfo) {
    SCParameterAssert(privateInstance);
    privateInstance->didReceiveRemoteNotification(userInfo);
}

void NotificationsImpl::didRegisterForRemoteNotificationsWithDeviceToken(string token) {
    SCParameterAssert(privateInstance);
    privateInstance->didRegisterForRemoteNotificationsWithDeviceToken(token);
    sendSettingsIfNeeded();
}

void NotificationsImpl::didFailToRegisterForRemoteNotificationsWithError(error err) {
    SCParameterAssert(privateInstance);
    privateInstance->didFailToRegisterForRemoteNotificationsWithError(err);
    sendSettingsIfNeeded();
}

void NotificationsImpl::sendSettingsIfNeeded() {
    string checkingString = generatePushSettingsString();
    string sended = serializer_->loadString("sendedPushSettings");
    if (checkingString == sended) {
        return;
    }
    serializer_->saveString("sendedPushSettings", checkingString);
    sendSettings();
}

void NotificationsImpl::sendSettingsForZodiacName(string zodiacName) {
    privateInstance->sendSettingsForZodiacName(zodiacName);
}

bool NotificationsImpl::notificationsDisabled() {
    return (settings_->notificationsDisabled() || !isRegisteredForRemoteNotifications());
}

void NotificationsImpl::setNotificationsDisabled(bool disabled) {
    settings_->setNotificationsDisabled(disabled);
    if (!disabled) {
        if (!isRegisteredForRemoteNotifications()) {
            openSettings();
        }
    }
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
    return privateInstance->setPushTime(aPushTime);
}

string NotificationsImpl::generatePushSettingsString() {
    SCParameterAssert(components_->person_.get());
    SCParameterAssert(components_->person_->zodiac().get());
    ZodiacTypes type = components_->person_->zodiac()->type();
    SCParameterAssert(type != Unknown);
    Json::Value value;
    value["type"]=type;
    value["time"]=pushTime();
    value["disabled"]=settings_->notificationsDisabled();
    string result = value.toStyledString();
    return result;
}

void NotificationsImpl::cleanBadgeNumber() {
    privateInstance->cleanBadgeNumber();
}

void NotificationsImpl::handleReceivedRemoteNotification(dictionary userInfo) {
    dictionary aps = userInfo["aps"];
    string zodiacName = aps["zodiacName"].asString();
    strong<Zodiac> zodiac = Zodiac::zodiacWithName(zodiacName);
    SCAssert(zodiac.get(), "Cannot allocate zodiac with zodiacName: %s", zodiacName.c_str());
    if (!zodiac.get()) {
        return;
    }
    screensManager_->showPredictionViewController(zodiac);
}

};
