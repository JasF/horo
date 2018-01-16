//
//  MenuSimpleCell.m
//  Horoscopes
//
//  Created by Jasf on 16.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "MenuSimpleCell.h"

@interface MenuSimpleCell ()
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@end

@implementation MenuSimpleCell

#pragma mark - Public Methods
- (void)setText:(NSString *)text {
    _label.text = text;
}

- (void)setOffset:(CGFloat)offset {
    _bottomConstraint.constant = offset;
    _topConstraint.constant = offset;
}

@end