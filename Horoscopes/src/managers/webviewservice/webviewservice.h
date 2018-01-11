//
//  webviewservice.hpp
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef webviewservice_hpp
#define webviewservice_hpp

#include <stdio.h>
#include <functional>
#include <string.h>
#include "httpresponse.h"
#include "base/horobase.h"

namespace horo {
  
    typedef enum {
        WebViewServiceWillShowDialog,
        WebViewServiceWillHideDialog
    } WebViewServiceMessages;
    
    class _WebViewService {
    public:
        virtual ~_WebViewService() {}
        virtual void beginRequest(string path,
                                  function<void(strong<HttpResponse> response, Json::Value value)> successBlock,
                                  function<void(error err)> failBlock,
                                  function<void(WebViewServiceMessages message)> serviceBlock) = 0;
        virtual void swipeToBottom(std::function<void(strong<HttpResponse> response, Json::Value value)> successBlock, std::function<void(error err)> failBlock) = 0;
        virtual void cancel()=0;
    };
    
    typedef reff<_WebViewService> WebViewService;
};

#endif /* webviewservice_hpp */
