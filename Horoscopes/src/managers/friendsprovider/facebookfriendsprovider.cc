//
//  facebookfriendsprovider.c
//  Horoscopes
//
//  Created by Jasf on 05.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "facebookfriendsprovider.h"

namespace horo {
  
void FacebookFriendsProvider::requestFriendsList(std::function<void(std::vector<FacebookFriend> friends,
                                                                    std::string nextUrl,
                                                                    RequestStatus status)> completion) {
    if (completion) {
        std::vector<FacebookFriend> friends;
        completion(friends, "", Unknown);
    }
}

};
