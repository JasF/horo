//
//  accountscreenviewmodel.h
//  Horoscopes
//
//  Created by Jasf on 19.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef accountscreenviewmodel_h
#define accountscreenviewmodel_h

#include "base/horobase.h"
#include "data/datewrapper.h"

namespace horo {
    class _AccountScreenViewModel {
    public:
        _AccountScreenViewModel(){}
        virtual ~_AccountScreenViewModel(){}
        virtual void loggedInOnFacebook()=0;
    public:
        virtual void menuTapped()=0;
        virtual void personRepresentation(function<void(std::string imageUrl, std::string name, horo::DateWrapper birthday)> callback)=0;
        virtual void userLoggedOut()=0;
        virtual void birthdayDateChanged(DateWrapper wrapper)=0;
        std::function<void(bool success)> personGatheredCallback_ = nullptr;
    };
    
    typedef reff<_AccountScreenViewModel> AccountScreenViewModel;
};

#endif
