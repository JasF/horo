//
//  screensmanagerimpl.hpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef screensmanagerimpl_hpp
#define screensmanagerimpl_hpp

#include <stdio.h>
#include "screensmanager.h"
#include "managers/viewmodelsimpl/viewmodelsimpl.h"
#include "managers/notifications/notificationsimpl.h"

namespace horo {
  
    class ScreensManagerImpl : public ScreensManager {
    public:
        static void setPrivateInstance(ScreensManager *privateInstance);
    public:
        ScreensManagerImpl(strong<Notifications> notifications);
        ~ScreensManagerImpl() override;
    public:
        void showPredictionViewController() override;
        void showPredictionViewController(strong<Person> person, bool push = false) override;
        void showWelcomeViewController() override;
        void showMenuViewController(bool animated) override;
        void showFriendsViewController() override;
        void showAccountViewController() override;
        void showFeedViewController() override;
        void showNotificationsViewController() override;
        void showPushTimeViewController() override;
        void showMenu() override;
        void hideMenu() override;
        
    private:
        void initializeNotifications();
    public:
        void setViewModels(strong<ViewModels> viewModels) { viewModels_ = viewModels; }
        strong<ViewModels> viewModels() {return viewModels_;};
    private:
        strong<ViewModels> viewModels_;
        strong<Notifications> notifications_;
        bool notificationsInitialized_;
    };
    
};


#endif /* screensmanagerimpl_hpp */
