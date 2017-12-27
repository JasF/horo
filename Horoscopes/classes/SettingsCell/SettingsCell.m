//
//  SettingsCell.m
//  Horoscopes
//
//  Created by Jasf on 27.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "SettingsCell.h"

static CGFloat kSelectedBackgroundViewAlpha = 0.2f;

@interface SettingsCell ()
@property (strong, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@end

@implementation SettingsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:kSelectedBackgroundViewAlpha];
    // Initialization code
}

#pragma mark - Accessors
- (NSString *)text {
    return _mainTextLabel.text;
}

- (void)setText:(NSString *)text {
    _mainTextLabel.text = text;
}

#pragma mark - Public Methods
- (void)setSwitcherOn:(BOOL)on {
    _switcher.on = on;
}

@end
