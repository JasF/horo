//
//  serializerimpl.c
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "serializerimpl.h"

namespace horo {
  
    strong<Serializer> g_privateInstance = nullptr;
    void SerializerImpl::setPrivateInstance(strong<Serializer> privateInstance) {
        g_privateInstance = privateInstance;
    }

    SerializerImpl::SerializerImpl() {
        
    }
    
    SerializerImpl::~SerializerImpl() {
        
    }
    
    void SerializerImpl::saveString(std::string key, std::string value) {
        if (g_privateInstance.get()) {
            g_privateInstance->saveString(key, value);
        }
    }
    
    std::string SerializerImpl::loadString(std::string key) {
        if (g_privateInstance.get()) {
            return g_privateInstance->loadString(key);
        }
        return "";
    }
    
};
