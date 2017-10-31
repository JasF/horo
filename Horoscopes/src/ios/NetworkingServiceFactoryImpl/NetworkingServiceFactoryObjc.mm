//
//  NetworkingServiceFactoryImpl.m
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "NetworkingServiceFactoryObjc.h"
#include "../src/managers/networkingservice/networkingservicefactoryimpl.h"
#include "NetworkingServiceObjc.h"
#include "HttpResponseObjc.h"

namespace horo {
    class NetworkingServiceFactoryObjc : public NetworkingServiceFactory {
    public:
        NetworkingServiceFactoryObjc() {}
        virtual ~NetworkingServiceFactoryObjc() {}
        
        virtual strong<NetworkingService> createNetworkingService(){
            return new horo::NetworkingServiceObjc(this);
        }
        virtual strong<HttpResponse> createHttpResponse() {
            return new horo::HttpResponseObjc();
        }
    };
};


@implementation NetworkingServiceFactoryObjc

+ (horo::NetworkingServiceFactoryObjc *)sharedFactory {
    static horo::NetworkingServiceFactoryObjc *sharedFactory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFactory = new horo::NetworkingServiceFactoryObjc();
    });
    return sharedFactory;
}

+ (void)load {
    
    horo::NetworkingServiceFactoryImpl::setPrivateInstance([self sharedFactory]);
}
@end
