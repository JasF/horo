//
//  predictionscreenmodel.cpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "predictionscreenmodelimpl.h"

namespace horo {
    
PredictionScreenModelImpl::PredictionScreenModelImpl(strong<CoreComponents> components,
                                                     strong<Firestore> firestore)
    : components_(components)
    , firestore_(firestore) {
        SCParameterAssert(components_.get());
        SCParameterAssert(firestore_.get());
        person_ = components_->person_;
        loadData();
}
    
PredictionScreenModelImpl::~PredictionScreenModelImpl() {
        
}
    
void PredictionScreenModelImpl::loadData() {
    firestore_->collectionWithPath("horoscopes");
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

