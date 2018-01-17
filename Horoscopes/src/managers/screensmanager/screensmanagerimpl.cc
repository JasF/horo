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
    
    ScreensManagerImpl::ScreensManagerImpl(strong<Notifications> notifications, strong<Analytics> analytics)
    : notifications_(notifications)
    , notificationsInitialized_(false)
    , analytics_(analytics) {
        SCParameterAssert(notifications_.get());
        SCParameterAssert(analytics_.get());
    }
    
    ScreensManagerImpl::~ScreensManagerImpl() {
    }
    
    void ScreensManagerImpl::showPredictionViewController() {
        initializeNotifications();
        analytics_->predictionScreenShow(false, false);
        if (g_privateInstance) {
            g_privateInstance->showPredictionViewController();
        }
    }
    
    void ScreensManagerImpl::showPredictionViewController(strong<Person> person, bool push) {
        initializeNotifications();
        analytics_->predictionScreenShow((person.get())?true:false, push);
        if (g_privateInstance) {
            g_privateInstance->showPredictionViewController(person, push);
        }
    }
    
    void ScreensManagerImpl::showWelcomeViewController() {
        analytics_->welcomeScreenShow();
        if (g_privateInstance) {
            g_privateInstance->showWelcomeViewController();
        }
    }
    
    void ScreensManagerImpl::showMenuViewController(bool animated) {
        analytics_->menuScreenShow();
        if (g_privateInstance) {
            g_privateInstance->showMenuViewController(animated);
        }
    }
    
    void ScreensManagerImpl::showFriendsViewController() {
        analytics_->friendsScreenShow();
        if (g_privateInstance) {
            g_privateInstance->showFriendsViewController();
        }
    }
    
    void ScreensManagerImpl::showAccountViewController() {
        analytics_->accountScreenShow();
        if (g_privateInstance) {
            g_privateInstance->showAccountViewController();
        }
    }
    
    void ScreensManagerImpl::showFeedbackViewController() {
        analytics_->feedbackScreenShow();
        if (g_privateInstance) {
            g_privateInstance->showFeedbackViewController();
        }
    }
    
    void ScreensManagerImpl::showNotificationsViewController() {
        analytics_->notificationsScreenShow();
        if (g_privateInstance) {
            g_privateInstance->showNotificationsViewController();
        }
    }
    
    void ScreensManagerImpl::showPushTimeViewController() {
        analytics_->pushTimeScreenShow();
        if (g_privateInstance) {
            g_privateInstance->showPushTimeViewController();
        }
    }
    
    void ScreensManagerImpl::initializeNotifications() {
        if (!notificationsInitialized_) {
            notificationsInitialized_ = true;
            notifications_->initialize();
        }
    }
    
};
