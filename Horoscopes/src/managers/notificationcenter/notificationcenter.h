//
//  notificationcenter.h
//  Horoscopes
//
//  Created by Jasf on 18.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef notificationcenter_h
#define notificationcenter_h

#include "base/horobase.h"

namespace horo {
    
    class NotificationCenterImpl;
    
    class _NotificationCenter {
        friend class NotificationCenterImpl;
    public:
        _NotificationCenter() {}
        virtual ~_NotificationCenter() {}
        
        virtual void addWillResignActiveCallback(void *pointer, function<void()> callback) {}
        virtual void addDidEnterBackgroundCallback(void *pointer, function<void()> callback) {}
        virtual void addWillEnterForegroundCallback(void *pointer, function<void()> callback) {}
        
        
    protected: // Internal
        virtual void subscribeForNotifications(function<void()> willResignActive, function<void()> didEnterBackground, function<void()> willEnterForeground) {}
    };
    
    typedef reff<_NotificationCenter> NotificationCenter;
    
};


#endif /* notificationcenter_h */
