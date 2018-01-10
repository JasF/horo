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
#include "managers/themesmanager/themesmanager.h"

namespace horo {
  
    class FriendsScreenViewModelImpl : public FriendsScreenViewModel {
    public:
        FriendsScreenViewModelImpl(strong<FriendsScreenModel> model, strong<ScreensManager> screensManager, strong<ThemesManager> themesManager);
        ~FriendsScreenViewModelImpl() override;
        
    public:
        void updateFriendsFromFacebook() override;
        void cancelOperation(enum CancelTypes type) override;
        void menuTapped() override;
        bool webViewDidLoad(std::string url) override;
        list<strong<Person>> allFriends() override;
        void personSelected(strong<Person> person) override;
        bool needsCancelSearchBeforeSegue() override;
        
    private:
        strong<Theme> theme() { return themesManager_->activeTheme(); }
        
    private:
        strong<FriendsScreenModel> model_;
        strong<ScreensManager> screensManager_;
        std::function<void(bool success)> userLoggedInCallback_;
        strong<ThemesManager> themesManager_;
        
    };
};

#endif /* friendsscreenviewmodelimpl_h */
