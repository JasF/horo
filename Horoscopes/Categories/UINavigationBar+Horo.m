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
    [self horo_makeWhite];
    self.backgroundColor = [UIColor clearColor];
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = [UIImage new];
}

- (void)horo_makeWhite {
    self.opaque = YES;
    self.translucent = YES;
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if (@available (iOS 11, *)) {
        self.largeTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    }
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[ [UISearchBar class] ]]
     setTintColor:[UIColor whiteColor]];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if (@available (iOS 11, *)) {
        self.largeTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    }
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[ [UISearchBar class] ]]
     setTintColor:[UIColor whiteColor]];
    self.tintColor = [UIColor whiteColor];
}

@end
