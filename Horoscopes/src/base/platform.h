//
//  platform.h
//  Horoscopes
//
//  Created by Jasf on 31.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef platform_h
#define platform_h

#include "base/horobase.h"

namespace horo {
    std::string documentsPath();
    std::string contentOfFile(string filename, string extension);
    string toLowerCase(string source);
};

#endif /* platform_h */
