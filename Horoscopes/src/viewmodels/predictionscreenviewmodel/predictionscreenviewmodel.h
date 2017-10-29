//
//  predictionscreenviewmodel.h
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef predictionscreenviewmodel_h
#define predictionscreenviewmodel_h

#include "base/horobase.h"

namespace horo {
  
    class _PredictionScreenViewModel {
    public:
        virtual ~_PredictionScreenViewModel() {}
        virtual void didActivated() = 0;
        virtual std::wstring yesterdayHoroscopeText() = 0;
        virtual std::wstring todayHoroscopeText() = 0;
        virtual std::wstring tomorrowHoroscopeText() = 0;
        virtual std::wstring weekHoroscopeText() = 0;
        virtual std::wstring monthHoroscopeText() = 0;
        virtual std::wstring yearHoroscopeText() = 0;
    };
    
    typedef reff<_PredictionScreenViewModel> PredictionScreenViewModel;
};


#endif /* predictionscreenviewmodel_h */
