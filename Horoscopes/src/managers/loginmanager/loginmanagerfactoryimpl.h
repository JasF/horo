//
//  loginmanagerfactoryimpl.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef loginmanagerfactoryimpl_h
#define loginmanagerfactoryimpl_h


#include "loginmanagerfactory.h"
#include "managers/facebookmanager/facebookmanager.h"

namespace horo {
    
    class LoginManagerFactoryImpl : public LoginManagerFactory {
    public:
        LoginManagerFactoryImpl(strong<FacebookManager> facebookManager);
        ~LoginManagerFactoryImpl() override;
    public:
        strong<LoginManager> createFacebookLoginManager() override;
        
    private:
        strong<FacebookManager> facebookManager_;
    };
    
};
#endif /* loginmanagerfactoryimpl_h */
