//
//  predictionscreenviewmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "predictionscreenviewmodelimpl.h"

namespace horo {
    PredictionScreenViewModelImpl::PredictionScreenViewModelImpl(strong<PredictionScreenModel> model,
                                                                 strong<ScreensManager> screensManager)
    : model_(model),
     screensManager_(screensManager) {
         SCParameterAssert(model_);
         SCParameterAssert(screensManager_);
     }
    
    PredictionScreenViewModelImpl::~PredictionScreenViewModelImpl() {
        
    }
    
    std::string PredictionScreenViewModelImpl::yesterdayHoroscopeText() {
        return "";
    }
    std::string PredictionScreenViewModelImpl::todayHoroscopeText() {
        return "";
    }
    std::string PredictionScreenViewModelImpl::tomorrowHoroscopeText() {
        return "";
    }
    std::string PredictionScreenViewModelImpl::weekHoroscopeText() {
        return "";
    }
    std::string PredictionScreenViewModelImpl::monthHoroscopeText() {
        return "";
    }
    std::string PredictionScreenViewModelImpl::yearHoroscopeText() {
        return "";
    }
    void PredictionScreenViewModelImpl::menuTapped() {
        screensManager_->showMenuViewController(true);
    }
    std::string PredictionScreenViewModelImpl::zodiacName() {
        return model_->zodiacName();
    }
    
    std::string PredictionScreenViewModelImpl::zodiacDateString() {
        return model_->zodiacDateString();
    }
    
    void PredictionScreenViewModelImpl::didActivated() {
        LOG(LS_WARNING) << "didActivated";
    }
};
