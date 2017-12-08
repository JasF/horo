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

- (UIImage *)horo_grabImage {
    // Create a "canvas" (image context) to draw in.
    UIGraphicsBeginImageContext([self bounds].size);
    
    // Make the CALayer to draw in our "canvas".
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    
    // Fetch an UIImage of our "canvas".
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Stop the "canvas" from accepting any input.
    UIGraphicsEndImageContext();
    
    // Return the image.
    return image;
}

- (id)horo_subviewWithClass:(Class)classForSearch {
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:classForSearch]) {
            return subview;
        }
        if (subview.subviews.count > 0) {
            UIView *subsubview = [subview horo_subviewWithClass:classForSearch];
            if (subsubview) {
                return subsubview;
            }
        }
    }
    
    return nil;
}

@end
