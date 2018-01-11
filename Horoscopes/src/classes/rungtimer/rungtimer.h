//
//  rungtimer.h
//  Horoscopes
//
//  Created by Jasf on 11.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef rungtimer_h
#define rungtimer_h

#include "base/horobase.h"
#include "managers/timerfactory/timerfactory.h"

namespace horo {
  
    class _RungTimer {
    public:
        _RungTimer(strong<TimerFactory> timerFactory, vector<int> timeouts, function<bool()> callback) : timerFactory_(timerFactory)
        , timeouts_(timeouts)
        , callback_(callback) {
            SCParameterAssert(timerFactory_.get());
            SCParameterAssert(timeouts_.size());
            performStep();
        }
        virtual ~_RungTimer() {
            currentTimer_ = nullptr;
            LOG(LS_INFO) << "RungTimer destructor";
        }
        
    private:
        void performStep() {
            currentTimer_ = nullptr;
            if (!timeouts_.size()) {
                return;
            }
            int frontTimeout = timeouts_.front();
            timeouts_.erase(timeouts_.begin());
            currentTimer_ = timerFactory_->scheduledTimer(frontTimeout, false, [this](){
                if (callback_) {
                    if (!callback_()) {
                        return;
                    }
                }
                performStep();
            });
        }
        
    private:
        strong<TimerFactory> timerFactory_;
        vector<int> timeouts_;
        strong<Timer> currentTimer_;
        function<bool()> callback_;
    };
    
    typedef reff<_RungTimer> RungTimer;
    
};

#endif /* rungtimer_h */
