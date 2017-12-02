//
//  BackgroundView.m
//  Horoscopes
//
//  Created by Jasf on 04.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "BackgroundView.h"
#import "UIView+TKGeometry.h"

static CGFloat const kAnimationDuration = 50.f;

@interface BackgroundView ()
@property IBOutlet UIImageView *imageView;
@property NSInteger animationSeed;
@end

@implementation BackgroundView
- (void)layoutSubviews {
    [super layoutSubviews];
    self.animationSeed = self.animationSeed + 1;
    [self doAnimation:self.animationSeed];
}
    
- (void)doAnimation:(NSInteger)seed {
    if (seed != self.animationSeed) {
        return;
    }
    [self.layer removeAllAnimations];
    self.imageView.xOrigin = 0.f;
    @weakify(self);
    [UIView animateWithDuration:kAnimationDuration delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
        @strongify(self);
        self.imageView.xOrigin = -self.height;
    } completion:^(BOOL finished) {
        @strongify(self);
        self.imageView.xOrigin = 0.f;
        [self doAnimation:seed];
    }];
}
@end
