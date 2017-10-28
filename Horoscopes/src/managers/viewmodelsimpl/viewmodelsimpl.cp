//
//  viewmodels.cpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "viewmodelsimpl.h"
#include "viewmodels/predictionscreenviewmodel/predictionscreenviewmodelimpl.h"

namespace horo {
    
    ViewModelsImpl::ViewModelsImpl(strong<Models> models)
    : models_(models) {
        SCParameterAssert(models_);
    }
    
    ViewModelsImpl::~ViewModelsImpl() {
        
    }
    
    strong<PredictionScreenViewModel> ViewModelsImpl::predictionScreenViewModel() {
        strong<PredictionScreenModel> model = models_->predictionScreenModel();
        PredictionScreenViewModelImpl *viewModel = new PredictionScreenViewModelImpl(model, screensManager_);
        return viewModel;
    }
};
