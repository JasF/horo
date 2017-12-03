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

@interface DesignLabel ()
@property (assign, nonatomic) CGFloat cachedWidth;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@end

@implementation DesignLabel
#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialization];
    self.text = L(self.text);
    _descriptionLabel.text = L(_descriptionLabel.text);
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
    UIImage *image = [UIImageView generateWithSize:[UIScreen mainScreen].bounds.size
                                              type:GradientMenuCell];
    aMaskLayer.contents=(id)image.CGImage;
    aMaskLayer.frame = CGRectMake(0,0, image.size.width, image.size.height);
    self.layer.mask=aMaskLayer;
}

@end
