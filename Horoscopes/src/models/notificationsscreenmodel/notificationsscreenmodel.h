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
    };
    
    typedef reff<_NotificationsScreenModel> NotificationsScreenModel;
};

#endif /* notificationsscreenmodel_h */
