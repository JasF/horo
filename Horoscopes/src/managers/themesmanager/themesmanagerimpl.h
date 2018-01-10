//
//  themesmanagerimpl.h
//  Horoscopes
//
//  Created by Jasf on 10.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef themesmanagerimpl_h
#define themesmanagerimpl_h

#include "managers/themesmanager/themesmanager.h"

namespace horo {
  
    class ThemesManagerImpl : public ThemesManager {
    public:
        ThemesManagerImpl();
        ~ThemesManagerImpl() override;
    
    public:
        strong<Theme> activeTheme() override;
        
    private:
        strong<Theme> activeTheme_;
    };
    
};

#endif /* themesmanagerimpl_h */
