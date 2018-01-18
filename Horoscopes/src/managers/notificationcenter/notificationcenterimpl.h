//
//  notificationcenterimpl.h
//  Horoscopes
//
//  Created by Jasf on 18.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef notificationcenterimpl_h
#define notificationcenterimpl_h

#include "managers/notificationcenter/notificationcenter.h"

namespace horo {
    
    class NotificationCenterImpl : public NotificationCenter {
    public:
        static void setPrivateInstance(NotificationCenter *privateInstance);
        
    public:
        void addWillResignActiveCallback(void *pointer, function<void()> callback) override;
        void addDidEnterBackgroundCallback(void *pointer, function<void()> callback) override;
        void addWillEnterForegroundCallback(void *pointer, function<void()> callback) override;
        
    public:
        NotificationCenterImpl();
        ~NotificationCenterImpl() override;
        
    private:
        map<void *, function<void()>> willResignActiveCallbacks_;
        map<void *, function<void()>> didEnterBackgroundCallbacks_;
        map<void *, function<void()>> willEnterForegroundsCallbacks_;
    };
    
};


#endif /* notificationcenterimpl_h */
