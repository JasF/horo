//
//  theme.h
//  Horoscopes
//
//  Created by Jasf on 10.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef theme_h
#define theme_h

#include "base/horobase.h"
#include "friends/htmlparser/htmlparser.h"

namespace horo {
  
class _Theme {
public:
    _Theme() {}
    virtual ~_Theme() {}
    
public:
    virtual bool needsCancelSearchBeforeSegue()=0;
    virtual bool nativeNavigationTransition()=0;
};
    
typedef reff<_Theme> Theme;
    
};

#endif /* theme_h */
