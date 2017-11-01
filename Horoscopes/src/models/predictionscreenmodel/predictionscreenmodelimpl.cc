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
                                                     strong<HoroscopesService> horoscopesService)
    : components_(components)
    , horoscopesService_(horoscopesService) {
        SCParameterAssert(components_.get());
        SCParameterAssert(horoscopesService_.get());
        person_ = components_->person_;
        loadData();
}
    
PredictionScreenModelImpl::~PredictionScreenModelImpl() {
        
}
    
void PredictionScreenModelImpl::loadData() {
    horoscopesService_->fetchHoroscopes([](strong<HoroscopeDTO> yesterday,
                                           strong<HoroscopeDTO> today,
                                           strong<HoroscopeDTO> tomorrow,
                                           strong<HoroscopeDTO> week,
                                           strong<HoroscopeDTO> month,
                                           strong<HoroscopeDTO> year){
        
    });
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

