//
//  Platform.m
//  Horoscopes
//
//  Created by Jasf on 31.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "Platform.h"
#include "base/platform.h"

namespace horo {
    std::string documentsPath() {
        NSArray*  paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
        NSString* dir   = paths.firstObject;
        return [dir UTF8String];
    }
};

@implementation Platform
@end
