//
//  notificationcenterimpl.c
//  Horoscopes
//
//  Created by Jasf on 18.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#include "notificationcenterimpl.h"

namespace horo {
    
    static NotificationCenter *g_privateInstance = nullptr;
    void NotificationCenterImpl::setPrivateInstance(NotificationCenter *privateInstance) {
        g_privateInstance = privateInstance;
    }
    
    NotificationCenterImpl::NotificationCenterImpl() {
        SCParameterAssert(g_privateInstance);
        auto willResignActive = [this]{
            for(auto it : willResignActiveCallbacks_) {
                it.second();
            }
        };
        
        auto didEnterBackground = [this]{
            for(auto it : didEnterBackgroundCallbacks_) {
                it.second();
            }
        };
        
        auto willEnterForeground = [this]{
            for(auto it : willEnterForegroundsCallbacks_) {
                it.second();
            }
        };
        
        g_privateInstance->subscribeForNotifications(willResignActive, didEnterBackground, willEnterForeground);
    }
    
    NotificationCenterImpl::~NotificationCenterImpl() {
        
    }
    
    void NotificationCenterImpl::addWillResignActiveCallback(void *pointer, function<void()> callback) {
        willResignActiveCallbacks_.insert( pair<void *, function<void()>>(pointer, callback) );
    }
    
    void NotificationCenterImpl::addDidEnterBackgroundCallback(void *pointer, function<void()> callback) {
        didEnterBackgroundCallbacks_.insert( pair<void *, function<void()>>(pointer, callback) );
    }
    
    void NotificationCenterImpl::addWillEnterForegroundCallback(void *pointer, function<void()> callback) {
        willEnterForegroundsCallbacks_.insert( pair<void *, function<void()>>(pointer, callback) );
    }
    
};

