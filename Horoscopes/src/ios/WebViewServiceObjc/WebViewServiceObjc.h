//
//  WebViewServiceImpl.h
//  Horoscopes
//
//  Created by Jasf on 27.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "../src/managers/webviewservice/webviewservice.h"
#include "managers/webviewservice/webviewservicefactory.h"

@class NSURLSessionDataTask;

namespace horo {
    class WebViewServiceObjc : public WebViewService {
    public:
        WebViewServiceObjc(strong<WebViewServiceFactory> factory);
        ~WebViewServiceObjc() override;
        void beginRequest(std::string path,
                              Json::Value parameters,
                                  std::function<void(strong<HttpResponse> response, Json::Value value)> successBlock,
                                  std::function<void(error err)> failBlock) override;
        void cancel() override;
    private:
        strong<WebViewServiceFactory> factory_;
        __strong NSURLSessionDataTask *task_;
        bool usingWebViewServices_;
    };
};
