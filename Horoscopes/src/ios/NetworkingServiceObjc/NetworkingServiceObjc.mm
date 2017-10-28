//
//  NetworkingServiceImpl.m
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "NetworkingServiceObjc.h"
#include "rtc_base/logging.h"
#import "AFHTTPSessionManager.h"
#import "HTTPSessionManager.h"
#include "json/reader.h"

namespace horo {
    
NetworkingServiceObjc::NetworkingServiceObjc() {
}

NetworkingServiceObjc::~NetworkingServiceObjc() {
}

    void NetworkingServiceObjc::beginRequest(std::string url, std::function<void(Json::Value value)> callback) {
    LOG(LS_WARNING) << url;
    NSMutableSet *set = [NSMutableSet new];
    [set addObject:@"text/plain"];
    [HTTPSessionManager sharedClient].responseSerializer.acceptableContentTypes = set;
    [[HTTPSessionManager sharedClient] GET:@"byZodiac" parameters:@{@"id":@"ok"} progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
        
        char *storage = new char[data.length];
        [data getBytes:storage length:data.length];
        Json::Reader reader;
        Json::Value root;
        if (!reader.parse(std::string(storage), root)) {
            // failed.
            return;
        }
        delete[]storage;
        if (callback) {
            callback(root);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        LOG(LS_WARNING) << "!";
       // if (block) {
      //      block([NSArray array], error);
      //  }
    }];
}

};
    
@implementation NetworkingServiceImpl
/*
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
*/
@end
