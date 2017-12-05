//
//  UINavigationBar+Horo.m
//  Horoscopes
//
//  Created by Jasf on 05.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import "UINavigationBar+Horo.h"

@implementation UINavigationBar (Horo)
- (void)horo_makeTransparent {
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = [UIImage new];
    self.opaque = YES;
    self.translucent = YES;
    self.backgroundColor = [UIColor clearColor];
}
@end
