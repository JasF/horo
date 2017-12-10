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
    NSString *birthday = [[NSString alloc] initWithUTF8String:_person->birthdayDate().toString().c_str()];
    if (!birthday.length) {
        birthday = L(@"birthday_unknown");
    }
    return birthday;
}

- (NSString *)imageUrl {
    return [NSString stringWithUTF8String:_person->imageUrl().c_str()];
}

@end
