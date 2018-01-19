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
#include "managers/analytics/analytics.h"

namespace horo {
  
    class ScreensManagerImpl : public ScreensManager {
    public:
        static void setPrivateInstance(ScreensManager *privateInstance);
    public:
        ScreensManagerImpl(strong<Notifications> notifications, strong<Analytics> analytics);
        ~ScreensManagerImpl() override;
    public:
        void showPredictionViewController() override;
        void showPredictionViewController(strong<Person> person, bool push = false) override;
        void showPredictionViewController(strong<Zodiac> zodiac) override;
        void showWelcomeViewController() override;
        void showMenuViewController(bool animated) override;
        void showFriendsViewController() override;
        void showAccountViewController() override;
        void showFeedbackViewController() override;
        void showNotificationsViewController() override;
        void showPushTimeViewController() override;
        
    private:
        void initializeNotifications();
    public:
        void setViewModels(strong<ViewModels> viewModels) { viewModels_ = viewModels; }
        strong<ViewModels> viewModels() {return viewModels_;};
    private:
        strong<ViewModels> viewModels_;
        strong<Notifications> notifications_;
        bool notificationsInitialized_;
        strong<Analytics> analytics_;
    };
    
};


#endif /* screensmanagerimpl_hpp */
