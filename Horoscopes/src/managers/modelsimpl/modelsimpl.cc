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
#import "managers/loginmanager/loginmanagerfactoryimpl.h"

namespace horo {
  
    ModelsImpl::ModelsImpl(strong<CoreComponents> components,
                           strong<FacebookManager> facebookManager,
                           strong<Settings> settings,
                           strong<Firestore> firestore)
    : components_(components)
    , facebookManager_(facebookManager)
    , settings_(settings)
    , firestore_(firestore) {
        SCParameterAssert(components_.get());
        SCParameterAssert(facebookManager_.get());
        SCParameterAssert(settings_.get());
        SCParameterAssert(firestore_.get());
    }
    
    ModelsImpl::~ModelsImpl() {
        
    }
    
    strong<PredictionScreenModel> ModelsImpl::predictionScreenModel() {
        return new PredictionScreenModelImpl(components_, firestore_);
    }
    
    strong<HelloScreenModel> ModelsImpl::helloScreenModel() {
        return new HelloScreenModelImpl(components_,
                                        new LoginManagerFactoryImpl(facebookManager_),
                                        settings_);
    }
    
};
