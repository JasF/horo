//
//  predictionscreenmodel.cpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "predictionscreenmodelimpl.h"

namespace horo {
    
PredictionScreenModelImpl::PredictionScreenModelImpl(strong<CoreComponents> components)
    : components_(components) {
        SCParameterAssert(components_);
        person_ = components_->person_;
}
    
PredictionScreenModelImpl::~PredictionScreenModelImpl() {
        
}
    
void PredictionScreenModelImpl::loadData() {
    
}

std::string PredictionScreenModelImpl::zodiacName() {
    if (person_.get()) {
        return person_->zodiac()->name();
    }
    return nullptr;
}

strong<Zodiac> PredictionScreenModelImpl::zodiac() {
    if (person_.get()) {
        return person_->zodiac();
    }
    return nullptr;
}

};

