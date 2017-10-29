//
//  helloscreenmodelimpl.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef helloscreenmodelimpl_h
#define helloscreenmodelimpl_h

#include <stdio.h>

#include "helloscreenmodel.h"
#include "models/corecomponents/corecomponents.h"
#include "managers/loginmanager/loginmanagerfactory.h"

namespace horo {
    class HelloScreenModelImpl : public HelloScreenModel {
    public:
        HelloScreenModelImpl(strong<CoreComponents> components,
                             strong<LoginManagerFactory> loginManagerFactory);
        ~HelloScreenModelImpl() override;
    public:
        void loginOnFacebook() override;
        
    private:
        strong<CoreComponents> components_;
        strong<LoginManagerFactory> loginManagerFactory_;
        strong<LoginManager> loginManager_;
    };
};

#endif /* helloscreenmodelimpl_h */
