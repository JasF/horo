//
//  predictionscreenmodel.hpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef predictionscreenmodel_h
#define predictionscreenmodel_h

#include <stdio.h>

#include "base/horobase.h"

namespace horo {
    
    class _PredictionScreenModel {
    public:
        virtual ~_PredictionScreenModel() {}
        virtual void loadData() = 0;
        virtual std::string zodiacName() = 0;
    };
    
    typedef reff<_PredictionScreenModel> PredictionScreenModel;
};

#endif /* predictionscreenmodel_hpp */
