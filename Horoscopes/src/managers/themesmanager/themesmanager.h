//
//  themesmanager.h
//  Horoscopes
//
//  Created by Jasf on 10.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef themesmanager_h
#define themesmanager_h

#include "base/horobase.h"
#include "themes/theme.h"

namespace horo {
  
class _ThemesManager {
public:
    _ThemesManager() {}
    virtual ~_ThemesManager() {}
public:
    virtual strong<Theme> activeTheme()=0;
};
    
typedef reff<_ThemesManager> ThemesManager;
    
};

#endif /* themesmanager_h */
