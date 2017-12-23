//
//  NotificationsScreenModel.h
//  Horoscopes
//
//  Created by Jasf on 19.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef NotificationsScreenModelImpl_h
#define NotificationsScreenModelImpl_h

#include "base/horobase.h"
#include "data/person.h"
#include "models/notificationsscreenmodel/notificationsscreenmodel.h"
#include "models/corecomponents/corecomponents.h"
#include "managers/notifications/notifications.h"
#include "managers/settings/settings.h"

namespace horo {
    class NotificationsScreenModelImpl : public NotificationsScreenModel {
    public:
        NotificationsScreenModelImpl(strong<CoreComponents> components, strong<Settings> settings, strong<Notifications> notifications);
        ~NotificationsScreenModelImpl() override;
    };
};

#endif
