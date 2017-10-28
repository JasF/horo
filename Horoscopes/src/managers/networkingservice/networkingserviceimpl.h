//
//  networkingserviceimpl.h
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef networkingserviceimpl
#define networkingserviceimpl

#include <stdio.h>
#include "networkingservice.h"

namespace horo {
  
    class NetworkingServiceImpl : public NetworkingService {
    public:
        NetworkingServiceImpl();
        ~NetworkingServiceImpl() override;
        
    public:
        void beginRequest(std::string url, std::function<void(Json::Value value)> callback) override;
    };
    
};

#endif /* networkingserviceimpl */
