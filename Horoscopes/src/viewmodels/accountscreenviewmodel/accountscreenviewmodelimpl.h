//
//  accountscreenviewmodelimpl.h
//  Horoscopes
//
//  Created by Jasf on 19.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef accountscreenviewmodelimpl_h
#define accountscreenviewmodelimpl_h

#include "viewmodels/accountscreenviewmodel/accountscreenviewmodel.h"
#include "models/accountscreenmodel/accountscreenmodel.h"
#include "managers/screensmanager/screensmanager.h"

namespace horo {
    
    class AccountScreenViewModelImpl : public AccountScreenViewModel {
    public:
        AccountScreenViewModelImpl(strong<AccountScreenModel> model, strong<ScreensManager> screensManager);
        ~AccountScreenViewModelImpl() override;
        
    public:
        void menuTapped() override;
        
    private:
        strong<AccountScreenModel> model_;
        strong<ScreensManager> screensManager_;
        std::function<void(bool success)> userLoggedInCallback_;
    };
};


#endif /* accountscreenviewmodelimpl_h */
