//
//  friendsscreenviewmodelimpl.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef friendsscreenviewmodelimpl_h
#define friendsscreenviewmodelimpl_h

#include "friendsscreenviewmodel.h"
#include "models/friendsscreenmodel/friendsscreenmodel.h"
#include "managers/screensmanager/screensmanager.h"

namespace horo {
  
    class FriendsScreenViewModelImpl : public FriendsScreenViewModel {
    public:
        FriendsScreenViewModelImpl(strong<FriendsScreenModel> model, strong<ScreensManager> screensManager);
        ~FriendsScreenViewModelImpl() override;
        
    public:
        void updateFriendsFromFacebook() override;
        bool webViewDidLoad(std::string url) override;
        int friendsCount() override;
        void friendDataAtIndex(int index, std::function<void(string name, string birthday)> callback) override;
        
    private:
        strong<FriendsScreenModel> model_;
        strong<ScreensManager> screensManager_;
        std::function<void(bool success)> userLoggedInCallback_;
    };
};

#endif /* friendsscreenviewmodelimpl_h */
