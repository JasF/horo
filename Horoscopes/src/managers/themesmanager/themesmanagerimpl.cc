//
//  themesmanagerimpl.c
//  Horoscopes
//
//  Created by Jasf on 10.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#include "themesmanagerimpl.h"
#include "themes/darkthemeimpl/darkthemeimpl.h"
#include "themes/lightthemeimpl/lightthemeimpl.h"

namespace horo {
    
ThemesManagerImpl::ThemesManagerImpl() :
    activeTheme_(new DarkThemeImpl())
    // activeTheme_(new LightThemeImpl())
    {
    
}

ThemesManagerImpl::~ThemesManagerImpl() {
    
}
    
strong<Theme> ThemesManagerImpl::activeTheme() {
    return activeTheme_;
}

};
