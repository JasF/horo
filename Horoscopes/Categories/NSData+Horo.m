//
//  NSData+Horo.m
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "NSData+Horo.h"

@implementation NSData (Horo)
- (NSString *)horo_hexString {
    const char *data = [self bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (int i = 0; i < [self length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    return [[token lowercaseString] copy];
}
@end
