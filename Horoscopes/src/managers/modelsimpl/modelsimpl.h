//
//  modelsimpl.h
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef modelsimpl_h
#define modelsimpl_h

#include "models.h"
#include "models/corecomponents/corecomponents.h"
#include "managers/facebookmanager/facebookmanager.h"
#include "managers/settings/settings.h"
#include "managers/firestore/firestore.h"
#include "managers/horoscopesservice/horoscopesservice.h"
#include "managers/screensmanager/screensmanager.h"
#include "data/person.h"

namespace horo {
  
    class ModelsImpl : public Models {
    public:
        ModelsImpl(strong<CoreComponents> components,
                   strong<FacebookManager> facebookManager,
                   strong<Settings> settings,
                   strong<Firestore> firestore,
                   strong<HoroscopesService> horoscopesService,
                   strong<ScreensManager> screensManager);
        ~ModelsImpl() override;
    public:
        strong<PredictionScreenModel> predictionScreenModel() override;
        strong<PredictionScreenModel> predictionScreenModel(strong<Person> person) override;
        strong<HelloScreenModel> helloScreenModel() override;
        strong<MenuScreenModel> menuScreenModel() override;
        strong<FriendsScreenModel> friendsScreenModel() override;
        strong<AccountScreenModel> accountScreenModel() override;
        
    private:
        strong<CoreComponents> components_;
        strong<FacebookManager> facebookManager_;
        strong<Settings> settings_;
        strong<Firestore> firestore_;
        strong<HoroscopesService> horoscopesService_;
        strong<ScreensManager> screensManager_;
    };
    
};

#endif /* modelsimpl_h */
