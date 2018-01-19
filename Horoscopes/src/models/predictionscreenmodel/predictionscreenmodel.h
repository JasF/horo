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
#include "data/zodiac.h"
#include "data/person.h"

namespace horo {
    
    class _PredictionScreenModel {
    public:
        virtual ~_PredictionScreenModel() {}
        virtual void loadData() = 0;
        virtual std::string zodiacName() = 0;
        virtual std::string zodiacDateString() = 0;
        virtual list<string> tabsTitles() = 0;
        virtual list<string> horoscopesText() = 0;
        virtual void setDataFetchedCallback(std::function<void(bool success)> callback) = 0;
        virtual void noConnectionTapped() = 0;
        virtual bool personExists() = 0;
        virtual void personData(std::function<void(string imageUrl, string name, string birthday)> callback) = 0;
        virtual strong<Zodiac> zodiac() = 0;
        virtual bool isCurrentModelEqualWithData(strong<Person> person, strong<Zodiac> zodiac) = 0;
    };
    
    typedef reff<_PredictionScreenModel> PredictionScreenModel;
};

#endif /* predictionscreenmodel_hpp */
