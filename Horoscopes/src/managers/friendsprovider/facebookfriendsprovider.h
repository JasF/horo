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
#include "managers/networkingservice/networkingservicefactory.h"
#include "managers/networkingservice/networkingservice.h"
#include "friends/htmlparserfactory/htmlparserfactory.h"
#include "managers/networkingservice/httpresponse.h"

namespace horo {
    class FacebookFriendsProvider : public FriendsProvider {
    public:
        FacebookFriendsProvider(strong<NetworkingServiceFactory> factory,
                                strong<HtmlParserFactory> parserFactory)
        : factory_(factory)
        , parserFactory_(parserFactory)
        {
            SCParameterAssert(factory_.get());
            SCParameterAssert(parserFactory_.get());
        }
        ~FacebookFriendsProvider() override {}
    public:
        void requestFriendsList(std::function<void(std::vector<GenericFriend> friends, std::string nextUrl, RequestStatus status)> completion) override;
        bool webViewDidLoad(std::string url) override;
        
    private:
        void parseHomePage(Json::Value json);
        void parseUserInformationPage(Json::Value json);
        void parseFriendsPage(Json::Value json);
        
        void operationDidFinishedWithError();
        
        void executeHomePageRequest();
        void executeUserInformationPageRequest(std::string path);
        void executeFriendsPageRequest(std::string path);
        void executeRequest(std::string path, std::function<void(strong<HttpResponse> response, Json::Value value)> callback);
        void executeRequest();
        
    public:
        bool isRequiredAuthorizationResponse(strong<HttpResponse> response);
        
    private:
        strong<HtmlParserFactory> parserFactory_;
        strong<NetworkingServiceFactory> factory_;
        strong<NetworkingService> request_;
        std::function<void(std::vector<GenericFriend> friends,
                           std::string nextUrl,
                           RequestStatus status)> callback_;
        std::string currentPath_;
        std::function<void(strong<HttpResponse> response, Json::Value value)> currentCallback_;
    };
};

#endif /* facebookfriendsprovider_h */
