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

- (NSData *)horo_dataFromHex {
    NSString *string = [self lowercaseString];
    NSMutableData *data= [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    int length =(int)string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

@end
