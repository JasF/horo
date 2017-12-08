//
//  UINavigationBar+Horo.m
//  Horoscopes
//
//  Created by Jasf on 05.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "UINavigationBar+Horo.h"

@implementation UINavigationBar (Horo)

#pragma mark - Public Methods
- (void)horo_makeWhiteAndTransparent {
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = [UIImage new];
    self.opaque = YES;
    self.translucent = YES;
    self.backgroundColor = [UIColor clearColor];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if (@available (iOS 11, *)) {
        self.largeTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    }
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[ [UISearchBar class] ]]
     setTintColor:[UIColor whiteColor]];
    /*
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor redColor],
                                                                                                  UITextAttributeTextColor,
                                                                                                  [UIColor whiteColor],
                                                                                                  UITextAttributeTextShadowColor,
                                                                                                  [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                                                                                  UITextAttributeTextShadowOffset,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
*/
  }

@end
