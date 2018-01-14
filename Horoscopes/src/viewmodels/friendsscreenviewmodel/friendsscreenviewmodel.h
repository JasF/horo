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
#include "friendsscreenmodel.h"

namespace horo {
  
    class _FriendsScreenViewModel {
    public:
        virtual ~_FriendsScreenViewModel(){}
    public:
        virtual void updateFriendsFromFacebook() = 0;
        virtual void cancelOperation(enum CancelTypes type) = 0;
        virtual void menuTapped() = 0;
        virtual bool webViewDidLoad(std::string url) = 0;
        virtual list<strong<Person>> allFriends() = 0;
        virtual void personSelected(strong<Person> person) = 0;
        virtual bool needsCancelSearchBeforeSegue() = 0;
        
    public:
        std::function<void(bool success)> userLoggedInCallback_ = nullptr;
        std::function<void(std::string url, std::vector<std::string> allowedPatterns)> authorizationUrlCallback_ = nullptr;
        std::function<void(set<strong<Person>> friends)> friendsUpdatedCallback_ = nullptr;
        std::function<void(strong<Person> person)> personStateChangedCallback_ = nullptr;
        std::function<void(strong<Person> person, bool closeAlert)> serialRequestAlertViewControllerCallback_ = nullptr;
        function<void *()> webViewControllerUICalback_ = nullptr;
    };
    
    typedef reff<_FriendsScreenViewModel> FriendsScreenViewModel;
};

#endif /* friendsscreenviewmodel_h */
