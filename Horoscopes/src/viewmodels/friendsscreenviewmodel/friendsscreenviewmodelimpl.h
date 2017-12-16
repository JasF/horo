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
        void cancelOperation(enum CancelTypes type) override;
        void menuTapped() override;
        bool webViewDidLoad(std::string url) override;
        list<strong<Person>> allFriends() override;
        void personSelected(strong<Person> person) override;
        
    private:
        strong<FriendsScreenModel> model_;
        strong<ScreensManager> screensManager_;
        std::function<void(bool success)> userLoggedInCallback_;
    };
};

#endif /* friendsscreenviewmodelimpl_h */
