//
//  accountscreenmodel.h
//  Horoscopes
//
//  Created by Jasf on 19.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef accountscreenmodel
#define accountscreenmodel

#include "base/horobase.h"
#include "data/person.h"

namespace horo {
    class _AccountScreenModel {
    public:
        virtual ~_AccountScreenModel() {}
    };
    
    typedef reff<_AccountScreenModel> AccountScreenModel;
};

#endif
