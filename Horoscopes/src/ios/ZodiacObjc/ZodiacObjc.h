//
//  ZodiacObjc.h
//  Horoscopes
//
//  Created by Jasf on 16.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "data/zodiac.h"

@interface ZodiacObjc : NSObject
@property (readonly, nonatomic) NSString *name;
- (instancetype)initWithZodiac:(strong<horo::Zodiac>)zodiac;
- (strong<horo::Zodiac>)nativeRepresentation;
@end
