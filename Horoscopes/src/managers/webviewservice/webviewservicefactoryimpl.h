//
//  webviewservicefactoryimpl.hpp
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef webviewservicefactoryimpl_hpp
#define webviewservicefactoryimpl_hpp

#include <stdio.h>
#include "webviewservicefactory.h"

namespace horo {
    
    
  
class WebViewServiceFactoryImpl : public WebViewServiceFactory {
public:
    static void setPrivateInstance(WebViewServiceFactory *instance);
public:
    WebViewServiceFactoryImpl();
    ~WebViewServiceFactoryImpl() override;
public: //abs
    strong<WebViewService> createWebViewService() override;
    strong<HttpResponse> createHttpResponse() override;
};
    
};

#endif /* webviewservicefactoryimpl_hpp */
