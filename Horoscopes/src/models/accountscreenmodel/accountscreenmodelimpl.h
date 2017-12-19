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
#include "managers/settings/settings.h"
#include "managers/screensmanager/screensmanager.h"

namespace horo {
    class AccountScreenModelImpl : public AccountScreenModel {
    public:
        AccountScreenModelImpl(strong<Settings> settings);
        ~AccountScreenModelImpl() override;
    };
};

#endif /* accountscreenmodelimpl_h */
