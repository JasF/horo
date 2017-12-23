//
//  PushNotificationsWrapper.swift
//  Horoscopes
//
//  Created by Jasf on 23.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

import PushNotifications

@objc

class PushNotificationsWrapper: NSObject {
    let pushNotifications = PushNotifications.shared
    func registerInstanceId() -> Void {
        self.pushNotifications.register(instanceId: "54423f63-b8dd-4f21-8563-b009f25c399f")
    }
    
    func registered(deviceToken :Data) -> Void {
        self.pushNotifications.registerDeviceToken(deviceToken, completion: {
            NSLog("hello");
            self.pushNotifications.subscribe(interest: "hello")
        })
    }
}
