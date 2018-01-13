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
#include "classes/rungtimer/rungtimer.h"

namespace horo {
    using namespace std;
  
void FacebookFriendsProvider::requestFriendsList(std::function<void(Json::Value friends,
                                                                    std::string nextUrl,
                                                                    RequestStatus status)> completion) {
    callback_ = completion;
    executeHomePageRequest();
}
    
void FacebookFriendsProvider::cancelRequest() {
    if (request_.get()) {
        request_->cancel();
    }
}

void FacebookFriendsProvider::executeHomePageRequest() {
    vector<int> timeouts = {2,3,4,5,6,7,8,9,10,11,12};
    responseTimeoutTimer_ = new RungTimer(timerFactory_, timeouts, [this]() {
        LOG(LS_WARNING) << "\n\n\n*************** RESTARTING DUE INACTIVITY *********\n\n\n";
        if (request_) {
            request_->cancel();
            request_ = nullptr;
        }
        doExecuteHomePageRequest();
        return true;
    });
    doExecuteHomePageRequest();
}

void FacebookFriendsProvider::doExecuteHomePageRequest() {
    serviceBlock_ = [this](WebViewServiceMessages message) {
        responseTimeoutTimer_ = nullptr;
        serviceBlock_ = nullptr;
    };
    executeRequest("home.php", [this](strong<HttpResponse> response, Json::Value json) {
        responseTimeoutTimer_ = nullptr;
        serviceBlock_ = nullptr;
        parseHomePage(json);
    });
}
    
void FacebookFriendsProvider::executeUserInformationPageRequest(string path) {
    SCParameterAssert(path.length());
    if (!path.length()) {
        return;
    }
    executeRequest(path, [this](strong<HttpResponse> response, Json::Value json) {
        parseUserInformationPage(json);
    });
}
    
void FacebookFriendsProvider::executeFriendsPageRequest(std::string path) {
    SCParameterAssert(path.length());
    if (!path.length()) {
        return;
    }
    {
        // AV: для ивента 'начала загрузки друзей'
        Json::Value persons;
        if (callback_) {
            callback_(persons, "", Partial);
        };
    }
    friendsUrl_ = path;
    executeRequest(path, [this](strong<HttpResponse> response, Json::Value json) {
        parseFriendsPage(json);
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
    executeRequest(friendsUrl_, [this](strong<HttpResponse> response, Json::Value json) {
        parseFriendsPage(json);
    }, true);
}

void FacebookFriendsProvider::executeRequest(std::string path, std::function<void(strong<HttpResponse> response, Json::Value value)> callback, bool swipeToBottom)
{
    if (path.find("http") != string::npos) {
        path = ReplaceAll(path, "https://m.facebook.com/", "");
    }
    if (path.length() && path[0] == '/') {
        path = path.substr(1, path.length()-1);
    }
    currentPath_ = path;
    currentCallback_ = callback;
    executeRequest(swipeToBottom);
}
    
void FacebookFriendsProvider::executeRequest(bool swipeToBottom) {
    request_ = factory_->createWebViewService();
    auto aCallback = currentCallback_;
    
    function<void(strong<HttpResponse> response, Json::Value json)> successBlock = [this, aCallback](strong<HttpResponse> response, Json::Value json) {
        if (isRequiredAuthorizationResponse(response)) {
            return;
        }
        if (aCallback) {
            aCallback(response, json);
        }
    };
    
    function<void(error aErr)> failBlock = [this](error aErr) {
        operationDidFinishedWithError();
    };
    
    if (swipeToBottom) {
        request_->swipeToBottom(successBlock, failBlock);
    }
    else {
        request_->beginRequest(currentPath_, successBlock, failBlock, [this](WebViewServiceMessages message) {
            if (serviceBlock_) {
                serviceBlock_(message);
            }
        });
    }
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
    
void FacebookFriendsProvider::requestUserInformation(string path, std::function<void(DateWrapper birthday, bool success)> completion) {
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
    string nextUrl = "/friends/center/friends/";
    executeFriendsPageRequest(nextUrl);
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
        userInformationCompletion_(wrapper, true);
    }
}

void FacebookFriendsProvider::operationDidFinishedWithError() {
    Json::Value friends;
    if (callback_) {
        callback_(friends, "", Failed);
    };
}

};
