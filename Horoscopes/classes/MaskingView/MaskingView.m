//
//  MaskingView.m
//  Horoscopes
//
//  Created by Jasf on 02.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "UIView+TKGeometry.h"
#import "MaskingView.h"


static CGFloat const kGradientLocationFirst = 0.0f;
static CGFloat const kGradientLocationSecond = 0.024f;
static CGFloat const kGradientLocationThird = 1.f;

@interface UIView (Horo)
- (UIImage *)horo_grabImage;
@end

@implementation UIView (Horo)
- (UIImage *)horo_grabImage {
    // Create a "canvas" (image context) to draw in.
    UIGraphicsBeginImageContext([self bounds].size);
    
    // Make the CALayer to draw in our "canvas".
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    
    // Fetch an UIImage of our "canvas".
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Stop the "canvas" from accepting any input.
    UIGraphicsEndImageContext();
    
    // Return the image.
    return image;
}
@end

@interface MaskingView ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *maskingView;
@end

@implementation MaskingView
- (void)didMoveToSuperview {
    self.superview.opaque = NO;
    self.superview.clearsContextBeforeDrawing = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CALayer *aMaskLayer=[CALayer layer];
    UIImage *image = [self generate];
    aMaskLayer.contents=(id)image.CGImage;
    aMaskLayer.frame = CGRectMake(0,0, image.size.width, image.size.height);
    self.layer.mask=aMaskLayer;
}

- (UIImage *)generate {
    static UIImage *g_GeneratedMaskImage = nil;
    static CGRect g_GeneratedMaskImageFrame = {{0.f, 0.f}, {0.f, 0.f}};
    CGRect frame = self.bounds;
    // AV: Проверки на случай добавления смены ориентации
    if (!g_GeneratedMaskImage || !CGRectEqualToRect(g_GeneratedMaskImageFrame, frame)) {
        UIView *view = [[UIView alloc] initWithFrame:frame];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
        gradient.colors =
        @[ (id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor ];
        gradient.locations = @[ @(kGradientLocationFirst), @(kGradientLocationSecond), @(kGradientLocationThird) ];
        [view.layer insertSublayer:gradient atIndex:0];
        g_GeneratedMaskImage = [view horo_grabImage];
    }
    return g_GeneratedMaskImage;
}

@end

