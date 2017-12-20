//
//  accountscreenmodelimpl.h
//  Horoscopes
//
//  Created by Jasf on 19.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef accountscreenmodelimpl_h
#define accountscreenmodelimpl_h

#include "models/accountscreenmodel/accountscreenmodel.h"
#include "managers/loginmanager/loginmanagerfactory.h"
#include "managers/screensmanager/screensmanager.h"
#include "models/corecomponents/corecomponents.h"
#include "managers/settings/settings.h"

namespace horo {
    class AccountScreenModelImpl : public AccountScreenModel {
    public:
        AccountScreenModelImpl(strong<CoreComponents> components, strong<Settings> settings, strong<LoginManagerFactory> loginManagerFactory);
        ~AccountScreenModelImpl() override;
        void loggedInOnFacebook() override;
        void personRepresentation(function<void(std::string imageUrl, std::string name, horo::DateWrapper birthday)> callback) override;
        void userLoggedOut() override;
        void birthdayDateChanged(DateWrapper wrapper) override;
        
    private:
        void handlePerson(strong<Person> person);
        
    private:
        strong<LoginManagerFactory> loginManagerFactory_;
        strong<LoginManager> loginManager_;
        strong<CoreComponents> components_;
        strong<Settings> settings_;
    };
};

#endif /* accountscreenmodelimpl_h */
