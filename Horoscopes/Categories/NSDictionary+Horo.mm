//
//  NSDictionary+Horo.m
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "NSDictionary+Horo.h"

@implementation NSDictionary (Horo)

NSDictionary *dictionaryFromJsonValue(Json::Value parameters) {
    NSMutableDictionary *result = [NSMutableDictionary new];
    for( Json::ValueIterator it = parameters.begin(); it != parameters.end(); ++it )
    {
        std::string key = it.key().asString();
        NSString *keyString = [NSString stringWithCString:key.c_str() encoding:[NSString defaultCStringEncoding]];
        NSCAssert(keyString.length, @"keyString is nil");
        if (!keyString) {
            continue;
        }
        Json::Value &value = *it;
        if (value.isNumeric()) {
            [result setObject:@(value.asInt()) forKey:keyString];
        }
        else if (value.isString()) {
            NSString *valueString = [NSString stringWithCString:value.asString().c_str() encoding:[NSString defaultCStringEncoding]];
            [result setObject:valueString forKey:keyString];
        }
        else {
            NSCAssert(NO, @"Unexpected type for value: %@.", @(value.type()));
        }
    }
    
    return [result copy];
}

+ (NSDictionary *)horo_dictionaryFromJsonValue:(Json::Value)value {
    return dictionaryFromJsonValue(value);
}

- (Json::Value)horo_jsonValue {
    Json::Value root;
    for (NSString *key in self.allKeys) {
        std::string csKey = [key UTF8String];
        id value = [self valueForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            NSString *string = (NSString *)value;
            std::string csString = [string UTF8String];
            root[csKey] = csString;
        }
        else if ([value isKindOfClass:[NSData class]]) {
            NSData *data = (NSData *)value;
            char *storage = new char[data.length];
            std::string str(storage, data.length);
            root[csKey] = str;
            delete[]storage;
        }
        else if ([value isKindOfClass:[NSNumber class]]) {
            NSNumber *number = (NSNumber *)value;
            root[csKey] = (int)[number integerValue];
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionary = (NSDictionary *)value;
            Json::Value value = [dictionary horo_jsonValue];
            root[csKey] = value;
        }
    }
    return root;
}

@end
