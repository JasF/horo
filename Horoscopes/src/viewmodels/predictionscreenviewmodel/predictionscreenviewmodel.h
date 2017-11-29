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
        virtual std::string zodiacName() = 0;
        virtual std::string zodiacDateString() = 0;
        virtual std::string yesterdayHoroscopeText() = 0;
        virtual std::string todayHoroscopeText() = 0;
        virtual std::string tomorrowHoroscopeText() = 0;
        virtual std::string weekHoroscopeText() = 0;
        virtual std::string monthHoroscopeText() = 0;
        virtual std::string yearHoroscopeText() = 0;
        virtual void menuTapped() = 0;
        virtual list<string> tabsTitles() = 0;
        virtual list<string> horoscopesText() = 0;
        virtual void setDataFetchedCallback(std::function<void(bool success)> callback) = 0;
    };
    
    typedef reff<_PredictionScreenViewModel> PredictionScreenViewModel;
};


#endif /* predictionscreenviewmodel_h */
