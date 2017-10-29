//
//  LoginManagerFactoryfactory.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef LoginManagerFactoryfactory_h
#define LoginManagerFactoryfactory_h

#include "base/horobase.h"
#include "loginmanager.h"

namespace horo {
    
    class _LoginManagerFactory {
    public:
        virtual ~_LoginManagerFactory() {}
    public:
        virtual strong<LoginManager> createFacebookLoginManager()=0;
    };
    
    typedef reff<_LoginManagerFactory> LoginManagerFactory;
    
};


#endif /* LoginManagerFactoryfactory_h */
