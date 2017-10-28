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
    };
    
    typedef reff<_PredictionScreenViewModel> PredictionScreenViewModel;
};


#endif /* predictionscreenviewmodel_h */
