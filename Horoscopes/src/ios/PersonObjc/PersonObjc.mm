//
//  PersonObjc.m
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "data/zodiac.h"
#import "PersonObjc.h"
#import "ZodiacObjc.h"

@interface PersonObjc ()
@property (assign, nonatomic) strong<horo::Person> person;
@end

@implementation PersonObjc

#pragma mark - Initialization
+ (instancetype)personWithPerson:(strong<horo::Person>)person {
    NSCParameterAssert(person.get());
    if (person->wrapper()) {
        return(__bridge PersonObjc *)person->wrapper();
    }
    return [[PersonObjc alloc] initWithPerson:person];
}

- (instancetype)initWithPerson:(strong<horo::Person>)person {
    NSCParameterAssert(person.get());
    if (person->wrapper()) {
        return(__bridge PersonObjc *)person->wrapper();
    }
    if (self = [self init]) {
        _person = person;
        _person->setWrapper((__bridge void *)self);
    }
    return self;
}

- (void)dealloc {
    if (_person->wrapper() == (__bridge void *)self) {
        _person->setWrapper(nullptr);
    }
}

#pragma mark - Getters
- (NSString *)name {
    return [[NSString alloc] initWithUTF8String:_person->name().c_str()];
}

- (NSString *)birthdayString {
    if (_person->updating()) {
        return L(@"updating");
    }
    if (_person->status() == horo::StatusCompleted) {
        horo::DateWrapper wrapper = _person->birthdayDate();
        NSString *monthString = L([NSString stringWithUTF8String:horo::stringByMonth((horo::Months)wrapper.month()).c_str()]);
        NSString *birthday = (wrapper.year()) ? [NSString stringWithFormat:@"%@ %@ %@", @(wrapper.day()), monthString, @(wrapper.year())]
                                              : [NSString stringWithFormat:@"%@ %@", @(wrapper.day()), monthString];
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

- (ZodiacObjc *)zodiac {
    if (!_person->zodiac().get()) {
        return nil;
    }
    return [[ZodiacObjc alloc] initWithZodiac:_person->zodiac()];
}

- (NSString *)imageUrl {
    return [NSString stringWithUTF8String:_person->imageUrl().c_str()];
}

- (strong<horo::Person>)nativeRepresentation {
    return _person;
}

- (BOOL)updating {
    return (BOOL) _person->updating();
}

@end
