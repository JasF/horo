//
//  helloscreenviewmodel.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef helloscreenviewmodel_h
#define helloscreenviewmodel_h

#include "base/horobase.h"

namespace horo {
  
    class _HelloScreenViewModel {
    public:
        virtual ~_HelloScreenViewModel(){}
    public:
        virtual void continueTapped()=0;
        virtual void loggedInOverFacebook()=0;
        
        std::function<void(bool success)> userLoggedInCallback_ = nullptr;
    };
    
    typedef reff<_HelloScreenViewModel> HelloScreenViewModel;
};

#endif /* helloscreenviewmodel_h */
