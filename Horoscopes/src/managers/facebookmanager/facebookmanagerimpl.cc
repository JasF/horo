//
//  facebookmanagerimpl.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "facebookmanagerimpl.h"

namespace horo {
  
    static FacebookManager *g_privateInstance = nullptr;
    void FacebookManagerImpl::setPrivateInstance(FacebookManager *privateInstance) {
        g_privateInstance = privateInstance;
    }
    
    FacebookManagerImpl::FacebookManagerImpl() {
        
    }
    
    FacebookManagerImpl::~FacebookManagerImpl() {
        
    }
    
    void FacebookManagerImpl::requestPersonalInformation(std::function<void(dictionary userInfo)> callback) {
        if (g_privateInstance) {
            g_privateInstance->requestPersonalInformation(callback);
        }
    }
};
