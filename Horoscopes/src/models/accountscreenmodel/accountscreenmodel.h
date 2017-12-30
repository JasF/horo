//
//  accountscreenmodel.h
//  Horoscopes
//
//  Created by Jasf on 19.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef accountscreenmodel
#define accountscreenmodel

#include "base/horobase.h"
#include "data/person.h"

namespace horo {
    class _AccountScreenModel {
    public:
        virtual ~_AccountScreenModel() {}
        virtual void loggedInOnFacebook()=0;
        virtual void personRepresentation(function<void(std::string imageUrl, std::string name, horo::DateWrapper birthday)> callback)=0;
        virtual void userLoggedOut()=0;
        virtual void sendSettingsIfNeeded()=0;
        virtual void birthdayDateChanged(DateWrapper wrapper)=0;        
    public:
        std::function<void(bool success)> personGatheredCallback_ = nullptr;
    };
    
    typedef reff<_AccountScreenModel> AccountScreenModel;
};

#endif
