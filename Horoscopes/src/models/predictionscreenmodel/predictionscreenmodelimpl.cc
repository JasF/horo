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
                                                     strong<HoroscopesService> horoscopesService,
                                                     strong<Person> person)
    : components_(components)
    , horoscopesService_(horoscopesService)
    , person_(person) {
        SCParameterAssert(components_.get());
        SCParameterAssert(horoscopesService_.get());
        if (!person_.get()) {
            person_ = components_->person_;
        }
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
        LOG(LS_WARNING) << "fetched!";
    });
}

std::string PredictionScreenModelImpl::zodiacName() {
    if (person_.get()) {
        if (person_->zodiac().get()) {
            return person_->zodiac()->name();
        }
        return "Unknown";
    }
    return nullptr;
}

std::string PredictionScreenModelImpl::zodiacDateString() {
    DateWrapper startDate = Zodiac::startDateForType(zodiac()->type());
    DateWrapper endDate = Zodiac::endDateForType(zodiac()->type());
    SCAssert(startDate.day() && startDate.month() && endDate.day() && endDate.month(), "Parameters must be satisfied");
    string startMonth = horo::stringByMonth((Months)startDate.month());
    string endMonth = stringByMonth((Months)endDate.month());
    string resultString = std::to_string(startDate.day()) + " " + startMonth + " - " + std::to_string(endDate.day()) + " " + endMonth;
    return resultString;
}
    
strong<Zodiac> PredictionScreenModelImpl::zodiac() {
    if (person_.get()) {
        return person_->zodiac();
    }
    return nullptr;
}

};

