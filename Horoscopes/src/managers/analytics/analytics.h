//
//  analytics.h
//  Horoscopes
//
//  Created by Jasf on 17.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef analytics_h
#define analytics_h

#include "base/horobase.h"

namespace horo {
    
    class _Analytics {
    public:
        _Analytics() {}
        virtual ~_Analytics() {}
        
    public:
// ScreensManager
        virtual void predictionScreenShow(bool withPerson, bool fromPush){}
        virtual void welcomeScreenShow(){}
        virtual void menuScreenShow(){}
        virtual void friendsScreenShow(){}
        virtual void accountScreenShow(){}
        virtual void feedbackScreenShow(){}
        virtual void notificationsScreenShow(){}
        virtual void pushTimeScreenShow(){}
        
    public:
// Internal
        virtual void logEvent(string eventName) = 0;
        virtual void logEvent(string eventName, Json::Value parameters) = 0;
    };
    
    typedef reff<_Analytics> Analytics;
    
};

#endif /* analytics_h */
