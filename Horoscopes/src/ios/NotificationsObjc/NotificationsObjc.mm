//
//  NotificationsObjc.m
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "NotificationsObjc.h"
#import "managers/notifications/notificationsimpl.h"

namespace horo {
    class NotificationsObjc : public Notifications {
    public:
        static NotificationsObjc *shared() {
            static NotificationsObjc *sharedInstance = nullptr;
            if (sharedInstance) {
                sharedInstance = new NotificationsObjc();
            }
            return sharedInstance;
        }
    public:
        NotificationsObjc() {}
        ~NotificationsObjc() override {}
    public:
        void initialize() override {
            
        }
    };
};

@implementation NotificationsObjc
+ (void)doLoading {
    horo::NotificationsImpl::setPrivateInstance(horo::NotificationsObjc::shared());
}
@end
