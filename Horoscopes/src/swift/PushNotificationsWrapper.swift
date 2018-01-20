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
    var needsSubscribe = false
    var subscribedToRoom = ""
    func registerInstanceId() -> Void {
        self.pushNotifications.register(instanceId: "54423f63-b8dd-4f21-8563-b009f25c399f")
    }
    var instanceOfCustomObject: Logger = Logger()
    func registered(deviceToken :Data) -> Void {
        Logger.shared().llog("registering deviceToken on pusher");
        self.pushNotifications.registerDeviceToken(deviceToken, completion: {
            self.isRegistered = true
            Logger.shared().llog("registered deviceTokn on pusher");
            if (self.needsSubscribe) {
                self.needsSubscribe = false;
                self.performSubscription()
            }
        })
    }
    
    func subscribeToRoom(roomName :String) -> Void {
        Logger.shared().log("request subscribeToRoom: %@", args:getVaList([roomName]))
        needsSubscribe = true
        delayedRoomName = roomName
        performSubscription()
    }
    
    func performSubscription() -> Void {
        if (self.isRegistered == false) {
            Logger.shared().llog("cannot perform subscription. Try again later");
            return;
        }
        needsSubscribe = false;
        DispatchQueue.main.async {
            Logger.shared().llog("Subscribing.. unsubscribeAll begin");
            self.pushNotifications.unsubscribeAll {
                Logger.shared().llog("Subscribing.. unsubscribeAll completed");
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
        Logger.shared().log("Subscribing.. perform subscription to room: %@ begin", args:getVaList([roomName]));
        self.pushNotifications.subscribe(interest: roomName, completion: {
            Logger.shared().log("Subscribing.. perform subscription completed. Room: %@", args:getVaList([roomName]));
            self.handleSubscribedToRoom(roomName: roomName)
        })
    }
    
    func unsubscribe() -> Void {
        Logger.shared().llog("Unsubscribing from all");
        self.pushNotifications.unsubscribeAll {
            Logger.shared().llog("Unsubscribed");
        }
    }
}
