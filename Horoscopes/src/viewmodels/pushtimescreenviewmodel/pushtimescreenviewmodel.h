//
//  pushtimescreenviewmodel.h
//  Horoscopes
//
//  Created by Jasf on 27.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef pushtimescreenviewmodel_h
#define pushtimescreenviewmodel_h

#include "base/horobase.h"
#include "data/datewrapper.h"

namespace horo {
    class _PushTimeScreenViewModel {
    public:
        _PushTimeScreenViewModel(){}
        virtual ~_PushTimeScreenViewModel(){}
    public:
        virtual int pushTime()=0;
        virtual void setPushTime(int pushTime)=0;
        virtual void sendSettingsIfNeeded()=0;
    };
    
    typedef reff<_PushTimeScreenViewModel> PushTimeScreenViewModel;
};

#endif /* pushtimescreenviewmodel_h */
