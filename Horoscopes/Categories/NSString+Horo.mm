//
//  NSString+Horo.m
//  Horoscopes
//
//  Created by Jasf on 02.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "NSString+Horo.h"

@implementation NSString (Horo)

+ (NSArray *)horo_stringsArrayWithList:(std::list<std::string>)list {
    NSMutableArray *array = [NSMutableArray new];
    for (auto string : list) {
        NSString *objcString = [NSString stringWithUTF8String:string.c_str()];
        [array addObject:objcString];
    }
    return [array copy];
}

@end
