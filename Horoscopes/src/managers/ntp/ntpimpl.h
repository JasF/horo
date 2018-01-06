//
//  ntpimpl.h
//  Horoscopes
//
//  Created by Jasf on 07.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef ntpimpl_h
#define ntpimpl_h

#include "managers/ntp/ntp.h"
#include "models/corecomponents/corecomponents.h"
#include "managers/settings/settings.h"

namespace horo {
    
    class NtpImpl : public Ntp {
    public:
        static void setPrivateInstance(Ntp *instance);
    public:
        NtpImpl();
        ~NtpImpl() override;
        void getServerTimeWithCompletion(std::function<void(double ti)> callback) override;
    };
    
}

#endif /* ntpimpl_h */
