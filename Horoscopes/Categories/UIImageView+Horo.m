//
//  UIImageView+Horo.m
//  Horoscopes
//
//  Created by Jasf on 03.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "UIImageView+Horo.h"
#import "UIView+Horo.h"

static CGFloat const kGradientLocationFirst = 0.0f;
static CGFloat const kGradientLocationSecond = 0.024f;
static CGFloat const kGradientLocationThird = 1.f;


static CGFloat const kGradientMenuCellFirst = 0.0f;
static CGFloat const kGradientMenuCellSecond = 0.25f;
static CGFloat const kGradientMenuCellThird = 1.f;

@implementation UIImageView (Horo)
+ (UIImage *)generateWithSize:(CGSize)size
                         type:(GradientGenerationTypes)type {
    static UIImage *g_GeneratedMaskImage = nil;
    static CGRect g_GeneratedMaskImageFrame = {{0.f, 0.f}, {0.f, 0.f}};
    CGRect frame = CGRectMake(0.f, 0.f, size.width, size.height);
    
    NSDictionary *typeParameters = @{@(GradientHolka) : @[@(kGradientLocationFirst), @(kGradientLocationSecond), @(kGradientLocationThird)],
                                 @(GradientMenuCell) : @[@(kGradientMenuCellFirst), @(kGradientMenuCellSecond), @(kGradientMenuCellThird)]};
    
    NSDictionary *colorParameters = @{@(GradientHolka) : @[ (id)[UIColor clearColor].CGColor,
                                                            (id)[UIColor blackColor].CGColor,
                                                            (id)[UIColor blackColor].CGColor ],
                                      @(GradientMenuCell) : @[ (id)[UIColor blackColor].CGColor,
                                                               (id)[UIColor clearColor].CGColor,
                                                               (id)[UIColor clearColor].CGColor ]};
    
    // AV: Проверки на случай добавления смены ориентации
    if (!g_GeneratedMaskImage || !CGRectEqualToRect(g_GeneratedMaskImageFrame, frame)) {
        UIView *view = [[UIView alloc] initWithFrame:frame];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
        gradient.colors = colorParameters[@(type)];
        gradient.locations = typeParameters[@(type)];
        [view.layer insertSublayer:gradient atIndex:0];
        g_GeneratedMaskImage = [view horo_grabImage];
    }
    return g_GeneratedMaskImage;
}
@end
