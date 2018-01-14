//
//  facebookfriendsprovider.h
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef facebookfriendsprovider_h
#define facebookfriendsprovider_h

#include "friendsprovider.h"
#include "managers/webviewservice/webviewservicefactory.h"
#include "managers/webviewservice/webviewservice.h"
#include "friends/htmlparserfactory/htmlparserfactory.h"
#include "managers/webviewservice/httpresponse.h"
#include "managers/timerfactory/timerfactory.h"
#include "classes/rungtimer/rungtimer.h"

namespace horo {
    class FacebookFriendsProvider : public FriendsProvider {
    public:
        FacebookFriendsProvider(strong<WebViewServiceFactory> factory,
                                strong<HtmlParserFactory> parserFactory,
                                strong<TimerFactory> timerFactory)
        : factory_(factory)
        , parserFactory_(parserFactory)
        , timerFactory_(timerFactory)
        {
            SCParameterAssert(factory_.get());
            SCParameterAssert(parserFactory_.get());
            SCParameterAssert(timerFactory_.get());
        }
        ~FacebookFriendsProvider() override {}
    public:
        void requestFriendsList(std::function<void(Json::Value friends, std::string nextUrl, RequestStatus status)> completion, void *webViewControllerUIDelegate) override;
        void cancelRequest() override;
        bool webViewDidLoad(std::string url) override;
        void requestUserInformation(string path, std::function<void(DateWrapper birthday, bool success)> completion) override;
        
    private:
        void parseHomePage(Json::Value json);
        void parseUserInformationPage(Json::Value json);
        void parseFriendsPage(Json::Value json);
        void parseUserDetailPage(Json::Value json);
        
    private:
        void operationDidFinishedWithError();
        
    private:
        void executeHomePageRequest();
        void doExecuteHomePageRequest();
        void executeUserInformationPageRequest(std::string path);
        void executeFriendsPageRequest(std::string path);
        void executeUserDetailPageRequest(string path);
        void executeRequestFriendsNextPage();
        void executeRequest(std::string path, std::function<void(strong<HttpResponse> response, Json::Value value)> callback, bool swipeToBottom=false);
        void executeRequest(bool swipeToBottom=false);
        
    public:
        bool isRequiredAuthorizationResponse(strong<HttpResponse> response);
        
    private:
        strong<HtmlParserFactory> parserFactory_;
        strong<WebViewServiceFactory> factory_;
        strong<WebViewService> request_;
        std::function<void(Json::Value friends,
                           std::string nextUrl,
                           RequestStatus status)> callback_;
        std::string currentPath_;
        std::string friendsUrl_;
        std::function<void(DateWrapper birthday, bool success)> userInformationCompletion_;
        std::function<void(strong<HttpResponse> response, Json::Value value)> currentCallback_;
        strong<TimerFactory> timerFactory_;
        strong<RungTimer> responseTimeoutTimer_;
        function<void(WebViewServiceMessages message)> serviceBlock_;
        void *webViewControllerUIDelegate_;
    };
};

#endif /* facebookfriendsprovider_h */
