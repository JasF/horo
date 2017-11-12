//
//  managers.hpp
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef managers_hpp
#define managers_hpp

#include <stdio.h>
#include "networkingservice.h"
#include "modelsimpl/models.h"
#include "viewmodelsimpl/viewmodels.h"
#include "screensmanager/screensmanager.h"
#include "models/corecomponents/corecomponents.h"
#include "managers/settings/settings.h"
#include "managers/serializer/serializer.h"
#include "managers/facebookmanager/facebookmanager.h"
#include "managers/firestore/firestore.h"
#include "managers/daofactory/daofactory.h"
#include "managers/horoscopesservice/horoscopesservice.h"
#include "managers/horoscopesparser/horoscopesparser.h"
#include "managers/friendsproviderfactory/friendsproviderfactory.h"
#include "managers/friendsmanager/friendsmanager.h"
#include "managers/networkingservice/networkingservicefactory.h"
#include "friends/htmlparserfactory/htmlparserfactory.h"
#include "managers/birthdaydetector/birthdaydetector.h"

namespace horo {
  
    class Managers {
    public:
        static Managers &shared();
    private:
        Managers();
        virtual ~Managers();
        std::string databaseFilePath();
        
    public:
        strong<NetworkingService> networkingService();
        strong<ViewModels> viewModels();
        strong<Models> models();
        strong<ScreensManager> screensManager();
        strong<CoreComponents> coreComponents();
        strong<Serializer> serializer();
        strong<Settings> settings();
        strong<FacebookManager> facebookManager();
        strong<Firestore> firestore();
        strong<DAOFactory> daoFactory();
        strong<HoroscopesService> horoscopesService();
        strong<HoroscopesParser> horoscopesParser();
        strong<FriendsProviderFactory> friendsProviderFactory();
        strong<FriendsManager> friendsManager();
        NetworkingServiceFactory *sharedNetworkingServiceFactory();
        strong<HtmlParserFactory> htmlParserFactory();
        strong<BirthdayDetector> birthdayDetector();
    };
    
};

#endif /* managers_hpp */
