//
//  predictionscreenviewmodelimpl.h
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef predictionscreenviewmodelimpl_h
#define predictionscreenviewmodelimpl_h

#include "predictionscreenviewmodel.h"
#include "models/predictionscreenmodel/predictionscreenmodel.h"
#include "managers/screensmanager/screensmanager.h"

namespace horo {
  
    class PredictionScreenViewModelImpl : public PredictionScreenViewModel {
    public:
        PredictionScreenViewModelImpl(strong<PredictionScreenModel> model,
                                      strong<ScreensManager> screensManager);
        ~PredictionScreenViewModelImpl() override;
    public:
        void didActivated() override;
        
        std::wstring yesterdayHoroscopeText() override;
        std::wstring todayHoroscopeText() override;
        std::wstring tomorrowHoroscopeText() override;
        std::wstring weekHoroscopeText() override;
        std::wstring monthHoroscopeText() override;
        std::wstring yearHoroscopeText() override;
        
    private:
        strong<PredictionScreenModel> model_;
        strong<ScreensManager> screensManager_;
    };
    
};

#endif /* predictionscreenviewmodelimpl_h */
