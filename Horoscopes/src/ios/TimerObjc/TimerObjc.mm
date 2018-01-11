//
//  TimerObjc.m
//  Horoscopes
//
//  Created by Jasf on 11.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "TimerObjc.h"

namespace horo {

TimerObjc::TimerObjc(int timeInterval, bool repeats, function<void()> completion) {
    SCParameterAssert(completion);
    timer_ = [NSTimer scheduledTimerWithTimeInterval:timeInterval repeats:repeats block:^(NSTimer * _Nonnull timer) {
        if (completion) {
            completion();
        }
    }];
}

TimerObjc::~TimerObjc() {
    if ([timer_ isValid]) {
        [timer_ invalidate];
    }
}

void TimerObjc::cancel() {
    [timer_ invalidate];
}

};
