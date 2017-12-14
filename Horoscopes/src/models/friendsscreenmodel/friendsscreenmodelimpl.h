//
//  friendsscreenmodelimpl.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef friendsscreenmodelimpl_h
#define friendsscreenmodelimpl_h

#include <stdio.h>

#include "friendsscreenmodel.h"
#include "models/corecomponents/corecomponents.h"
#include "managers/friendsmanager/friendsmanager.h"
#include "managers/screensmanager/screensmanager.h"
#include "managers/settings/settings.h"

namespace horo {
    class FriendsScreenModelImpl : public FriendsScreenModel {
    public:
        FriendsScreenModelImpl(strong<CoreComponents> components,
                             strong<FriendsManager> friendsManager,
                             strong<Settings> settings,
                               strong<ScreensManager> screensManager);
        ~FriendsScreenModelImpl() override;
    public:
        void updateFriendsFromFacebook() override;
        bool webViewDidLoad(std::string url) override;
        list<strong<Person>> allFriends() override;
        void cancelFriendsUpdating() override;
        void personSelected(strong<Person> person) override;
        
    private:
        void loadFriends(set<strong<Person>> loadFriends);
    private:
        strong<CoreComponents> components_;
        strong<FriendsManager> friendsManager_;
        strong<Settings> settings_;
        list<strong<Person>> friendsList_;
        strong<ScreensManager> screensManager_;
    };
};

#endif /* friendsscreenmodelimpl_h */
