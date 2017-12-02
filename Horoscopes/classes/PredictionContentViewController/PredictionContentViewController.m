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

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods
- (void)setText:(NSString *)text width:(CGFloat)width {
    self.view.width = width;
    _label.text = text;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [_label sizeToFit];
    self.view.height = _label.height;
    _blurEffectView.frame = self.view.bounds;
}

@end
