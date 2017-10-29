//
//  screensmanagerimpl.hpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef screensmanagerimpl_hpp
#define screensmanagerimpl_hpp

#include <stdio.h>
#include "screensmanager.h"
#include "managers/viewmodelsimpl/viewmodelsimpl.h"

namespace horo {
  
    class ScreensManagerImpl : public ScreensManager {
    public:
        static void setPrivateInstance(ScreensManager *privateInstance);
    public:
        ScreensManagerImpl();
        ~ScreensManagerImpl() override;
    public:
        void showPredictionViewController() override;
        void showWelcomeViewController() override;
    public:
        void setViewModels(strong<ViewModels> viewModels) { viewModels_ = viewModels; }
        strong<ViewModels> viewModels() {return viewModels_;};
    private:
        strong<ViewModels> viewModels_;
    };
    
};


#endif /* screensmanagerimpl_hpp */
