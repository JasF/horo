//
//  facebookloginmanager.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef facebookloginmanager_h
#define facebookloginmanager_h

#include "loginmanager.h"
#include "managers/facebookmanager/facebookmanager.h"

namespace horo {
    
    class FacebookLoginManager : public LoginManager {
    public:
        FacebookLoginManager(strong<FacebookManager> facebookManager);
        ~FacebookLoginManager() override;
    public:
        void requestUserInformation(std::function<void(strong<Person> person)> callback) override;
    
    private:
        strong<FacebookManager> facebookManager_;
    };
    
};

#endif /* facebookloginmanager_h */
