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
    
WebViewServiceObjc::WebViewServiceObjc(strong<WebViewServiceFactory> factory) : factory_(factory) {
    NSCParameterAssert(factory.get());
}

WebViewServiceObjc::~WebViewServiceObjc() {
}

void WebViewServiceObjc::beginRequest(string path,
                                      function<void(strong<HttpResponse> response, Json::Value value)> successBlock,
                                      function<void(error err)> failBlock,
                                      function<void(WebViewServiceMessages message)> serviceBlock) {
    
    NSString *pathString = [NSString stringWithCString:path.c_str() encoding:[NSString defaultCStringEncoding]];
    NSString *baseUrl = [HTTPSessionManager sharedClient].baseURL.absoluteString;
    NSString *urlString = [baseUrl stringByAppendingString:pathString];
    [[Controllers shared].webViewController loadURLWithPath:[NSURL URLWithString:urlString]
                                                 completion:^(NSString *html, NSURL *url, NSError *error) {
                                                     NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
                                                     requestCompleted(url, data, successBlock, failBlock);
                                                 }
                                               serviceBlock:^(WebViewServiceMessages message) {
                                                   if (serviceBlock) {
                                                       serviceBlock(message);
                                                   }
                                               }];
}

void WebViewServiceObjc::swipeToBottom(function<void(strong<HttpResponse> response, Json::Value value)> successBlock, function<void(error err)> failBlock) {
    [[Controllers shared].webViewController triggerSwipeToBottomWithCompletion:^(NSString *html, NSURL *url, NSError *error) {
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        requestCompleted(url, data, successBlock, failBlock);
    }];
}

void WebViewServiceObjc::cancel() {
    [[Controllers shared].webViewController cancel];
}
    
void WebViewServiceObjc::requestCompleted(NSURL *url,
                                          id JSON,
                                          std::function<void(strong<HttpResponse> response, Json::Value value)> successBlock,
                                          std::function<void(error err)> failBlock) {
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
}
    
};

