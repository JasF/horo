//
//  loginmanager.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef loginmanager_h
#define loginmanager_h

#include "base/horobase.h"
#include "data/person.h"

namespace horo {
  
    class _LoginManager {
    public:
        virtual ~_LoginManager() {}
    public:
        virtual void requestUserInformation(std::function<void(strong<Person> person)> callback) = 0;
    };
    
    typedef reff<_LoginManager> LoginManager;
    
};

#endif /* loginmanager_h */
