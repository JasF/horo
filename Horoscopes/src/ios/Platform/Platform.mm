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
    
    string contentOfFile(string filename, string extension) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithUTF8String:filename.c_str()]
                                             withExtension:[NSString stringWithUTF8String:extension.c_str()]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        return string((char *)data.bytes, data.length);
    }
    
    string toLowerCase(string source) {
        return [[[NSString stringWithUTF8String:source.c_str()] lowercaseString] UTF8String];
    }
};

@implementation Platform
@end
