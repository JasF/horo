//
//  pushtimescreenmodel.h
//  Horoscopes
//
//  Created by Jasf on 27.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef pushtimescreenmodel_h
#define pushtimescreenmodel_h

#include "base/horobase.h"
#include "data/person.h"

namespace horo {
    class _PushTimeScreenModel {
    public:
        _PushTimeScreenModel(){}
        virtual ~_PushTimeScreenModel() {}
        
        virtual int pushTime()=0;
        virtual void setPushTime(int pushTime)=0;
        virtual void sendSettingsIfNeeded()=0;
    };
    
    typedef reff<_PushTimeScreenModel> PushTimeScreenModel;
};


#endif /* pushtimescreenmodel_h */
