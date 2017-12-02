//
//  PredictionContentViewController.m
//  Horoscopes
//
//  Created by Jasf on 02.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "PredictionContentViewController.h"
#import "UIView+TKGeometry.h"

@interface PredictionContentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) UIVisualEffectView *blurEffectView;
@end

@implementation PredictionContentViewController

#pragma mark - Public Methods
- (void)setText:(NSString *)text width:(CGFloat)width {
    self.view.width = width;
    _label.text = text;
    self.view.height = [self getHeight];
    _blurEffectView.frame = self.view.bounds;
}

- (CGFloat)getHeight {
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [_label sizeToFit];
    return _label.height;
}

@end
