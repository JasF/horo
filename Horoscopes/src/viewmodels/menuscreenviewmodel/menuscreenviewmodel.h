//
//  menuscreenviewmodel.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef menuscreenviewmodel_h
#define menuscreenviewmodel_h

#include "base/horobase.h"
#include "data/datewrapper.h"

namespace horo {
  
    class _MenuScreenViewModel {
    public:
        virtual ~_MenuScreenViewModel(){}
    public:
        virtual void continueTapped(DateWrapper date)=0;
        virtual void loggedInOverFacebook()=0;
        virtual void zodiacsTapped()=0;
        virtual void friendsTapped()=0;
        virtual void accountTapped()=0;
        virtual void notificationsTapped()=0;
        virtual void feedbackTapped()=0;
        virtual void closeTapped()=0;
        virtual void dataForZodiacRow(int zodiacRowIndex, function<void(string leftZodiacName, string rightZodiacName)> callback)=0;
        virtual void didSelectZodiac(int zodiacRowIndex, bool isLeftZodiac)=0;
        virtual vector<dictionary> zodiacsTitlesAndImageNames()=0;
        std::function<void(bool success)> userLoggedInCallback_ = nullptr;
    };
    
    typedef reff<_MenuScreenViewModel> MenuScreenViewModel;
};

#endif /* menuscreenviewmodel_h */
