//
//  screensmanagerimpl.cpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "screensmanagerimpl.h"

namespace horo {
    static ScreensManager *g_privateInstance = nullptr;
    void ScreensManagerImpl::setPrivateInstance(ScreensManager *privateInstance) {
        SCParameterAssert(privateInstance);
        g_privateInstance = privateInstance;
    }
    
    ScreensManagerImpl::ScreensManagerImpl(strong<Notifications> notifications)
    : notifications_(notifications)
    , notificationsInitialized_(false) {
        SCParameterAssert(notifications_.get());
    }
    
    ScreensManagerImpl::~ScreensManagerImpl() {
    }
    
    void ScreensManagerImpl::showPredictionViewController() {
        initializeNotifications();
        if (g_privateInstance) {
            g_privateInstance->showPredictionViewController();
        }
    }
    
    void ScreensManagerImpl::showPredictionViewController(strong<Person> person) {
        initializeNotifications();
        if (g_privateInstance) {
            g_privateInstance->showPredictionViewController(person);
        }
    }
    
    void ScreensManagerImpl::showWelcomeViewController() {
        if (g_privateInstance) {
            g_privateInstance->showWelcomeViewController();
        }
    }
    
    void ScreensManagerImpl::showMenuViewController(bool animated) {
        if (g_privateInstance) {
            g_privateInstance->showMenuViewController(animated);
        }
    }
    
    void ScreensManagerImpl::showFriendsViewController() {
        if (g_privateInstance) {
            g_privateInstance->showFriendsViewController();
        }
    }
    
    void ScreensManagerImpl::showAccountViewController() {
        if (g_privateInstance) {
            g_privateInstance->showAccountViewController();
        }
    }
    
    void ScreensManagerImpl::showFeedViewController() {
        if (g_privateInstance) {
            g_privateInstance->showFeedViewController();
        }
    }
    
    void ScreensManagerImpl::initializeNotifications() {
        if (!notificationsInitialized_) {
            notificationsInitialized_ = true;
            notifications_->initialize();
        }
    }
};
