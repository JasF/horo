//
//  darkthemeimpl.h
//  Horoscopes
//
//  Created by Jasf on 10.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef darkthemeimpl_h
#define darkthemeimpl_h

#include "themes/theme.h"

namespace horo {
  
    class DarkThemeImpl : public Theme {
    public:
        DarkThemeImpl();
        ~DarkThemeImpl() override;
        bool needsCancelSearchBeforeSegue() override;
        bool nativeNavigationTransition() override;
    };
    
};

#endif /* darkthemeimpl_h */
