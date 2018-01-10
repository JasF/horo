//
//  themesmanagerimpl.c
//  Horoscopes
//
//  Created by Jasf on 10.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#include "themesmanagerimpl.h"
#include "themes/darkthemeimpl/darkthemeimpl.h"

namespace horo {
    
ThemesManagerImpl::ThemesManagerImpl() :
    activeTheme_(new DarkThemeImpl()) {
    
}

ThemesManagerImpl::~ThemesManagerImpl() {
    
}
    
strong<Theme> ThemesManagerImpl::activeTheme() {
    return activeTheme_;
}

};
