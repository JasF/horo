//
//  NotificationCenterObjc.m
//  Horoscopes
//
//  Created by Jasf on 18.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "NotificationCenterObjc.h"
#include "managers/notificationcenter/notificationcenterimpl.h"

namespace horo {
  
    class NotificationCenterCC : public NotificationCenter {
public:
    static NotificationCenterCC *shared() {
        static NotificationCenterCC *sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new NotificationCenterCC();
        }
        return sharedInstance;
    }
    
private:
        NotificationCenterCC() :
        willResignActive_(nullptr),
        didEnterBackground_(nullptr),
        willEnterForeground_(nullptr) {}
    ~NotificationCenterCC() override {}
    
public: // override methods - NotificationCenter
    void subscribeForNotifications(function<void()> willResignActive, function<void()> didEnterBackground, function<void()> willEnterForeground) override {
        willResignActive_ = willResignActive;
        didEnterBackground_ = didEnterBackground;
        willEnterForeground_ = willEnterForeground;
    }
        
public:
    void callWillResignActive() {
        if (willResignActive_) {
            willResignActive_();
        }
    }
    
    void callDidEnterBackground() {
        if (didEnterBackground_) {
            didEnterBackground_();
        }
    }
        
    void callWillEnterForeground() {
        if (willEnterForeground_) {
            willEnterForeground_();
        }
    }
        
private:
    function<void()> willResignActive_;
    function<void()> didEnterBackground_;
    function<void()> willEnterForeground_;
};
    
};

using namespace horo;

@implementation NotificationCenterObjc {
    NotificationCenterCC *_notifications;
}

+ (instancetype)shared {
    static NotificationCenterObjc *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NotificationCenterObjc new];
    });
    return sharedInstance;
}

+ (void)doLoading {
    NotificationCenterImpl::setPrivateInstance(NotificationCenterCC::shared());
    [self shared];
}

#pragma mark - Initialization
- (id)init {
    if (self = [super init]) {
        _notifications = NotificationCenterCC::shared();
        NSCParameterAssert(_notifications);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Observers
- (void)applicationWillResignActive:(NSNotification *)notification {
    _notifications->callWillResignActive();
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    _notifications->callDidEnterBackground();
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    _notifications->callWillEnterForeground();
}

@end
