//
//  BackgroundView.m
//  Horoscopes
//
//  Created by Jasf on 04.11.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "UIView+TKGeometry.h"
#import "BackgroundView.h"
#import "UIView+Horo.h"

static CGFloat const kAnimationDuration = 50.f;

@interface BackgroundView ()
@property IBOutlet UIImageView *imageView;
@property NSInteger animationSeed;
@end

@implementation BackgroundView

- (id)init {
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialization];
}

- (void)initialization {
    if (!_imageView) {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray *array = [NSMutableArray new];
        [array addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1.f
                                                       constant:0.f]];
        [array addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1.f
                                                       constant:0.f]];
        [array addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                      attribute:NSLayoutAttributeLeading
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeLeading
                                                     multiplier:1.f
                                                       constant:0.f]];
        [self addConstraints:array];
    }
    self.backgroundColor = [UIColor yellowColor];
    _imageView.image = [UIImage imageNamed:@"bg-cyclic"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.animationSeed = self.animationSeed + 1;
    [self doAnimation:self.animationSeed];
}
    
- (void)doAnimation:(NSInteger)seed {
    if (seed != self.animationSeed) {
        return;
    }
    /*
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
     */
}

@end
