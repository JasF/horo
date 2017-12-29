//
//  pushtimescreenmodelimpl.h
//  Horoscopes
//
//  Created by Jasf on 27.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef pushtimescreenmodelimpl_h
#define pushtimescreenmodelimpl_h

#include "base/horobase.h"
#include "data/person.h"
#include "models/pushtimescreenmodel/pushtimescreenmodel.h"
#include "models/corecomponents/corecomponents.h"
#include "managers/settings/settings.h"
#include "managers/notifications/notifications.h"

namespace horo {
    class PushTimeScreenModelImpl : public PushTimeScreenModel {
    public:
        PushTimeScreenModelImpl(strong<Notifications> notifications);
        ~PushTimeScreenModelImpl() override;
        
    private:
        int pushTime() override;
        void setPushTime(int pushTime) override;
        void sendSettingsIfNeeded() override;
        
    private:
        strong<Notifications> notifications_;
    };
};


#endif /* pushtimescreenmodelimpl_h */
