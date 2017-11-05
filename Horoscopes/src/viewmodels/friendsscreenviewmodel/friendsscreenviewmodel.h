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

namespace horo {
  
    class _FriendsScreenViewModel {
    public:
        virtual ~_FriendsScreenViewModel(){}
    public:
        virtual void updateFriendsFromFacebook() = 0;
        virtual bool webViewDidLoad(std::string url) = 0;
        
        std::function<void(bool success)> userLoggedInCallback_ = nullptr;
        
    public:
        std::function<void(std::string url, std::vector<std::string> allowedPatterns)> authorizationUrlCallback_;
    };
    
    typedef reff<_FriendsScreenViewModel> FriendsScreenViewModel;
};

#endif /* friendsscreenviewmodel_h */
