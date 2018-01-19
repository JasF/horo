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
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *backgroundColor;
@end

@implementation PredictionContentViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    _label.textColor = _textColor;
    self.view.backgroundColor = _backgroundColor;
}

#pragma mark - Public Methods
- (void)setText:(NSString *)text width:(CGFloat)width {
    self.view.width = width;
    _label.text = text;
    self.view.height = [self getHeight];
    _blurEffectView.frame = self.view.bounds;
}

- (void)setTextColor:(UIColor *)color {
    _label.textColor = color;
    _textColor = color;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if ([self isViewLoaded]) {
        self.view.backgroundColor = backgroundColor;
    }
    _backgroundColor = backgroundColor;
}

- (CGFloat)getHeight {
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [_label sizeToFit];
    return _label.height;
}

@end
