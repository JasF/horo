//
//  webviewservicefactoryimpl.cpp
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "webviewservicefactoryimpl.h"

namespace horo {
  
static WebViewServiceFactory *privateInstance = nullptr;
    
void WebViewServiceFactoryImpl::setPrivateInstance(WebViewServiceFactory *instance) {
    SCParameterAssert(instance);
    privateInstance = instance;
}

strong<WebViewService> WebViewServiceFactoryImpl::createWebViewService() {
    if (privateInstance) {
        return privateInstance->createWebViewService();
    }
    return nullptr;
}
    
strong<HttpResponse> WebViewServiceFactoryImpl::createHttpResponse() {
    if (privateInstance) {
        return privateInstance->createHttpResponse();
    }
    return nullptr;
}

WebViewServiceFactoryImpl::WebViewServiceFactoryImpl() {
    
}

WebViewServiceFactoryImpl::~WebViewServiceFactoryImpl() {
    
}
};
