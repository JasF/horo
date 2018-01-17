//
//  analyticsimpl.h
//  Horoscopes
//
//  Created by Jasf on 17.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef analyticsimpl_h
#define analyticsimpl_h

#include "managers/analytics/analytics.h"

namespace horo {
    
    class AnalyticsImpl : public Analytics {
    public:
        static void setPrivateInstance(Analytics *privateInstance);
    public:
        AnalyticsImpl();
        ~AnalyticsImpl() override;
        
    protected:
        // ScreensManager
        void predictionScreenShow(bool withPerson, bool fromPush) override;
        void welcomeScreenShow() override { logEvent("welcomeScreenShow"); }
        void menuScreenShow() override { logEvent("menuScreenShow"); }
        void friendsScreenShow() override { logEvent("friendsScreenShow"); }
        void accountScreenShow() override { logEvent("accountScreenShow"); }
        void feedbackScreenShow() override { logEvent("feedbackScreenShow"); }
        void notificationsScreenShow() override { logEvent("notificationsScreenShow"); }
        void pushTimeScreenShow() override { logEvent("pushTimeScreenShow"); }
        
    private:
        void logEvent(string eventName) override;
        void logEvent(string eventName, Json::Value parameters) override;
    };
    
};

#endif /* analyticsimpl_h */
