//
//  helloscreenmodelimpl.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "helloscreenmodelimpl.h"

namespace horo {
  
    HelloScreenModelImpl::HelloScreenModelImpl(strong<CoreComponents> components,
                                               strong<LoginManagerFactory> loginManagerFactory)
    : components_(components)
    , loginManagerFactory_(loginManagerFactory) {
        SCParameterAssert(components_);
        SCParameterAssert(loginManagerFactory_);
    }
    
    HelloScreenModelImpl::~HelloScreenModelImpl() {
        
    }
    
    void HelloScreenModelImpl::loginOnFacebook() {
        loginManager_ = loginManagerFactory_->createFacebookLoginManager();
        SCAssert(loginManager_.get(), "login manager is not allocated");
        if (!loginManager_.get()) {
            return;
        }
        loginManager_->requestUserInformation([this](strong<Person> person) {
            // set to application storage
            
            if (!person.get()) {
                if (personGatheredCallback_) {
                    personGatheredCallback_();
                }
                return;
            }
            if (personGatheredCallback_) {
                personGatheredCallback_();
            }
        });
    }
};
