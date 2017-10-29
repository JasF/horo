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
  
    ModelsImpl::ModelsImpl(strong<CoreComponents> components, strong<FacebookManager> facebookManager)
    : components_(components)
    , facebookManager_(facebookManager) {
        
    }
    
    ModelsImpl::~ModelsImpl() {
        
    }
    
    strong<PredictionScreenModel> ModelsImpl::predictionScreenModel() {
        return new PredictionScreenModelImpl();
    }
    
    strong<HelloScreenModel> ModelsImpl::helloScreenModel() {
        return new HelloScreenModelImpl(components_, new LoginManagerFactoryImpl(facebookManager_));
    }
    
};
