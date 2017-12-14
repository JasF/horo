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

- (NSString *)birthdayString {
    if (_person->status() == horo::StatusCompleted) {
        NSString *birthday = [[NSString alloc] initWithUTF8String:_person->birthdayDate().toString().c_str()];
        return birthday;
    }
    else if (_person->status() == horo::StatusReadyForRequest) {
        return L(@"person_birthday_status_ready_for_request");
    }
    else if (_person->status() == horo::StatusFailed) {
        return L(@"person_birthday_status_failed");
    }
    
    return nil;
}

- (NSString *)imageUrl {
    return [NSString stringWithUTF8String:_person->imageUrl().c_str()];
}

- (strong<horo::Person>)nativeRepresentation {
    return _person;
}

@end
