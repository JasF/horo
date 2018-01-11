//
//  timerfactory.h
//  Horoscopes
//
//  Created by Jasf on 11.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef timerfactory_h
#define timerfactory_h

#include "base/horobase.h"
#include "classes/timer/timer.h"

namespace horo {
  
    class _TimerFactory {
    public:
        _TimerFactory() {}
        virtual ~_TimerFactory() {}
        virtual strong<Timer> scheduledTimer(int timeInterval, bool repeats, function<void()> completion)=0;
    };
 
    typedef reff<_TimerFactory> TimerFactory;
    
};

#endif /* timerfactory_h */
