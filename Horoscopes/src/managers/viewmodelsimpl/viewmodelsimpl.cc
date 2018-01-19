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
#include "viewmodels/accountscreenviewmodel/accountscreenviewmodelimpl.h"
#include "viewmodels/notificationsscreenviewmodel/notificationsscreenviewmodelimpl.h"
#include "viewmodels/pushtimescreenviewmodel/pushtimescreenviewmodelimpl.h"

namespace horo {
    
    ViewModelsImpl::ViewModelsImpl(strong<Models> models, strong<ThemesManager> themesManager)
    : models_(models)
    , themesManager_(themesManager) {
        SCParameterAssert(models_.get());
        SCParameterAssert(themesManager_.get());
    }
    
    ViewModelsImpl::~ViewModelsImpl() {
        
    }
    
    strong<PredictionScreenViewModel> ViewModelsImpl::predictionScreenViewModel() {
        strong<PredictionScreenModel> model = models_->predictionScreenModel();
        PredictionScreenViewModelImpl *viewModel = new PredictionScreenViewModelImpl(model, screensManager_, themesManager_);
        return viewModel;
    }
    
    strong<PredictionScreenViewModel> ViewModelsImpl::predictionScreenViewModel(strong<Person> person, strong<Zodiac> zodiac) {
        strong<PredictionScreenModel> model = models_->predictionScreenModel(person, zodiac);
        PredictionScreenViewModelImpl *viewModel = new PredictionScreenViewModelImpl(model, screensManager_, themesManager_);
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
        FriendsScreenViewModelImpl *viewModel = new FriendsScreenViewModelImpl(model, screensManager_, themesManager_);
        return viewModel;
    }
    
    strong<AccountScreenViewModel> ViewModelsImpl::accountScreenViewModel() {
        strong<AccountScreenModel> model = models_->accountScreenModel();
        AccountScreenViewModelImpl *viewModel = new AccountScreenViewModelImpl(model, screensManager_);
        return viewModel;
    }
    
    strong<NotificationsScreenViewModel> ViewModelsImpl::notificationsScreenViewModel() {
        strong<NotificationsScreenModel> model = models_->notificationsScreenModel();
        strong<NotificationsScreenViewModel> viewModel = new NotificationsScreenViewModelImpl(model, screensManager_);
        return viewModel;
    }
    
    strong<PushTimeScreenViewModel> ViewModelsImpl::pushTimeScreenViewModel() {
        strong<PushTimeScreenModel> model = models_->pushTimeScreenModel();
        strong<PushTimeScreenViewModel> viewModel = new PushTimeScreenViewModelImpl(model);
        return viewModel;
    }
    
};
