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
        void beginRequest(string path,
                          function<void(strong<HttpResponse> response, Json::Value value)> successBlock,
                          function<void(error err)> failBlock,
                          function<void(WebViewServiceMessages message)> serviceBlock, void *webViewControllerUIDelegate) override;
        void swipeToBottom(std::function<void(strong<HttpResponse> response, Json::Value value)> successBlock, std::function<void(error err)> failBlock) override;
        void cancel() override;
        
    private:
        void requestCompleted(NSURL *url, id JSON, std::function<void(strong<HttpResponse> response, Json::Value value)> successBlock, std::function<void(error err)> failBlock);
        
    private:
        strong<WebViewServiceFactory> factory_;
    };
};
