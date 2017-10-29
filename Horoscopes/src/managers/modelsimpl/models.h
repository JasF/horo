//
//  models.hpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef models_hpp
#define models_hpp

#include <stdio.h>
#include "base/horobase.h"
#include "models/predictionscreenmodel/predictionscreenmodel.h"
#include "models/helloscreenmodel/helloscreenmodel.h"

namespace horo {
    
    class _Models {
    public:
        virtual ~_Models() {}
    public:
        virtual strong<PredictionScreenModel> predictionScreenModel()=0;
        virtual strong<HelloScreenModel> helloScreenModel()=0;
    };
    
    typedef reff<_Models> Models;
};

#endif /* models_hpp */
