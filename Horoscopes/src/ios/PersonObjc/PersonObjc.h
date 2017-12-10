//
//  PersonObjc.h
//  Horoscopes
//
//  Created by Jasf on 09.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "data/person.h"

@interface PersonObjc : NSObject
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *birthday;
@property (readonly, nonatomic) NSString *imageUrl;
- (instancetype)initWithPerson:(strong<horo::Person>)person;
@end
