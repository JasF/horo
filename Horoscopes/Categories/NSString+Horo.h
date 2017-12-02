//
//  NSString+Horo.h
//  Horoscopes
//
//  Created by Jasf on 02.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <list>
#include <string>

@interface NSString (Horo)

+ (NSArray *)horo_stringsArrayWithList:(std::list<std::string>)list;

@end
