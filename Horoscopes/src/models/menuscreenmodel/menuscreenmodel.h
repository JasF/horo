//
//  menuscreenmodel.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef menuscreenmodel_h
#define menuscreenmodel_h

#include "base/horobase.h"

namespace horo {
  
    class _MenuScreenModel {
    public:
        virtual ~_MenuScreenModel() {}
        
    public:
        virtual void loginOnFacebook()=0;
        std::function<void(bool success)> personGatheredCallback_ = nullptr;
    };
    
    typedef reff<_MenuScreenModel> MenuScreenModel;
};

#endif /* menuscreenmodel_h */
