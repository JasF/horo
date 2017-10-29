//
//  helloscreenmodel.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef helloscreenmodel_h
#define helloscreenmodel_h

#include "base/horobase.h"

namespace horo {
  
    class _HelloScreenModel {
    public:
        virtual ~_HelloScreenModel() {}
        
    public:
        virtual void loginOnFacebook()=0;
        std::function<void()> personGatheredCallback_ = nullptr;
    };
    
    typedef reff<_HelloScreenModel> HelloScreenModel;
};

#endif /* helloscreenmodel_h */
