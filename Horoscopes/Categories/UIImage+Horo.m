//
//  UIImage+Horo.m
//  Horoscopes
//
//  Created by Jasf on 08.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "UIImage+Horo.h"

@implementation UIImage (Horo)

+ (UIImage *)horo_strechableImageWithTopPixelColor:(UIColor *)topPixelColor {
    CGRect topPixelFrame = CGRectMake(0, 0, 3, 3);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(3, 3), NO, 0);
    [topPixelColor setFill];
    UIRectFill(topPixelFrame);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
}

@end
