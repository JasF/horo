//
//  ScreensManagerObjc.h
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MainViewController;

@interface ScreensManagerOBJC : NSObject
@property (nonatomic, readonly) MainViewController *mainViewController;
@property (nonatomic, readonly) UIWindow *window;
+ (UINavigationController *)createMenuNavigationController;
+ (instancetype)shared;
- (MainViewController *)mainViewController;
- (void)setupViewControllers;
@end
