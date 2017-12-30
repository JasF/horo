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
    var delayedRoomName = ""
    var isRegistered = false
    var subscribedToRoom = ""
    func registerInstanceId() -> Void {
        self.pushNotifications.register(instanceId: "54423f63-b8dd-4f21-8563-b009f25c399f")
    }
    
    func registered(deviceToken :Data) -> Void {
        self.pushNotifications.registerDeviceToken(deviceToken, completion: {
            self.isRegistered = true
            self.performSubscription()
        })
    }
    
    func subscribeToRoom(roomName :String) -> Void {
        delayedRoomName = roomName
        performSubscription()
    }
    
    func performSubscription() -> Void {
        if (self.isRegistered == false) {
            return;
        }
        DispatchQueue.main.async {
            self.pushNotifications.unsubscribeAll {
                self.performSubscriptionToRoom(roomName: self.delayedRoomName)
            }
        }
    }
    
    func handleSubscribedToRoom(roomName :String) -> Void {
        NSLog("Subscribed: " + roomName);
        subscribedToRoom = roomName
        clean();
    }
    
    func clean() {
        self.delayedRoomName = ""
    }
    
    func performSubscriptionToRoom(roomName: String) -> Void {
        self.pushNotifications.subscribe(interest: roomName, completion: {
            self.handleSubscribedToRoom(roomName: roomName)
        })
    }
    
    func unsubscribe() -> Void {
        self.pushNotifications.unsubscribeAll {
            NSLog("manually disabled")
        }
    }
}
