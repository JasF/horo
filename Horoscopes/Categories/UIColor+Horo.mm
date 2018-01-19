//
//  UIColor+Horo.m
//  Horoscopes
//
//  Created by Jasf on 19.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "UIColor+Horo.h"

@implementation UIColor (Horo)

+ (UIColor *)horo_fromColor:(Color)color {
    return [UIColor colorWithRed:color.red_ green:color.green_ blue:color.blue_ alpha:color.alpha_];
}

@end
