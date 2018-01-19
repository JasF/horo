//
//  menuscreenmodelimpl.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef menuscreenmodelimpl_h
#define menuscreenmodelimpl_h

#include <stdio.h>

#include "menuscreenmodel.h"
#include "models/corecomponents/corecomponents.h"
#include "managers/loginmanager/loginmanagerfactory.h"
#include "managers/settings/settings.h"

namespace horo {
    class MenuScreenModelImpl : public MenuScreenModel {
    public:
        MenuScreenModelImpl(strong<CoreComponents> components,
                             strong<LoginManagerFactory> loginManagerFactory,
                             strong<Settings> settings);
        ~MenuScreenModelImpl() override;
    public:
        void loginOnFacebook() override;
        void dataForZodiacRow(int zodiacRowIndex, function<void(string leftZodiacName, string rightZodiacName)> callback) override;
        strong<Zodiac> zodiacForRow(int zodiacRowIndex, bool isLeftZodiac) override;
        
    private:
        strong<CoreComponents> components_;
        strong<LoginManagerFactory> loginManagerFactory_;
        strong<LoginManager> loginManager_;
        strong<Settings> settings_;
    };
};

#endif /* menuscreenmodelimpl_h */
