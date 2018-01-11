//
//  managers.cpp
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "managers.h"
#include "webviewservicefactoryimpl.h"
#include "modelsimpl/modelsimpl.h"
#include "viewmodelsimpl/viewmodelsimpl.h"
#include "screensmanager/screensmanagerimpl.h"
#include "managers/serializer/serializerimpl.h"
#include "managers/facebookmanager/facebookmanagerimpl.h"
#include "managers/firestore/firestoreimpl.h"
#include "managers/firestore/firestorefactoryimpl.h"
#include "managers/daofactory/daofactoryimpl.h"
#include "database/databaseimpl.h"
#include "managers/horoscopesservice/horoscopesserviceimpl.h"
#include "managers/horoscopesparser/horoscopesparserimpl.h"
#include "base/platform.h"
#include "managers/friendsproviderfactory/friendsproviderfactoryimpl.h"
#include "managers/friendsmanager/friendsmanagerimpl.h"
#include "friends/htmlparserfactory/htmlparserfactoryimpl.h"
#include "managers/birthdaydetector/birthdaydetectorimpl.h"
#include "managers/notifications/notificationsimpl.h"
#include "managers/ntp/ntpimpl.h"
#include "managers/themesmanager/themesmanagerimpl.h"

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

    WebViewServiceFactory *Managers::sharedWebViewServiceFactory() {
        static WebViewServiceFactory *sharedInstance = nullptr;
        if (sharedInstance == nullptr) {
            sharedInstance = new WebViewServiceFactoryImpl();
        }
        return sharedInstance;
    }
    
    strong<ViewModels> Managers::viewModels() {
        static strong<ViewModelsImpl> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new ViewModelsImpl(models(), themesManager());
            sharedInstance->setScreensManager(screensManager());
        }
        return sharedInstance;
    }
    
    strong<Models> Managers::models() {
        static strong<Models> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new ModelsImpl(coreComponents(),
                                            facebookManager(),
                                            settings(),
                                            firestore(),
                                            horoscopesService(),
                                            screensManager(),
                                            notifications(),
                                            ntp());
        }
        return sharedInstance;
    }
    
    strong<ScreensManager> Managers::screensManager() {
        static strong<ScreensManagerImpl> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new ScreensManagerImpl(notifications());
            sharedInstance->setViewModels(viewModels());
        }
        return sharedInstance;
    }
    
    strong<CoreComponents> Managers::coreComponents() {
        static strong<CoreComponents> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new CoreComponents();
        }
        return sharedInstance;
    }
    
    strong<Serializer> Managers::serializer() {
        static strong<SerializerImpl> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new SerializerImpl();
        }
        return sharedInstance;
    }
    
    strong<Settings> Managers::settings() {
        static strong<Settings> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new Settings(serializer());
        }
        return sharedInstance;
    }
    
    strong<FacebookManager> Managers::facebookManager() {
        static strong<FacebookManager> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new FacebookManagerImpl();
        }
        return sharedInstance;
    }
    
    strong<FirestoreFactory> firestoreFactory() {
        static strong<FirestoreFactory> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new FirestoreFactoryImpl();
        }
        return sharedInstance;
    }
    
    strong<Firestore> Managers::firestore() {
        static strong<Firestore> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = firestoreFactory()->createFirestore();
        }
        return sharedInstance;
    }
    
    std::string Managers::databaseFilePath() {
        std::string path = documentsPath();
        path += "/offline.sql";
        return path;
    }
    
    strong<DAOFactory> Managers::daoFactory() {
        static strong<DAOFactory> sharedInstance = nullptr;
        if (!sharedInstance) {
            std::string path = databaseFilePath();
            sharedInstance = new DAOFactoryImpl(new DatabaseImpl(path));
        }
        return sharedInstance;
    }
    
    strong<HoroscopesService> Managers::horoscopesService() {
        static strong<HoroscopesService> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new HoroscopesServiceImpl(firestore(), horoscopesParser(), daoFactory()->createHoroscopeDAO());
        }
        return sharedInstance;
    }
    
    strong<HoroscopesParser> Managers::horoscopesParser() {
        static strong<HoroscopesParser> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new HoroscopesParserImpl();
        }
        return sharedInstance;
    }
    
    strong<FriendsProviderFactory> Managers::friendsProviderFactory() {
        static strong<FriendsProviderFactory> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new FriendsProviderFactoryImpl(sharedWebViewServiceFactory(), htmlParserFactory());
        }
        return sharedInstance;
    }
    
    strong<FriendsManager> Managers::friendsManager() {
        return new FriendsManagerImpl(friendsProviderFactory(), daoFactory()->createPersonDAO());
    }
    
    strong<HtmlParserFactory> Managers::htmlParserFactory() {
        static strong<HtmlParserFactory> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new HtmlParserFactoryImpl(birthdayDetector());
        }
        return sharedInstance;
    }
    
    strong<BirthdayDetector> Managers::birthdayDetector() {
        static strong<BirthdayDetector> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new BirthdayDetectorImpl();
        }
        return sharedInstance;
    }
    
    strong<Notifications> Managers::notifications() {
        static strong<Notifications> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new NotificationsImpl(coreComponents(), settings());
        }
        return sharedInstance;
    }
    
    strong<Ntp> Managers::ntp() {
        static strong<Ntp> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new NtpImpl();
        }
        return sharedInstance;
    }
    
    strong<ThemesManager> Managers::themesManager() {
        static strong<ThemesManager> sharedInstance = nullptr;
        if (!sharedInstance) {
            sharedInstance = new ThemesManagerImpl();
        }
        return sharedInstance;
    }
};
