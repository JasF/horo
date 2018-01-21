//
//  menuscreenviewmodelimpl.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef menuscreenviewmodelimpl_h
#define menuscreenviewmodelimpl_h

#include "menuscreenviewmodel.h"
#include "models/menuscreenmodel/menuscreenmodel.h"
#include "managers/screensmanager/screensmanager.h"

namespace horo {
  
    class MenuScreenViewModelImpl : public MenuScreenViewModel {
    public:
        MenuScreenViewModelImpl(strong<MenuScreenModel> model, strong<ScreensManager> screensManager);
        ~MenuScreenViewModelImpl() override;
        
    public:
        void continueTapped(DateWrapper date) override;
        void loggedInOverFacebook() override;
        void zodiacsTapped() override;
        void friendsTapped() override;
        void accountTapped() override;
        void notificationsTapped() override;
        void feedbackTapped() override;
        void closeTapped() override;
        void dataForZodiacRow(int zodiacRowIndex, function<void(string leftZodiacName, string rightZodiacName)>) override;
        void didSelectZodiac(int zodiacRowIndex, bool isLeftZodiac) override;
        void didSelectZodiacWithIndex(int zodiacIndex) override;
        vector<dictionary> zodiacsTitlesAndImageNames() override;
        
    private:
        strong<MenuScreenModel> model_;
        strong<ScreensManager> screensManager_;
        std::function<void(bool success)> userLoggedInCallback_;
    };
};

#endif /* menuscreenviewmodelimpl_h */
