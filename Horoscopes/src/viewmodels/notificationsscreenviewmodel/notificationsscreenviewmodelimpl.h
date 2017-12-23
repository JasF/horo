//
//  notificationsscreenviewmodelimpl.h
//  Horoscopes
//
//  Created by Jasf on 23.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef notificationsscreenviewmodelimpl_h
#define notificationsscreenviewmodelimpl_h

#include <stdio.h>
#include "viewmodels/notificationsscreenviewmodel/notificationsscreenviewmodel.h"
#include "models/notificationsscreenmodel/notificationsscreenmodel.h"
#include "managers/screensmanager/screensmanager.h"

namespace horo {
    class NotificationsScreenViewModelImpl : public NotificationsScreenViewModel {
    public:
        NotificationsScreenViewModelImpl(strong<NotificationsScreenModel> model, strong<ScreensManager> screensManager);
        ~NotificationsScreenViewModelImpl() override;
        
    public:
        void menuTapped() override;
        
    private:
        strong<NotificationsScreenModel> model_;
        strong<ScreensManager> screensManager_;
    };
};


#endif /* notificationsscreenviewmodelimpl_h */
