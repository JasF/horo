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

namespace horo {
  
    class _FriendsScreenModel {
    public:
        virtual ~_FriendsScreenModel() {}
        
    public:
        virtual void updateFriendsFromFacebook()=0;
        virtual bool webViewDidLoad(std::string url)=0;
        
    public:
        std::function<void(std::string url, std::vector<std::string> allowedPatterns)> authorizationUrlCallback_;
        
    };
    
    typedef reff<_FriendsScreenModel> FriendsScreenModel;
};

#endif /* friendsscreenmodel_h */
