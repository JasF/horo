//
//  MaskingView.m
//  Horoscopes
//
//  Created by Jasf on 02.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "UIView+TKGeometry.h"
#import "UIImageView+Horo.h"
#import "UIView+Horo.h"
#import "MaskingView.h"

@implementation MaskingView
- (void)didMoveToSuperview {
    self.superview.opaque = NO;
    self.superview.clearsContextBeforeDrawing = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CALayer *aMaskLayer=[CALayer layer];
    UIImage *image = [UIImageView horo_generateWithSize:self.size
                                                   type:GradientHolka];
    aMaskLayer.contents=(id)image.CGImage;
    aMaskLayer.frame = CGRectMake(0,0, image.size.width, image.size.height);
    self.layer.mask=aMaskLayer;
}

@end
