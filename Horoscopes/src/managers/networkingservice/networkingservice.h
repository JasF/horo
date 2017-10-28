//
//  networkingservice.hpp
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef networkingservice_hpp
#define networkingservice_hpp

#include <stdio.h>
#include <functional>
#include <string.h>
#include "base/horobase.h"

namespace horo {
  
    class _NetworkingService {
    public:
        virtual ~_NetworkingService() {}
        virtual void beginRequest(std::string url, std::function<void(Json::Value value)> successBlock) = 0;
    };
    
    class NetworkingService : public
    rtc::RefCountedObject<_NetworkingService> {};
};

#endif /* networkingservice_hpp */
