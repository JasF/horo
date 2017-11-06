//
//  facebookfriendsprovider.c
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "facebookfriendsprovider.h"

namespace horo {
  
void FacebookFriendsProvider::requestFriendsList(std::function<void(std::vector<GenericFriend> friends,
                                                                    std::string nextUrl,
                                                                    RequestStatus status)> completion) {
    callback_ = completion;
    request_ = factory_->createNetworkingService();
    executeHomePageRequest();
}
    
void FacebookFriendsProvider::executeHomePageRequest() {
    Json::Value parameters;
    strong<FacebookFriendsProvider> aProvider(this);
    auto aCallback = callback_;
    request_->beginRequest("/home.php", parameters, [aCallback, aProvider](strong<HttpResponse> response, Json::Value json) {
        std::string url = response->url_;
        if (url.find("login") != std::string::npos) {
            std::vector<GenericFriend> friends;
            if (aCallback) {
                aCallback(friends, response->url_, AuthorizationRequired);
            };
            return;
        }
        aProvider->parseHomePage(json);
    }, [aCallback](error aErr) {
        std::vector<GenericFriend> friends;
        if (aCallback) {
            aCallback(friends, "", Failed);
        };
        LOG(LS_WARNING) << "err:" << aErr.text_;
    });
}

bool FacebookFriendsProvider::webViewDidLoad(std::string url) {
    if (url.find("login") != std::string::npos) {
        return true;
    }
    else if (url.find("home.php") != std::string::npos) {
        return false;
    }
    return true;
}
    
void FacebookFriendsProvider::parseHomePage(Json::Value json) {
    std::string text = json["text"].asString();
    // зачем нам home page? ради авторизации конечно!
    // из home.php извлекаем ссылку на локальный профиль, из ссылки на локальный профиль ссылку на список друзей
    // -> home.php
    // information
    // friends
}

};
