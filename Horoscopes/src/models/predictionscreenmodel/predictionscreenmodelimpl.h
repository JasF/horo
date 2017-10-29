//
//  predictionscreenmodel.hpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef predictionscreenmodelimpl_h
#define predictionscreenmodelimpl_h

#include <stdio.h>

#include "predictionscreenmodel.h"
#include "models/corecomponents/corecomponents.h"
#include "data/person.h"

namespace horo {
  
    class PredictionScreenModelImpl : public PredictionScreenModel {
    public:
        PredictionScreenModelImpl(strong<CoreComponents> components);
        ~PredictionScreenModelImpl() override;
    public:
        void loadData() override;
        std::string zodiacName() override;
        
        strong<Zodiac> zodiac();
    private:
        strong<CoreComponents> components_;
        strong<Person> person_;
    };
    
};

#endif /* predictionscreenmodel_hpp */
