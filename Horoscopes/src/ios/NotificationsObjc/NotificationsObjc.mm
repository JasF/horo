//
//  NotificationsObjc.m
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "managers/notifications/notificationsimpl.h"
#import <UserNotifications/UserNotifications.h>
#import <libPusher/Pusher/Pusher.h>
#import "NotificationsObjc.h"
#import "base/platform.h"
#import "NSString+Horo.h"
#include "managers.h"

#ifdef CENSORED
#import "Horoscopes_censored-Swift.h"
#else
#import "Horoscopes-Swift.h"
#endif

@interface NotificationsObjc () <UNUserNotificationCenterDelegate>
@end

namespace horo {
    class NotificationsCC : public Notifications {
        friend class NotificationsImpl;
    public:
        static NotificationsCC *shared() {
            static NotificationsCC *sharedInstance = nullptr;
            if (!sharedInstance) {
                sharedInstance = new NotificationsCC(Managers::shared().settings());
            }
            return sharedInstance;
        }
    public:
        NotificationsCC(strong<Settings> settings) : pushNotificationsWrapper_([[PushNotificationsWrapper alloc] init]),
        settings_(settings) {
            NSCParameterAssert(pushNotificationsWrapper_);
            NSCParameterAssert(settings_);
            [pushNotificationsWrapper_ registerInstanceId];
        }
        ~NotificationsCC() override {}
    public:
        void initialize() override {
            if (@available (iOS 10, *)) {
                currentNotificationCenter().delegate = [NotificationsObjc shared];
            }
            registerForRemoteNotifications();
        }
        
        void registerForRemoteNotifications() {
            UIApplication *application = [UIApplication sharedApplication];
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                UIUserNotificationSettings *settings =
                [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert
                                                  categories:nil];
                [application registerUserNotificationSettings:settings];
                [application registerForRemoteNotifications];
                if (@available (iOS 10, *)) {
                    registerForUserNotification();
                }
            });
        }

        void registerForUserNotification() {
            if (@available (iOS 10, *)) {
                [currentNotificationCenter() requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound |
                                                                              UNAuthorizationOptionAlert)
                                                           completionHandler:^(BOOL granted, NSError *_Nullable error) {
                                                               if (granted) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       [[UIApplication sharedApplication] registerForRemoteNotifications];
                                                                   });
                                                               }
                                                           }];
            }
        }
        
        void openSettings() override {
            BOOL canOpenSettings = (UIApplicationOpenSettingsURLString) ? YES : NO;
            if (canOpenSettings) {
                NSString *commonString = [NSString stringWithFormat:@":root=NOTIFICATIONS_ID&path=%@", [[NSBundle mainBundle] bundleIdentifier]];
                if (@available (iOS 11, *)) {
                    NSURL *url = [NSURL URLWithString:[@"app-settings" stringByAppendingString:commonString]];
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
                else {
                    NSURL *url = [NSURL URLWithString:[@"App-Prefs" stringByAppendingString:commonString]];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }
        
        bool isRegisteredForRemoteNotifications() override {
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
                bool result = (bool)[UIApplication sharedApplication].isRegisteredForRemoteNotifications;
                return result;
            }
            return true;
        }
        
        string deviceToken() override {
            return deviceToken_;
        }
        
        void didReceiveRemoteNotification(Json::Value userInfo) override {}
        
        void didRegisterForRemoteNotificationsWithDeviceToken(string token) override {
            deviceToken_ = token;
            NSString *tokenString = [[NSString alloc] initWithUTF8String:token.c_str()];
            NSData *tokenData = [tokenString horo_dataFromHex];
            [pushNotificationsWrapper_ registeredWithDeviceToken:tokenData];
        }
        
        void didFailToRegisterForRemoteNotificationsWithError(error err) override {}
        
        int pushTime() override {
            return settings_->pushTime();
        }
        
        void setPushTime(int aPushTime) override {
            return settings_->setPushTime(aPushTime);
        }

        void sendSettingsIfNeeded() override {
            NSCAssert(false, @"Must be implemented in manager class");
        }
        
        bool notificationsDisabled() override {
            NSCAssert(false, @"Must be implemented in manager class");
            return false;
        }
        
        void setNotificationsDisabled(bool disabled) override {
            NSCAssert(false, @"Must be implemented in manager class");
        }
        
        void sendSettingsForZodiacName(string zodiacName) override {
            if (settings_->notificationsDisabled()) {
                [pushNotificationsWrapper_ unsubscribe];
            }
            else {
                NSString *roomName = getRoomName(zodiacName);
                [pushNotificationsWrapper_ subscribeToRoomWithRoomName:roomName];
            }
        }
        
        NSString *getRoomName(string zodiacName) {
            int time = pushTime() - timezoneOffset();
            NSString *roomName = [NSString stringWithFormat:@"%@%@", [NSString stringWithUTF8String:zodiacName.c_str()], @(time)];
            return roomName;
        }
        
    private:
        UNUserNotificationCenter *currentNotificationCenter() {
            if (@available (iOS 10, *)) {
                static BOOL g_exception_handled = NO;
                id result = nil;
                if (g_exception_handled) {
                    return nil;
                }
                @try {
                    result = [UNUserNotificationCenter currentNotificationCenter];
                }
                @catch (NSException *exception) {
                    g_exception_handled = YES;
                }
                if (g_exception_handled) {
                    return nil;
                }
                return result;
            }
            return nil;
        }
    private:
        string deviceToken_;
        PushNotificationsWrapper *pushNotificationsWrapper_;
        strong<Settings> settings_;
    };
};

@implementation NotificationsObjc
+ (void)doLoading {
    horo::NotificationsImpl::setPrivateInstance(horo::NotificationsCC::shared());
}

+ (instancetype)shared {
    static NotificationsObjc *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NotificationsObjc new];
    });
    return sharedInstance;
}

#pragma mark - Public Methods
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
}

#pragma mark - UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    
}

@end
