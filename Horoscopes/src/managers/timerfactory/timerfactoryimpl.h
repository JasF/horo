//
//  timerfactoryimpl.h
//  Horoscopes
//
//  Created by Jasf on 11.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef timerfactoryimpl_h
#define timerfactoryimpl_h

#include "managers/timerfactory/timerfactory.h"

namespace horo {
  
class TimerFactoryImpl : public TimerFactory {
public:
    static void setPrivateInstance(TimerFactory *privateInstance);
public:
    TimerFactoryImpl();
    ~TimerFactoryImpl() override;
    strong<Timer> scheduledTimer(int timeInterval, bool repeats, function<void()> completion) override;
};
    
};

#endif /* timerfactoryimpl_h */
