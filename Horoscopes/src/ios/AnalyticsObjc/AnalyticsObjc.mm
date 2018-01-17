//
//  AnalyticsObjc.m
//  Horoscopes
//
//  Created by Jasf on 17.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "AnalyticsObjc.h"
#import "NSDictionary+Horo.h"
#import "AnalyticsProviders.h"
#include "managers/analytics/analyticsimpl.h"

using namespace horo;

namespace horo {
  
    class AnalyticsCC : public Analytics {
    public:
        static AnalyticsCC *shared() {
            static AnalyticsCC *sharedInstance = nullptr;
            if (!sharedInstance) {
                sharedInstance = new AnalyticsCC();
            }
            return sharedInstance;
        }
    private:
        AnalyticsCC() : providers_([AnalyticsProviders new]) {
            NSCParameterAssert(providers_);
        }
        ~AnalyticsCC() override {}
        
    private:
        void logEvent(string eventName) override {
            [providers_ logEvent:[NSString stringWithUTF8String:eventName.c_str()]];
        }
        
        void logEvent(string eventName, Json::Value parameters) override {
            [providers_ logEvent:[NSString stringWithUTF8String:eventName.c_str()] parameters:[NSDictionary horo_dictionaryFromJsonValue:parameters]];
        }
        
    private:
        AnalyticsProviders *providers_;
    };
    
};

@implementation AnalyticsObjc
+ (void)doLoading {
    AnalyticsImpl::setPrivateInstance(AnalyticsCC::shared());
}
@end
