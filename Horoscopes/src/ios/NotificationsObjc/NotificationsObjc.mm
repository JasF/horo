//
//  NotificationsObjc.m
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "managers/notifications/notificationsimpl.h"
#import <UserNotifications/UserNotifications.h>
#import "NotificationsObjc.h"

@interface NotificationsObjc () <UNUserNotificationCenterDelegate>
@end

namespace horo {
    class NotificationsCC : public Notifications {
    public:
        static NotificationsCC *shared() {
            static NotificationsCC *sharedInstance = nullptr;
            if (!sharedInstance) {
                sharedInstance = new NotificationsCC();
            }
            return sharedInstance;
        }
    public:
        NotificationsCC() {}
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
                return(bool)[UIApplication sharedApplication].isRegisteredForRemoteNotifications;
            }
            return true;
        }
        
        string deviceToken() override {
            return deviceToken_;
        }
        
        void didReceiveRemoteNotification(Json::Value userInfo) override {
            
        }
        
        void didRegisterForRemoteNotificationsWithDeviceToken(string token) override {
            deviceToken_ = token;
        }
        
        void didFailToRegisterForRemoteNotificationsWithError(error err) override {
            
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
