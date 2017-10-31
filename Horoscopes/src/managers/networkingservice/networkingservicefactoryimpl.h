//
//  networkingservicefactoryimpl.hpp
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef networkingservicefactoryimpl_hpp
#define networkingservicefactoryimpl_hpp

#include <stdio.h>
#include "networkingservicefactory.h"

namespace horo {
    
    
  
class NetworkingServiceFactoryImpl : public NetworkingServiceFactory {
public:
    static void setPrivateInstance(NetworkingServiceFactory *instance);
public:
    NetworkingServiceFactoryImpl();
    ~NetworkingServiceFactoryImpl() override;
public: //abs
    strong<NetworkingService> createNetworkingService() override;
    strong<HttpResponse> createHttpResponse() override;
};
    
};

#endif /* networkingservicefactoryimpl_hpp */
