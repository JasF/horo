//
//  friendsscreenmodel.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef friendsscreenmodel_h
#define friendsscreenmodel_h

#include "base/horobase.h"
#include "data/person.h"

namespace horo {
  
    class _FriendsScreenModel {
    public:
        virtual ~_FriendsScreenModel() {}
        
    public:
        virtual void updateFriendsFromFacebook() = 0;
        virtual bool webViewDidLoad(std::string url) = 0;
        virtual void friendWithIndexSelected(int index) = 0;
        virtual list<strong<Person>> allFriends() = 0;
        
    public:
        std::function<void(std::string url, std::vector<std::string> allowedPatterns)> authorizationUrlCallback_ = nullptr;
        std::function<void(set<strong<Person>> friends)> friendsUpdatedCallback_ = nullptr;
        
    };
    
    typedef reff<_FriendsScreenModel> FriendsScreenModel;
};

#endif /* friendsscreenmodel_h */
