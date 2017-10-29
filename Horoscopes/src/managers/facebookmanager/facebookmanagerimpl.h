//
//  facebookmanagerimpl.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef facebookmanagerimpl_h
#define facebookmanagerimpl_h

#include "facebookmanager.h"

namespace horo {
  
    class FacebookManagerImpl : public FacebookManager {
    public:
        static void setPrivateInstance(FacebookManager *privateInstance);
    public:
        FacebookManagerImpl();
        ~FacebookManagerImpl() override;
    public:
        void requestPersonalInformation(std::function<void(dictionary userInfo)> callback) override;
    };
    
};

#endif /* facebookmanagerimpl_h */
