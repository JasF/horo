//
//  analyticsimpl.c
//  Horoscopes
//
//  Created by Jasf on 17.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#include "analyticsimpl.h"

namespace horo {
  
static Analytics *g_privateInstance = nullptr;
void AnalyticsImpl::setPrivateInstance(Analytics *privateInstance) {
    g_privateInstance = privateInstance;
}

AnalyticsImpl::AnalyticsImpl() {
    
}

AnalyticsImpl::~AnalyticsImpl() {
    
}
    
void AnalyticsImpl::predictionScreenShow(bool withPerson, bool fromPush) {
    Json::Value parameters;
    parameters["withPerson"]=withPerson;
    parameters["fromPush"]=fromPush;
    logEvent("predictionScreenShow", parameters);
}

// Private Methods
void AnalyticsImpl::logEvent(string eventName) {
    if (g_privateInstance) {
        g_privateInstance->logEvent(eventName);
    }
}

void AnalyticsImpl::logEvent(string eventName, Json::Value parameters) {
    if (g_privateInstance) {
        g_privateInstance->logEvent(eventName, parameters);
    }
}

};
