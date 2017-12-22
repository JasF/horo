//
//  NSError+Horo.m
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "NSError+Horo.h"

@implementation NSError (Horo)
- (horo::error)horo_error {
    horo::error err(self.localizedDescription.UTF8String, (int)self.code);
    return err;
}
@end
