//
//  UIViewControllerInjector.m
//  Horoscopes
//
//  Created by Jasf on 13.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#import "UIViewControllerInjector.h"
#import "MenuViewController.h"
#import "managers/managers.h"

@import JGMethodSwizzler;

@implementation UIViewControllerInjector

+ (void)doLoading {
    NSDictionary *dictionary = @{[MenuViewController class]:^{
        horo
    }};
    [UIViewController swizzleInstanceMethod:@selector(viewDidLoad) withReplacement:JGMethodReplacementProviderBlock {
        //return a replacement block
        return JGMethodReplacement(int, UIViewController *object, int arg) {
            
            //get the original value
            JGOriginalImplementation(int, arg);
            //return the modified value
            return 0;
        };
    }];
}

@end
