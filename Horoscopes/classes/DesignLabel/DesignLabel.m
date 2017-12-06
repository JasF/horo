//
//  DesignLabel.m
//  Horoscopes
//
//  Created by Jasf on 03.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "UIView+TKGeometry.h"
#import "UIImageView+Horo.h"
#import "UIView+Horo.h"
#import "DesignLabel.h"

static CGFloat const kAnimationDuration = 0.5f;

@interface DesignLabel ()
@property (assign, nonatomic) CGFloat cachedWidth;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation DesignLabel {
    BOOL _backgroundHighlighted;
}
#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialization];
    self.text = L(self.text);
    self.adjustsFontSizeToFitWidth = YES;
    [self sizeToFit];
}

- (void)initialization {
    
}

- (void)didMoveToSuperview {
    self.superview.opaque = NO;
    self.superview.clearsContextBeforeDrawing = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateMask];
}

- (void)updateMask {
    CALayer *aMaskLayer=[CALayer layer];
    CGSize size = self.size;
    size.height *= 2;
    UIImage *image = [UIImageView generateWithSize:size
                                              type:GradientMenuCell];
    aMaskLayer.contents=(id)image.CGImage;
    aMaskLayer.frame = CGRectMake(0,0, image.size.width, image.size.height);
    self.layer.mask=aMaskLayer;
    [self animateHighligh:_backgroundHighlighted animated:NO];
}

- (void)animateHighligh:(BOOL)highlight {
    [self animateHighligh:highlight animated:YES];
}

- (void)animateHighligh:(BOOL)highlight animated:(BOOL)animated {
    _backgroundHighlighted = highlight;
    dispatch_block_t block = ^{
        CGRect frame = self.layer.mask.frame;
        frame.origin.y = (highlight) ? 0 : -(frame.size.height-self.height);
        self.layer.mask.frame = frame;
    };
    
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration animations:block];
    }
    else {
        block();
    }
}

@end
