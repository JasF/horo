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
    
public:
    void initialize() override;
};
    
}

#endif /* notificationsimpl_h */
