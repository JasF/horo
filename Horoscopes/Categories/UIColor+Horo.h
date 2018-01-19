//
//  UIColor+Horo.h
//  Horoscopes
//
//  Created by Jasf on 19.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "data/color.h"

using namespace horo;

@interface UIColor (Horo)
+ (UIColor *)horo_fromColor:(Color)color;
@end
