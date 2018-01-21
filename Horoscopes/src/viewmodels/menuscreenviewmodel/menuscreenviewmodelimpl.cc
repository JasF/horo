//
//  menuscreenviewmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "menuscreenviewmodelimpl.h"

namespace horo {
  
    MenuScreenViewModelImpl::MenuScreenViewModelImpl(strong<MenuScreenModel> model,
                                                       strong<ScreensManager> screensManager)
    : model_(model),
    screensManager_(screensManager) {
        model_->personGatheredCallback_ = [this](bool success) {
            if (userLoggedInCallback_) {
                userLoggedInCallback_(success);
            }
            if (success) {
                screensManager_->showPredictionViewController();
            }
        };
    }
    
    MenuScreenViewModelImpl::~MenuScreenViewModelImpl() {
        
    }
    
    void MenuScreenViewModelImpl::continueTapped(DateWrapper date) {
        
    }
    
    void MenuScreenViewModelImpl::loggedInOverFacebook() {
        model_->loginOnFacebook();
    }
    
    void MenuScreenViewModelImpl::zodiacsTapped() {
        screensManager_->showPredictionViewController();
    }
    
    void MenuScreenViewModelImpl::friendsTapped() {
        screensManager_->showFriendsViewController();
    }
    
    void MenuScreenViewModelImpl::accountTapped() {
        screensManager_->showAccountViewController();
    }
    
    void MenuScreenViewModelImpl::notificationsTapped() {
        screensManager_->showNotificationsViewController();
    }
    
    void MenuScreenViewModelImpl::feedbackTapped() {
        screensManager_->showFeedbackViewController();
    }
    
    void MenuScreenViewModelImpl::closeTapped() {
        screensManager_->showPredictionViewController();
    }
    
    void MenuScreenViewModelImpl::dataForZodiacRow(int zodiacRowIndex, function<void(string leftZodiacName, string rightZodiacName)> callback) {
        model_->dataForZodiacRow(zodiacRowIndex, callback);
    }
    
    void MenuScreenViewModelImpl::didSelectZodiac(int zodiacRowIndex, bool isLeftZodiac) {
    }
    
    void MenuScreenViewModelImpl::didSelectZodiacWithIndex(int zodiacIndex) {
        auto zodiacs = Zodiac::allZodiacs();
        SCAssert(zodiacIndex < zodiacs.size(), "index out of bounds");
        if (zodiacIndex >= zodiacs.size()) {
            return;
        }
        strong<Zodiac> zodiac = zodiacs.at(zodiacIndex);
        screensManager_->showPredictionViewController(zodiac);
    }
    
    vector<dictionary> MenuScreenViewModelImpl::zodiacsTitlesAndImageNames() {
        dictionary zodiacs = Zodiac::zodiacsNamesAndTypes();
        vector<Json::Value> results;
        for (auto it = zodiacs.begin(); it != zodiacs.end(); ++it) {
            Json::Value zodiacItem;
            zodiacItem["name"] = *it;
            string imageName = (*it).asString();
            imageName += ".png";
            zodiacItem["imageName"] = imageName;
            results.push_back(zodiacItem);
        }
        return results;
    }
    
};
