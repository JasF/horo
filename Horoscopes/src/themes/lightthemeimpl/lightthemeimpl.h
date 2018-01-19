//
//  lightthemeimpl.h
//  Horoscopes
//
//  Created by Jasf on 19.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef lightthemeimpl_h
#define lightthemeimpl_h

#include "themes/theme.h"

namespace horo {
    
    class LightThemeImpl : public Theme {
    public:
        LightThemeImpl();
        ~LightThemeImpl() override;
        bool needsCancelSearchBeforeSegue() override { return false; }
        bool nativeNavigationTransition() override { return true; }
        
        bool backgroundWithSolidColor() override { return true; }
        Color backgroundColor() override { return Color::whiteColor(); }
        
        bool predictionsWithCurlEffect() override { return true; }
        Color fontColor() override { return Color::blackColor(); }
    };
    
};

#endif /* lightthemeimpl_h */
