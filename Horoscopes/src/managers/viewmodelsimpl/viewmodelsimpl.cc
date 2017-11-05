//
//  viewmodels.cpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "viewmodelsimpl.h"
#include "viewmodels/predictionscreenviewmodel/predictionscreenviewmodelimpl.h"
#include "viewmodels/helloscreenviewmodel/helloscreenviewmodelimpl.h"
#include "viewmodels/menuscreenviewmodel/menuscreenviewmodelimpl.h"
#include "viewmodels/friendsscreenviewmodel/friendsscreenviewmodelimpl.h"

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
    
    strong<HelloScreenViewModel> ViewModelsImpl::helloScreenViewModel() {
        strong<HelloScreenModel> model = models_->helloScreenModel();
        HelloScreenViewModelImpl *viewModel = new HelloScreenViewModelImpl(model, screensManager_);
        return viewModel;
    }
    
    strong<MenuScreenViewModel> ViewModelsImpl::menuScreenViewModel() {
        strong<MenuScreenModel> model = models_->menuScreenModel();
        MenuScreenViewModelImpl *viewModel = new MenuScreenViewModelImpl(model, screensManager_);
        return viewModel;
    }
    
    strong<FriendsScreenViewModel> ViewModelsImpl::friendsScreenViewModel() {
        strong<FriendsScreenModel> model = models_->friendsScreenModel();
        FriendsScreenViewModelImpl *viewModel = new FriendsScreenViewModelImpl(model, screensManager_);
        return viewModel;
    }
};
