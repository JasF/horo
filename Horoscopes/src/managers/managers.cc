//
//  managers.cpp
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "managers.h"
#include "networkingservicefactoryimpl.h"
#include "modelsimpl/modelsimpl.h"
#include "viewmodelsimpl/viewmodelsimpl.h"
#include "screensmanager/screensmanagerimpl.h"

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
    
    strong<ViewModels> Managers::viewModels() {
        static strong<ViewModelsImpl> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new ViewModelsImpl(models());
            sharedInstance->setScreensManager(screensManager());
        }
        return sharedInstance;
    }
    
    strong<Models> Managers::models() {
        static strong<Models> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new ModelsImpl();
        }
        return sharedInstance;
    }
    
    strong<ScreensManager> Managers::screensManager() {
        static strong<ScreensManagerImpl> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new ScreensManagerImpl();
            sharedInstance->setViewModels(viewModels());
        }
        return sharedInstance;
    }
    
};


