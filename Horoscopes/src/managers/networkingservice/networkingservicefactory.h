//
//  networkingservicefactory.h
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef networkingservicefactory_h
#define networkingservicefactory_h

#include "networkingservice.h"
#include "httpresponse.h"

namespace horo {
    
    class NetworkingServiceFactory {
    public:
        virtual ~NetworkingServiceFactory() {}
        virtual NetworkingService *createNetworkingService()=0;
        virtual HttpResponse *createHttpResponse()=0;
    };
};


#endif /* networkingservicefactory_h */
