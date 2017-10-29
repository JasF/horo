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
        
        std::string zodiacName() override;
        std::string yesterdayHoroscopeText() override;
        std::string todayHoroscopeText() override;
        std::string tomorrowHoroscopeText() override;
        std::string weekHoroscopeText() override;
        std::string monthHoroscopeText() override;
        std::string yearHoroscopeText() override;
        
    private:
        strong<PredictionScreenModel> model_;
        strong<ScreensManager> screensManager_;
    };
    
};

#endif /* predictionscreenviewmodelimpl_h */
