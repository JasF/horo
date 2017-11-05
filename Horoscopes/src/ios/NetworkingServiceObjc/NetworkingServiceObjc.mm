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
#include "NSDictionary+Horo.h"

static const int kParsingFailedError = -1;

namespace horo {
    
    using namespace std;
    
NetworkingServiceObjc::NetworkingServiceObjc(strong<NetworkingServiceFactory> factory) : factory_(factory) {
    NSCParameterAssert(factory.get());
}

NetworkingServiceObjc::~NetworkingServiceObjc() {
}

void NetworkingServiceObjc::beginRequest(std::string path,
                                             Json::Value parameters,
                                             std::function<void(strong<HttpResponse> response, Json::Value value)> successBlock,
                                             std::function<void(error err)> failBlock) {
    LOG(LS_WARNING) << path;
    NSString *pathString = [NSString stringWithCString:path.c_str() encoding:[NSString defaultCStringEncoding]];
    NSDictionary *dictionaryParameters = [NSDictionary horo_dictionaryFromJsonValue:parameters];
    NSMutableSet *set = [NSMutableSet new];
    [set addObject:@"text/plain"];
    [set addObject:@"text/html"];
    [HTTPSessionManager sharedClient].responseSerializer.acceptableContentTypes = set;
    [[HTTPSessionManager sharedClient] GET:pathString parameters:dictionaryParameters progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        if ([JSON isKindOfClass:[NSData class]]) {
            NSString *text = [[NSString alloc] initWithData:(NSData *)JSON encoding:NSUTF8StringEncoding];
            if (text.length) {
                JSON = @{@"text" : text};
            }
            else {
                JSON = nil;
            }
            
        }
       
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
            delete[]storage;
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

