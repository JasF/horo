//
//  WebViewServiceFactoryImpl.m
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "WebViewServiceFactoryObjc.h"
#include "../src/managers/webviewservice/webviewservicefactoryimpl.h"
#include "WebViewServiceObjc.h"
#include "HttpResponseObjc.h"

namespace horo {
    class WebViewServiceFactoryObjc : public WebViewServiceFactory {
    public:
        WebViewServiceFactoryObjc() {}
        virtual ~WebViewServiceFactoryObjc() {
            LOG(LS_WARNING) << "!";
        }
        
        virtual strong<WebViewService> createWebViewService(){
            this->AddRef();
            return new horo::WebViewServiceObjc(this);
        }
        virtual strong<HttpResponse> createHttpResponse() {
            return new horo::HttpResponseObjc();
        }
    };
};


@implementation WebViewServiceFactoryObjc

+ (horo::WebViewServiceFactoryObjc *)sharedFactory {
    static horo::WebViewServiceFactoryObjc *sharedFactory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFactory = new horo::WebViewServiceFactoryObjc();
    });
    return sharedFactory;
}

+ (void)doLoading {
    horo::WebViewServiceFactoryImpl::setPrivateInstance([self sharedFactory]);
}
@end
