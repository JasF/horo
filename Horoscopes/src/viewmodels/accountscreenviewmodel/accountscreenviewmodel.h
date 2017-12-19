//
//  accountscreenviewmodel.h
//  Horoscopes
//
//  Created by Jasf on 19.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef accountscreenviewmodel
#define accountscreenviewmodel

#include "base/horobase.h"

namespace horo {
    
    class _AccountScreenViewModel {
    public:
        _AccountScreenViewModel(){}
        virtual ~_AccountScreenViewModel(){}
    public:
        virtual void menuTapped()=0;
    };
    
    typedef reff<_AccountScreenViewModel> AccountScreenViewModel;
};


#endif
