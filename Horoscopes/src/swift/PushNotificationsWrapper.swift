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
        self.pushNotifications.register(instanceId: "f07bb86d-5529-42d5-b55e-e1054842456a")
    }
    
    func registeredWithDeviceToken(deviceToken :Data) -> Void {
        self.pushNotifications.registerDeviceToken(deviceToken, completion: {
            self.pushNotifications.subscribe(interest: "hello")
        })
    }
}
