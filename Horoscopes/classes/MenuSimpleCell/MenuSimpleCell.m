//
//  MenuSimpleCell.m
//  Horoscopes
//
//  Created by Jasf on 16.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "MenuSimpleCell.h"

static CGFloat const kSelectedCellBackgroundAlpha = 0.2f;

@interface MenuSimpleCell ()
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIView *verticalDelimeter;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@end

@implementation MenuSimpleCell

#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:kSelectedCellBackgroundAlpha];
}

#pragma mark - Public Methods
- (void)setText:(NSString *)text {
    _label.text = text;
    [self setMode:YES];
}

- (void)setLeftText:(NSString *)leftText
          rightText:(NSString *)rightText {
    [_leftButton setTitle:leftText forState:UIControlStateNormal];
    [_rightButton setTitle:rightText forState:UIControlStateNormal];
    [self setMode:NO];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}

- (void)setOffset:(CGFloat)offset {
    _bottomConstraint.constant = offset;
    _topConstraint.constant = offset;
}

#pragma mark - Private Methods
- (void)setMode:(BOOL)singleMode {
    _label.hidden = !singleMode;
    _leftButton.hidden = singleMode;
    _rightButton.hidden = singleMode;
    _verticalDelimeter.hidden = singleMode;
}

#pragma mark - Observers
- (IBAction)buttonPressed:(UIButton *)sender {
    sender.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:kSelectedCellBackgroundAlpha];
}

- (IBAction)buttonReleased:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
}

- (IBAction)buttonTapped:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(menuSimpleCell:didTappedOnZodiacButton:)]) {
        [_delegate menuSimpleCell:self didTappedOnZodiacButton:([sender isEqual:_leftButton])];
    }
}

@end
