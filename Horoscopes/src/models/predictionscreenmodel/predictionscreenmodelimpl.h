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
#include "managers/horoscopesservice/horoscopesservice.h"
#include "managers/ntp/ntp.h"

namespace horo {
  
    class PredictionScreenModelImpl : public PredictionScreenModel {
    public:
        PredictionScreenModelImpl(strong<CoreComponents> components,
                                  strong<HoroscopesService> horoscopesService,
                                  strong<Person> person,
                                  strong<Ntp> ntp);
        ~PredictionScreenModelImpl() override;
    public:
        void loadData() override;
        std::string zodiacName() override;
        std::string zodiacDateString() override;
        list<string> tabsTitles() override;
        list<string> horoscopesText() override;
        void setDataFetchedCallback(std::function<void(bool success)> callback) override;
        
        strong<Zodiac> zodiac();
    private:
        void processFetchedHoroscopes();
        void handleFetchedHoroscopes(strong<HoroscopeDTO> yesterday,
                                     strong<HoroscopeDTO> today,
                                     strong<HoroscopeDTO> tomorrow,
                                     strong<HoroscopeDTO> week,
                                     strong<HoroscopeDTO> month,
                                     strong<HoroscopeDTO> year);
    private:
        strong<CoreComponents> components_;
        strong<Person> person_;
        strong<HoroscopesService> horoscopesService_;
        strong<Ntp> ntp_;
        list<string> predictions_;
        list<string> tabsTitles_;
        std::function<void(bool success)> callback_;
        
        long long yesterdayTimestamp_;
        long long todayTimestamp_;
        long long weekTimestamp_;
        long long monthTimestamp_;
        
        strong<HoroscopeDTO> yesterday_;
        strong<HoroscopeDTO> today_;
        strong<HoroscopeDTO> tomorrow_;
        strong<HoroscopeDTO> week_;
        strong<HoroscopeDTO> month_;
        strong<HoroscopeDTO> year_;
    };
    
};

#endif /* predictionscreenmodel_hpp */
