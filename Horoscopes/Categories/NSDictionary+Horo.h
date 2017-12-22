//
//  NSDictionary+Horo.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "base/horobase.h"

@interface NSDictionary (Horo)

+ (NSDictionary *)horo_dictionaryFromJsonValue:(Json::Value)value;
- (Json::Value)horo_jsonValue;

@end

