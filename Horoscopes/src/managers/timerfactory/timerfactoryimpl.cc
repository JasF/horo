//
//  timerfactoryimpl.c
//  Horoscopes
//
//  Created by Jasf on 11.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#include "timerfactoryimpl.h"

namespace horo {

static TimerFactory *g_privateInstance;
void TimerFactoryImpl::setPrivateInstance(TimerFactory *privateInstance) {
    g_privateInstance = privateInstance;
}

TimerFactoryImpl::TimerFactoryImpl() {
    
}

TimerFactoryImpl::~TimerFactoryImpl() {
    
}

strong<Timer> TimerFactoryImpl::scheduledTimer(int timeInterval, bool repeats, function<void()> completion) {
    if (g_privateInstance) {
        return g_privateInstance->scheduledTimer(timeInterval, repeats, completion);
    }
    return nullptr;
}

};
