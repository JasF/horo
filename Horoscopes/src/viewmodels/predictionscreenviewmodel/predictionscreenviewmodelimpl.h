//
//  predictionscreenviewmodelimpl.h
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef predictionscreenviewmodelimpl_h
#define predictionscreenviewmodelimpl_h

#include "predictionscreenviewmodel.h"
#include "models/predictionscreenmodel/predictionscreenmodel.h"
#include "managers/screensmanager/screensmanager.h"
#include "managers/themesmanager/themesmanager.h"

namespace horo {
  
    class PredictionScreenViewModelImpl : public PredictionScreenViewModel {
    public:
        PredictionScreenViewModelImpl(strong<PredictionScreenModel> model,
                                      strong<ScreensManager> screensManager,
                                      strong<ThemesManager> themesManager);
        ~PredictionScreenViewModelImpl() override;
    public:
        void didActivated() override;
        
        std::string zodiacName() override;
        std::string zodiacDateString() override;
        std::string yesterdayHoroscopeText() override;
        std::string todayHoroscopeText() override;
        std::string tomorrowHoroscopeText() override;
        std::string weekHoroscopeText() override;
        std::string monthHoroscopeText() override;
        std::string yearHoroscopeText() override;
        void menuTapped() override;
        list<string> tabsTitles() override;
        list<string> horoscopesText() override;
        void setDataFetchedCallback(std::function<void(bool success)> callback) override;
        void noConnectionTapped() override;
        bool personExists() override;
        void personData(std::function<void(string imageUrl, string name, string birthday)> callback) override;
        bool isCurrentModelEqualWithData(strong<Person> person, strong<Zodiac> zodiac) override {
            return model_->isCurrentModelEqualWithData(person, zodiac);
        }
        strong<PredictionScreenModel> model() override {
            return model_;
        }
        
        // themes
        bool backgroundWithSolidColor() override { return theme()->backgroundWithSolidColor(); }
        Color backgroundColor() override { return theme()->backgroundColor(); }
        bool predictionsWithCurlEffect() override { return theme()->predictionsWithCurlEffect(); }
        Color fontColor() override { return theme()->fontColor(); }
        
    private:
        strong<Theme> theme() { return themesManager_->activeTheme(); }
        
    private:
        strong<PredictionScreenModel> model_;
        strong<ScreensManager> screensManager_;
        std::function<void(bool success)> callback_;
        strong<ThemesManager> themesManager_;
    };
    
};

#endif /* predictionscreenviewmodelimpl_h */
