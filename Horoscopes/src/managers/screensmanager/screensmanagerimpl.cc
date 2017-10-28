//
//  screensmanagerimpl.cpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "screensmanagerimpl.h"

namespace horo {
    static ScreensManager *g_privateInstance = nullptr;
    void ScreensManagerImpl::setPrivateInstance(ScreensManager *privateInstance) {
        SCParameterAssert(privateInstance);
        g_privateInstance = privateInstance;
    }
    
    ScreensManagerImpl::ScreensManagerImpl() {
        
    }
    
    ScreensManagerImpl::~ScreensManagerImpl() {
        
    }
    
    void ScreensManagerImpl::showPredictionViewController() {
        if (g_privateInstance) {
            g_privateInstance->showPredictionViewController();
        }
    }
};
