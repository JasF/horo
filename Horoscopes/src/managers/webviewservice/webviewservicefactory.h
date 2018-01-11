//
//  webviewservicefactory.h
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef webviewservicefactory_h
#define webviewservicefactory_h

#include "webviewservice.h"
#include "httpresponse.h"
#include "base/horobase.h"

namespace horo {
    class _WebViewServiceFactory {
    public:
        virtual ~_WebViewServiceFactory() {}
        virtual strong<WebViewService> createWebViewService()=0;
        virtual strong<HttpResponse> createHttpResponse()=0;
    };
    
    typedef reff<_WebViewServiceFactory> WebViewServiceFactory;
};


#endif /* webviewservicefactory_h */
