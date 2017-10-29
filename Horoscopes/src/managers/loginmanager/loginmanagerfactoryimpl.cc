//
//  loginmanagerfactoryimpl.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "loginmanagerfactoryimpl.h"
#include "facebookloginmanager.h"

namespace horo {
    LoginManagerFactoryImpl::LoginManagerFactoryImpl(strong<FacebookManager> facebookManager)
    : facebookManager_(facebookManager) {
        SCParameterAssert(facebookManager_.get());
    }
    
    LoginManagerFactoryImpl::~LoginManagerFactoryImpl() {
        
    }
    
    strong<LoginManager> LoginManagerFactoryImpl::createFacebookLoginManager() {
        return new FacebookLoginManager(facebookManager_);
    }
};
