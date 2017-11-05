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
    /*
    if (completion) {
    }
     */
    request_ = factory_->createNetworkingService();
    Json::Value parameters;
    request_->beginRequest("/home.php", parameters, [completion](strong<HttpResponse> response, Json::Value json) {
        std::string url = response->url_;
        if (url.find("login") != std::string::npos) {
            std::vector<GenericFriend> friends;
            if (completion) {
                completion(friends, response->url_, AuthorizationRequired);
            };
            return;
        }
        LOG(LS_WARNING) << "success:: " << json.toStyledString();
    }, [](error aErr) {
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
    
};
