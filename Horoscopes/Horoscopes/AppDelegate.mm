//
//  AppDelegate.m
//  Horoscopes
//
//  Created by ANDREI VAYAVODA on 25.10.17.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#include <FirebaseCore/FirebaseCore.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FirebaseMessaging/FirebaseMessaging.h>
#include "managers/managers.h"
#import "NSError+Horo.h"
#import "AppDelegate.h"

#import "NSDictionary+Horo.h"
#import "NSError+Horo.h"

@interface AppDelegate () <FIRMessagingDelegate>
@property (assign, nonatomic) strong<horo::Notifications> notifications;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    Log(@"\n\n\n*****SESSION START*****\napplication:didFinishLaunchingWithOptions: %@", launchOptions);
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    
    [FIRMessaging messaging].delegate = self;
    [FIRApp configure];
    [FBSDKLoginButton class];
    _notifications = horo::Managers::shared().notifications();
    NSCParameterAssert(_notifications.get());
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [self performShowingOperations];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    Log(@"application:didReceiveRemoteNotification:fetchCompletionHandler: %@", userInfo);
    Json::Value dictionary = [userInfo horo_jsonValue];
    _notifications->didReceiveRemoteNotification(dictionary);
    if (completionHandler) {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    Log(@"application:didRegisterForRemoteNotificationsWithDeviceToken: %@", [deviceToken horo_hexString]);
    _notifications->didRegisterForRemoteNotificationsWithDeviceToken([deviceToken horo_hexString].UTF8String);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    Log(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    _notifications->didFailToRegisterForRemoteNotificationsWithError([error horo_error]);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(nullable NSString *)sourceApplication
         annotation:(id)annotation {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation];
    // Add any custom logic here.
    return handled;
}

#pragma mark - Private Methods
- (void)performShowingOperations {
    strong<horo::Settings> settings = horo::Managers::shared().settings();
    strong<horo::Person> person = settings->currentPerson();
    horo::Managers::shared().coreComponents()->person_ = person;
    if (person.get()) {
        horo::Managers::shared().screensManager()->showPredictionViewController();
    }
    else {
        horo::Managers::shared().screensManager()->showMenuViewController(false);
        horo::Managers::shared().screensManager()->showWelcomeViewController();
    }
}

#pragma mark - FIRMessagingDelegate
- (void)messaging:(nonnull FIRMessaging *)messaging
didReceiveMessage:(nonnull FIRMessagingRemoteMessage *)remoteMessage {
    Log(@"messaging:didReceiveMessage: %@ - %@", messaging, remoteMessage);
}

- (void)applicationReceivedRemoteMessage:(nonnull FIRMessagingRemoteMessage *)remoteMessage {
    Log(@"applicationReceivedRemoteMessage: %@", remoteMessage);
}

- (void)messaging:(nonnull FIRMessaging *)messaging
didReceiveRegistrationToken:(nonnull NSString *)fcmToken {
    Log(@"messaging:didReceiveRegistrationToken: %@", fcmToken);
}

@end
