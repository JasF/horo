//
//  TimerFactoryObjc.m
//  Horoscopes
//
//  Created by Jasf on 11.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "TimerFactoryObjc.h"
#include "managers/timerfactory/timerfactoryimpl.h"
#import "TimerObjc.h"

namespace horo {
    class TimerFactoryCC : public TimerFactory {
    public:
        TimerFactoryCC() {}
        ~TimerFactoryCC() override {}
        static TimerFactoryCC *shared() {
            static TimerFactoryCC *sharedInstance = nullptr;
            if (!sharedInstance) {
                sharedInstance = new TimerFactoryCC();
            }
            return sharedInstance;
        }
    public:
        strong<Timer> scheduledTimer(int timeInterval, bool repeats, function<void()> completion) override {
            strong<Timer> timer = new TimerObjc(timeInterval, repeats, completion);
            return timer;
        }
    };
}

@implementation TimerFactoryObjc
+ (void)doLoading {
    horo::TimerFactoryImpl::setPrivateInstance(horo::TimerFactoryCC::shared());
}
@end
