//
//  TimerObjc.h
//  Horoscopes
//
//  Created by Jasf on 11.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "classes/timer/timer.h"

namespace horo {
    class TimerObjc : public Timer {
    public:
        TimerObjc(int timeInterval, bool repeats, function<void()> completion);
        ~TimerObjc() override;
        
    public:
        void cancel() override;
        
    private:
        NSTimer *timer_;
    };
};

