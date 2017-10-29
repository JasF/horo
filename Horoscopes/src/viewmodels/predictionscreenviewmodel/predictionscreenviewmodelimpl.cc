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
    
    std::wstring PredictionScreenViewModelImpl::yesterdayHoroscopeText() {
        return L"";
    }
    std::wstring PredictionScreenViewModelImpl::todayHoroscopeText() {
        return L"";
    }
    std::wstring PredictionScreenViewModelImpl::tomorrowHoroscopeText() {
        return L"";
    }
    std::wstring PredictionScreenViewModelImpl::weekHoroscopeText() {
        return L"";
    }
    std::wstring PredictionScreenViewModelImpl::monthHoroscopeText() {
        return L"";
    }
    std::wstring PredictionScreenViewModelImpl::yearHoroscopeText() {
        return L"";
    }
    void PredictionScreenViewModelImpl::didActivated() {
        LOG(LS_WARNING) << "didActivated";
    }
};
