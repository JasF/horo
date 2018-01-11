//
//  timer.h
//  Horoscopes
//
//  Created by Jasf on 11.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef timer_h
#define timer_h

#include "base/horobase.h"

namespace horo {
    
    class _Timer {
    public:
        _Timer() {}
        virtual ~_Timer() {}
        virtual void cancel()=0;
    };
    
    typedef reff<_Timer> Timer;
    
}

#endif /* timer_h */
