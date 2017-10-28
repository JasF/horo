//
//  managers.hpp
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef managers_hpp
#define managers_hpp

#include <stdio.h>
#include "networkingservice.h"
#include "modelsimpl/models.h"
#include "viewmodelsimpl/viewmodels.h"
#include "screensmanager/screensmanager.h"

namespace horo {
  
    class Managers {
    public:
        static Managers &shared();
    private:
        Managers();
        virtual ~Managers();
        
    public:
        strong<NetworkingService> networkingService();
        strong<ViewModels> viewModels();
        strong<Models> models();
        strong<ScreensManager> screensManager();
    };
    
};

#endif /* managers_hpp */
