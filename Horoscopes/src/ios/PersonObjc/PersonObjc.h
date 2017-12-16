//
//  PersonObjc.h
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "data/person.h"
#import "ZodiacObjc.h"

@interface PersonObjc : NSObject
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *birthdayString;
@property (readonly, nonatomic) NSString *imageUrl;
@property (readonly, nonatomic) BOOL updating;
@property (readonly, nonatomic) ZodiacObjc *zodiac;
- (instancetype)initWithPerson:(strong<horo::Person>)person;
- (strong<horo::Person>)nativeRepresentation;
@end
