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
#include "base/horobase.h"

namespace horo {
    class _NetworkingServiceFactory {
    public:
        virtual ~_NetworkingServiceFactory() {}
        virtual NetworkingService *createNetworkingService()=0;
        virtual strong<HttpResponse> createHttpResponse()=0;
    };
    
    class NetworkingServiceFactory : public rtc::RefCountedObject<_NetworkingServiceFactory> {};
};


#endif /* networkingservicefactory_h */
