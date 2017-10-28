//
//  managers.cpp
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "managers.h"
#include "networkingservicefactoryimpl.h"

namespace horo {
Managers &Managers::shared() {
    static Managers *sharedInstance = nullptr;
    if (sharedInstance == nullptr) {
        sharedInstance = new Managers();
    }
    return *sharedInstance;
}
    
    Managers::Managers() {
        
    }
    
    
    Managers::~Managers() {
        
    }

    NetworkingServiceFactory *sharedNetworkingServiceFactory() {
        static NetworkingServiceFactory *sharedInstance = nullptr;
        if (sharedInstance == nullptr) {
            sharedInstance = new NetworkingServiceFactoryImpl();
        }
        return sharedInstance;
    }
    
    strong<NetworkingService> Managers::networkingService() {
        rtc::scoped_refptr<NetworkingService> service = sharedNetworkingServiceFactory()->createNetworkingService();
        return service;
    }
};


