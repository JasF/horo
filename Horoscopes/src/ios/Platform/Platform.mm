//
//  Platform.m
//  Horoscopes
//
//  Created by Jasf on 31.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "Platform.h"
#include "base/platform.h"
#include <iostream>
#include <sstream>

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
    
    string loc(string term) {
        return [L([NSString stringWithUTF8String:term.c_str()]) UTF8String];
    }
    
    string urlDecode(string decodedUrl) {
        NSString *string = [NSString stringWithUTF8String:decodedUrl.c_str()];
        NSMutableArray *components = [[string componentsSeparatedByString:@"\\"] mutableCopy];
        NSMutableString *restored = [NSMutableString new];
        NSInteger index = 0;
        for (NSString *component in components) {
            if (index) {
                NSArray *subcomponents = [component componentsSeparatedByString:@" "];
                if (subcomponents.count != 2) {
                    return "";
                }
                NSString *hex = subcomponents.firstObject;
                int n;
                std::istringstream([[hex uppercaseString] UTF8String]) >> std::hex >> n;
                [restored appendString:[NSString stringWithFormat:@"%c", (char)n]];
                [restored appendString:subcomponents.lastObject];
            }
            else {
                [restored appendString:component];
            }
            index++;
        }
        return [restored UTF8String];
    }
    
    double timezoneOffset() {
        NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        NSTimeInterval timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600.0;
        return timeZoneOffset;
    }
};

@implementation Platform
@end
