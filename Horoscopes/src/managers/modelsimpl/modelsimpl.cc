//
//  models.cpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "modelsimpl.h"
#import "models/predictionscreenmodel/predictionscreenmodelimpl.h"
#import "models/helloscreenmodel/helloscreenmodelimpl.h"
#import "models/menuscreenmodel/menuscreenmodelimpl.h"
#import "models/friendsscreenmodel/friendsscreenmodelimpl.h"
#import "managers/loginmanager/loginmanagerfactoryimpl.h"
#import "models/accountscreenmodel/accountscreenmodelimpl.h"
#import "managers/managers.h"

namespace horo {
  
    ModelsImpl::ModelsImpl(strong<CoreComponents> components,
                           strong<FacebookManager> facebookManager,
                           strong<Settings> settings,
                           strong<Firestore> firestore,
                           strong<HoroscopesService> horoscopesService,
                           strong<ScreensManager> screensManager)
    : components_(components)
    , facebookManager_(facebookManager)
    , settings_(settings)
    , firestore_(firestore)
    , horoscopesService_(horoscopesService)
    , screensManager_(screensManager) {
        SCParameterAssert(components_.get());
        SCParameterAssert(facebookManager_.get());
        SCParameterAssert(settings_.get());
        SCParameterAssert(firestore_.get());
        SCParameterAssert(horoscopesService_.get());
        SCParameterAssert(screensManager_.get());
    }
    
    ModelsImpl::~ModelsImpl() {
        
    }
    
    strong<PredictionScreenModel> ModelsImpl::predictionScreenModel() {
        return predictionScreenModel(nullptr);
    }
    
    strong<PredictionScreenModel> ModelsImpl::predictionScreenModel(strong<Person> person) {
        return new PredictionScreenModelImpl(components_, horoscopesService_, person);
    }
    
    strong<HelloScreenModel> ModelsImpl::helloScreenModel() {
        return new HelloScreenModelImpl(components_,
                                        new LoginManagerFactoryImpl(facebookManager_),
                                        settings_);
    }
    
    strong<MenuScreenModel> ModelsImpl::menuScreenModel() {
        return new MenuScreenModelImpl(components_,
                                        new LoginManagerFactoryImpl(facebookManager_),
                                        settings_);
    }
    
    strong<FriendsScreenModel> ModelsImpl::friendsScreenModel() {
        return new FriendsScreenModelImpl(components_,
                                          Managers::shared().friendsManager(),
                                          settings_,
                                          screensManager_);
    }
    
    strong<AccountScreenModel> ModelsImpl::accountScreenModel() {
        return new AccountScreenModelImpl(settings_);
    }
};
