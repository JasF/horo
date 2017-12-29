//
//  notificationsscreenviewmodel.h
//  Horoscopes
//
//  Created by Jasf on 23.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef notificationsscreenviewmodel_h
#define notificationsscreenviewmodel_h

#include "base/horobase.h"
#include "data/datewrapper.h"

namespace horo {
    class _NotificationsScreenViewModel {
    public:
        _NotificationsScreenViewModel(){}
        virtual ~_NotificationsScreenViewModel(){}
    public:
        virtual void menuTapped() = 0;
        virtual void pushTimeTapped() = 0;
        virtual void sendSettingsIfNeeded() = 0;
    };
    
    typedef reff<_NotificationsScreenViewModel> NotificationsScreenViewModel;
};

#endif /* notificationsscreenviewmodel_h */
