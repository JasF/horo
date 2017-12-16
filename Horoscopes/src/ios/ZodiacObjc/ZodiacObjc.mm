//
//  ZodiacObjc.m
//  Horoscopes
//
//  Created by Jasf on 16.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "ZodiacObjc.h"

@interface ZodiacObjc ()
@property (assign, nonatomic) strong<horo::Zodiac> zodiac;
@end

@implementation ZodiacObjc

#pragma mark - Initialization
- (instancetype)initWithZodiac:(strong<horo::Zodiac>)zodiac {
    NSCParameterAssert(zodiac.get());
    if (self = [super init]) {
        _zodiac = zodiac;
    }
    return self;
}

- (strong<horo::Zodiac>)nativeRepresentation {
    return _zodiac;
}

#pragma mark - Getters
- (NSString *)name {
    if (_zodiac->type() == horo::Unknown) {
        return nil;
    }
    return [[NSString alloc] initWithUTF8String:_zodiac->name().c_str()];
}

@end
