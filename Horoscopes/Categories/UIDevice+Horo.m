//
//  UIDevice+Horo.m
//  Horoscopes
//
//  Created by Jasf on 22.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "UIDevice+Horo.h"

@implementation UIDevice (Horo)
+ (CGFloat)horo_systemVersion {
    static float systemVersion = 0.0f;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    });
    
    return systemVersion;
}
@end
