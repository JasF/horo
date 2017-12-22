//
//  notifications.h
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef notifications_h
#define notifications_h

#include "base/horobase.h"

namespace horo {
    class _Notifications {
    public:
        virtual ~_Notifications(){}
        virtual void initialize()=0;
    };
    typedef reff<_Notifications> Notifications;
};


#endif /* notifications_h */
