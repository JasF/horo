//
//  notificationsimpl.h
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef notificationsimpl_h
#define notificationsimpl_h

#include "managers/notifications/notifications.h"

namespace horo {
    
class NotificationsImpl : public Notifications {
public:
    static void setPrivateInstance(Notifications *instance);
public:
    NotificationsImpl();
    ~NotificationsImpl() override;
    void initialize() override;
    void openSettings() override;
    bool isRegisteredForRemoteNotifications() override;
    string deviceToken() override;
    // for AppDelegate
    void didReceiveRemoteNotification(Json::Value userInfo) override;
    void didRegisterForRemoteNotificationsWithDeviceToken(string token) override;
    void didFailToRegisterForRemoteNotificationsWithError(error err) override;
};
    
}

#endif /* notificationsimpl_h */