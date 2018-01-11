//
//  NetworkingServiceFactoryImpl.m
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "NetworkingServiceFactoryImpl.h"
#import "networkingservicefactoryimpl.h"


namespace horo {
    class NetworkingServiceFactoryObjc : public NetworkingServiceFactory {
    public:
        NetworkingServiceFactoryObjc() {}
        virtual ~NetworkingServiceFactoryObjc() {}
        
        virtual NetworkingService *createNetworkingService(){
            return nullptr;
        }
    };
};


+ (horo::NetworkingServiceFactoryObjc *)sharedFactory {
    static horo::NetworkingServiceFactoryObjc *sharedFactory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFactory = new horo::NetworkingServiceFactoryObjc();
    });
    return sharedFactory;
}

@implementation NetworkingServiceFactoryImpl

@end
