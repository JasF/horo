//
//  facebookfriendsprovider.c
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "facebookfriendsprovider.h"
#include "friends/htmlparser/htmlparser.h"
#include <algorithm>
#include <string>
#include "data/url.h"
#include "data/datewrapper.h"

namespace horo {
    using namespace std;
  
void FacebookFriendsProvider::requestFriendsList(std::function<void(Json::Value friends,
                                                                    std::string nextUrl,
                                                                    RequestStatus status)> completion) {
    callback_ = completion;
    executeHomePageRequest();
}
    
void FacebookFriendsProvider::executeHomePageRequest() {
    strong<FacebookFriendsProvider> aProvider(this);
    executeRequest("home.php", [aProvider](strong<HttpResponse> response, Json::Value json) {
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
    friendsUrl_ = path;
    strong<FacebookFriendsProvider> aProvider(this);
    executeRequest(path, [aProvider](strong<HttpResponse> response, Json::Value json) {
        aProvider->parseFriendsPage(json);
    });
}
    
void FacebookFriendsProvider::executeUserDetailPageRequest(string path) {
    SCParameterAssert(path.length());
    if (!path.length()) {
        return;
    }
    executeRequest(path, [this](strong<HttpResponse> response, Json::Value json) {
        this->parseUserDetailPage(json);
    });
}

void FacebookFriendsProvider::executeRequestFriendsNextPage() {
    strong<FacebookFriendsProvider> aProvider(this);
    Json::Value parameters;
    parameters["triggerSwipeToBottom"]=1;
    executeRequest(friendsUrl_, parameters, [aProvider](strong<HttpResponse> response, Json::Value json) {
        aProvider->parseFriendsPage(json);
    });
}

void FacebookFriendsProvider::executeRequest(std::string path, std::function<void(strong<HttpResponse> response, Json::Value value)> callback) {
    Json::Value parameters;
    executeRequest(path, parameters, callback);
}
    
void FacebookFriendsProvider::executeRequest(std::string path, Json::Value parameters, std::function<void(strong<HttpResponse> response, Json::Value value)> callback)
{
    if (path.find("http") != string::npos) {
        path = ReplaceAll(path, "https://m.facebook.com/", "");
    }
    if (path.length() && path[0] == '/') {
        path = path.substr(1, path.length()-1);
    }
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
    parameters_["webViewFriendsLoading"]=1;
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
        Json::Value friends;
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
        //executeRequest();
        return false;
    }
    return false;
}
    
void FacebookFriendsProvider::requestUserInformation(string path, std::function<void(DateWrapper birthday)> completion) {
    userInformationCompletion_ = completion;
    if (path.find("profile.php") == string::npos) {
        size_t index = path.find("?");
        if (index != string::npos) {
            path = path.substr(0, index);
        }
        path += "/about";
    }
    else {
        path += "&v=info";
    }
    executeUserDetailPageRequest(path);
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
    
    Json::Value persons = result["results"];
    if (callback_) {
        callback_(persons, "", Partial);
    };
    executeRequestFriendsNextPage();    
}

void FacebookFriendsProvider::parseUserDetailPage(Json::Value json) {
    std::string text = json["text"].asString();
    strong<HtmlParser> parser = parserFactory_->createFacebookUserDetailParser(text);
    Json::Value result = parser->parse();
    string dateString = result["birthdayTimestamp"].asString();
    DateWrapper wrapper;
    if (dateString.length()) {
        DateWrapper date(dateString);
        wrapper = date;
    }
    if (userInformationCompletion_) {
        userInformationCompletion_(wrapper);
    }
}

void FacebookFriendsProvider::operationDidFinishedWithError() {
    Json::Value friends;
    if (callback_) {
        callback_(friends, "", Failed);
    };
}

};
