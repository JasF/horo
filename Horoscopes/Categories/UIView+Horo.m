//
//  UIView+Horo.m
//  Horoscopes
//
//  Created by Jasf on 02.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "UIView+Horo.h"

@implementation UIView (Horo)
- (void)horo_addFillingSubview:(UIView *)subview {
    if (subview.superview) {
        [subview removeFromSuperview];
    }
    [self addSubview:subview];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[subview]|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(subview)]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[subview]|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(subview)]];
}
@end
