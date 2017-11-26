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
        std::function<void(bool success)> userLoggedInCallback_ = nullptr;
    };
    
    typedef reff<_MenuScreenViewModel> MenuScreenViewModel;
};

#endif /* menuscreenviewmodel_h */
