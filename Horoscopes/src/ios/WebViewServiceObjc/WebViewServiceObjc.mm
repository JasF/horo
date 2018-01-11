//
//  WebViewServiceImpl.m
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "WebViewServiceObjc.h"
#include "rtc_base/logging.h"
#import "AFHTTPSessionManager.h"
#import "HTTPSessionManager.h"
#include "json/reader.h"
#include "NSDictionary+Horo.h"
#import "Controllers.h"

static const int kParsingFailedError = -1;

namespace horo {
    
    using namespace std;
    
WebViewServiceObjc::WebViewServiceObjc(strong<WebViewServiceFactory> factory) : factory_(factory),
    usingWebViewServices_(false) {
    NSCParameterAssert(factory.get());
}

WebViewServiceObjc::~WebViewServiceObjc() {
}

void WebViewServiceObjc::beginRequest(std::string path,
                                             Json::Value parameters,
                                             std::function<void(strong<HttpResponse> response, Json::Value value)> successBlock,
                                             std::function<void(error err)> failBlock) {
    
    auto safeSuccess = ^(NSURL *url, id JSON) {
        if (!JSON) {
            error cerr("zero error", kParsingFailedError);
            if (failBlock) {
                failBlock(cerr);
            }
            return;
        }
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
        if (url) {
            respone->url_ = [url.absoluteString UTF8String];
        }
        delete[]storage;
        if (successBlock) {
            successBlock(respone, root);
        }
    };
    NSString *pathString = [NSString stringWithCString:path.c_str() encoding:[NSString defaultCStringEncoding]];
    NSMutableDictionary *dictionaryParameters = [[NSDictionary horo_dictionaryFromJsonValue:parameters] mutableCopy];
    if ([dictionaryParameters[@"triggerSwipeToBottom"] boolValue]) {
        usingWebViewServices_ = true;
        [dictionaryParameters removeObjectForKey:@"triggerSwipeToBottom"];
        [[Controllers shared].webViewController triggerSwipeToBottomWithCompletion:^(NSString *html, NSURL *url, NSError *error) {
            NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
            safeSuccess(url, data);
        }];
        return;
    }
    if ([dictionaryParameters[@"webViewFriendsLoading"] boolValue]) {
        usingWebViewServices_ = true;
        [dictionaryParameters removeObjectForKey:@"webViewFriendsLoading"];
        NSString *baseUrl = [HTTPSessionManager sharedClient].baseURL.absoluteString;
        NSString *urlString = [baseUrl stringByAppendingString:pathString];
        [[Controllers shared].webViewController loadURLWithPath:[NSURL URLWithString:urlString]
                                                     completion:^(NSString *html, NSURL *url, NSError *error) {
                                                        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
                                                        safeSuccess(url, data);
                                                     }];
        return;
    }
    NSMutableSet *set = [NSMutableSet new];
    [set addObject:@"text/plain"];
    [set addObject:@"text/html"];
    [HTTPSessionManager sharedClient].responseSerializer.acceptableContentTypes = set;
    task_ = [[HTTPSessionManager sharedClient] GET:pathString parameters:dictionaryParameters progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        safeSuccess(task.response.URL, JSON);
    }
                                           failure:^(NSURLSessionDataTask *__unused task, NSError *aError) {
        error cerr([[aError localizedDescription] UTF8String], (int)[aError code]);
        if (failBlock) {
            failBlock(cerr);
        }
    }];
}

void WebViewServiceObjc::cancel() {
    if (task_) {
        [task_ cancel];
        task_ = nil;
    }
    if (usingWebViewServices_) {
        usingWebViewServices_ = false;
        [[Controllers shared].webViewController cancel];
    }
}
    
};

