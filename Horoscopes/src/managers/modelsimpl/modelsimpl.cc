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
#import "models/notificationsscreenmodel/notificationsscreenmodelimpl.h"
#import "models/pushtimescreenmodel/pushtimescreenmodelimpl.h"
#import "managers/managers.h"

namespace horo {
  
    ModelsImpl::ModelsImpl(strong<CoreComponents> components,
                           strong<FacebookManager> facebookManager,
                           strong<Settings> settings,
                           strong<Firestore> firestore,
                           strong<HoroscopesService> horoscopesService,
                           strong<ScreensManager> screensManager,
                           strong<Notifications> notifications,
                           strong<Ntp> ntp)
    : components_(components)
    , facebookManager_(facebookManager)
    , settings_(settings)
    , firestore_(firestore)
    , horoscopesService_(horoscopesService)
    , screensManager_(screensManager)
    , notifications_(notifications)
    , ntp_(ntp) {
        SCParameterAssert(components_.get());
        SCParameterAssert(facebookManager_.get());
        SCParameterAssert(settings_.get());
        SCParameterAssert(firestore_.get());
        SCParameterAssert(horoscopesService_.get());
        SCParameterAssert(screensManager_.get());
        SCParameterAssert(notifications_.get());
        SCParameterAssert(ntp_.get());
    }
    
    ModelsImpl::~ModelsImpl() {
        
    }
    
    strong<PredictionScreenModel> ModelsImpl::predictionScreenModel() {
        return predictionScreenModel(nullptr);
    }
    
    strong<PredictionScreenModel> ModelsImpl::predictionScreenModel(strong<Person> person) {
        return new PredictionScreenModelImpl(components_, horoscopesService_, person, ntp_);
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
        return new AccountScreenModelImpl(components_, settings_, new LoginManagerFactoryImpl(facebookManager_), notifications_);
    }
    
    strong<NotificationsScreenModel> ModelsImpl::notificationsScreenModel() {
        return new NotificationsScreenModelImpl(notifications_);
    }
    
    strong<PushTimeScreenModel> ModelsImpl::pushTimeScreenModel() {
        return new PushTimeScreenModelImpl(notifications_);
    }
};
