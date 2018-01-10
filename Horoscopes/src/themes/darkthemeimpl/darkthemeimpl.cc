//
//  darkthemeimpl.c
//  Horoscopes
//
//  Created by Jasf on 10.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#include "darkthemeimpl.h"

namespace horo {

DarkThemeImpl::DarkThemeImpl() {
    
}

DarkThemeImpl::~DarkThemeImpl() {
    
}
    
bool DarkThemeImpl::needsCancelSearchBeforeSegue() {
    return true;
}

bool DarkThemeImpl::nativeNavigationTransition() {
    return false;
}

};
