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

static const int kParsingFailedError = -1;

namespace horo {
    
    using namespace std;
    
NetworkingServiceObjc::NetworkingServiceObjc(NetworkingServiceFactory *factory) : factory_(factory) {
     
}

NetworkingServiceObjc::~NetworkingServiceObjc() {
}

NSDictionary *dictionaryFromJsonValue(Json::Value parameters) {
    NSMutableDictionary *result = [NSMutableDictionary new];
    for( Json::ValueIterator it = parameters.begin(); it != parameters.end(); ++it )
    {
        std::string key = it.key().asString();
        NSString *keyString = [NSString stringWithCString:key.c_str() encoding:[NSString defaultCStringEncoding]];
        NSCAssert(keyString.length, @"keyString is nil");
        if (!keyString) {
            continue;
        }
        Json::Value &value = *it;
        if (value.isNumeric()) {
            [result setObject:@(value.asInt()) forKey:keyString];
        }
        else if (value.isString()) {
            NSString *valueString = [NSString stringWithCString:value.asString().c_str() encoding:[NSString defaultCStringEncoding]];
            [result setObject:valueString forKey:keyString];
        }
        else {
            NSCAssert(NO, @"Unexpected type for value: %@.", @(value.type()));
        }
    }
    
    return [result copy];
}

void NetworkingServiceObjc::beginRequest(std::string path,
                                             Json::Value parameters,
                                             std::function<void(strong<HttpResponse> response, Json::Value value)> successBlock,
                                             std::function<void(error err)> failBlock) {
    LOG(LS_WARNING) << path;
    NSString *pathString = [NSString stringWithCString:path.c_str() encoding:[NSString defaultCStringEncoding]];
        NSDictionary *dictionaryParameters = dictionaryFromJsonValue(parameters);
    NSMutableSet *set = [NSMutableSet new];
    [set addObject:@"text/plain"];
    [HTTPSessionManager sharedClient].responseSerializer.acceptableContentTypes = set;
    [[HTTPSessionManager sharedClient] GET:pathString parameters:dictionaryParameters progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
        
        char *storage = new char[data.length];
        [data getBytes:storage length:data.length];
        Json::Reader reader;
        Json::Value root;
        if (!reader.parse(std::string(storage), root)) {
            error cerr("parsing failed error", kParsingFailedError);
            if (failBlock) {
                failBlock(cerr);
            }
            return;
        }
        strong<HttpResponse> respone = factory_->createHttpResponse();
        delete[]storage;
        if (successBlock) {
            successBlock(respone, root);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *aError) {
        error cerr([[aError localizedDescription] UTF8String], (int)[aError code]);
        if (failBlock) {
            failBlock(cerr);
        }
    }];
}

};

