//
//  facebookmanager.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef facebookmanager_h
#define facebookmanager_h

#include "base/horobase.h"

namespace horo {
    
    class _FacebookManager {
    public:
        virtual ~_FacebookManager() {}
    public:
        virtual void requestPersonalInformation(std::function<void(dictionary userInfo)> callback)=0;
    };
    
    typedef reff<_FacebookManager> FacebookManager;
    
};


#endif /* facebookmanager_h */
