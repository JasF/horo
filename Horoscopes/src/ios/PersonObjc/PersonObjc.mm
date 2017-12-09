//
//  PersonObjc.m
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "PersonObjc.h"


@interface PersonObjc ()
@property (assign, nonatomic) strong<horo::Person> person;
@end

@implementation PersonObjc

#pragma mark - Initialization
- (instancetype)initWithPerson:(strong<horo::Person>)person {
    if (self = [self init]) {
        _person = person;
    }
    return self;
}

- (NSString *)name {
    return [[NSString alloc] initWithUTF8String:_person->name().c_str()];
}

- (NSString *)birthday {
    return [[NSString alloc] initWithUTF8String:_person->birthdayDate().toString().c_str()];
}

@end
