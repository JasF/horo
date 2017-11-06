//
//  facebookfriendsprovider.c
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "facebookfriendsprovider.h"
#include "friends/htmlparser/htmlparser.h"

namespace horo {
    using namespace std;
  
void FacebookFriendsProvider::requestFriendsList(std::function<void(std::vector<GenericFriend> friends,
                                                                    std::string nextUrl,
                                                                    RequestStatus status)> completion) {
    callback_ = completion;
    executeHomePageRequest();
}
    
void FacebookFriendsProvider::executeHomePageRequest() {
    strong<FacebookFriendsProvider> aProvider(this);
    executeRequest("/home.php", [aProvider](strong<HttpResponse> response, Json::Value json) {
        aProvider->parseHomePage(json);
    });
}
    
void FacebookFriendsProvider::executeUserInformationPageRequest(string path) {
    SCParameterAssert(path.length());
    if (!path.length()) {
        return;
    }
    strong<FacebookFriendsProvider> aProvider(this);
    executeRequest(path, [aProvider](strong<HttpResponse> response, Json::Value json) {
        aProvider->parseUserInformationPage(json);
    });
}
    
void FacebookFriendsProvider::executeFriendsPageRequest(std::string path) {
    SCParameterAssert(path.length());
    if (!path.length()) {
        return;
    }
    Json::Value parameters;
    parameters["webViewFriendsLoading"]=1;
    strong<FacebookFriendsProvider> aProvider(this);
    executeRequest(path, parameters, [aProvider](strong<HttpResponse> response, Json::Value json) {
        aProvider->parseFriendsPage(json);
    });
}

void FacebookFriendsProvider::executeRequest(std::string path, std::function<void(strong<HttpResponse> response, Json::Value value)> callback) {
    Json::Value parameters;
    executeRequest(path, parameters, callback);
}
    
void FacebookFriendsProvider::executeRequest(std::string path, Json::Value parameters, std::function<void(strong<HttpResponse> response, Json::Value value)> callback) {
    currentPath_ = path;
    currentCallback_ = callback;
    executeRequest(parameters);
}

void FacebookFriendsProvider::executeRequest() {
    executeRequest(parameters_);
}
    
void FacebookFriendsProvider::executeRequest(Json::Value parameters) {
    strong<FacebookFriendsProvider> aProvider(this);
    request_ = factory_->createNetworkingService();
    auto aCallback = currentCallback_;
    parameters_ = parameters;
    request_->beginRequest(currentPath_, parameters_, [aProvider, aCallback](strong<HttpResponse> response, Json::Value json) {
        if (aProvider->isRequiredAuthorizationResponse(response)) {
            return;
        }
        if (aCallback) {
            aCallback(response, json);
        }
    }, [aProvider](error aErr) {
        aProvider->operationDidFinishedWithError();
    });
}

bool FacebookFriendsProvider::isRequiredAuthorizationResponse(strong<HttpResponse> response) {
    if (!response.get()) {
        return false;
    }
    std::string url = response->url_;
    if (url.find("login") != std::string::npos) {
        std::vector<GenericFriend> friends;
        if (callback_) {
            callback_(friends, response->url_, AuthorizationRequired);
        };
        return true;
    }
    return false;
}

bool FacebookFriendsProvider::webViewDidLoad(std::string url) {
    if (url.find("login") != std::string::npos) {
        return true;
    }
    else if (url.find(currentPath_) != std::string::npos) {
        executeRequest();
        return false;
    }
    return true;
}
    
void FacebookFriendsProvider::parseHomePage(Json::Value json) {
    std::string text = json["text"].asString();
    strong<HtmlParser> parser = parserFactory_->createFacebookHomePageParser(text);
    Json::Value result = parser->parse();
    std::string nextUrl = result["url"].asString();
    if (!nextUrl.length()) {
        operationDidFinishedWithError();
        return;
    }
    executeUserInformationPageRequest(nextUrl);
}
    
void FacebookFriendsProvider::parseUserInformationPage(Json::Value json) {
    std::string text = json["text"].asString();
    strong<HtmlParser> parser = parserFactory_->createFacebookUserInformationParser(text);
    Json::Value result = parser->parse();
    std::string nextUrl = result["url"].asString();
    if (!nextUrl.length()) {
        operationDidFinishedWithError();
        return;
    }
    executeFriendsPageRequest(nextUrl);
}

void FacebookFriendsProvider::parseFriendsPage(Json::Value json) {
    std::string text = json["text"].asString();
    strong<HtmlParser> parser = parserFactory_->createFacebookFriendsParser(text);
    Json::Value result = parser->parse();
    Json::Value array = result["results"];
    LOG(LS_WARNING) << "friends: " << array.toStyledString();
}

void FacebookFriendsProvider::operationDidFinishedWithError() {
    std::vector<GenericFriend> friends;
    if (callback_) {
        callback_(friends, "", Failed);
    };
}

};