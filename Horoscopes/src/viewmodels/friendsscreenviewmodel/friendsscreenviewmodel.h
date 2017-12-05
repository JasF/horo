//
//  friendsscreenviewmodel.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef friendsscreenviewmodel_h
#define friendsscreenviewmodel_h

#include "base/horobase.h"
#include "data/person.h"

namespace horo {
  
    class _FriendsScreenViewModel {
    public:
        virtual ~_FriendsScreenViewModel(){}
    public:
        virtual void updateFriendsFromFacebook() = 0;
        virtual void menuTapped() = 0;
        virtual bool webViewDidLoad(std::string url) = 0;
        virtual int friendsCount()=0;
        virtual void friendDataAtIndex(int index, std::function<void(string name, string birthday)> callback)=0;
        virtual void friendWithIndexSelected(int index)=0;
        
    public:
        std::function<void(bool success)> userLoggedInCallback_ = nullptr;
        std::function<void(std::string url, std::vector<std::string> allowedPatterns)> authorizationUrlCallback_ = nullptr;
        std::function<void(set<strong<Person>> friends)> friendsUpdatedCallback_ = nullptr;
    };
    
    typedef reff<_FriendsScreenViewModel> FriendsScreenViewModel;
};

#endif /* friendsscreenviewmodel_h */
