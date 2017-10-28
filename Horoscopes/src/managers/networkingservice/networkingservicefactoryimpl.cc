//
//  networkingservicefactoryimpl.cpp
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "networkingservicefactoryimpl.h"

namespace horo {
  
static NetworkingServiceFactory *privateInstance = nullptr;
    
void NetworkingServiceFactoryImpl::setPrivateInstance(NetworkingServiceFactory *instance) {
    privateInstance = instance;
}

NetworkingService *NetworkingServiceFactoryImpl::createNetworkingService() {
    if (privateInstance) {
        return privateInstance->createNetworkingService();
    }
    return nullptr;
}
    
HttpResponse *NetworkingServiceFactoryImpl::createHttpResponse() {
    if (privateInstance) {
        return privateInstance->createHttpResponse();
    }
    return nullptr;
}
    
NetworkingServiceFactoryImpl::NetworkingServiceFactoryImpl() {
    
}

NetworkingServiceFactoryImpl::~NetworkingServiceFactoryImpl() {
    
}
};
