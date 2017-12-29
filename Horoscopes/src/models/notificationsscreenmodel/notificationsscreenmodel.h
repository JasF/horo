//
//  notificationsscreenmodel.h
//  Horoscopes
//
//  Created by Jasf on 23.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef notificationsscreenmodel_h
#define notificationsscreenmodel_h

#include "base/horobase.h"
#include "data/person.h"

namespace horo {
    class _NotificationsScreenModel {
    public:
        _NotificationsScreenModel(){}
        virtual ~_NotificationsScreenModel() {}
    public:
        virtual void sendSettingsIfNeeded()=0;
        virtual bool notificationsDisabled()=0;
        virtual void setNotificationsDisabled(bool disabled)=0;
        virtual int pushTime()=0;
    };
    
    typedef reff<_NotificationsScreenModel> NotificationsScreenModel;
};

#endif /* notificationsscreenmodel_h */
