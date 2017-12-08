//
//  UIImageView+Horo.h
//  Horoscopes
//
//  Created by Jasf on 03.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GradientGenerationTypes) {
   GradientHolka,
   GradientMenuCell
};

@interface UIImageView (Horo)
+ (UIImage *)generateWithSize:(CGSize)size
                         type:(GradientGenerationTypes)type;
@end