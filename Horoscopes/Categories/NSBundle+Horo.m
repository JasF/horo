//
//  NSBundle+Horo.m
//  Horoscopes
//
//  Created by Jasf on 08.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "NSBundle+Horo.h"

@implementation NSBundle (Horo)

+ (UIView *)horo_loadTopViewFromNibNamed:(NSString *)nibName {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    UIView *result = nil;
    for (id object in array) {
        if ([object isKindOfClass:[UIView class]]) {
            result = object;
            break;
        }
    }
    NSCAssert(result, @"Cannot find UIView instance in nib named: %@", nibName);
    return result;
}

@end
