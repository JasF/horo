//
//  screensmanager.h
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef screensmanager_h
#define screensmanager_h

#include "base/horobase.h"
#include "data/person.h"

namespace horo {
  
class _ScreensManager {
public:
    virtual ~_ScreensManager() {}
    virtual void showPredictionViewController() = 0;
    virtual void showPredictionViewController(strong<Person> person, bool push = false) = 0;
    virtual void showWelcomeViewController() = 0;
    virtual void showMenuViewController(bool animated) = 0;
    virtual void showFriendsViewController() = 0;
    virtual void showAccountViewController() = 0;
    virtual void showFeedViewController() = 0;
    virtual void showNotificationsViewController() = 0;
    virtual void showPushTimeViewController() = 0;
};
    
typedef reff<_ScreensManager> ScreensManager;
    
};

#endif /* screensmanager_h */
